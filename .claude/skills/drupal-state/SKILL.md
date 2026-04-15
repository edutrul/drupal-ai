---
name: drupal-state
description: Drupal State API — storing and retrieving runtime state that persists across requests but is not configuration.
---

# Drupal State API

State is for runtime data that should persist across requests but is NOT configuration. Use Config for user-managed settings. Use State for internal operational data (last cron run, migration status, etc.).

## Basic Usage

```php
use Drupal\Core\State\StateInterface;

// Inject
public function __construct(
  private readonly StateInterface $state,
) {}

// Get
$value = $this->state->get('my_module.last_run');
$value = $this->state->get('my_module.last_run', $default_value);

// Set
$this->state->set('my_module.last_run', \Drupal::time()->getRequestTime());

// Delete
$this->state->delete('my_module.last_run');

// Get multiple
$values = $this->state->getMultiple(['key1', 'key2']);

// Set multiple
$this->state->setMultiple([
  'my_module.status' => 'active',
  'my_module.count' => 42,
]);

// Delete multiple
$this->state->deleteMultiple(['key1', 'key2']);
```

## Naming Convention

Use a namespaced key: `module_name.key_name`

```php
// Good
$this->state->get('my_module.last_import_time');
$this->state->get('my_module.processed_count');

// Bad
$this->state->get('last_import');   // Not namespaced
```

## State vs Config vs Cache

| Storage | Use for | Exportable |
|---|---|---|
| **State** | Runtime operational data (last run times, counters, flags) | No |
| **Config** | User-managed settings, site configuration | Yes (via cex/cim) |
| **Cache** | Expensive computed data, invalidated on change | No (temporary) |
| **UserData** | Per-user preferences/data | No |

## Common Use Cases

```php
// Track last cron run
$this->state->set('my_module.cron_last', \Drupal::time()->getRequestTime());

// Feature flag (internal)
$isEnabled = $this->state->get('my_module.feature_enabled', FALSE);

// Track migration progress
$this->state->set('my_module.migration_offset', $offset);

// Store external API token (not sensitive — use KeyModule for secrets)
$this->state->set('my_module.api_token_expires', $expires);
```

## Drush State Commands

```bash
# Get
drush state:get my_module.last_run

# Set
drush state:set my_module.feature_enabled 1

# Delete
drush state:del my_module.last_run
```

## Service ID

`state`

