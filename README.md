<div align="center">

# Terraria Server Container

**A Terraria dedicated server that starts with one command: the official 1.4.4.9 binary in a slim image, with your world and config mounted from the host.**

[![CI](https://badgers.space/github/checks/Delnegend/terraria-server-container/main?corner_radius=0&label=build)](https://github.com/Delnegend/terraria-server-container/actions)
[![Release](https://badgers.space/github/release/Delnegend/terraria-server-container?corner_radius=0&color=ea7233)](https://github.com/Delnegend/terraria-server-container/releases)
[![License](https://badgers.space/badge/license/MIT/007ec6?corner_radius=0)](LICENSE)

</div>

---

## Quick Start

```bash
# 1. Bring your world: drop your .wld file into data/Worlds/
#    and copy serverconfig.txt.example to serverconfig.txt, pointing
#    `world=` at it, e.g. world=/home/terraria/.local/share/Terraria/Worlds/YourWorldName.wld

# 2. Start it (the compose file joins the external `web-tailscale`
#    network; `docker network create web-tailscale` first, or repoint it)
docker compose up -d --build

# 3. Watch it come up
docker logs -f game-terraria
```

## Highlights

- **A stock server, containerized**: The official 1.4.4.9 dedicated binary over `debian:12-slim`, running as the unprivileged `terraria` user, with nothing patched.
- **Your world outlives the container**: Worlds and config are bind mounts, so rebuilding the image never touches them.
- **One config file to learn**: `serverconfig.txt` holds port, players, password, and world; the shipped example is annotated.
- **Survives reboots**: `restart: unless-stopped`, with a TTY and open stdin so `docker attach` drops you at the server console.

## Documentation

- **[Architecture](docs/architecture.md)**: Container design, unprivileged runtime, and world persistence.
- **[Development](docs/development.md)**: Release procedures, workflow gating, and container-specific notes.
- **[Deployment](docs/deployment.md)**: Deployment via Docker Compose or Podman, console access, and upgrades.

## License

[MIT](LICENSE)
