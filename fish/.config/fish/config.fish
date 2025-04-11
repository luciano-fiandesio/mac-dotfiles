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
