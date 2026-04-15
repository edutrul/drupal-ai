# docker-local skill — Developer Notes

## When to use this skill

Use when working with:

- Custom Docker Compose setups (non-DDEV)
- `docker-compose.yml` service configuration
- Running Drush or Composer inside containers
- Database import/export with Docker
- Makefile wrappers for Docker commands
- Troubleshooting container startup, port conflicts, or permission issues
- Environment variable management with `.env` files

## Mental Model

| Scenario | Command pattern |
|---|---|
| Run in container | `docker compose exec <service> <cmd>` |
| Run one-off | `docker compose run --rm <service> <cmd>` |
| Check status | `docker compose ps` |
| View logs | `docker compose logs -f <service>` |
| Fresh start | `docker compose down -v && up -d` *(loses data!)* |

## Example Prompts

- Set up Docker Compose for a Drupal project without DDEV
- Add Redis to an existing Docker Compose setup
- How do I create a Makefile wrapper for Docker Compose commands in a local development setup?
- Fix file permission issues in a local Docker Compose Drupal container

## Standard docker-compose.yml Template

```yaml
services:
  php:
    build:
      context: .
      dockerfile: docker/php/Dockerfile
    volumes:
      - .:/var/www/html:cached
    depends_on:
      - db
    environment:
      - PHP_MEMORY_LIMIT=512M

  web:
    image: nginx:alpine
    ports:
      - "8080:80"
    volumes:
      - .:/var/www/html:ro
      - ./docker/nginx/default.conf:/etc/nginx/conf.d/default.conf:ro
    depends_on:
      - php

  db:
    image: mariadb:10.11
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: drupal
      MYSQL_USER: drupal
      MYSQL_PASSWORD: drupal
    volumes:
      - db-data:/var/lib/mysql
    ports:
      - "3306:3306"

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

volumes:
  db-data:
```

## PHP Dockerfile

```dockerfile
# docker/php/Dockerfile
FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    git unzip libpng-dev libjpeg-dev libfreetype6-dev \
    libzip-dev libicu-dev mariadb-client \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo_mysql zip intl opcache bcmath

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html
```

## Nginx Config

```nginx
# docker/nginx/default.conf
server {
    listen 80;
    server_name localhost;
    root /var/www/html/web;
    index index.php;

    location / {
        try_files $uri /index.php$is_args$args;
    }

    location ~ \.php$ {
        fastcgi_pass php:9000;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.ht {
        deny all;
    }
}
```

## Makefile Wrapper

```makefile
.PHONY: up down restart shell drush composer logs

up:
	docker compose up -d

down:
	docker compose down

restart:
	docker compose restart

shell:
	docker compose exec php bash

drush:
	docker compose exec php ./vendor/bin/drush $(filter-out $@,$(MAKECMDGOALS))

composer:
	docker compose exec php composer $(filter-out $@,$(MAKECMDGOALS))

logs:
	docker compose logs -f

db-import:
	docker compose exec -T db mysql -u root -proot drupal < $(file)

db-export:
	docker compose exec db mysqldump -u root -proot drupal > dump.sql

%:
	@:
```

## Drupal settings.php for Docker

```php
$databases['default']['default'] = [
  'driver' => 'mysql',
  'database' => getenv('MYSQL_DATABASE') ?: 'drupal',
  'username' => getenv('MYSQL_USER') ?: 'drupal',
  'password' => getenv('MYSQL_PASSWORD') ?: 'drupal',
  'host' => getenv('DB_HOST') ?: 'db',
  'port' => getenv('DB_PORT') ?: 3306,
];

if (getenv('REDIS_HOST')) {
  $settings['redis.connection']['host'] = getenv('REDIS_HOST') ?: 'redis';
  $settings['cache']['default'] = 'cache.backend.redis';
}
```

## Best Practices

1. Version your `docker-compose.yml` for consistent environments
2. Use `.env` for secrets — never commit passwords
3. Create a Makefile to simplify commands for the team
4. Document in README: how to start, stop, access services
5. Use named volumes for database persistence
6. Add health checks so dependent services wait for readiness

## Source

[Docker Compose Documentation](https://docs.docker.com/compose/)
