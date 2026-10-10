# Development

## Release procedure

Releases are automatic: the Sunday 00:00 UTC cron (or a manual dispatch of
`release.yml`) runs one of three targets. The version is derived from
Conventional Commits since the last tag — nobody types a number — and the
`prepare` job gates on `just check`, bumps `VERSION` via `just bump`, and
pushes the commit and tag atomically (`git push origin HEAD:main <tag>`).

| Target | Effect |
|---|---|
| `new-tag` (default, and what the cron uses) | Gate → bump → tag & push → build & publish |
| `tag` | Rebuild an existing tag (`ref`, default newest) and publish its release |
| `commit` | Test-build a commit (`ref`, default `HEAD`); image loads locally, no release |

`VERSION` tracks the packaged upstream build (`1.4.4` = the 1.4.4.9 blob the
`Dockerfile` downloads), not repo churn — `docs:`/`ci:`/`chore:`-only weeks
release nothing and the run ends green having published nothing.

### Container-specific notes

- The compose file joins the **external `web-tailscale` network** — create it
  first (`docker network create web-tailscale`) or repoint the service at your
  own network. CI and the release build never touch compose: they build the
  `Dockerfile` directly, so the external network is a runtime-only concern.
- `serverconfig.txt` is **gitignored by design** (real worlds and passwords
  live in it). The release `commit` build stages a throwaway copy from
  `serverconfig.txt.example` so the layer context matches; locally, copy the
  example and set `world=` before `docker compose up -d --build`.
- Branch protection requires exactly `Check (just check)`. Image builds and
  the digest artifact live in the release workflow only; CI stays build-free.
