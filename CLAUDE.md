# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Personal macOS dotfiles, deployed with [GNU Stow](https://www.gnu.org/software/stow/). There is no build, no test suite, and no linter — "correctness" means the symlinks land in the right place and the shell/tool still starts.

## Stow model (read this before adding or moving any file)

- The repo is expected to live at `~/.mac-dotfiles`. Stow's default target is the **parent of the current directory**, so all `stow` commands must be run from the repo root and deploy into `$HOME`.
- `.stowrc` sets `--dotfiles`. A file named `dot-gitconfig` is symlinked as `~/.gitconfig`. Files that already begin with a literal `.` (e.g. `git/.gitalias`, `macos/.macos`) are linked verbatim.
- Each top-level directory is one stow **package**; the path *inside* it mirrors the path under `$HOME`. `starship/.config/starship.toml` → `~/.config/starship.toml`. So placement inside a package is the deployment decision — get it right rather than fixing it up afterwards.
- Preview before applying, always:

```bash
stow -n -v <package>     # dry run, show what would be linked
stow <package>           # link
stow -R <package>        # relink after adding/removing files in a package
stow -D <package>        # unlink
```

Stow packages: `aichat claude fish ghostty git karabiner kitty lsd mpd ncmpcpp phoenix starship`.

Not stow packages: `homebrew`, `fisher`, `dev`, `macos`, `espanso`, `doc` — these hold scripts, run directly.

## Setup commands

```bash
cd homebrew && ./install.sh      # installs Homebrew if missing, then `brew bundle --file=./Brewfile`
                                 # (uses a relative Brewfile path — must be run from homebrew/)
fish fisher/install.fish         # install the fish plugins
./espanso/setup.sh -l            # symlink espanso matches into the espanso config dir (-r to remove)
./macos/.macos                   # apply macOS defaults (reboots-worth of settings; read before running)
dev/java/setup.sh                # sdkman
dev/python/setup.sh              # uv
dev/node/setup.sh                # node via asdf (requires asdf already installed)
dev/ai/claude.sh dev/ai/codex.sh # npm-global installs of the CLI agents
```

## Fish configuration

`fish/.config/fish/config.fish` is the entry point and sources, in order: `env.fish`, `path.fish`, `aliases.fish`, `functions.fish`, then `.local.fish` if present.

- **Custom functions go in `fish/.config/fish/user/functions/`.** `functions.fish` sources every file in that directory at startup. This is the only fish function directory that is version-controlled.
- `fish/.config/fish/functions/`, `completions/`, `conf.d/`, `fish_plugins`, and `fish_variables` are **gitignored** — they are owned by fisher and by fish itself. Files exist there on disk but are not tracked; do not edit them as if they were repo content, and do not `git add -f` them. Plugin changes belong in `fisher/install.fish`.
- `aliases.fish` defines aliases as fish *functions* (including overrides of `grep`, `ls`, etc.) — follow that style.

## Secrets

Never committed; two local files supply them, both created by hand on each machine:

- `~/.config/fish/.local.fish` — env vars / API keys (gitignored inside the fish package).
- `~/.gitconfig.local` — user name, email, signing key, GitHub token. `git/dot-gitconfig` `[include]`s it at the top and would otherwise leave git unconfigured; the README has the template.

`git/dot-gitconfig` also includes `~/.gitalias` (from `git/.gitalias`) and points `excludesfile` at `~/.gitignore` (from `git/dot-gitignore`) — those three files ship together.

## Conventions

- Shell scripts are `#!/usr/bin/env bash` and interactive: they confirm before installing and check for their prerequisite binary first (see `dev/ai/claude.sh`, `espanso/setup.sh`).
- The `Brewfile` keeps obsolete taps commented out rather than deleted; likewise `fisher/install.fish` comments out disabled plugins with the reason (usually a link to the upstream issue). Preserve that when removing something.
- README.md is the human-facing install guide and is organized per tool — when a package's setup steps change, update the matching README section.
