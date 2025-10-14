# .dotfiles

My macOS-specific dotfiles 🤘.

![kitty](doc/screenshot.png?raw=true)

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

Fish automatically loads a `.local.fish` file that can be used to store secrets and API keys:

.local.fish

```
set -Ux OPENAI_API_KEY sk-12345667
```

## Install fisher (fish plugin manager) and the plugins

```
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
fish fisher/install.fish
```

## Configure Ghostty

[Ghostty](https://ghostty.org) is my terminal emulator of choice, mostly because of its configurability and speed.

`stow ghostty`

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

`stow lsd`

## Neovim

I use [LazyVim](http://www.lazyvim.org).

Checkout the [Installation](http://www.lazyvim.org/installation) page for updated instructions.

## Karabinier

Mainly to setup the Hyperkey (`caps_lock` to `command+control+option+shift`) and get the `~` key to work.

`stow karabinier`

## Phoenix

My [favourite](https://github.com/kasper/phoenix) window manager, can be configured using Javascript.

`stow phoenix`

Tiling movements are mapped to Hyperkey + arrow keys.

### Docker

I use [OrbStack](https://orbstack.dev) as Docker Desktop replacement.

Compose and other tools are included in OrbStack.

### Setup development environment

#### java

```
dev/java/setup.sh
```

This will install `sdkman` <https://sdkman.io>.
Install the required JVM and tooling (Gradle, Maven, etc.)

#### python

Install `uv`.

```
./dev/python/setup.sh
```

### IntelliJ

I prefer to install IntelliJ by [downloading](https://www.jetbrains.com/idea/download/#section=mac) the dmg directly from Jetbrains.

Theme: [OneDark](https://plugins.jetbrains.com/plugin/11938-one-dark-theme)

Fonts: [MonoLisa](https://www.monolisa.dev) - ligatures enabled

**Plugins:**

- [AceJump](https://plugins.jetbrains.com/plugin/7086-acejump)

Hotkey: `hyper + ;`

- [Copilot](https://plugins.jetbrains.com/plugin/17718-github-copilot)
- [JPA Buddy](https://plugins.jetbrains.com/plugin/15075-jpa-buddy)
- [Mario Progress Bar](https://plugins.jetbrains.com/plugin/14708-mario-progress-bar)
- [Rainbow Bracket](https://plugins.jetbrains.com/plugin/10080-rainbow-brackets)
- [Return Highlighter](https://plugins.jetbrains.com/plugin/13303-return-highlighter)
