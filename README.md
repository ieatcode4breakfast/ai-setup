# ai-setup

## Prerequisites (before running the AI prompt)

- **Git** — the setup clones this repo (installed on Codespaces by default)
- **Node.js + npm** — the Codex step installs the Codex CLI itself via npm; if npm is missing, the script stops and tells you to install Node first
- **DeepSeek account + API key** — create a `.env` file in the project root containing `DEEPSEEK_API_KEY=sk-...` before running the setup. The script imports it into `~/.deepseek.env` (600 perms). No ChatGPT/OpenAI login is needed — the DeepSeek key is Codex's authentication
- After the setup completes, open a **new terminal** (or `source ~/.bashrc`) so the key is in the environment; then just run `codex` whenever

AI prompt:
```
Download and sync all files from https://github.com/ieatcode4breakfast/ai-setup into the current project:

1. Clone the ai-setup repo into a temporary directory (shallow clone, no history):
   TEMP_DIR=$(mktemp -d)
   git clone --depth 1 https://github.com/ieatcode4breakfast/ai-setup "$TEMP_DIR"

2. Remove README.md from the temp clone (not needed):
   rm "$TEMP_DIR/README.md" 2>/dev/null

3. For each file in the temp clone (excluding the .git directory):
   a. Compute its relative path from the temp root
   b. Delete the file at that relative path in the current project if it already exists
   c. Ensure the parent directories exist in the current project
   d. Copy the file from the temp clone into the current project at the relative path
   e. Append "/<relative-path>" to .git/info/exclude (always with leading /)

4. Normalize all non-comment, non-blank exclude entries to use a leading /, then deduplicate:
   sed -i '/^$/b; /^#/b; s|^[^/]|/&|' .git/info/exclude
   sort -u -o .git/info/exclude .git/info/exclude

5. Remove the temporary clone directory:
   rm -rf "$TEMP_DIR"

6. Verify nothing from the downloaded repo is tracked by Git in the current project:
   git status --short

7. Run the Codex + DeepSeek machine-layer setup (installs the Codex CLI if missing, writes ~/.codex config + model catalog, imports DEEPSEEK_API_KEY from a .env file in the project root if present, and self-verifies with `codex doctor`):
   bash .ai-setup/codex/setup-codex.sh

Full one-shot command:
TEMP_DIR=$(mktemp -d) && git clone --depth 1 https://github.com/ieatcode4breakfast/ai-setup "$TEMP_DIR" && rm "$TEMP_DIR/README.md" 2>/dev/null && find "$TEMP_DIR" -name '.git' -prune -o -type f -print | while read -r src; do rel="${src#$TEMP_DIR/}"; rm -f "$rel" 2>/dev/null; mkdir -p "$(dirname "$rel")"; cp "$src" "$rel"; echo "/$rel" >> .git/info/exclude; done && sed -i '/^$/b; /^#/b; s|^[^/]|/&|' .git/info/exclude && sort -u -o .git/info/exclude .git/info/exclude && rm -rf "$TEMP_DIR" && echo "Done. Git status:" && git status --short
```

Then run the Codex + DeepSeek setup (with `DEEPSEEK_API_KEY=...` in a `.env` file in the project root):
```
bash .ai-setup/codex/setup-codex.sh
```
```
