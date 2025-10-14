#!/bin/bash

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "Error: Node.js is not installed."
    echo "Please install Node.js from https://nodejs.org/"
    exit 1
fi

# Ask for confirmation
read -p "Do you want to install Claude Code? (y/n): " confirm

if [[ "$confirm" =~ ^[Yy]$ ]]; then
    echo "Installing Claude Code..."
    npm install -g @anthropic-ai/claude-code

    if [ $? -eq 0 ]; then
        echo ""
        echo "✓ Claude Code installed successfully!"
    else
        echo ""
        echo "✗ Installation failed. Please check the error messages above."
        exit 1
    fi
else
    echo "Installation cancelled."
    exit 0
fi
