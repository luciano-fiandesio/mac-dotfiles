#!/usr/bin/env bash

if [[ -f $HOME/.asdf/asdf.fish ]]; then
    
    echo "Setting up node using asdf..."
	asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
	asdf install nodejs latest
	asdf global nodejs latest
else
	echo "Please install asdf"
	exit
fi