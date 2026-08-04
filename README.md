# Codespace Starter Kit


## Quick Installation in local

```bash
cp .env.example .env
```

```bash
docker network create app

docker compose pull

sudo chown -R 5050:5050 storage/pgadmin/

docker compose up -d mariadb postgres redis minio phpmyadmin pgadmin meilisearch mailhog selenium nginx dnsmasq
```

### Local DNS setup (once per machine)

All services are served under `*.codespacex.ir`. The `dnsmasq` container resolves
these domains locally so requests never touch the internet, keeping them fast
regardless of your network quality. Any new `something.codespacex.ir` subdomain
works automatically — no `/etc/hosts` editing needed.

Run this once after cloning:

```bash
./setup-dns.sh
```

The script detects your environment and takes the right path:

| Your machine | What the script does |
|---|---|
| No dnsmasq installed | Configures `systemd-resolved` to forward `*.codespacex.ir` to the Docker `dnsmasq` container (`127.0.0.2:53`) |
| dnsmasq already running | Adds a drop-in config to your existing dnsmasq (`/etc/dnsmasq.d/codespacex.conf`) — the Docker container is not needed and can be omitted from `docker compose up` |

**Also disable DNS-over-HTTPS in your browser** (DoH bypasses the system resolver
entirely and must be turned off separately):

- Firefox: `about:config` → set `network.trr.mode` to `5`
- Chrome: Settings → Privacy and security → Security → turn off **Use secure DNS**


### Accessing containers

Every container on the `app` network is reachable through nginx in three ways.
All are automatic — start a container and it's served, no per-container config.

| Method | URL | Path handling |
|---|---|---|
| **Subdomain** | `http://<name>.codespacex.ir/` | full path forwarded to the container |
| **Subfolder (literal name)** | `http://codespacex.ir/<name>/` | the `<name>` segment is stripped, the rest is forwarded |
| **Subfolder (friendly)** | `http://codespacex.ir/<path>/` | full path forwarded (for `sanjeman_*` apps) |

The first two need no setup at all. For example, a `phpmyadmin` container is
reachable at both [http://phpmyadmin.codespacex.ir](http://phpmyadmin.codespacex.ir)
and [http://codespacex.ir/phpmyadmin](http://codespacex.ir/phpmyadmin).

**Friendly subfolder routes** give `sanjeman_*` containers a short, production-like
path. They strip the `sanjeman_` prefix and turn `_` into `/`:

| Container | Friendly URL |
|---|---|
| `sanjeman_core` | [http://codespacex.ir/core](http://codespacex.ir/core) |
| `sanjeman_sanjup_api` | [http://codespacex.ir/sanjup/api](http://codespacex.ir/sanjup/api) |

These are for apps that are **mounted under the subfolder** — the subfolder is part
of every route in the app, exactly as on production. nginx forwards the full path
unchanged, so a friendly route behaves identically to its subdomain:

```text
http://codespacex.ir/sanjup/api/health  ==  http://sanjup.codespacex.ir/sanjup/api/health
```

Because the container can't always be inferred from a multi-segment URL alone
(`/sanjup/api/...` → `sanjeman_sanjup` or `sanjeman_sanjup_api`?), these routes are
generated into `src/conf.d/app-routes/app-routes.conf` (sorted longest-first so
nested paths win) and included by nginx. Regenerate after adding or removing a
`sanjeman_*` container:

```bash
./regen-routes.sh
```

The generated `app-routes.conf` is gitignored. Defaults can be overridden with env
vars: `APP_ROUTE_PREFIX=sanjeman APP_DOCKER_NETWORK=app`.


### Ports

```text
mariadb:3306
```
```text
postgres:5432
```
```text
redis:6379
```
```text
mailhog:1025
```
```text
mongodb:27017
```
```text
mongo-express:8081
```


### Minio

- admin: [http://minio.codespacex.ir/](http://minio.codespacex.ir/)
- api: [http://storage.codespacex.ir/](http://storage.codespacex.ir/)


### Phpmyadmin

- [http://phpmyadmin.codespacex.ir](http://phpmyadmin.codespacex.ir)

### Mongo-express

- [http://mongoexpress.codespacex.ir](http://mongoexpress.codespacex.ir)

### PGAdmin

- [http://pgadmin.codespacex.ir/](http://pgadmin.codespacex.ir/)

### Meilisearch

- [http://meilisearch.codespacex.ir](http://meilisearch.codespacex.ir)

### Mailhog

- [http://mailhog.codespacex.ir/](http://mailhog.codespacex.ir/)

### Selenium

- [http://selenium.codespacex.ir](http://selenium.codespacex.ir)


# Tools

Generate password:
```bash
date +%s | sha256sum | base64 | head -c 32 ; echo
```
