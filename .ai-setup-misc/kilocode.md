{
  "$schema": "https://app.kilo.ai/config.json",
  "agent": {
    "ask": {
      "disable": true,
      "hidden": true
    },
    "build-lite": {
      "hidden": true,
      "disable": true,
      "model": "opencode/deepseek-v4-flash-free",
      "variant": "high",
      "description": "Lightweight build agent using Flash Free with Think High reasoning",
      "mode": "subagent",
      "permission": {
        "task": "deny"
      }
    },
    "code": {
      "hidden": true,
      "disable": true,
      "model": "opencode-go/deepseek-v4-pro"
    },
    "debug": {
      "hidden": true,
      "disable": true
    },
    "orchestrator": {
      "hidden": true,
      "disable": true
    },
    "plan": {
      "hidden": true,
      "disable": true,
      "model": "opencode-go/glm-5.2",
      "variant": "high",
      "permission": {
        "task": {
          "*": "deny",
          "explore": "allow"
        }
      }
    },
    "queen": {
      "mode": "primary",
      "description": "A high-level implementer.",
      "model": "opencode-go/deepseek-v4-flash",
      "variant": "high",
      "permission": {
        "bash": "allow",
        "read": "allow",
        "edit": "allow",
        "glob": "allow",
        "grep": "allow",
        "list": "allow",
        "task": "allow",
        "skill": "allow",
        "lsp": "allow",
        "todoread": "allow",
        "todowrite": "allow",
        "websearch": "allow",
        "webfetch": "allow",
        "doom_loop": "allow"
      },
      "prompt": "Always delegate high-volume codebase search, websearch, and code implementation. You are simply the controller, analyzer and decision-maker."
    },
    "explore": {
      "model": "opencode/deepseek-v4-flash-free",
      "variant": "max",
      "description": "Fast agent for exploring codebases and multi-step research. Use when you need to search multiple sources, find files by patterns, or cross-reference information.",
      "mode": "subagent",
      "permission": {
        "task": "deny"
      }
    },
    "general": {
      "model": "opencode/deepseek-v4-flash-free",
      "variant": "high"
    },
    "build": {
      "model": "opencode-go/deepseek-v4-pro",
      "variant": "max",
      "prompt": "Delegate to a sub-agent if the task requires multi-file exploration, multi-web search, multiple git-related steps, cross-dependency planning, or sequential steps.",
      "permission": {
        "task": {
          "*": "deny",
          "explore": "allow",
          "build-lite": "allow"
        }
      }
    }
  },
  "permission": {
    "bash": "allow"
  },
  "subagent_model": "opencode/mimo-v2.5-free",
  "subagent_variant_overrides": {
    "opencode/mimo-v2.5-free": "high"
  },
  "small_model": "opencode/mimo-v2.5-free"
}
