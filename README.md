# Ghetto Gist Manager

## Prerequisites
- GitHub client (gh): https://github.com/cli/cli/blob/trunk/docs/install_linux.md
- fzf: https://github.com/junegunn/fzf/releases
- nano: (any package manager)

## Description

This is a simple script that allows you to manage your gists from the command line. It is written in Bash and uses 'gh' to interact with the GitHub API.

## Installation
```Bash
git clone https://github.com/uwbfritz/gist-editor.git
cd gist-editor
chmod +x gist.sh
sudo cp gist.sh /usr/bin/gist
```

## Usage
```Bash
gist
```

## Troubleshooting
- I'm getting another editor than nano:
    
```Bash
    echo "export EDITOR=/usr/bin/nano" >> ~/.bashrc
    source ~/.bashrc
```
