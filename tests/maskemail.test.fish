#!/usr/bin/env fish
# Exercises maskemail's preconditions. The success path needs the real
# maskedemail-cli and a live Fastmail token, so it is not covered here.

set -g repo (dirname (status --current-filename))/..
source $repo/tests/helpers.fish
source $repo/fish/.config/fish/user/functions/maskemail.fish

echo "preconditions:"

maskemail >/dev/null 2>&1
check "no domain is a usage error" 2 $status

set -lx MASKEDEMAIL_CLI /nonexistent/maskedemail-cli
set -l err (maskemail example.com 2>&1 >/dev/null)
set -l st $status
check "missing cli exits 127" 127 $st

set -l hint no
string match -q '*go install*' -- "$err"; and set hint yes
check "missing cli says how to install it" yes $hint

test_summary
exit $status
