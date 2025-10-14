#!/bin/bash

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "Error: Node.js is not installed."
    echo "Please install Node.js from https://nodejs.org/"
    exit 1
fi

# Ask for confirmation
read -p "Do you want to install OpenAi Codex CLI? (y/n): " confirm

if [[ "$confirm" =~ ^[Yy]$ ]]; then
    echo "Installing Codex CLI..."
    npm install -g @openai/codex

    if [ $? -eq 0 ]; then
        echo ""
        echo "✓ OpenAI Codex CLI installed successfully!"
    else
        echo ""
        echo "✗ Installation failed. Please check the error messages above."
        exit 1
    fi
else
    echo "Installation cancelled."
    exit 0
fi
