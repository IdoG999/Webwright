# Example Webwright tasks

Two ways to run each example:

- **Terminal harness** — you type commands in the terminal (official Webwright loop)
- **Cursor skill** — you paste a prompt in Cursor Agent chat (`@webwright`)

---

## Before you start

```bash
cd /path/to/Webwright
source .venv/bin/activate      # Required in every new terminal
webwright doctor               # Verify setup (fix any FAIL rows)
```

For **terminal harness** runs, also set an API key:

```bash
export OPENAI_API_KEY=sk-...          # with model_openai.yaml
# OR
export ANTHROPIC_API_KEY=sk-ant-...   # with model_claude.yaml
```

---

## Terminal harness — command template

```bash
webwright main \
  -t "<TASK DESCRIPTION>" \
  --start-url <URL> \
  --task-id <SHORT_NAME> \
  -c base.yaml \
  -c model_openai.yaml \
  -o outputs/default
```

| Flag | What it does |
|---|---|
| `main` | Starts the Webwright agent loop |
| `-t` | Task in plain English |
| `--start-url` | First page to open |
| `--task-id` | Name for the output folder |
| `-c base.yaml` | Workspace + bash-loop rules |
| `-c model_openai.yaml` | Use OpenAI (swap for `model_claude.yaml` + Anthropic key) |
| `-o outputs/default` | Where artifacts are saved |

After the run finishes:

```bash
ls outputs/default/<task-id>_*/
python outputs/default/<task-id>_*/final_runs/run_1/final_script.py
```

---

## Beginner examples

### Weather lookup

**Terminal:**

```bash
webwright main \
  -t "Get the current weather for Austin, TX on weather.com" \
  --start-url https://weather.com \
  --task-id ex-weather \
  -c base.yaml \
  -c model_openai.yaml \
  -o outputs/default
```

**Cursor Agent chat:**

```
@webwright
Task: Get the current weather for Austin, TX from weather.com.
Start URL: https://weather.com
Workspace: outputs/ex-weather/
```

### Wikipedia extract

**Terminal:**

```bash
webwright main \
  -t "Open Wikipedia, search for Playwright (software), and return the first paragraph of the article" \
  --start-url https://en.wikipedia.org \
  --task-id ex-wiki \
  -c base.yaml \
  -c model_openai.yaml \
  -o outputs/default
```

**Cursor Agent chat:**

```
@webwright
Task: Open Wikipedia, search for "Playwright (software)", and return the first paragraph of the article.
Start URL: https://en.wikipedia.org
Workspace: outputs/ex-wiki/
```

---

## Intermediate examples

### Flight search (one-shot)

**Terminal:**

```bash
webwright main \
  -t "On Google Flights, search round-trip SEA to JFK, depart 2026-09-01, return 2026-09-08. Report the cheapest economy fare shown." \
  --start-url https://www.google.com/flights \
  --task-id ex-flights \
  -c base.yaml \
  -c model_openai.yaml \
  -o outputs/default
```

**Cursor Agent chat:**

```
@webwright
Task: On Google Flights, search round-trip SEA to JFK, depart 2026-09-01, return 2026-09-08.
Report the cheapest economy fare shown.
Start URL: https://www.google.com/flights
Workspace: outputs/ex-flights/
```

### Product with sort

**Terminal:**

```bash
webwright main \
  -t "On amazon.com, search mechanical keyboard, sort by customer reviews, and report the top result title and price" \
  --start-url https://www.amazon.com \
  --task-id ex-amazon-sort \
  -c base.yaml \
  -c model_openai.yaml \
  -o outputs/default
```

**Cursor Agent chat:**

```
@webwright
Task: On amazon.com, search "mechanical keyboard", sort by customer reviews, and report the top result title and price.
Workspace: outputs/ex-amazon-sort/
```

---

## Advanced — reusable CLI tool

Turns `final_script.py` into a parameterized CLI you can rerun with different arguments.

**Cursor Agent chat** (use `prompts/craft.md` template):

```
@webwright CLI tool mode.
Task: Google Flights LAX → SFO, depart 2026-06-07, return 2026-06-14.
Parameterize origin, destination, depart date, return date.
Workspace: outputs/ex-flights-cli/
```

**Terminal harness** with crafted CLI config:

```bash
webwright main \
  -t "Search Google Flights LAX to SFO, depart 2026-06-07, return 2026-06-14. Make the script a reusable CLI tool." \
  --start-url https://www.google.com/flights \
  --task-id ex-flights-cli \
  -c base.yaml \
  -c model_openai.yaml \
  -c crafted_cli.yaml \
  -o outputs/default
```

| Extra flag | What it does |
|---|---|
| `-c crafted_cli.yaml` | Enables parameterized CLI tool mode in the harness |

After completion, test the CLI:

```bash
python outputs/default/ex-flights-cli_*/final_runs/run_1/final_script.py --help
python outputs/default/ex-flights-cli_*/final_runs/run_1/final_script.py
```

---

## Useful inspection commands

| Command | What it does |
|---|---|
| `webwright doctor` | Check Python, Playwright, browser, API key |
| `ls -R outputs/default/<run>/` | List all generated files |
| `cat outputs/.../final_script_log.txt` | Read the step-by-step action log |
| `cat outputs/.../trajectory.json` | Read full agent trajectory (harness mode) |
| `python outputs/.../final_script.py` | Re-run the finished script without LLM |
