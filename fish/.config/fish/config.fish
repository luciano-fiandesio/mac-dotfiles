# fish config
set --global --export DOTFILES_REPO ~/.dotfiles-arch

# no greeting
set fish_greeting

source ~/.config/fish/path.fish
source ~/.config/fish/aliases.fish
source ~/.config/fish/functions.fish

if test -e ~/.config/fish/.local.fish
  source ~/.config/fish/.local.fish
end 

# asdf
source ~/.asdf/asdf.fish

# Enable starship prompt
# https://starship.rs/
starship init fish | source

# Enable mcfly
mcfly init fish | source
