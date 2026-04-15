---
name: drupal-migrations
description: Drupal migration API — D7-to-D11 upgrades, CSV imports, JSON API imports, and custom source/process/destination plugins.
---

# Drupal Migrations

## Migration YAML Structure

```yaml
id: my_migration
label: 'My Migration'
migration_group: my_group  # group related migrations together

source:
  plugin: source_plugin_name

process:
  destination_field: source_field

destination:
  plugin: 'entity:node'
  default_bundle: article

migration_dependencies:
  required:
    - other_migration  # must match actual migration IDs
```

## Process Plugins Quick Reference

| Plugin | Use for |
|---|---|
| `default_value` | Hardcode a value |
| `static_map` | Map old values → new values |
| `concat` | Join fields with a delimiter |
| `migration_lookup` | Reference a previously migrated entity (by old ID) |
| `entity_lookup` | Reference an existing entity by field value |
| `entity_generate` | Create entity if it doesn't exist |
| `skip_on_empty` | Skip field/row if value is empty |
| `skip_on_value` | Skip row if field equals a value |
| `sub_process` | Iterate a multi-value source array |

## Entity References

```yaml
process:
  # Reference a previously migrated entity
  uid:
    plugin: migration_lookup
    migration: users
    source: author_id

  # Reference an existing entity by field value
  field_category:
    plugin: entity_lookup
    source: category_name
    entity_type: taxonomy_term
    bundle: categories
    bundle_key: vid
    value_key: name

  # Create term if it doesn't exist
  field_tags:
    plugin: entity_generate
    source: tag_name
    entity_type: taxonomy_term
    bundle: tags
    value_key: name
```

## Multiple Values & Conditional

```yaml
process:
  # Iterate a multi-value source array
  field_tags:
    plugin: sub_process
    source: tags
    process:
      target_id:
        plugin: entity_generate
        source: name
        entity_type: taxonomy_term
        bundle: tags
        value_key: name

  # Skip field processing if source is empty
  field_image:
    plugin: skip_on_empty
    method: process
    source: image_url

  # Skip entire row based on a value
  pseudo_skip:
    plugin: skip_on_value
    source: status
    method: row
    value: 'draft'
```

## Custom Source Plugin

```php
namespace Drupal\my_module\Plugin\migrate\source;

use Drupal\migrate\Attribute\MigrateSource;
use Drupal\migrate\Plugin\migrate\source\SqlBase;
use Drupal\migrate\Row;

#[MigrateSource(id: 'legacy_products', source_module: 'my_module')]
final class LegacyProducts extends SqlBase {

  public function query() {
    return $this->select('legacy_products', 'p')
      ->fields('p', ['id', 'name', 'price'])
      ->condition('p.status', 'active');
  }

  public function fields() {
    return [
      'id' => $this->t('Product ID'),
      'name' => $this->t('Name'),
      'price' => $this->t('Price'),
    ];
  }

  public function getIds() {
    return ['id' => ['type' => 'integer', 'alias' => 'p']];
  }

  public function prepareRow(Row $row) {
    $row->setSourceProperty('price_with_tax', $row->getSourceProperty('price') * 1.21);
    return parent::prepareRow($row);
  }

}
```

## Custom Process Plugin

```php
namespace Drupal\my_module\Plugin\migrate\process;

use Drupal\migrate\Attribute\MigrateProcess;
use Drupal\migrate\MigrateExecutableInterface;
use Drupal\migrate\ProcessPluginBase;
use Drupal\migrate\Row;

#[MigrateProcess(id: 'cents_to_decimal')]
final class CentsToDecimal extends ProcessPluginBase {

  public function transform($value, MigrateExecutableInterface $migrate_executable, Row $row, $destination_property) {
    if (empty($value) || !is_numeric($value)) {
      return NULL;
    }
    return number_format((float) $value / 100, 2, '.', '');
  }

}
```

## Key Drush Commands

```bash
drush migrate:status                          # list all migrations + status
drush migrate:import migration_id             # run
drush migrate:import migration_id --update    # re-run and update existing records
drush migrate:import migration_id --limit=50  # batch to avoid memory issues
drush migrate:rollback migration_id           # undo
drush migrate:reset-status migration_id       # fix "migration is busy" state
drush migrate:messages migration_id           # show per-row errors
```
