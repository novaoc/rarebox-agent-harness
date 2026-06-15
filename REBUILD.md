# Rebuild Notes

This repo is deliberately small. It is not a full Hermes backup.

Why:

- Full Hermes profiles include secrets, state DBs, session history, logs, cron state, and transient runtime files.
- Rebuilding the Rarebox agent should require explicit credentials on the target machine, not copied tokens.

Rebuild process:

1. Install Hermes Agent on the target machine.
2. Configure at least one working model/provider in the default profile, or edit the new rarebox profile after install.
3. Clone `novaoc/rarebox`.
4. Clone this repo.
5. Run `./scripts/install.sh /absolute/path/to/rarebox`.
6. Run verification from the Rarebox repo:
   - `npm run eval:harness`
   - `npm run eval:danger`
   - `npm run build`
   - `npm run smoke:browser`
   - `rarebox -z "In two sentences, identify your role and state whether you are Nova. Do not use tools."`

Optional:

- If the rarebox profile needs its own Telegram bot, create a separate BotFather token and add it manually to `~/.hermes/profiles/rarebox/.env`.
- Do not reuse Nova's Telegram/social tokens.
