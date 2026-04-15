---
name: docker-local
description: Custom Docker Compose local development patterns. Use when working with Docker-based local environments, container configuration, or troubleshooting Docker setups.
---

# Docker Compose Local Development

You are working with custom Docker Compose local development environments (non-DDEV).

## Environment Detection

```bash
ls -la docker-compose*.yml compose*.yml .env* Makefile docker/ scripts/ 2>/dev/null
```

## Common Commands

```bash
docker compose up -d              # Start in background
docker compose up -d --build      # Start with rebuild
docker compose down               # Stop and remove containers
docker compose down -v            # Also remove volumes (DATA LOSS!)
docker compose exec <service> <cmd>
docker compose run --rm <service> <cmd>  # One-off (if not running)
docker compose ps && docker compose logs -f <service>
```

## Drupal Docker Patterns

| Service Type | Common Names |
|---|---|
| PHP/Web | `php`, `web`, `app`, `drupal`, `php-fpm` |
| Database | `db`, `mysql`, `mariadb`, `postgres` |
| Cache | `redis`, `memcached` |
| Search | `solr`, `elasticsearch` |

```bash
# Drush
docker compose exec php ./vendor/bin/drush cr

# MySQL import/export
docker compose exec -T db mysql -u root -p<password> <database> < dump.sql
docker compose exec db mysqldump -u root -p<password> <database> > dump.sql
```

## Troubleshooting

```bash
# Port conflicts
sudo lsof -i :80

# Container won't start
docker compose logs <service>
docker compose down && docker compose up -d --build

# Permissions
docker compose exec php chown -R www-data:www-data /var/www/html/web/sites/default/files

# Network: containers reach each other by service name (e.g. host: db)
docker network inspect <project>_default
```

## Environment Variables

Docker Compose auto-loads `.env`:
```env
COMPOSE_PROJECT_NAME=myproject
MYSQL_ROOT_PASSWORD=root
MYSQL_DATABASE=drupal
```

Performance on macOS: use `:cached` volume flag and named volumes for `vendor/`.
