# Example Webwright tasks for Cursor

Copy a prompt into Agent chat with `@webwright`, or use the templates in
`.cursor/skills/webwright/prompts/`.

## Beginner

### Weather lookup

```
@webwright
Task: Get the current weather for Austin, TX from weather.com.
Start URL: https://weather.com
Workspace: outputs/ex-weather/
```

### Wikipedia extract

```
@webwright
Task: Open Wikipedia, search for "Playwright (software)", and return the first paragraph of the article.
Start URL: https://en.wikipedia.org
Workspace: outputs/ex-wiki/
```

## Intermediate

### Flight search (one-shot)

```
@webwright
Task: On Google Flights, search round-trip SEA to JFK, depart 2026-09-01, return 2026-09-08.
Report the cheapest economy fare shown.
Start URL: https://www.google.com/flights
Workspace: outputs/ex-flights/
```

### Product with sort

```
@webwright
Task: On amazon.com, search "mechanical keyboard", sort by customer reviews, and report the top result title and price.
Workspace: outputs/ex-amazon-sort/
```

## Advanced — reusable CLI

Use `prompts/craft.md` template:

```
@webwright CLI tool mode.
Task: Google Flights LAX → SFO, depart 2026-06-07, return 2026-06-14.
Parameterize origin, destination, depart date, return date.
Workspace: outputs/ex-flights-cli/
```

## Harness mode (terminal)

Requires `OPENAI_API_KEY` or `ANTHROPIC_API_KEY` in `.env`.

```bash
source .venv/bin/activate
python -m webwright.run.cli \
  -c base.yaml -c model_openai.yaml \
  -t "Look up weather for Seattle on weather.com" \
  --start-url https://weather.com \
  --task-id harness_weather \
  -o outputs/default
```
