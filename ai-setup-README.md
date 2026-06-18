# ai-setup

1. Copy files into a project
2. Make sure everything in ai-setup-gitignore.txt is copied into the global gitignore file without removing existing gitignores

```
curl -O https://raw.githubusercontent.com/ieatcode4breakfast/ai-setup/main/opencode.json
curl -O https://raw.githubusercontent.com/ieatcode4breakfast/ai-setup/main/AGENTS.md
```

Once per machine:
```
mkdir -p ~/.config/git
curl -s https://raw.githubusercontent.com/ieatcode4breakfast/ai-setup/main/ai-setup-gitignore.txt >> ~/.config/git/ignore
git config --global core.excludesFile ~/.config/git/ignore
```
