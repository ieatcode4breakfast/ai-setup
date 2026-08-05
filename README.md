# ai-setup

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
   e. Append that relative path to .git/info/exclude in the current project

4. Deduplicate .git/info/exclude after all files are processed:
   sort -u -o .git/info/exclude .git/info/exclude

5. Remove the temporary clone directory:
   rm -rf "$TEMP_DIR"

6. Verify nothing from the downloaded repo is tracked by Git in the current project:
   git status --short

Full one-shot command:
TEMP_DIR=$(mktemp -d) && git clone --depth 1 https://github.com/ieatcode4breakfast/ai-setup "$TEMP_DIR" && rm "$TEMP_DIR/README.md" 2>/dev/null && find "$TEMP_DIR" -name '.git' -prune -o -type f -print | while read -r src; do rel="${src#$TEMP_DIR/}"; rm -f "$rel" 2>/dev/null; mkdir -p "$(dirname "$rel")"; cp "$src" "$rel"; echo "/$rel" >> .git/info/exclude; done && sort -u -o .git/info/exclude .git/info/exclude && rm -rf "$TEMP_DIR" && echo "Done. Git status:" && git status --short
```
