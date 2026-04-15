# drupal-composer skill — Developer Notes

## When to use this skill

Use when working with:

- Installing or updating contrib modules via Composer
- Setting version constraints (`^2.0`, `~1.0`, `2.x-dev`)
- Adding patches via `cweagans/composer-patches`
- Checking for security vulnerabilities with `composer audit`
- Verifying Drupal 11 compatibility of a module
- Running post-install steps (enable, updb, cex)

## Mental Model

| Task | Command |
|---|---|
| Install module | `composer require drupal/module_name` |
| Update module | `composer update drupal/module_name` |
| Check outdated | `composer outdated drupal/*` |
| Security audit | `composer audit` |
| Apply patches | `composer install` (reads `composer.json`) |

## Example Prompts

- Install the Paragraphs module with Composer
- Update a specific module to a new major version
- Add a patch from Drupal.org to composer.json
- Check security updates for Drupal modules in this Drupal 11 in the project, for management composer

## After Installing a Module

```bash
ddev drush en module_name -y
ddev drush updb -y
ddev drush cex -y
ddev drush cr
```

## Drupal 11 Compatibility Checklist

Before requiring a module, check:
1. `core_version_requirement: ^11` in module's `info.yml`
2. Security coverage (green shield on drupal.org)
3. Last commit date (is it maintained?)
4. Number of sites using it

## Sources

- [Using Composer with Drupal](https://www.drupal.org/docs/develop/using-composer)
- [composer-patches](https://github.com/cweagans/composer-patches)
