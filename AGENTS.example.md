# MY_PROJECT Drupal 11

Drupal 11 / PHP 8.3 / MySQL 8.0 / DDEV (`my-project`) / Acquia Cloud via GitHub Actions.
All PHP/Drush commands run inside DDEV. Main branch: `develop`.

## Commands

```bash
# Cache / config
ddev drush cr && ddev drush cim && ddev drush cex && ddev drush updb

# Frontend
ddev exec 'cd docroot/themes/custom/my_theme && npm run dev'
ddev exec 'cd docroot/themes/custom/my_theme && npm run build'

# Code quality (run before PR)
ddev phpcs && ddev phpstan

# Tests
ddev exec vendor/bin/phpunit tests/
```

## Custom Modules (`docroot/modules/custom/`)

- `myproject_media` — Custom media source + field formatter
- `myproject_analytics` — `window.dataLayer` for GTM/analytics
- `myproject_auth` — SSO / OpenID Connect helpers
- `myproject_content` — Default content + test users export/import
- `myproject_icons` — Icon media entities from YAML
- `myproject_menu` — Menu alterations
- `myproject_paragraphs` — Paragraph alterations
- `myproject_schema` — JSON-LD structured data in `<head>`
- `myproject_search` — Search API functionality
- `myproject_tables` — Responsive table wrappers + captions

## Custom Theme (`docroot/themes/custom/my_theme/`)

Storybook 9 + ViteJS 6, SDC components in `components/`, PostCSS, ESLint, Stylelint, Prettier.

## Key Paths

- Config: `config/default/` (base), `config/envs/` (env overrides) — managed via `config_split`
- Tests: `tests/src/ExistingSite/` (DTT / `ExistingSiteBase`)
- Drush commands: `drush/Commands/MyProject/`
- Patches: `patches/` via `cweagans/composer-patches`

## Naming Conventions

- Modules: `myproject_` prefix. Constants: `MYPROJECT_`. Functions: `_myproject_` prefix.
- Prefer placing code in an existing relevant module over creating a new one.

## Code Standards

PHP: Drupal + DrupalPractice PHPCS on `docroot/modules/custom/`, `docroot/themes/custom/`, `docroot/sites/default/settings.php`. PHPStan level 5, Rector (custom modules only). LF line endings, 2-space indent (4 for composer).

## PHP Design

- Prefer `final` for new concrete classes
- `private` properties by default; `readonly` for injected dependencies
- Constructor injection; no `\Drupal::service()` in classes

## Testing

- Framework: DTT ExistingSite (`weitzman\DrupalTestTraits\ExistingSiteBase`)
- Location: `tests/src/ExistingSite/`
- Run: `ddev exec vendor/bin/phpunit tests/`
