# .dotfiles

My macOS-specific dotfiles 🤘.

I also maintain a ArchLinux-specific dotfiles repo.

This dotfiles are customized for my needs and are mostly revolving around building a pleasant development experience.

The majority of these dotfiles can be managed using [Gnu Stow](https://www.gnu.org/software/stow/).

## Install dependencies

Install Xcode Command Line Tools

`xcode-select --install`

## Install homebrew and formulas

Install the brew formulas in the Brewfile. This will take a while!.
If you are using this repo, you may want to review which applications and command line tools get installed.

`homebrew/install.sh`

## Starship

[Starship](https://starship.rs/) is a highly customizable terminal prompt.

`stow starship`


## Make fish the default shell

I use [Fish](https://fishshell.com/) as my primary shell. 

```
command -v fish | sudo tee -a /etc/shells

chsh -s "$(command -v fish)"
```

## Configure the fish shell

`stow fish`

## Install fisher (fish plugin manager) and the plugins

```
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
fish fisher/install.fish
```

## Configure Kitty

[Kitty](https://sw.kovidgoyal.net/kitty/) is my terminal emulator of choice, mostly because of its configurability and speed.

`stow kitty`

Kitty uses the Hyperkey (CapsLock) as mod key (see the Karabinier section). 

## Configure Git

Git configuration and git aliases. Highly customized, you may want to review it before using it.

`stow git`


The `.gitconfig` file requires a local `.gitconfig.local` file, where sensitive info are stored.

This is a template:

```
[user]
  name = [name lastname]
  email = [email]
  useConfigOnly = false # see: https://collectiveidea.com/blog/archives/2016/04/04/multiple-personalities-in-git
  signingkey = [sign key] 
[github]
  user = [github user] 
  token = [github token]
[commit]
  gpgSign = false
```

## LSDeluxe

[LSDeluxe](https://github.com/lsd-rs/lsd): a `ls` rewrite with fancy colors and icons.

`stew lsd`


## Neovim

I use [AstroVim](https://github.com/AstroNvim/AstroNvim).

## Development

Short intro to `direnv` and `asdf`: <https://www.keybits.net/blog/asdf-and-direnv-isolated-environment-heaven>


### Install asdf

[asdf.vm](https://asdf-vm.com) is a versatile version manager for programming languages and development tools. It enables users to easily manage multiple versions of languages like Ruby, Node.js, and Elixir, streamlining the development process.

Check the [asdf installation guide](https://asdf-vm.com/guide/getting-started.html#_1-install-dependencies) for updated instructions.

```
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.11.3

mkdir -p ~/.config/fish/completions; and ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions
```


### Install other development dependencies


Setup `direnv`

```
./dev/setup.sh
```

### java

```
dev/java/setup.sh
```

This will install `sdkman` <https://sdkman.io>.
Install the required JVM and tooling (Gradle, Maven, etc.)

### python

```
./dev/python/setup.sh
```

### node

```
dev/node/setup.sh
```