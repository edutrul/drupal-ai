# ddev-expert skill — Developer Notes

## When to use this skill

Use when working with:

- Starting, stopping, or restarting DDEV containers
- Configuring `.ddev/config.yaml` (PHP version, docroot, web server)
- Adding custom services (Redis, Solr, Elasticsearch)
- Troubleshooting container issues, port conflicts, or Mutagen sync
- Setting up Xdebug for PHPStorm or VS Code with DDEV
- Creating custom DDEV commands in `.ddev/commands/`
- CI/CD integration with DDEV (GitHub Actions, GitLab CI)

## Mental Model

| Concept | Details |
|---|---|
| **Project config** | `.ddev/config.yaml` — PHP version, docroot, project type |
| **Custom services** | `.ddev/docker-compose.*.yaml` — Redis, Solr, etc. |
| **Custom commands** | `.ddev/commands/web/` or `host/` — project shortcuts |
| **PHP overrides** | `.ddev/php/*.ini` — memory limit, upload size |
| **Local overrides** | `.ddev/config.local.yaml` — gitignored personal config |

## Example Prompts

- Set up DDEV for a new Drupal 11 project
- Add a Redis service to DDEV
- Configure Xdebug in a DDEV project for PHPStorm debugging
- Fix Mutagen sync hanging after Docker crash
- Create a custom ddev refresh command

## Source

[DDEV Documentation](https://ddev.readthedocs.io/)

---

## New Project Setup

### Drupal 11

```bash
mkdir my-drupal && cd my-drupal
ddev config --project-type=drupal --docroot=web --php-version=8.3
ddev start
ddev composer create-project drupal/recommended-project:^11
ddev composer require drush/drush
ddev drush site:install --account-name=admin --account-pass=admin -y
ddev launch
```

**Notes:**
- `ddev composer create-project` requires a clean directory. Move `.claude/`, `.git/` out first, then move back.
- Drush is NOT in Drupal 11's recommended-project — always install separately.

### Drupal 10

```bash
mkdir my-drupal && cd my-drupal
ddev config --project-type=drupal --docroot=web --php-version=8.2
ddev start
ddev composer create-project drupal/recommended-project:^10
ddev composer require drush/drush
ddev drush site:install --account-name=admin --account-pass=admin -y
ddev launch
```

### Existing Project

```bash
cd existing-project
ddev config --project-type=drupal --docroot=web
ddev start
ddev composer install
ddev import-db --file=database.sql.gz
ddev drush cr
```

---

## Xdebug IDE Configuration

### VS Code (PHP Debug extension)

```json
// .vscode/launch.json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Listen for Xdebug",
      "type": "php",
      "request": "launch",
      "port": 9003,
      "pathMappings": {
        "/var/www/html": "${workspaceFolder}"
      }
    }
  ]
}
```

### PHPStorm

1. Settings → PHP → Servers
2. Add server: name matches DDEV project name
3. Host: `<project>.ddev.site`, Port: 443, HTTPS
4. Path mappings: project root → `/var/www/html`

---

## Custom Services

### Redis

```yaml
# .ddev/docker-compose.redis.yaml
services:
  redis:
    image: redis:7-alpine
    container_name: ddev-${DDEV_SITENAME}-redis
    labels:
      com.ddev.site-name: ${DDEV_SITENAME}
      com.ddev.approot: $DDEV_APPROOT
    expose:
      - "6379"
    volumes:
      - redis-data:/data
volumes:
  redis-data:
```

Drupal `settings.php`:
```php
$settings['redis.connection']['host'] = 'redis';
$settings['redis.connection']['port'] = 6379;
$settings['cache']['default'] = 'cache.backend.redis';
```

### Solr

```yaml
# .ddev/docker-compose.solr.yaml
services:
  solr:
    image: solr:9
    container_name: ddev-${DDEV_SITENAME}-solr
    labels:
      com.ddev.site-name: ${DDEV_SITENAME}
      com.ddev.approot: $DDEV_APPROOT
    expose:
      - "8983"
    volumes:
      - solr-data:/var/solr
    command: solr-precreate drupal
volumes:
  solr-data:
```

### Elasticsearch

```yaml
# .ddev/docker-compose.elasticsearch.yaml
services:
  elasticsearch:
    image: elasticsearch:8.11.0
    container_name: ddev-${DDEV_SITENAME}-elasticsearch
    labels:
      com.ddev.site-name: ${DDEV_SITENAME}
      com.ddev.approot: $DDEV_APPROOT
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=false
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
    expose:
      - "9200"
    volumes:
      - elasticsearch-data:/usr/share/elasticsearch/data
volumes:
  elasticsearch-data:
```

---

## CI/CD Integration

### GitHub Actions

```yaml
# .github/workflows/test.yml
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Setup DDEV
        uses: ddev/github-action-setup-ddev@v1
      - name: Start DDEV
        run: ddev start
      - name: Install dependencies
        run: ddev composer install
      - name: Run tests
        run: ddev exec ./vendor/bin/phpunit
```

### GitLab CI

```yaml
test:
  image: ddev/ddev-gitpod-base:latest
  services:
    - docker:dind
  variables:
    DOCKER_HOST: tcp://docker:2375
  script:
    - ddev start
    - ddev composer install
    - ddev exec ./vendor/bin/phpunit
```

---

## Performance Tuning

### NFS (macOS, without Mutagen)

```bash
ddev config global --nfs-mount-enabled
```

### Exclude files from sync

```yaml
# .ddev/config.yaml
upload_dirs:
  - sites/default/files
```

### tmpfs for temp files

```yaml
# .ddev/docker-compose.performance.yaml
services:
  web:
    tmpfs:
      - /tmp
```

### Increase PHP memory

```ini
# .ddev/php/performance.ini
memory_limit = 1024M
```

---

## Multi-Environment / ddev pull

```yaml
# .ddev/providers/platform.yaml
environment_variables:
  project: my-project
  environment: main
db_pull_command:
  command: platform db:dump -e ${environment}
```

Then: `ddev pull platform`

---

## Best Practices

1. Commit `.ddev/` (`.ddev/db_snapshots/` is gitignored automatically)
2. Use `.ddev/config.local.yaml` for personal overrides (gitignored)
3. Document custom services in project README
4. Use `ddev snapshot` before risky database operations
5. Keep DDEV updated: `ddev self-upgrade`
6. Use Mutagen on macOS/Windows for better performance
7. Create custom commands for repetitive tasks
8. Test DDEV config in CI to catch issues early
