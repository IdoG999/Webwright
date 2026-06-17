Use the @webwright skill. Solve the following web task code-as-action style by
driving a local Playwright browser through one shell command at a time, saving
screenshots and an action log into `final_runs/run_<id>/`, and visually
verifying the result.

**Task:** <describe your web task here>

**Start URL (optional):** <e.g. https://www.google.com/flights>

**Workspace:** `outputs/<task_id>/`

Follow the standard Webwright workflow:

1. Write `plan.md` with numbered critical points.
2. Explore with scratch Playwright scripts; read PNG screenshots to inspect UI.
3. Author and run instrumented `final_script.py` in `final_runs/run_<id>/`
   (viewport 1280×1800, headless Firefox, no `full_page=True`).
4. Self-verify every critical point against screenshots and `final_script_log.txt`.
5. Report the final datum verbatim.

Do **not** use CLI tool mode for this task.
