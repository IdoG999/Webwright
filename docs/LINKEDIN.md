# LinkedIn Showcase — Webwright in Cursor

Use these drafts to post about your Webwright learning project. Pick one tone, customize the bracketed parts, and add a screenshot of your `outputs/` folder or a `final_script.py` run.

---

## Post option A — Learning journey (recommended)

**Hook + story**

I stopped teaching AI to click one button at a time.

This week I set up **Webwright** — Microsoft's terminal-native web agent framework — inside **Cursor**, and the mental model shift is real.

Instead of a persistent browser where the model predicts the next click, Webwright gives the agent a **terminal** and a **workspace**. It writes Playwright Python, runs it, saves screenshots + logs, and iterates until the task is provably done.

The durable artifact isn't a chat transcript. It's `final_script.py` — reusable automation you can rerun or parameterize as a CLI.

**What I built**
→ Cursor-adapted Webwright skill (`@webwright` in Agent chat)  
→ Hands-on tutorial repo: github.com/IdoG999/Webwright  
→ First live-web runs with screenshot evidence in `outputs/`

**Why it matters**
→ 86.7% on Online-Mind2Web (300 live sites)  
→ 60.8% on long-horizon Odysseys tasks  
→ ~1K lines of harness code — no orchestration tower

The research line that stuck with me: *"A terminal is all you need for web agents."*

**Links**
🔬 Microsoft Research: https://www.microsoft.com/en-us/research/articles/webwright-a-terminal-is-all-you-need-for-web-agents/  
📦 Upstream project: https://github.com/microsoft/Webwright  
📘 My learning repo: https://github.com/IdoG999/Webwright

**Hashtags**
#WebAgents #Playwright #Cursor #AIEngineering #Automation #MicrosoftResearch #Python #RPA #LLM

---

## Post option B — Technical / builder audience

**Shorter, punchier**

Web agents don't need a bigger harness. They need a better action space.

Microsoft's **Webwright** treats code as the action space:
- Workspace = state (not the browser session)
- Playwright scripts = actions (not x,y clicks)
- `final_script.py` = reusable output (not ephemeral chat)

I adapted it for **Cursor** — invoke `@webwright` in Agent chat, no extra API key for skill mode.

Repo with tutorial: github.com/IdoG999/Webwright

Benchmarks (GPT-5.4, 100-step budget):
• Online-Mind2Web: 86.7%
• Odysseys: 60.8%

Research: https://www.microsoft.com/en-us/research/articles/webwright-a-terminal-is-all-you-need-for-web-agents/

#WebAutomation #AIAgents #CursorIDE #Playwright

---

## Post option C — Carousel / document outline

If you want a multi-slide LinkedIn document or carousel, use this structure:

| Slide | Title | Content |
|---|---|---|
| 1 | The problem | Step-by-step browser agents = fragile, slow, non-reusable |
| 2 | The insight | Separate agent from browser; workspace persists, browser is disposable |
| 3 | How it works | Plan → Explore → Script → Execute → Self-verify |
| 4 | Results | 86.7% Mind2Web · 60.8% Odysseys · reusable CLI tools |
| 5 | My setup | Webwright repo + Cursor `@webwright` skill |
| 6 | Try it | Clone repo → `./scripts/setup.sh` → `@webwright` in Cursor |
| 7 | CTA | Star microsoft/Webwright · fork my tutorial repo |

---

## Visual assets to attach

Best engagement comes from real artifacts:

1. **Terminal screenshot** — `ls -R outputs/<task>/final_runs/run_1/`
2. **plan.md** with checked critical points
3. **Screenshot** from `final_execution_*.png` proving a filter or result
4. **Snippet** of `final_script.py` (10–15 lines, not the whole file)
5. **Architecture** — link to https://microsoft.github.io/Webwright/#top

---

## Profile / featured section

**Featured link title:** Webwright — Learn terminal-native web agents in Cursor  
**URL:** https://github.com/IdoG999/Webwright  
**Description:** Hands-on tutorial for Microsoft's terminal-native web agent framework, adapted for Cursor Agent chat.

---

## Comment reply templates

**"How is this different from Playwright MCP?"**  
Playwright MCP is great for IDE-integrated browser inspection. Webwright is a full task loop: plan, script, verify, and ship a reusable `final_script.py`. Complementary, not competing.

**"Do I need OpenAI API keys?"**  
Not for Cursor skill mode — Cursor's agent drives the loop. API keys are only for the upstream Python harness (`python -m webwright.run.cli`).

**"Is this your framework?"**  
No — Webwright is by Microsoft Research + HKU. My repo adds Cursor integration and a learning tutorial on top of the MIT-licensed upstream project.

---

## Posting checklist

- [ ] Run at least one task so `outputs/` has real artifacts
- [ ] Screenshot or screen recording attached
- [ ] Link to your GitHub repo in the first comment if not in post body
- [ ] Credit Microsoft Research + link upstream repo
- [ ] Post when your audience is active (Tue–Thu morning tends to work well)
