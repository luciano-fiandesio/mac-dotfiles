#!/usr/bin/env fish
# Exercises the go-tools manifest parsing and preconditions.
# Actually installing a tool needs the network, so that is not covered here.

set -g repo (dirname (status --current-filename))/..
source $repo/tests/helpers.fish

set -l script $repo/dev/go-tools/install.sh
set -l tmp (mktemp -d)
printf '# a comment\n\nexample.com/one@latest\n  example.com/two@v1.2.3  \n\n# trailing\n' >$tmp/tools.txt

echo "manifest parsing:"
set -lx GO_TOOLS_MANIFEST $tmp/tools.txt
set -l out (bash $script --dry-run)
check "comments and blank lines are skipped" 2 (count $out)
check "first entry" example.com/one@latest "$out[1]"
check "surrounding whitespace is trimmed" example.com/two@v1.2.3 "$out[2]"

echo "preconditions:"
env PATH=/usr/bin:/bin GO_TOOLS_MANIFEST=$tmp/tools.txt bash $script >/dev/null 2>&1
check "missing go toolchain exits 127" 127 $status

set -lx GO_TOOLS_MANIFEST $tmp/does-not-exist.txt
bash $script --dry-run >/dev/null 2>&1
check "missing manifest exits non-zero" 1 $status

command rm -rf $tmp
test_summary
exit $status
