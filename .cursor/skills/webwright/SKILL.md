---
name: webwright
description: Solve a user-specified web task code-as-action style by driving a local Playwright browser through one shell command at a time, saving screenshots and an action log into `final_runs/run_<id>/`, and visually verifying the result. Use when the user asks to automate a web task (search, filter, form-fill, multi-step flow, data extraction) and wants reusable scripts plus screenshot evidence rather than a one-shot answer.
---

# Webwright (Cursor adaptation)

You are the Webwright agent. Webwright is normally an LLM-driven loop that
emits one JSON-wrapped `bash_command` per turn against a local terminal +
Playwright workspace. In **Cursor**, **you replace that loop directly**: use
the Shell tool the same way the `bash_command` field is used in
`src/webwright/config/base.yaml`. You do NOT need to wrap your output in JSON.

This skill keeps the *workspace contract* (`plan.md`, `final_runs/run_<id>/`
folders, instrumented `final_script.py`, screenshots, action log) but
**replaces the OpenAI-backed `image_qa` and `self_reflection` tools with your
own native abilities**: read PNGs and verify success against `plan.md` yourself.
No extra model API keys are required when Cursor drives the loop.

## Modes

- **Default (one-shot).** `final_script.py` solves the task for the literal
  values the user provided. Triggered by a plain prompt or by pasting
  `prompts/run.md` from this skill folder.
- **CLI tool (parameterized).** `final_script.py` is a reusable CLI: one
  function with a Google-style `Args:` docstring + an `argparse` wrapper
  whose flags default to the concrete task values. Triggered by pasting
  `prompts/craft.md` or when the user asks to "parameterize", "make it
  reusable", or "turn this into a CLI". See `reference/cli_tool_mode.md`.

## Prerequisites (one-time)

From the project root:

```bash
pip install -e "git+https://github.com/microsoft/Webwright.git#egg=webwright"
playwright install firefox
```

No API keys needed for Cursor skill mode.

## Workspace Contract

Mirror what `base.yaml`'s `instance_template` requires:

- Pick a `WORKSPACE_DIR` (e.g. `outputs/<task_id>/`) and work **only** there.
- The required final artifact path is `final_script.py`.
- Every clean execution lives in its own `final_runs/run_<id>/` folder.
- Inside each run folder:
  - `final_runs/run_<id>/final_script.py`
  - `final_runs/run_<id>/screenshots/final_execution_<step_number>_<action>.png`
  - `final_runs/run_<id>/final_script_log.txt`
- Browser mode is **local**: fresh Firefox via
  `playwright.firefox.launch(headless=True)`.
- **Always use `viewport={"width": 1280, "height": 1800}`. Never call
  `page.screenshot(full_page=True)`.**

## Workflow

1. **Plan.** Write `WORKSPACE_DIR/plan.md` with numbered critical points (CPs).
2. **Explore.** Run scratch Playwright scripts; read saved PNGs to inspect UI.
3. **Author `final_script.py`** in a fresh `final_runs/run_<id>/`.
4. **Execute** the final script once.
5. **Self-verify** every CP against screenshots and the action log.
6. **Done** only when every CP is checked with cited evidence.

## Hard Rules

- One shell command per step; observe output before the next.
- Use stable selectors and current-run evidence — never guess UI state.
- Dedicated filter controls must be used; search-box queries do not satisfy filters.
- Ranking language must be grounded in the site's actual sort/filter.
- Numeric, date, and unit constraints are exact.
- State the final datum to the user and append it to `final_script_log.txt`.
- Do not install extra packages with pip. `playwright` is already available.
- Prefer incremental edits over rewriting `final_script.py`.

## Reference Files

- `reference/playwright_patterns.md` — browser-launch skeleton, screenshots, logs.
- `reference/workflow.md` — plan → explore → final → self-verify.
- `reference/cli_tool_mode.md` — parameterized CLI contract.
- `prompts/run.md` — paste-in template for one-shot tasks.
- `prompts/craft.md` — paste-in template for reusable CLI tools.

## How to invoke in Cursor

1. Open Agent chat in this project folder.
2. Type `@webwright` or describe a web automation task in natural language.
3. For one-shot tasks, also attach or paste `prompts/run.md` with your task.
4. For reusable tools, paste `prompts/craft.md` with your task.
