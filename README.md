# Rarebox Agent Harness

Public rebuild kit for the `rarebox` Hermes profile: a focused engineering agent for Rarebox.

This repo intentionally contains no secrets. It stores identity, project rules, skills, and harness eval templates so the agent can be recreated on a new machine or Hermes install.

## Compatibility

This harness was made for **Hermes Agent**. The full installer (`scripts/install.sh`) assumes Hermes profiles, Hermes config commands, and Hermes `SKILL.md` workflows.

It can still be useful with **OpenClaw** or another coding agent if that agent can read project instructions and run shell commands:

| Harness piece | Hermes | OpenClaw / other agents |
| --- | --- | --- |
| `profile/SOUL.md` identity | Installed into the `rarebox` Hermes profile | Use as manual system/context text if supported |
| `skills/*/SKILL.md` | Native Hermes skills | Read manually as workflow docs; not auto-loaded unless the agent supports this format |
| `repo/AGENTS.md` | Copied into Rarebox repo and read as repo rules | Copy into the Rarebox repo; most coding agents can use it as project instructions |
| `evals/` | Copied to `scripts/evals/` and run with npm | Works normally; just run the npm scripts |
| `smoke/` | Copied to `scripts/smoke/` and run with npm | Works normally; just run the npm scripts |
| `templates/` | Copied to `docs/harness/templates/` | Works normally as Markdown templates |

For OpenClaw-style use, copy the repo-facing files into Rarebox and tell the agent to read `AGENTS.md` before planning or editing:

```bash
./scripts/sync-to-rarebox.sh /absolute/path/to/rarebox
cd /absolute/path/to/rarebox
npm run eval:harness
npm run eval:danger
npm run build
npm run smoke:browser
```

Then start OpenClaw in the Rarebox checkout and ask it to read `AGENTS.md` plus the relevant template in `docs/harness/templates/`. The Hermes profile installer is optional in that flow.

## What this installs

- Hermes profile identity: `profile/SOUL.md`
- Rarebox provider integration skill: `skills/rarebox-provider-integration/SKILL.md`
- Repo-level coding-agent rules: `repo/AGENTS.md`
- Harness eval scripts: `evals/`
- Browser smoke scripts: `smoke/`
- Task/review templates: `templates/`
- Installer: `scripts/install.sh`
- Sync helpers: `scripts/sync-from-rarebox.sh`, `scripts/sync-to-rarebox.sh`

## Quick rebuild

Prerequisites:

- Hermes Agent installed
- git + gh installed if cloning from GitHub
- Rarebox repo cloned locally
- A working Hermes default profile or provider credentials configured separately

Example:

```bash
git clone https://github.com/novaoc/rarebox-agent-harness.git
cd rarebox-agent-harness
./scripts/install.sh /absolute/path/to/rarebox
```

Pass the absolute path to your local Rarebox checkout. Then run:

```bash
rarebox chat
```

## What the installer does

1. Creates a `rarebox` Hermes profile if it does not exist.
2. Clones current/default Hermes configuration when creating the profile so model/tool config is inherited.
3. Sets `terminal.cwd` to the Rarebox repo path you pass in.
4. Copies `profile/SOUL.md` into `~/.hermes/profiles/rarebox/SOUL.md`.
5. Copies the provider skill into `~/.hermes/profiles/rarebox/skills/rarebox-provider-integration/SKILL.md`.
6. Copies `repo/AGENTS.md` into the Rarebox repo.
7. Copies `evals/` into `<rarebox repo>/scripts/evals/`.
8. Copies `smoke/` into `<rarebox repo>/scripts/smoke/`.
9. Copies `templates/` into `<rarebox repo>/docs/harness/templates/`.
10. Removes Telegram/social token lines from the rarebox profile `.env` so it cannot accidentally use another profile's messaging credentials.
11. Adds `eval:harness`, `eval:danger`, and `smoke:browser` to the Rarebox `package.json` if missing.

## Verification

From the Rarebox repo:

```bash
npm run eval:harness
npm run eval:danger
npm run build
npm run smoke:browser
rarebox -z "In two sentences, identify your role and scope. Do not use tools."
```

Expected identity response: the agent says it is the Rarebox engineering agent focused on Rarebox development.

## Secrets policy

Do not commit `.env`, tokens, session DBs, state DBs, backups, or Hermes profile runtime state. This repo is a template, not a profile dump.

If a future Rarebox Telegram bot is desired, configure a separate bot token manually in `~/.hermes/profiles/rarebox/.env`. Do not reuse another profile's token.
