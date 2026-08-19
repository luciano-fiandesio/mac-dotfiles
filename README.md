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

Fish automatically loads a `.local.fish` file, for settings that belong to one machine only:

.local.fish

```
set -gx SOME_MACHINE_LOCAL_SETTING value
```

API keys are not kept here, see [Secrets](#secrets).

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

## Secrets

API keys live in a private [sops](https://github.com/getsops/sops)-encrypted store, decrypted
with an [age](https://github.com/FiloSottile/age) key that never leaves the machine that
generated it. The store is a separate private repo, cloned to `~/.config/secrets`.

Read a key from the shell:

```
secret OPENAI_API_KEY
```

The store is decrypted once per shell, on the first lookup, and held in memory afterwards.
Nothing is decrypted at startup, so a shell that never asks for a secret never pays for one.

### Setting up a new machine

`sops` and `age` are both in the Brewfile. On Linux, install them from the package manager first.

**1. Generate this machine's age key**

```
mkdir -p ~/.config/sops/age && chmod 700 ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt
```

Note the `age1...` public key it prints, it is needed in step 3. The private key stays here:
every machine generates its own and they are never copied around.

**2. On macOS, make the key visible outside fish**

```
mkdir -p ~/Library/"Application Support"/sops/age
ln -sfn ~/.config/sops/age/keys.txt ~/Library/"Application Support"/sops/age/keys.txt
```

`SOPS_AGE_KEY_FILE` in `env.fish` covers fish sessions on both platforms. This symlink covers
everything else, because sops looks under `~/Library/Application Support` on macOS and under
`~/.config` on Linux.

**3. Enrol the new key, on a machine that already has access**

The new machine cannot do this itself: it cannot decrypt the store yet. In `~/.config/secrets`
on an enrolled machine, add the `age1...` public key to the `keys:` list in `.sops.yaml`,
reference it in the `key_groups` block, then re-encrypt and push:

```
sops updatekeys secrets.enc.yaml
git commit -am "Add <machine> as a recipient" && git push
```

**4. Clone the store on the new machine**

```
git clone https://github.com/luciano-fiandesio/dotfiles-secrets.git ~/.config/secrets
chmod 700 ~/.config/secrets
```

**5. Verify**

```
secret OPENAI_API_KEY
```

### Editing and rotating

```
sops ~/.config/secrets/secrets.enc.yaml
```

Opens the decrypted file in `$EDITOR` and re-encrypts it on save. Commit and push afterwards.

Shells started before the edit still hold the old values in memory. Run `secret-forget` in each,
or open a new shell.

### Recovery

Every value is also encrypted to an offline backup key, held off all machines and protected by a
passphrase. If every machine is lost, the store still opens with it:

```
age -d /path/to/age-backup-key.age > /tmp/backup-id.txt && chmod 600 /tmp/backup-id.txt
env HOME=$(mktemp -d) SOPS_AGE_KEY_FILE=/tmp/backup-id.txt sops -d ~/.config/secrets/secrets.enc.yaml
command rm -f /tmp/backup-id.txt
```

Overriding `HOME` forces sops to ignore the machine key, so this exercises the backup rather than
quietly succeeding with the wrong identity.

Removing a recipient does not protect values already committed: git history keeps the old
ciphertext. Decommissioning a machine means removing it from `.sops.yaml` **and** rotating the
keys it could read.

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

#### go

Command line tools written in Go are listed in `dev/go-tools/tools.txt`:

```
dev/go-tools/install.sh              # install everything listed
dev/go-tools/install.sh --dry-run    # show what would be installed
```

They land in `~/go/bin`, which `path.fish` puts on `PATH`.

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
