---
name: drupal-composer
description: Drupal Composer management — requiring modules, updates, patches via composer-patches, and version constraints.
---

# Drupal Composer Management

## Installing & Updating

```bash
composer require drupal/module_name
composer require drupal/module_name:^2.0
composer require drupal/module_name:^1.0@dev
composer update drupal/module_name
composer update drupal/*
composer outdated drupal/*
composer audit
```

## Version Constraints

| Constraint | Meaning |
|---|---|
| `^2.0` | >= 2.0.0 and < 3.0.0 |
| `~2.0` | >= 2.0.0 and < 2.1.0 |
| `2.x-dev` | Latest 2.x dev branch |
| `^1.0@dev` | >= 1.0 dev releases |

## Patches (composer-patches)

```json
"extra": {
  "patches": {
    "drupal/module_name": {
      "Patch description - issue #1234567": "patches/module_name-patch-description.patch"
    },
    "drupal/tb_megamenu": {
      "Block content support": "patches/tb_megamenu-block-content-support.patch"
    }
  }
}
```

Patches apply on `composer install` and re-apply on `composer update drupal/module_name`.

## Useful Commands

```bash
composer show drupal/module_name
composer validate
composer clear-cache
composer install --no-cache
```
