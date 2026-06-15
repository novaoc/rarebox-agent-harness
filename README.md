# Rarebox Agent Harness

Private rebuild kit for the `rarebox` Hermes profile: a non-Nova engineering agent for Rarebox.

This repo intentionally contains no secrets. It stores identity, project rules, skills, and harness eval templates so the agent can be recreated on a new machine or Hermes install.

## What this installs

- Hermes profile identity: `profile/SOUL.md`
- Rarebox provider integration skill: `skills/rarebox-provider-integration/SKILL.md`
- Repo-level coding-agent rules: `repo/AGENTS.md`
- Harness eval scripts: `evals/`
- Browser smoke scripts: `smoke/`
- Task/review templates: `templates/`
- Installer: `scripts/install.sh`

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

Default local path used by Nova's Mac Mini setup:

```bash
./scripts/install.sh /Users/wren/nova/rarebox-main
```

Then run:

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
10. Removes Telegram/social token lines from the rarebox profile `.env` so it cannot accidentally run as Nova.
11. Adds `eval:harness`, `eval:danger`, and `smoke:browser` to the Rarebox `package.json` if missing.

## Verification

From the Rarebox repo:

```bash
npm run eval:harness
npm run build
rarebox -z "In two sentences, identify your role and state whether you are Nova. Do not use tools."
```

Expected identity response: the agent says it is the Rarebox engineering agent and not Nova.

## Secrets policy

Do not commit `.env`, tokens, session DBs, state DBs, backups, or Hermes profile runtime state. This repo is a template, not a profile dump.

If a future Rarebox Telegram bot is desired, configure a separate bot token manually in `~/.hermes/profiles/rarebox/.env`. Do not reuse Nova's token.
