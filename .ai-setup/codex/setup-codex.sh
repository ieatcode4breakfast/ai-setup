#!/usr/bin/env bash
# Codex CLI + DeepSeek machine-layer setup. Idempotent — safe to re-run.
#
# What it does:
#   1. Installs Codex via npm if missing; warns if older than CODE_MIN
#   2. Writes $CODEX_HOME/deepseek-models.json (overwritten each run — static metadata)
#   3. Writes $CODEX_HOME/config.toml ONLY if absent (existing config is never clobbered)
#   4. Appends a trust entry for the current repo (skipped if already present)
#   5. Imports DEEPSEEK_API_KEY from ./.env into ~/.deepseek.env (600 perms),
#      sourced by the shell rc. The .env itself is left untouched.
#   6. Self-verifies with `codex doctor`; exits non-zero on failure
#
# ponytail: ~/.deepseek.env is fully replaced each run (its known ceiling: other
# exports in that file are dropped). .env parsing supports `KEY=value`,
# `export KEY=value`, and quoted values; inline `#` comments after the value are
# not stripped. The catalog-path sed assumes the home path contains no `|`.

set -u

CODE_MIN="0.147.0"
SKIP_CODEX=0
SKIP_DOCTOR=0

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
CATALOG="$CODEX_HOME/deepseek-models.json"
CONFIG="$CODEX_HOME/config.toml"
SECRET_FILE="$HOME/.deepseek.env"
RC_LINE='[ -f "$HOME/.deepseek.env" ] && . "$HOME/.deepseek.env"'

die()  { printf 'ERROR: %s\n' "$*" >&2; exit 1; }
warn() { printf 'WARN: %s\n' "$*" >&2; }
step() { printf '==> %s\n' "$*"; }

ensure_codex() {
  [ "$SKIP_CODEX" = 1 ] && return 0
  if ! command -v codex >/dev/null 2>&1; then
    command -v npm >/dev/null 2>&1 || die "codex not found and npm is unavailable — install Node.js/npm first"
    step "installing codex via npm"
    npm install -g @openai/codex || die "npm install failed"
  fi
  local v
  v=$(codex --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)
  if [ -n "$v" ] && ! awk -v a="$v" -v b="$CODE_MIN" \
      'BEGIN { split(a, x, "."); split(b, y, "."); for (i = 1; i <= 3; i++) { if (x[i]+0 < y[i]+0) exit 1; if (x[i]+0 > y[i]+0) exit 0 } exit 0 }'; then
    warn "codex $v is older than $CODE_MIN — run 'codex update'"
  fi
}

write_catalog() {
  mkdir -p "$CODEX_HOME"
  cat > "$CATALOG" <<'JSONEOF'
{
  "models": [
    {
      "slug": "deepseek-v4-flash",
      "display_name": "DeepSeek V4 Flash",
      "description": "DeepSeek V4 Flash - fast, cost-efficient model (1M context)",
      "default_reasoning_level": "none",
      "supported_reasoning_levels": [
        { "effort": "none", "description": "No reasoning" },
        { "effort": "minimal", "description": "Minimal reasoning" },
        { "effort": "low", "description": "Light reasoning" },
        { "effort": "medium", "description": "Balanced reasoning" },
        { "effort": "high", "description": "Greater reasoning depth" },
        { "effort": "xhigh", "description": "Extra high reasoning depth" },
        { "effort": "max", "description": "Maximum reasoning depth" }
      ],
      "shell_type": "shell_command",
      "visibility": "list",
      "supported_in_api": true,
      "priority": 1,
      "additional_speed_tiers": [],
      "service_tiers": [],
      "availability_nux": null,
      "upgrade": null,
      "model_messages": null,
      "include_skills_usage_instructions": false,
      "include_plugin_usage_instructions": false,
      "include_apps_usage_instructions": false,
      "default_reasoning_summary": "none",
      "support_verbosity": false,
      "default_verbosity": null,
      "apply_patch_tool_type": null,
      "web_search_tool_type": "text",
      "truncation_policy": { "mode": "tokens", "limit": 10000 },
      "supports_parallel_tool_calls": true,
      "supports_image_detail_original": false,
      "context_window": 1000000,
      "max_context_window": 1000000,
      "comp_hash": null,
      "effective_context_window_percent": 95,
      "experimental_supported_tools": [],
      "input_modalities": ["text"],
      "supports_search_tool": false,
      "use_responses_lite": false,
      "tool_mode": null,
      "multi_agent_version": null,
      "base_instructions": "You are Codex, an AI coding agent. You and the user share one workspace. Work with the user to complete their tasks: understand the request, plan, implement, and verify. Be concise and precise."
    },
    {
      "slug": "deepseek-v4-pro",
      "display_name": "DeepSeek V4 Pro",
      "description": "DeepSeek V4 Pro - most capable model (1M context)",
      "default_reasoning_level": "none",
      "supported_reasoning_levels": [
        { "effort": "none", "description": "No reasoning" },
        { "effort": "minimal", "description": "Minimal reasoning" },
        { "effort": "low", "description": "Light reasoning" },
        { "effort": "medium", "description": "Balanced reasoning" },
        { "effort": "high", "description": "Greater reasoning depth" },
        { "effort": "xhigh", "description": "Extra high reasoning depth" },
        { "effort": "max", "description": "Maximum reasoning depth" }
      ],
      "shell_type": "shell_command",
      "visibility": "list",
      "supported_in_api": true,
      "priority": 2,
      "additional_speed_tiers": [],
      "service_tiers": [],
      "availability_nux": null,
      "upgrade": null,
      "model_messages": null,
      "include_skills_usage_instructions": false,
      "include_plugin_usage_instructions": false,
      "include_apps_usage_instructions": false,
      "default_reasoning_summary": "none",
      "support_verbosity": false,
      "default_verbosity": null,
      "apply_patch_tool_type": null,
      "web_search_tool_type": "text",
      "truncation_policy": { "mode": "tokens", "limit": 10000 },
      "supports_parallel_tool_calls": true,
      "supports_image_detail_original": false,
      "context_window": 1000000,
      "max_context_window": 1000000,
      "comp_hash": null,
      "effective_context_window_percent": 95,
      "experimental_supported_tools": [],
      "input_modalities": ["text"],
      "supports_search_tool": false,
      "use_responses_lite": false,
      "tool_mode": null,
      "multi_agent_version": null,
      "base_instructions": "You are Codex, an AI coding agent. You and the user share one workspace. Work with the user to complete their tasks: understand the request, plan, implement, and verify. Be concise and precise."
    }
  ]
}
JSONEOF
}

