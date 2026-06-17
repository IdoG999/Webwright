# Webwright Tutorial — Learn in Cursor

A hands-on guide to [Microsoft Webwright](https://github.com/microsoft/Webwright), adapted for **Cursor**. By the end you will understand the paradigm, run tasks two ways, inspect artifacts, and build reusable browser automation scripts.

**Time:** ~45–90 minutes  
**Prerequisites:** Python 3.10+, Cursor, basic terminal comfort

---

## Table of contents

1. [The big idea](#1-the-big-idea)
2. [Setup](#2-setup)
3. [Your first Cursor task (skill mode)](#3-your-first-cursor-task-skill-mode)
4. [Understanding the workspace contract](#4-understanding-the-workspace-contract)
5. [Harness mode (Python CLI)](#5-harness-mode-python-cli)
6. [Craft a reusable CLI tool](#6-craft-a-reusable-cli-tool)
7. [Debugging & inspection](#7-debugging--inspection)
8. [Exercise ideas](#8-exercise-ideas)
9. [Cursor tips](#9-cursor-tips)
10. [Further reading](#10-further-reading)

---

## 1. The big idea

### The old paradigm

```
Page screenshot → Model picks ONE action → Click → Repeat
```

The browser session **is** the agent's memory. Every step depends on the last. Long tasks accumulate errors.

### The Webwright paradigm

```
Task → Model writes Python → Run in terminal → Inspect logs/screenshots → Refine code
```

The **workspace** is the memory: `plan.md`, `final_script.py`, screenshots, action logs. Browsers are **disposable** — launch, use, close.

### Why this matters

- **Robustness:** Playwright selectors beat pixel coordinates.
- **Efficiency:** One script can fill an entire form; not 20 separate clicks.
- **Reusability:** `final_script.py` becomes an RPA-style tool you can rerun or share.

Read the [Microsoft Research article](https://www.microsoft.com/en-us/research/articles/webwright-a-terminal-is-all-you-need-for-web-agents/) for architecture details and benchmark numbers.

---

## 2. Setup

### Step 2.1 — Clone and enter the project

```bash
git clone https://github.com/IdoG999/Webwright.git
cd Webwright
```

### Step 2.2 — Run the setup script

```bash
chmod +x scripts/setup.sh
./scripts/setup.sh
source .venv/bin/activate
webwright doctor
```

| Command | What it does |
|---|---|
| `./scripts/setup.sh` | Creates `.venv`, installs Webwright + Firefox, creates `outputs/` |
| `source .venv/bin/activate` | Activates Python env (repeat in every new terminal) |
| `webwright doctor` | Validates Python, Playwright, browser, and API key |

### Step 2.3 — Open in Cursor

1. **File → Open Folder** → select `Webwright`
2. Confirm `.cursor/skills/webwright/SKILL.md` exists
3. Open **Agent** chat (not Ask mode — Agent can run shell commands)

### Step 2.4 — (Optional) API key for harness mode

```bash
cp .env.example .env
```

Edit `.env` and set `OPENAI_API_KEY` or `ANTHROPIC_API_KEY`. Skip this for Lesson 3 (Cursor skill mode).

---

## 3. Your first Cursor task (skill mode)

**Goal:** Complete a simple live-web task with screenshot evidence.

### Step 3.1 — Choose a starter task

Pick something with clear success criteria. Good first tasks:

| Task | Why it's good |
|---|---|
| Weather lookup for a city | Short flow, obvious final datum |
| Google search + extract first result title | Simple navigation |
| Product search with one filter | Introduces critical points |

Avoid paywalled or login-heavy sites for your first run.

### Step 3.2 — Invoke the skill

In Cursor Agent chat:

```
@webwright

Task: Look up the current weather for Seattle, WA on weather.com.
Start URL: https://weather.com
Workspace: outputs/weather-demo/

Use one-shot mode. Follow the workspace contract in the webwright skill.
```

Or open `.cursor/skills/webwright/prompts/run.md`, replace the placeholders, and paste it.

### Step 3.3 — Watch the agent loop

The agent should:

1. Create `outputs/weather-demo/plan.md` with **critical points** (CPs)
2. Run exploration Playwright scripts (scratch PNGs)
3. Write `final_runs/run_1/final_script.py`
4. Execute it and save screenshots per CP
5. Read screenshots and tick off CPs in `plan.md`
6. Report the final datum (temperature, condition, etc.)

### Step 3.4 — Verify yourself

```bash
ls -R outputs/weather-demo/
cat outputs/weather-demo/final_runs/run_1/final_script_log.txt
```

Open screenshots in Cursor's file explorer. Do they match what the agent claimed?

### What you learned

- Cursor **replaces** the harness LLM loop — no separate API billing for skill mode
- The durable output is **code + evidence**, not chat text
- **Self-verification** prevents premature "done" (a key Webwright design choice)

---

## 4. Understanding the workspace contract

Every Webwright run follows the same file layout:

```
outputs/<task_id>/
├── plan.md                          # Critical points checklist
├── screenshots/                     # Exploration scratch shots
└── final_runs/
    └── run_1/
        ├── final_script.py          # The reusable artifact
        ├── final_script_log.txt     # Step-by-step action log
        └── screenshots/
            └── final_execution_1_open_start_page.png
            └── final_execution_2_....png
```

### Critical points (CPs)

Each CP is one **independently verifiable** requirement:

```markdown
# Critical Points
- [ ] CP1: Navigate to weather.com
- [ ] CP2: Search for Seattle, WA
- [ ] CP3: Record the displayed current temperature
```

Rules from the skill:

- Exact numeric/date constraints — no "close enough"
- Ranking words (`cheapest`, `highest-rated`) require the site's actual sort control
- Dedicated filters must be used (search box ≠ filter)

### Playwright conventions

- **Firefox** headless (some sites block Chromium fingerprinting)
- Viewport **1280×1800** always
- **Never** `full_page=True` screenshots
- Fresh browser per script run — no persistent session

See `.cursor/skills/webwright/reference/playwright_patterns.md` for code templates.

---

## 5. Harness mode (Python CLI) — terminal

**Goal:** Run the official Webwright agent loop from your terminal.

This is the **canonical** way to run Webwright. The loop lives in your terminal: the model emits bash commands, they execute, and output is fed back until the task completes.

### When to use harness mode

- Running Webwright the way Microsoft designed it
- Reproducing benchmark settings
- Generating `trajectory.json` / `raw_responses.jsonl` for analysis
- Running tasks without Cursor open

### Step 5.1 — Activate environment and set API key

```bash
cd /path/to/Webwright
source .venv/bin/activate
export OPENAI_API_KEY=sk-...
```

| Command | What it does |
|---|---|
| `source .venv/bin/activate` | Loads the Python env with Webwright installed |
| `export OPENAI_API_KEY=...` | API key for OpenAI backend (or `ANTHROPIC_API_KEY` with `model_claude.yaml`) |

### Step 5.2 — Verify setup

```bash
webwright doctor
```

Fix any FAIL checks before continuing.

### Step 5.3 — Run

```bash
webwright main \
  -t "Search for flights from SEA to JFK departing 2026-08-15 returning 2026-08-20" \
  --start-url https://www.google.com/flights \
  --task-id harness_demo \
  -c base.yaml \
  -c model_openai.yaml \
  -o outputs/default
```

| Flag | What it does |
|---|---|
| `main` | Starts the agent loop (required subcommand) |
| `-t` | Task description |
| `--start-url` | First page to open |
| `--task-id` | Output folder label |
| `-c base.yaml` | Base workspace + bash-loop config |
| `-c model_openai.yaml` | OpenAI model backend |
| `-o outputs/default` | Root output directory |

Equivalent: `python -m webwright.run.cli main ...`

### Step 5.4 — Inspect outputs

```bash
ls outputs/default/
ls outputs/default/harness_demo_*/
cat outputs/default/harness_demo_*/final_runs/run_1/final_script_log.txt
python outputs/default/harness_demo_*/final_runs/run_1/final_script.py
```

Look for `trajectory.json`, debug screenshots, and the agent's step history.

### Harness vs Cursor skill

| | Terminal harness | Cursor skill |
|---|---|---|
| Where you type | Terminal | Cursor Agent chat |
| Who runs shell commands | Webwright loop | Cursor Agent |
| Model | OpenAI / Anthropic via config | Cursor's agent |
| Cost | Per-token API billing | Cursor subscription |
| Visual QA | `image_qa` + `self_reflection` tools | Agent reads PNGs |
| Best for | Official loop, benchmarks | Learning without extra API key |

---

## 6. Craft a reusable CLI tool

**Goal:** Turn a one-shot script into a parameterized CLI you can rerun.

### Step 6.1 — Prompt

```
@webwright

Use CLI tool mode (see prompts/craft.md).

Task: Search Google Flights from LAX to SFO, depart June 7 2026, return June 14 2026.
Workspace: outputs/flights-cli/

Parameterize origin, destination, depart date, and return date.
```

### Step 6.2 — Expected output shape

`plan.md` gains a `# Parameters` table. `final_script.py` contains:

- One domain function (`def search_flights(origin, destination, ...)`)
- Google-style `Args:` docstring
- `argparse` CLI with defaults matching the original task
- `step 0 params: origin=LAX destination=SFO ...` in the log

### Step 6.3 — Rerun with different args

```bash
cd outputs/flights-cli/final_runs/run_1
python final_script.py --help
python final_script.py --origin JFK --destination LAX --depart-date 2026-07-01 --return-date 2026-07-08
```

This is Webwright's path to **RPA-style reuse** — the script library idea from the research paper.

---

## 7. Debugging & inspection

### Agent claims success but CPs look wrong

1. Open `plan.md` — which CPs are checked?
2. Open the cited screenshot — is evidence ambiguous?
3. Read `final_script_log.txt` — does `FINAL_RESPONSE:` match?

### Playwright errors

```bash
# Re-run the final script manually
cd outputs/<task>/final_runs/run_1
python final_script.py
```

### Site blocks automation

- Webwright defaults to Firefox for TLS/H2 fingerprint issues
- Some sites need slower `wait_until` or explicit waits
- If a filter is "missing", the agent should expand drawers/panels first

### Context too long (harness mode)

The upstream harness compacts history every 20 steps. In Cursor, start a **new Agent chat** for a fresh task.

---

## 8. Exercise ideas

Progress from easy to hard:

| # | Exercise | Skill practiced |
|---|---|---|
| 1 | Weather lookup | Basic CPs, final datum |
| 2 | Wikipedia summary extraction | Navigation + text extraction |
| 3 | E-commerce search with price sort | Ranking CP, sort control |
| 4 | Multi-filter product search | Multiple CPs, filter drawers |
| 5 | Craft CLI for flight search | Parameterization |
| 6 | Same task: Cursor skill vs harness | Compare trajectories & cost |

---

## 9. Cursor tips

### Invoke the skill reliably

- Type `@webwright` in Agent chat — Cursor loads `.cursor/skills/webwright/SKILL.md`
- Be explicit about `Workspace: outputs/<name>/` so artifacts stay organized
- Use **Agent mode**, not Ask mode (shell execution required)

### Keep workspaces clean

```bash
# One folder per task
outputs/
├── weather-demo/
├── flights-cli/
└── wiki-extract/
```

### Combine with BMAD (optional)

This repo also has [BMAD Method](https://github.com/bmad-code-org/bmad-method) installed. Use `bmad-help` for product planning, then `@webwright` for web automation stories.

### Playwright MCP

If you have the Playwright MCP server enabled in Cursor, Webwright skill mode still prefers **local Python scripts** in a workspace — that's the Webwright contract. MCP is complementary for quick page inspection.

---

## 10. Further reading

- [Webwright GitHub](https://github.com/microsoft/Webwright) — source, configs, task showcase
- [Project page](https://microsoft.github.io/Webwright/#top) — architecture diagram, demo videos
- [Research blog](https://www.microsoft.com/en-us/research/articles/webwright-a-terminal-is-all-you-need-for-web-agents/) — benchmarks, cost analysis, lessons learned
- [LinkedIn post draft](LINKEDIN.md) — share what you built

---

**Next step:** Run Exercise 1 in Cursor Agent chat right now. When artifacts land in `outputs/`, you're officially a Webwright practitioner.
