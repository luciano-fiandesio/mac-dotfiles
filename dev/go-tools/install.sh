#!/usr/bin/env bash
# Installs the Go command line tools listed in tools.txt.
# --dry-run prints the tools that would be installed and exits.

set -euo pipefail

here=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
manifest=${GO_TOOLS_MANIFEST:-$here/tools.txt}

dry_run=false
if [[ ${1:-} == "--dry-run" ]]; then
  dry_run=true
fi

if [[ ! -f $manifest ]]; then
  echo "go-tools: manifest not found at $manifest" >&2
  exit 1
fi

# drop comments, trim surrounding whitespace, discard what is left empty
tools=()
while IFS= read -r line; do
  tools+=("$line")
done < <(sed -e 's/#.*//' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' "$manifest" | grep -v '^$' || true)

if [[ ${#tools[@]} -eq 0 ]]; then
  echo "go-tools: nothing listed in $manifest" >&2
  exit 1
fi

if $dry_run; then
  printf '%s\n' "${tools[@]}"
  exit 0
fi

if ! command -v go >/dev/null 2>&1; then
  echo "go-tools: go is not installed" >&2
  echo "go-tools: brew install go" >&2
  exit 127
fi

for tool in "${tools[@]}"; do
  echo "⬇️  $tool"
  go install "$tool"
done

bindir=$(go env GOBIN)
[[ -n $bindir ]] || bindir=$(go env GOPATH)/bin
echo "✅ installed ${#tools[@]} tool(s) into $bindir"
