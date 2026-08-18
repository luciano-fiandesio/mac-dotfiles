# Reads a single value out of the sops-encrypted secret store.
# Decrypts the store once per shell, then answers later lookups from memory.

function secret --description 'Read a value from the encrypted secret store'
    set -l name $argv[1]
    if test -z "$name"
        echo "secret: usage: secret <KEY>" >&2
        return 2
    end

    if not set -q __secret_store
        if not type -q sops
            echo "secret: sops is not installed" >&2
            return 127
        end

        set -l store $SECRET_STORE_FILE
        test -n "$store"; or set store ~/.config/secrets/secrets.enc.yaml
        if not test -f "$store"
            echo "secret: store not found at $store" >&2
            return 1
        end

        # -g and not -gx: child processes must not inherit the whole store
        set -g __secret_store (sops -d --output-type dotenv "$store" 2>/dev/null)
        if test (count $__secret_store) -eq 0
            set -e __secret_store
            echo "secret: could not decrypt $store" >&2
            return 1
        end
    end

    for line in $__secret_store
        set -l pair (string split -m1 -- '=' $line)
        if test (count $pair) -lt 2
            continue
        end
        if test "$pair[1]" = "$name"
            printf '%s\n' (string trim --chars='"' -- $pair[2])
            return 0
        end
    end

    echo "secret: no such key: $name" >&2
    return 1
end
