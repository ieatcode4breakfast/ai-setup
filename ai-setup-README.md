# ai-setup

Portable AI coding setup — clone anywhere, prevent AI tool config from leaking into remote repos.

## What it does

This repo contains your personal opencode config, agent rules, and a global gitignore template. Clone it onto any machine, copy the files where they belong, and no AI tool will ever accidentally commit its config files into a remote repo again.

## Quick start

1. Clone into a permanent location:
   ```
   git clone https://github.com/ieatcode4breakfast/ai-setup.git ~/ai-setup
   ```

2. Install the global gitignore (appends to your existing global ignore — does NOT replace anything you already have):
   ```
   mkdir -p ~/.config/git
   cat ~/ai-setup/ai-setup-gitignore.txt >> ~/.config/git/ignore
   git config --global core.excludesFile ~/.config/git/ignore
   ```