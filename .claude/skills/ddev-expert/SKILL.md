---
name: ddev-expert
description: DDEV local development expertise. Use when working with DDEV projects, containers, configuration, or troubleshooting DDEV environments.
---

# DDEV Expert

## Essential Commands

```bash
# Project
ddev start | stop | restart | poweroff | delete

# Execute
ddev drush <cmd> | ddev composer <cmd> | ddev exec <cmd> | ddev ssh

# Database
ddev mysql | ddev export-db | ddev import-db --file=dump.sql
ddev snapshot | ddev restore

# Utilities
ddev describe        # URLs and project info
ddev logs -f         # Follow logs
ddev launch          # Open in browser
ddev launch -m       # Open Mailpit UI
```

## Configuration (.ddev/config.yaml)

```yaml
name: my-project
type: drupal          # auto-detects version; or drupal11/drupal10
docroot: web
php_version: "8.3"
webserver_type: nginx-fpm
database:
  type: mariadb
  version: "10.11"
additional_hostnames:
  - api.my-project.ddev.site
webimage_extra_packages: [php8.3-imagick]
mutagen_enabled: true  # macOS/Windows performance
```

**Overrides:** `.ddev/config.local.yaml` (gitignored personal config)
**PHP overrides:** `.ddev/php/*.ini`

## Troubleshooting

**`ddev composer create-project` fails ("not allowed to be present"):**
Move extra dirs out temporarily (`.claude/`, `.git/`), run create-project, move back.

**Port conflicts:**
```bash
ddev poweroff && sudo lsof -i :80
```

**Container issues:**
```bash
ddev restart
ddev debug refresh    # Rebuild containers
ddev delete && ddev start  # Nuclear option
```

**Database:** Host is `db` (inside container) or `127.0.0.1:PORT` (outside). Check port with `ddev describe`.

**Permissions:** `ddev exec chown -R $(id -u):$(id -g) .`

**PHP deprecation warnings in Drush** — create `.ddev/php/drush.ini`:
```ini
[PHP]
error_reporting = 22527   ; E_ALL & ~E_DEPRECATED
display_errors = Off
log_errors = On
error_log = /tmp/php-errors.log
```

**Docker Desktop overlay2 I/O errors** — normal restart is not enough:
```bash
killall -9 Docker   # then relaunch Docker Desktop
```

**Mutagen sync hanging after Docker crash:**
```bash
ddev poweroff && ddev start
# If still stuck:
ddev stop
~/.ddev/bin/mutagen daemon stop
~/.ddev/bin/mutagen daemon start
ddev mutagen reset && ddev start
```

```bash
ddev mutagen status -l   # Detailed sync status
ddev mutagen monitor     # Real-time progress
```

**Debug commands:**
```bash
ddev debug capabilities | ddev debug router
ddev exec env
```

## Xdebug

```bash
ddev xdebug on | off | status
```

`.ddev/php/xdebug.ini`:
```ini
[xdebug]
xdebug.mode=debug,develop,coverage
```

Modes: `debug` (step), `develop` (enhanced errors), `coverage`, `profile`.
See README.md for full IDE setup (VS Code / PHPStorm).

## Custom Services

Add `.ddev/docker-compose.<service>.yaml`. Common pattern:
```yaml
services:
  redis:
    image: redis:7-alpine
    container_name: ddev-${DDEV_SITENAME}-redis
    labels:
      com.ddev.site-name: ${DDEV_SITENAME}
      com.ddev.approot: $DDEV_APPROOT
    expose:
      - "6379"
```

See README.md for full Solr, Elasticsearch, Redis configs and Drupal settings.php snippets.

## Custom Commands

Create `.ddev/commands/web/<name>` (or `host/`, `db/`):
```bash
#!/bin/bash
## Description: Full site refresh
## Usage: refresh
set -e
drush sql:drop -y && drush sql:cli < /var/www/html/reference.sql
drush config:import -y && drush updatedb -y && drush cache:rebuild
```

`chmod +x` then run as `ddev <name>`.

## Performance (macOS/Windows)

```bash
ddev config global --mutagen-enabled   # Enable globally
ddev mutagen status | sync | reset
```

See README.md for NFS, tmpfs, and file sync exclusion patterns.
