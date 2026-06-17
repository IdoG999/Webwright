# Webwright

**Learn [Microsoft Webwright](https://github.com/microsoft/Webwright) in Cursor** — terminal-native web agents that turn browsing into reusable Python scripts.

> *"A terminal is all you need for web agents."* — [Microsoft Research](https://www.microsoft.com/en-us/research/articles/webwright-a-terminal-is-all-you-need-for-web-agents/)

This repo is a **Cursor-ready learning project**: install the upstream harness, invoke the `@webwright` skill in Agent chat, and follow the [tutorial](docs/TUTORIAL.md) step by step.

## What is Webwright?

Most web agents click one button at a time inside a persistent browser session. Webwright flips that model:

| Traditional agents | Webwright |
|---|---|
| Browser session = state | **Workspace** (code, logs, screenshots) = state |
| One click/type per step | **Python + Playwright** scripts per step |
| Fragile coordinate clicks | Stable selectors, loops, functions |
| Task dies with the session | **Reusable `final_script.py`** artifacts |

The harness is deliberately minimal (~1K lines): Runner + Model + Terminal Environment. No multi-agent orchestration tower.

**Reported benchmarks** ([project page](https://microsoft.github.io/Webwright/#top)):

- **86.7%** on Online-Mind2Web (300 live tasks, GPT-5.4)
- **60.8%** on Odysseys long-horizon browsing
- Reusable CLI tools let smaller models complete hard tasks

## Quick start (Cursor)

### 1. Install dependencies

```bash
./scripts/setup.sh
```

Or manually:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
playwright install firefox
```

### 2. (Optional) Harness mode API key

For the **Python CLI harness** (`python -m webwright.run.cli`), copy `.env.example` to `.env` and set one backend key:

```bash
cp .env.example .env
# OPENAI_API_KEY=...   OR   ANTHROPIC_API_KEY=...
```

**Cursor skill mode does not need these keys** — Cursor's agent drives the loop directly.

### 3. Run your first task in Cursor

1. Open this folder in **Cursor**.
2. Open **Agent** chat.
3. Type `@webwright` and describe a task, or paste a prompt from `.cursor/skills/webwright/prompts/run.md`.

Example:

```
@webwright Search Google Flights for round-trip SEA → JFK,
depart 2026-08-15, return 2026-08-20. Save artifacts under outputs/flight-demo/.
```

The agent will create `plan.md`, explore with Playwright, write `final_script.py`, capture screenshots, and self-verify.

## Two ways to run Webwright

| Mode | When to use | API key? |
|---|---|---|
| **Cursor skill** (`@webwright`) | Learning, fast iteration, no extra cost beyond Cursor | No |
| **Python harness** (`webwright` CLI) | Benchmarks, batch runs, trajectory logs | Yes (OpenAI / Anthropic) |

### Harness example

```bash
source .venv/bin/activate
export OPENAI_API_KEY=sk-...

python -m webwright.run.cli \
  -c base.yaml -c model_openai.yaml \
  -t "Search for flights from SEA to JFK on 2026-08-15 to 2026-08-20" \
  --start-url https://www.google.com/flights \
  --task-id demo_openai \
  -o outputs/default
```

## Project layout

```
Webwright/
├── .cursor/skills/webwright/   # Cursor skill (adapted from microsoft/Webwright)
├── docs/
│   ├── TUTORIAL.md             # Full hands-on tutorial
│   └── LINKEDIN.md             # LinkedIn post drafts
├── examples/                   # Starter task ideas
├── outputs/                    # Run artifacts (gitignored)
├── scripts/setup.sh
├── requirements.txt
└── README.md
```

## Learn more

- [Hands-on tutorial](docs/TUTORIAL.md)
- [Microsoft Webwright repo](https://github.com/microsoft/Webwright)
- [Research article](https://www.microsoft.com/en-us/research/articles/webwright-a-terminal-is-all-you-need-for-web-agents/)
- [Project page & demos](https://microsoft.github.io/Webwright/#top)

## Credits

Webwright is developed by [Microsoft Research](https://www.microsoft.com/en-us/research/) and HKU. This repo adds Cursor integration and learning materials on top of the upstream project (MIT license).

```bibtex
@misc{webwright2026,
  title        = {Webwright: A terminal is all you need for web agents},
  author       = {Lu, Yadong and Xu, Lingrui and Huang, Chao and Awadallah, Ahmed},
  year         = {2026},
  howpublished = {\url{https://github.com/microsoft/Webwright}},
  note         = {GitHub repository}
}
```

## License

Learning materials in this repo: MIT. Webwright upstream: MIT ([microsoft/Webwright](https://github.com/microsoft/Webwright)).
