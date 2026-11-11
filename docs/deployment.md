# Deployment & Operations

## Run with Docker Compose

1. Drop your world save (`.wld`) into `data/Worlds/`.
2. Copy `serverconfig.txt.example` to `serverconfig.txt` and configure `world=`:

```bash
cp serverconfig.txt.example serverconfig.txt
# Edit serverconfig.txt to set world path, port, password, and max players
```

3. Ensure the required network exists or adjust `docker-compose.yml`:

```bash
docker network create web-tailscale || true
```

4. Start the server:

```bash
docker compose up -d --build
```

## Run with Podman

```bash
podman run -d --name terraria \
  -it \
  --restart unless-stopped \
  -p 7777:7777 \
  -v ./data:/home/terraria/.local/share/Terraria:Z \
  -v ./serverconfig.txt:/home/terraria/serverconfig.txt:Z \
  ghcr.io/delnegend/terraria-server-container:latest
```

## Logs & Console Access

Inspect startup logs:

```bash
docker compose logs -f
```

Attach to the interactive server console to issue administrative commands:

```bash
docker attach game-terraria
```

Detach cleanly using the key sequence `Ctrl+P`, `Ctrl+Q`.

## Upgrades

Pull the latest image release and recreate the container:

```bash
docker compose pull
docker compose up -d
```
