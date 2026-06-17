# Webwright

**Learn [Microsoft Webwright](https://github.com/microsoft/Webwright) in Cursor** — terminal-native web agents that turn browsing into reusable Python scripts.

> *"A terminal is all you need for web agents."* — [Microsoft Research](https://www.microsoft.com/en-us/research/articles/webwright-a-terminal-is-all-you-need-for-web-agents/)

Webwright runs from the **terminal**. The agent loop sends bash commands (usually Python + Playwright) to a shell, inspects the output, and iterates until the task is done. The durable result is a workspace folder with `final_script.py`, logs, and screenshots.

This repo adds a **Cursor skill** (`@webwright`) as an optional second path — Cursor's Agent runs the same terminal commands for you.

---

## What is Webwright?

| Traditional web agents | Webwright |
|---|---|
| Browser session = state | **Workspace** (code, logs, screenshots) = state |
| One click/type per step | **Python + Playwright** scripts per step |
| Fragile coordinate clicks | Stable selectors, loops, functions |
| Task dies with the session | **Reusable `final_script.py`** artifacts |

**Reported benchmarks** ([project page](https://microsoft.github.io/Webwright/#top)):

- **86.7%** on Online-Mind2Web (300 live tasks, GPT-5.4)
- **60.8%** on Odysseys long-horizon browsing

---

## How to run (pick one path)

| Path | Where you type | API key? | Best for |
|---|---|---|---|
| **A. Terminal harness** | Your terminal | Yes (OpenAI or Anthropic) | Official Webwright loop, benchmarks |
| **B. Cursor skill** | Cursor Agent chat | No (uses Cursor) | Learning, no extra API cost |

Both paths use the terminal under the hood. Path A is the canonical Microsoft Webwright experience.

---

## Step-by-step: Terminal harness (Path A)

### Step 1 — One-time setup

```bash
cd /path/to/Webwright          # Go to this project folder
./scripts/setup.sh             # Install everything (see table below)
source .venv/bin/activate      # Activate Python for this terminal session
```

| Command | What it does |
|---|---|
| `cd /path/to/Webwright` | Enter the project root |
| `./scripts/setup.sh` | Creates `.venv`, installs Microsoft Webwright from GitHub, installs Playwright's Firefox browser, creates `outputs/`, copies `.env.example` → `.env` |
| `source .venv/bin/activate` | Activates the virtual environment. Your prompt shows `(.venv)`. Required in every new terminal before running Webwright |

**Manual setup** (same result as `setup.sh`):

| Command | What it does |
|---|---|
| `python3 -m venv .venv` | Creates an isolated Python environment in `.venv/` |
| `pip install -r requirements.txt` | Installs the `webwright` package from [microsoft/Webwright](https://github.com/microsoft/Webwright) |
| `playwright install firefox` | Downloads the Firefox browser Webwright automates |

### Step 2 — Set an API key

The terminal harness calls OpenAI or Anthropic directly.

```bash
export OPENAI_API_KEY=sk-...          # For OpenAI (GPT models)
# OR
export ANTHROPIC_API_KEY=sk-ant-...    # For Anthropic (Claude models)
```

Or edit `.env` (created by setup) and add your key there.

| Variable | Used with config | Model backend |
|---|---|---|
| `OPENAI_API_KEY` | `-c model_openai.yaml` | OpenAI (default) |
| `ANTHROPIC_API_KEY` | `-c model_claude.yaml` | Anthropic Claude |

### Step 3 — Verify setup

```bash
webwright doctor
```

| Command | What it does |
|---|---|
| `webwright doctor` | Checks Python, Playwright, browser, API key, and plugin manifests. Fix any FAIL rows before running tasks |

Equivalent: `python -m webwright.run.cli doctor`

### Step 4 — Run a web task

```bash
webwright main \
  -t "Get the current weather for Austin, TX on weather.com" \
  --start-url https://weather.com \
  --task-id ex-weather \
  -c base.yaml \
  -c model_openai.yaml \
  -o outputs/default
```

Equivalent long form: `python -m webwright.run.cli main ...`

#### What happens when you run this

1. Webwright creates an output folder under `outputs/default/` (named with your `--task-id` + timestamp)
2. The **agent loop** starts in your terminal:
   - Sends task + workspace state to the LLM
   - LLM returns a **bash command** (often a Python/Playwright script)
   - Command runs in the terminal
   - Output (logs, screenshots, errors) is fed back to the LLM
   - Repeats until the task is complete
3. Artifacts are saved: `plan.md`, `final_script.py`, `trajectory.json`, screenshots, logs

#### Command flags explained

| Flag | Required | What it does |
|---|---|---|
| `main` | Yes | Subcommand that starts the agent loop |
| `-t "..."` | Yes | Natural-language task description |
| `--start-url` | No | First page the browser opens |
| `--task-id` | No | Label for the output folder (e.g. `ex-weather`) |
| `-c base.yaml` | No* | Base config: workspace rules, bash-loop prompts, self-reflection gate |
| `-c model_openai.yaml` | No* | Model backend config (OpenAI). Use `model_claude.yaml` for Anthropic |
| `-o outputs/default` | No | Root directory for run artifacts |
| `--debug` | No | Opens a visible browser with devtools (for troubleshooting) |

\*Defaults to `base.yaml` + `model_openai.yaml` if omitted.

#### Anthropic example

```bash
export ANTHROPIC_API_KEY=sk-ant-...

webwright main \
  -t "Get weather for Seattle on weather.com" \
  --start-url https://weather.com \
  --task-id ex-weather \
  -c base.yaml \
  -c model_claude.yaml \
  -o outputs/default
```

### Step 5 — Inspect and re-run results

```bash
ls outputs/default/                              # List run folders
ls outputs/default/ex-weather_*/                 # Files from your task
cat outputs/default/ex-weather_*/final_runs/run_1/final_script_log.txt
python outputs/default/ex-weather_*/final_runs/run_1/final_script.py
```

| Command | What it does |
|---|---|
| `ls outputs/default/` | Shows timestamped run folders |
| `cat .../final_script_log.txt` | Step-by-step action log the agent wrote |
| `python .../final_script.py` | Re-runs the finished script yourself (no LLM needed) |

---

## Step-by-step: Cursor skill (Path B)

Use this if you don't want a separate OpenAI/Anthropic API key. Cursor's Agent drives the terminal for you.

### Step 1 — Setup (same as Path A, steps 1–3)

You still need `./scripts/setup.sh` and `source .venv/bin/activate` so Playwright is installed. **No API key required** for skill mode.

### Step 2 — Open in Cursor

1. **File → Open Folder** → select this project
2. Open **Agent** chat (not Ask mode — Agent can run shell commands)

### Step 3 — Run a task in chat

Paste into Agent chat:

```
@webwright

Task: Get the current weather for Austin, TX on weather.com.
Start URL: https://weather.com
Workspace: outputs/ex-weather/
```

| Part | What it does |
|---|---|
| `@webwright` | Loads `.cursor/skills/webwright/SKILL.md` — the agent workflow |
| `Task:` | What to accomplish on the live web |
| `Start URL:` | First page to open |
| `Workspace:` | Folder where `plan.md`, scripts, screenshots, and logs are saved |

The Agent runs Playwright commands in your terminal, verifies screenshots, and reports the result.

More copy-paste examples: [examples/README.md](examples/README.md)

---

## Project layout

```
Webwright/
├── .cursor/skills/webwright/   # Cursor skill (optional Path B)
├── docs/
│   ├── TUTORIAL.md             # Full hands-on tutorial
│   └── LINKEDIN.md             # LinkedIn post drafts
├── examples/                   # Starter tasks (terminal + Cursor)
├── outputs/                    # Run artifacts (gitignored)
├── scripts/setup.sh            # One-command install
├── requirements.txt
└── README.md
```

---

## Quick reference — all commands

| Command | What it does |
|---|---|
| `./scripts/setup.sh` | One-time install: venv, webwright package, Firefox |
| `source .venv/bin/activate` | Enable Python env (run in every new terminal) |
| `webwright doctor` | Validate local setup |
| `webwright main -t "..." ...` | **Run a web task** (terminal harness) |
| `webwright --help` | Show all CLI options |
| `webwright main --help` | Show flags for the `main` command |
| `python .../final_script.py` | Re-run a finished script without the LLM |
| `@webwright` in Cursor Agent | Run a task via Cursor skill (Path B) |

---

## Learn more

- [Hands-on tutorial](docs/TUTORIAL.md)
- [Example tasks](examples/README.md)
- [Microsoft Webwright repo](https://github.com/microsoft/Webwright)
- [Research article](https://www.microsoft.com/en-us/research/articles/webwright-a-terminal-is-all-you-need-for-web-agents/)
- [Project page & demos](https://microsoft.github.io/Webwright/#top)

## Credits

Webwright is developed by [Microsoft Research](https://www.microsoft.com/en-us/research/) and HKU. This repo adds Cursor integration and learning materials on top of the upstream project (MIT license).

## License

Learning materials in this repo: MIT. Webwright upstream: MIT ([microsoft/Webwright](https://github.com/microsoft/Webwright)).
