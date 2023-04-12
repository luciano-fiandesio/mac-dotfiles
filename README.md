# Install dependencies

xcode-select --install

# Install homebrew and formulas

homebrew/install.sh

# Make fish default shell

command -v fish | sudo tee -a /etc/shells

chsh -s "$(command -v fish)"


# Stow fish

`stow fish`

# Install fisher (fish plugin manager)

curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher

# Install fish plugins

`fish fisher/install.fish`


## Development

### Install asdf

```
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.2

mkdir -p ~/.config/fish/completions; and ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions
```

Check the [asdf installation guide](https://asdf-vm.com/guide/getting-started.html#_1-install-dependencies) for updated instructions.

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
Install the required JVM and tooling.

### python

```
./dev/python/setup.sh
```

### node

```
dev/node/setup.sh
```