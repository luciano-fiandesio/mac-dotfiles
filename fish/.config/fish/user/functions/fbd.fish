# fbd - delete git branch (including remote branches)
# Select branches with TAB
# Delete branches with Enter
function fbd
    set -l branches (git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)")
    set -l selected_branches (string split \n -- $branches | fzf --multi)
    
    if test -n "$selected_branches"
        for branch in $selected_branches
            set -l branch_name (echo $branch | sed "s/.* //" | sed "s#remotes/[^/]*/##")
            echo "Deleting branch: $branch_name"
            git branch -D $branch_name
        end
    end
end