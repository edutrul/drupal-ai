---
name: drupal-debugging
description: Drupal debugging techniques — Devel module, Drush watchdog, Twig debug, XDebug, error logging, and common troubleshooting patterns.
---

# Drupal Debugging

## Drush Log Watching

```bash
# Watch all errors
ddev drush ws --severity=error

# Last 20 entries
ddev drush ws --severity=error --count=20

# Watch all log levels
ddev drush ws --count=50

# Specific type
ddev drush ws --type=php --count=20
```

## PHP Inline Debugging

```bash
# Run PHP in Drupal context
ddev drush php:eval "var_dump(\Drupal::config('my_module.settings')->getRawData());"

# Check if service exists
ddev drush php:eval "var_dump(\Drupal::hasService('my_module.my_service'));"

# Check class autoloading
ddev drush php:eval "class_exists('Drupal\my_module\Service\MyService') ? print 'Found' : print 'Not found';"

# Inspect an entity
ddev drush php:eval "
\$node = \Drupal::entityTypeManager()->getStorage('node')->load(1);
print_r(\$node->toArray());
"
```

## Twig Debugging

Enable in `sites/default/services.yml`:
```yaml
parameters:
  twig.config:
    debug: true
    auto_reload: true
    cache: false
```

Then in templates:
```twig
{{ dump(content) }}
{{ dump(node) }}
{{ dump(_context|keys) }}
```

HTML comments in source will show template suggestions:
```html
<!-- FILE NAME SUGGESTIONS:
  * node--1--full.html.twig
  * node--1.html.twig
  * node--article--full.html.twig
  x node--article.html.twig  ← currently used
  * node--full.html.twig
  * node.html.twig
-->
```

## Devel Module

```bash
# Install devel
composer require drupal/devel
ddev drush en devel -y
```

In PHP:
```php
// Dump and die
dpm($variable);        // Krumo output in message area
ksm($variable);        // Krumo output (devel module)
dvm($variable);        // Var dump

// Krumo (in Twig via Devel)
// {{ devel_dump(node) }}
```

## Cache Debugging

```bash
# Clear all caches
ddev drush cr

# Rebuild theme registry only
ddev drush php:eval "\Drupal::service('theme.registry')->reset();"

# Check cache hit for a page (Drupal page cache)
# Look for X-Drupal-Cache: HIT in response headers
curl -I https://my-project.ddev.site/

# Check Big Pipe and render cache
ddev drush state:get drupal.maintenance_mode
```

## Service Container Debugging

```bash
# List all services matching a pattern
ddev drush devel:services | grep my_module

# List all services
ddev drush devel:services

# Check container definition
ddev drush php:eval "
\$def = \Drupal::getContainer()->getDefinition('my_module.my_service');
var_dump(\$def);
"
```

## Module/Hook Debugging

```bash
# List all enabled modules
ddev drush pm:list --status=enabled

# Check which modules implement a hook
ddev drush php:eval "
\$modules = \Drupal::moduleHandler()->getImplementations('form_alter');
print implode(', ', \$modules);
"

# Check module info
ddev drush pm:info my_module
```

## Common Problems and Solutions

| Problem | Solution |
|---|---|
| Class not found | Check namespace, PSR-4 in .info.yml, run `composer dump-autoload` |
| Service not found | Check services.yml syntax, run `ddev drush cr` |
| Template not used | Enable Twig debug, check template suggestions in HTML comments |
| Hook not firing | Check class is registered in services.yml, verify Hook attribute |
| Config not saving | Check config schema exists in `config/schema/` |
| Migration failing | `ddev drush ws` for details, check field mappings |

## XDebug with DDEV

```bash
# Enable XDebug
ddev xdebug on

# Disable XDebug (performance)
ddev xdebug off

# Check XDebug status
ddev xdebug status
```

Configure IDE (PHPStorm) to listen on port 9003.

