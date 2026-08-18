#!/usr/bin/env fish
# Exercises the `secret` helper against a throwaway sops store.
# Builds its own age key and store, so the real secrets are never touched.

set -g repo (dirname (status --current-filename))/..
source $repo/tests/helpers.fish

# ---- throwaway store -------------------------------------------------------

set -g tmp (mktemp -d)
function cleanup --on-event fish_exit
    command rm -rf $tmp
end

age-keygen -o $tmp/keys.txt 2>/dev/null
set -g pubkey (grep -o 'age1[a-z0-9]*' $tmp/keys.txt | head -1)

printf 'creation_rules:\n  - key_groups:\n      - age: [%s]\n' $pubkey >$tmp/.sops.yaml
printf 'PLAIN_KEY: plain-value\nEQUALS_KEY: abc=def=ghi\nPLACEHOLDER_KEY: REPLACE_ME\n' >$tmp/secrets.enc.yaml

env SOPS_AGE_KEY_FILE=$tmp/keys.txt \
    sops -e -i --config $tmp/.sops.yaml $tmp/secrets.enc.yaml

set -gx SOPS_AGE_KEY_FILE $tmp/keys.txt
set -gx SECRET_STORE_FILE $tmp/secrets.enc.yaml

source $repo/fish/.config/fish/user/functions/secret.fish
source $repo/fish/.config/fish/user/functions/secret-forget.fish

# ---- lookups ---------------------------------------------------------------

echo "lookups:"
check "known key returns its value" plain-value (secret PLAIN_KEY)
check "value containing = survives intact" abc=def=ghi (secret EQUALS_KEY)

set -l out (secret MISSING_KEY 2>/dev/null)
set -l st $status
check "missing key exits non-zero" 1 $st
check "missing key prints nothing on stdout" "" "$out"

secret >/dev/null 2>&1
check "no argument is a usage error" 2 $status

set -l ph (secret PLACEHOLDER_KEY 2>/dev/null)
set -l phst $status
check "unfilled placeholder is refused" 3 $phst
check "placeholder prints nothing on stdout" "" "$ph"

# ---- memoisation -----------------------------------------------------------
# Deleting the store proves the second lookup was served from memory rather
# than by decrypting again.

echo "memoisation:"
secret PLAIN_KEY >/dev/null
command rm -f $tmp/secrets.enc.yaml
check "serves from memo after store is gone" plain-value (secret PLAIN_KEY)

secret-forget
secret PLAIN_KEY 2>/dev/null
check "secret-forget drops the memo" 1 $status

# ---- result ----------------------------------------------------------------

test_summary
exit $status
