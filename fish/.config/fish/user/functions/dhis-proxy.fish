function dhis-proxy --description "Switch DHIS connection.url port 5432→5433, run sql-tapd, restore on Ctrl+C/exit"
    set -l config_file "$HOME/.dhis2/dhis.conf"  # <-- set this
    set -l old_port 5432
    set -l new_port 5433

    if not test -f "$config_file"
        echo "Config file not found: $config_file" >&2
        return 1
    end

    set -l backup_file "$config_file.bak.dhis-proxy."(date +%s)
    cp "$config_file" "$backup_file"
    or begin
        echo "Failed to create backup: $backup_file" >&2
        return 1
    end

    function __restore_config --no-scope-shadowing
        if test -f "$backup_file"
            mv -f "$backup_file" "$config_file"
        end
    end

    function __on_int --on-signal INT --no-scope-shadowing
        __restore_config
        exit 130
    end
    function __on_term --on-signal TERM --no-scope-shadowing
        __restore_config
        exit 143
    end

    set -l tmp (mktemp)
    sed -E "s|^(connection\.url[[:space:]]*=[[:space:]]*jdbc:postgresql://localhost:)$old_port(/.*)|\1$new_port\2|" \
        "$config_file" > "$tmp"
    or begin
        echo "Failed to modify config file." >&2
        rm -f "$tmp"
        __restore_config
        return 1
    end
    mv -f "$tmp" "$config_file"
    or begin
        echo "Failed to write updated config file." >&2
        rm -f "$tmp"
        __restore_config
        return 1
    end

    env DATABASE_URL="postgres://dhis:dhis@localhost:$old_port/e2e?sslmode=disable" \
        sql-tapd --driver=postgres --listen=:$new_port --upstream=localhost:$old_port

    set -l exit_code $status   # <-- changed
    __restore_config
    return $exit_code
end