write_config() {
  # write-if-absent: an existing config is the user's — never overwrite it.
  [ -e "$CONFIG" ] && return 0
  mkdir -p "$CODEX_HOME"
  # ponytail: sed pipe substitutes the only placeholder; template has no other $ or backticks.
  sed "s|__CODEX_HOME__|$CODEX_HOME|" > "$CONFIG" <<'TOMEOF'
# ============================================================
#  DeepSeek — default provider & model
# ============================================================
model = "deepseek-v4-pro"   # accurate API name; "deepseek-chat" is an alias for this
model_provider = "deepseek"

# Custom model catalog so Codex knows DeepSeek's real metadata
# (1M context window, supported reasoning levels) — removes the
# "fallback metadata" warning and enables the /model picker.
model_catalog_json = "__CODEX_HOME__/deepseek-models.json"

# ============================================================
#  Reasoning effort — default (high)
# ============================================================
# DeepSeek accepts, lowest -> highest:
#   none | minimal | low | medium | high | xhigh | max
#   "high" = moderate thinking  |  "max" = deepest thinking
#   Change in-session via the /model picker or effort keybindings.
model_reasoning_effort = "high"

[model_providers.deepseek]
name = "DeepSeek"
base_url = "https://api.deepseek.com/v1"
env_key = "DEEPSEEK_API_KEY"
wire_api = "responses"
TOMEOF
}

add_trust() {
  # Append one trust entry for the current repo, idempotently. A duplicate
  # TOML table would be a parse error, so grep for the exact header first.
  local entry
  entry="[projects.\"$PWD\"]"
  grep -qF -- "$entry" "$CONFIG" 2>/dev/null || printf '\n%s\ntrust_level = "trusted"\n' "$entry" >> "$CONFIG"
}

