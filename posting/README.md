# posting collection

Version-controlled API requests, replacing one-off `opr curl '{json}'` calls.
Built from real calls in shell history: orchestrator, faucet, and RPC.

## Launch
```
post [prod|dev|staging|local]    # default prod, no secrets
posts [prod|dev|staging|local]   # same + 1Password secrets injected (run from a dir with a .env)
```
Both layer `env/common.env` + `env/<environment>.env`, so switching prod↔dev↔staging↔local
only swaps the `${ORCH}` host — every saved request follows.

## Environments (`env/`)
- `common.env` — shared non-secret vars: `ACCOUNT`, `FAUCET`, RPC defaults. **No secrets here.**
- `prod.env` / `dev.env` / `staging.env` / `local.env` — just set `${ORCH}` base URL.

## Secrets
Requests reference `${ORCH_API_KEY}` / `${FAUCET_API_KEY}`. These are **not** in any env file —
launch with `posts`, which runs `op run --env-file=.env` so 1Password injects them as env vars
(posting resolves `${VAR}` from the environment too). Put `ORCH_API_KEY=op://...` in the `.env`
of whatever dir you launch from.

## Inside posting
- `Tab` / `Ctrl+O` (jump mode) to move focus out of text inputs — then `j`/`k` navigate.
- `Enter` opens the selected request; `Alt+Enter` sends (Ctrl+J is your tmux pane-down).
- Response body: `j`/`k`/`g`/`G` scroll, `y` yank, `f3` opens in `$PAGER`.
- `?` for help (when focus isn't in a text box).

## Add a request
Clone any `*.posting.yaml`, or in posting press `i` and paste a `curl` to import it.
Bodies carry a real example payload — edit inline before sending.
