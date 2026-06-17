Use the @webwright skill in **CLI tool mode**. Parameterize the following task
so `final_script.py` can be re-run later with different argument values.

**Task:** <describe your web task with concrete values>

**Start URL (optional):** <e.g. https://www.google.com/flights>

**Workspace:** `outputs/<task_id>/`

Steps:

1. Identify parameters the user could vary (dates, locations, filters, etc.).
2. Write `plan.md` with `# Parameters` table and `# Critical Points`.
3. Author `final_script.py` with one reusable function + `argparse` CLI.
4. Run `python final_script.py` with no args to reproduce the task.
5. Run an import-safety smoke test (no browser at import time).
6. Self-verify every CP; fix and re-run in `run_<id+1>/` if needed.
7. Show `--help` output and the final datum to the user.

See `reference/cli_tool_mode.md` for the full contract.
