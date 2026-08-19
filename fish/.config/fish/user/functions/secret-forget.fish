# Drops the decrypted secret store from the current shell.
# The next `secret` lookup decrypts the store again.

function secret-forget --description 'Drop the decrypted secret store from this shell'
    set -e __secret_store
    return 0
end
