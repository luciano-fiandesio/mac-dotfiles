# fish config
set --global --export DOTFILES_REPO ~/.mac-dotfiles

# no greeting
set fish_greeting

source ~/.config/fish/env.fish
source ~/.config/fish/path.fish
source ~/.config/fish/aliases.fish
source ~/.config/fish/functions.fish

if test -e ~/.config/fish/.local.fish
    source ~/.config/fish/.local.fish
end

# asdf - use mise now
#source ~/.asdf/asdf.fish
function dhis2_java_switch --on-variable PWD
    # Normalize to absolute paths
    set dhis2_root "$HOME/projects/clients/dhis2/dhis2-core"
    set dhis2_sub "$HOME/projects/clients/dhis2/dhis2-core/dhis-2"

    switch $PWD
        case $dhis2_root $dhis2_sub
            sdk use java 17.0.12-oracle
    end
end

# Enable starship prompt
# https://starship.rs/
starship init fish | source

# Enable mcfly
mcfly init fish | source

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/luciano/.cache/lm-studio/bin