import_key() {
  # The .env in the repo root is the source of truth. The key is never
  # printed or logged — only ever written to the 600-perm secret file.
  local value
  [ -f .env ] || die "no .env in $PWD — create it with a DEEPSEEK_API_KEY line, then re-run"
  chmod 600 .env
  value=$(sed -n \
    -e 's/^[[:space:]]*export[[:space:]][[:space:]]*DEEPSEEK_API_KEY[[:space:]]*=[[:space:]]*//p' \
    -e 's/^[[:space:]]*DEEPSEEK_API_KEY[[:space:]]*=[[:space:]]*//p' \
    .env | tail -n 1)
  value=${value%$'\r'}  # tolerate CRLF line endings
  case "$value" in
    \"*\"|\'*\') value="${value%\"}"; value="${value#\"}"; value="${value%\'}"; value="${value#\'}" ;;
  esac
  [ -n "$value" ] || die "no DEEPSEEK_API_KEY line found in .env"

  umask 077
  printf 'export DEEPSEEK_API_KEY=%s\n' "$value" > "$SECRET_FILE"
  chmod 600 "$SECRET_FILE"
  for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
    [ -f "$rc" ] || continue
    grep -qF -- "$RC_LINE" "$rc" 2>/dev/null || printf '\n%s\n' "$RC_LINE" >> "$rc"
  done
  # make the key available to codex doctor within this run
  # shellcheck disable=SC1090
  . "$SECRET_FILE"
  step "api key imported from .env into $SECRET_FILE (600)"
}

verify() {
  [ "$SKIP_DOCTOR" = 1 ] && return 0
  step "codex doctor"
  local out rc
  out=$(codex doctor 2>&1); rc=$?
  printf '%s\n' "$out" | tail -n 2
  if [ $rc -ne 0 ] || printf '%s\n' "$out" | grep -qE '[1-9][0-9]* fail'; then
    die "codex doctor reported a failure"
  fi
}

run_all() {
  step "codex"
  ensure_codex
  step "catalog"
  write_catalog
  step "config"
  write_config
  add_trust
  import_key
  verify
  step "done"
  echo "Codex + DeepSeek ready. New terminals pick up the key automatically."
  echo "This terminal: run 'source ~/.bashrc' (or ~/.zshrc) or open a new one."
}

self_test() {
  # Runs the full write path against a throwaway HOME/CODEX_HOME and asserts
  # the invariants. Never touches the real ~/.codex, real rc files, or real keys.
  local fake_home fake_key out
  fake_home=$(mktemp -d)
  HOME="$fake_home"; export HOME
  CODEX_HOME="$fake_home/.codex"; export CODEX_HOME
  SKIP_CODEX=1; SKIP_DOCTOR=1; export SKIP_CODEX SKIP_DOCTOR
  CATALOG="$CODEX_HOME/deepseek-models.json"
  CONFIG="$CODEX_HOME/config.toml"
  SECRET_FILE="$HOME/.deepseek.env"

  fail() { printf 'self-test FAILED: %s\n' "$*" >&2; [ -n "$fake_home" ] && rm -rf "$fake_home"; rm -f .env; exit 1; }

  fake_key="sk-test-1234567890abcdef"
  touch "$fake_home/.bashrc" "$fake_home/.zshrc"
  printf 'DEEPSEEK_API_KEY=%s\n' "$fake_key" > .env

  out=$(run_all 2>&1) || fail "run_all exited non-zero: $out"

  grep -q "deepseek-v4-pro" "$CONFIG" || fail "config missing model"
  grep -q "__CODEX_HOME__" "$CONFIG" && fail "catalog path placeholder unresolved"
  grep -q "deepseek-v4-flash" "$CATALOG" || fail "catalog missing flash slug"
  [ "$(stat -c %a "$SECRET_FILE" 2>/dev/null || stat -f %Lp "$SECRET_FILE")" = "600" ] || fail "secret file perms"
  grep -q "DEEPSEEK_API_KEY=$fake_key" "$SECRET_FILE" || fail "secret file content"
  grep -qF "$RC_LINE" "$fake_home/.bashrc" || fail "bashrc source line missing"
  grep -qF "$RC_LINE" "$fake_home/.zshrc" || fail "zshrc source line missing"
  [ "$(grep -cF "$RC_LINE" "$fake_home/.bashrc")" = "1" ] || fail "bashrc source line duplicated"

  # idempotency: existing config must not be clobbered, trust entry not duplicated
  echo "# marker-do-not-remove" >> "$CONFIG"
  local trust_before trust_after
  trust_before=$(grep -cF "[projects.\"$PWD\"]" "$CONFIG")
  run_all >/dev/null 2>&1
  grep -q "marker-do-not-remove" "$CONFIG" || fail "existing config was overwritten on re-run"
  trust_after=$(grep -cF "[projects.\"$PWD\"]" "$CONFIG")
  [ "$trust_before" = "1" ] && [ "$trust_after" = "1" ] || fail "trust entry duplicated on re-run"
  [ "$(grep -cF "$RC_LINE" "$fake_home/.bashrc")" = "1" ] || fail "bashrc source line duplicated on re-run"

  case "$out" in
    *"$fake_key"*) fail "api key leaked to script output" ;;
  esac

  rm -rf "$fake_home"
  rm -f .env
  echo "self-test: all checks passed"
}

if [ "${1:-}" = "--self-test" ]; then
  self_test
  exit 0
fi

run_all
