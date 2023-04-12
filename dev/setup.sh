#!/usr/bin/env bash

if [[ -f $HOME/.asdf/asdf.fish ]]; then
    
    echo "Setting up direnv using asdf..."
	asdf plugin-add direnv
	asdf direnv setup --shell fish --version latest
	
else
	echo "Please install asdf"
	exit
fi