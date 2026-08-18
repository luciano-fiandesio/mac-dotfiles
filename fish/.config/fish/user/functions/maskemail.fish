# 
# generated a masked email from fastmail
# requires: https://github.com/dvcrn/maskedemail-cli
# 
function maskemail --description 'Create a fastmail masked email for a domain'
    set -l domain $argv[1]
    if test -z "$domain"
        echo "maskemail: usage: maskemail <domain>" >&2
        return 2
    end

    set -l cli $MASKEDEMAIL_CLI
    test -n "$cli"; or set cli $HOME/go/bin/maskedemail-cli
    if not test -x "$cli"
        echo "maskemail: maskedemail-cli not found at $cli" >&2
        echo "maskemail: go install github.com/dvcrn/maskedemail-cli@latest" >&2
        return 127
    end

    set -l token (secret FASTMAIL_MASKEDMAIL_TOKEN)
    if test -z "$token"
        return 1
    end

    $cli -token $token create -domain $domain | pbcopy
    if test $pipestatus[1] -ne 0
        echo "maskemail: could not create a masked address for $domain" >&2
        return 1
    end
    echo "done!"
end
