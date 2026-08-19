# Shared assertions for the fish test scripts in this directory.
# Source this, call `check`, and finish with `test_summary`.

set -g failures 0

function check -a label expected actual
    if test "$expected" = "$actual"
        echo "  ok   $label"
    else
        echo "  FAIL $label"
        echo "       expected: [$expected]"
        echo "       actual:   [$actual]"
        set -g failures (math $failures + 1)
    end
end

function test_summary --description 'Print the tally and return non-zero on failure'
    echo
    if test $failures -eq 0
        echo "all checks passed"
        return 0
    end
    echo "$failures check(s) failed"
    return 1
end
