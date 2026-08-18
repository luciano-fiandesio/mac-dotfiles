# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Personal macOS dotfiles, deployed with [GNU Stow](https://www.gnu.org/software/stow/). There is no build step and no linter. A small fish test suite covers the shell functions that have logic worth breaking; for everything else "correctness" means the symlinks land in the right place and the shell/tool still starts.

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

Not stow packages: `homebrew`, `fisher`, `dev`, `macos`, `espanso`, `doc`, `tests` — these hold scripts, run directly.

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
dev/go-tools/install.sh          # go CLI tools from dev/go-tools/tools.txt (--dry-run to preview)
dev/ai/claude.sh dev/ai/codex.sh # npm-global installs of the CLI agents
```

## Tests

```bash
fish tests/secret.test.fish                  # one suite
for t in tests/*.test.fish; fish $t; end     # all of them
```

`tests/helpers.fish` holds the shared assertions (`check`, `test_summary`). A suite sources it, sources the function under test straight out of the repo, and ends with `all checks passed`.

Suites build their own throwaway fixtures — `secret.test.fish` generates a scratch age key and sops store — so they never touch the real one. Two seams exist purely for that: `SECRET_STORE_FILE` overrides the store path, `MASKEDEMAIL_CLI` overrides the binary path.

Only our own logic is covered. Paths needing the network, a live API token, or a real external binary are left uncovered rather than faked.

## Fish configuration

`fish/.config/fish/config.fish` is the entry point and sources, in order: `env.fish`, `path.fish`, `aliases.fish`, `functions.fish`, then `.local.fish` if present.

- **Custom functions go in `fish/.config/fish/user/functions/`.** `functions.fish` sources every file in that directory at startup. This is the only fish function directory that is version-controlled.
- `fish/.config/fish/functions/`, `completions/`, `conf.d/`, `fish_plugins`, and `fish_variables` are **gitignored** — they are owned by fisher and by fish itself. Files exist there on disk but are not tracked; do not edit them as if they were repo content, and do not `git add -f` them. Plugin changes belong in `fisher/install.fish`.
- `aliases.fish` defines aliases as fish *functions* (including overrides of `grep`, `ls`, etc.) — follow that style.
- `~/.config/fish` is a single stow symlink into this repo, so a new file under `fish/.config/fish/` is live immediately. No `stow -R` needed.

## Secrets

API keys live in a **separate private repo**, sops-encrypted, cloned to `~/.config/secrets`. Nothing in this repo holds a credential.

- Read one with `secret <KEY>` (`fish/.config/fish/user/functions/secret.fish`). It decrypts the store on the first lookup in a shell and memoises it in a global — deliberately not exported, so children do not inherit the whole store. `secret-forget` clears the memo, which is required after any edit to the store.
- Exit codes are distinct: 1 unknown key or unreadable store, 2 no argument, 3 key still at its `REPLACE_ME` placeholder, 127 sops missing.
- The age identity is at `~/.config/sops/age/keys.txt`, which is **not** sops' default on macOS: sops resolves through `os.UserConfigDir()`, `~/Library/Application Support` here and `~/.config` on Linux. `SOPS_AGE_KEY_FILE` in `env.fish` covers fish sessions; a symlink under `~/Library/Application Support/sops/age/` covers every other process. Both are needed.
- Every value is encrypted to two recipients: the machine key and an offline backup key.
- `~/.gitconfig.local` is still hand-written per machine — name, email, signing key. `git/dot-gitconfig` `[include]`s it at the top and git is unconfigured without it; the README has the template.

README.md carries the full new-machine procedure, including why a new machine cannot enrol itself as a recipient.

`git/dot-gitconfig` also includes `~/.gitalias` (from `git/.gitalias`) and points `excludesfile` at `~/.gitignore` (from `git/dot-gitignore`) — those three files ship together.

## Conventions

- Shell scripts are `#!/usr/bin/env bash` and interactive: they confirm before installing and check for their prerequisite binary first (see `dev/ai/claude.sh`, `espanso/setup.sh`).
- The `Brewfile` keeps obsolete taps commented out rather than deleted; likewise `fisher/install.fish` comments out disabled plugins with the reason (usually a link to the upstream issue). Preserve that when removing something.
- README.md is the human-facing install guide and is organized per tool — when a package's setup steps change, update the matching README section.
- `rm` is aliased to `grm --interactive --verbose`. Scripts and tests must call `command rm`, or they stall on a prompt and silently skip the deletion.
- The global gitconfig sets `remote.origin.fetch`, so every freshly `git init`ed repo reports a phantom `origin` with no URL. `gh repo create --source=. --remote=origin` trips over it; set `remote.origin.url` directly, and add the standard `+refs/heads/*:refs/remotes/origin/*` refspec, which will otherwise be missing and leave `git fetch` unable to see branches.
