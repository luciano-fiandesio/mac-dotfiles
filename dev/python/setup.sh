#!/usr/bin/env bash

if [[ -f $HOME/.asdf/asdf.fish ]]; then
    
    echo "Setting up python 3 using asdf..."
	asdf plugin-add python
	asdf install python latest
	asdf global python latest
else
	echo "Please install asdf"
	exit
fi