<div align="center">

# Terraria Server Container

**A Terraria dedicated server that starts with one command: the official 1.4.4.9 binary in a slim image, with your world and config mounted from the host.**

[![CI](https://img.shields.io/github/actions/workflow/status/Delnegend/terraria-server-container/ci.yml?branch=main&style=flat-square)](https://github.com/Delnegend/terraria-server-container/actions)
[![License](https://img.shields.io/github/license/Delnegend/terraria-server-container?style=flat-square)](LICENSE)

</div>

---

## Quick Start

```bash
# 1. Bring your world: drop your .wld file into data/Worlds/
#    and copy serverconfig.txt.example to serverconfig.txt, pointing
#    `world=` at it — e.g. world=/home/terraria/.local/share/Terraria/Worlds/YourWorldName.wld

# 2. Start it (the compose file joins the external `web-tailscale`
#    network — `docker network create web-tailscale` first, or repoint it)
docker compose up -d --build

# 3. Watch it come up
docker logs -f game-terraria
```

## Highlights

- **A stock server, containerized** — the official 1.4.4.9 dedicated binary over `debian:12-slim`, running as the unprivileged `terraria` user, with nothing patched.
- **Your world outlives the container** — worlds and config are bind mounts, so rebuilding the image never touches them.
- **One config file to learn** — `serverconfig.txt` holds port, players, password, and world; the shipped example is annotated.
- **Survives reboots** — `restart: unless-stopped`, with a TTY and open stdin so `docker attach` drops you at the server console.

## Files

| File | Purpose |
|---|---|
| `Dockerfile` | Fetches the 1.4.4.9 zip, extracts the Linux server, runs as `terraria` |
| `docker-compose.yml` | Build, world/config bind mounts, port `7777`, restart |
| `serverconfig.txt.example` | Annotated server config — copy to `serverconfig.txt` and set `world=` |
| `data/` | Your `.wld` worlds, mounted as Terraria's save directory |

## Releases

- Weekly `new-tag` runs cut a semver tag and build `ghcr.io/delnegend/terraria-server-container:<version>` plus `:latest`.
- `VERSION` holds the repackaging version (`1.4.4` today); the server blob it wraps stays pinned at `terraria-server-1449` in the Dockerfile.
- `commit` target test-builds any commit and uploads the image digest without publishing anything.

## License

[MIT](LICENSE)
