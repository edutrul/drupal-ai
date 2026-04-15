# drupal-migrations skill — Developer Notes

## When to use this skill

Use when working with:

- Migrating content from Drupal 7 to Drupal 10/11
- Importing data from CSV files
- Importing data from JSON or external APIs
- Writing custom source, process, or destination plugins
- Running and debugging migrations with `drush migrate:*` commands
- Handling migration dependencies and rollbacks

## Mental Model

| Component | Role |
|---|---|
| **Source** | Where data comes from (D7 DB, CSV, JSON API) |
| **Process** | Transform data between source and destination |
| **Destination** | Where data lands (`entity:node`, `entity:user`, etc.) |

| Process Plugin | Use for |
|---|---|
| `default_value` | Hardcode a value |
| `static_map` | Map old values to new values |
| `migration_lookup` | Reference a previously migrated entity |
| `entity_lookup` | Reference an existing entity by field value |
| `entity_generate` | Create entity if it doesn't exist |
| `skip_on_empty` | Skip field/row if value is empty |

## Example Prompts

- Create a Drupal migration to import article nodes from Drupal 7 to Drupal 11
- Generate a full Drupal CSV migration YAML including source, process, and destination to import products as nodes with one field
- Create a custom Drupal migrate source plugin for a legacy database table
- Map old taxonomy terms to a new Drupal vocabulary using Migrate API
- How to fix a Drupal migration stuck in busy status

## Sources

- [Migrate API](https://www.drupal.org/docs/drupal-apis/migrate-api)
- [Migrate Plus](https://www.drupal.org/project/migrate_plus)
- [Migrate Tools](https://www.drupal.org/project/migrate_tools)
- [D7 to D10 Migration Guide](https://www.drupal.org/docs/upgrading-drupal/upgrading-from-drupal-7)

## Essential Modules

```bash
drush en migrate migrate_drupal migrate_drupal_ui
composer require drupal/migrate_plus drupal/migrate_tools drupal/migrate_file
drush en migrate_plus migrate_tools migrate_file
```

| Module | Purpose |
|---|---|
| `migrate` | Core migration framework |
| `migrate_drupal` | D6/D7 migration support |
| `migrate_drupal_ui` | Browser-based migration wizard |
| `migrate_plus` | Config-based migrations, extra source plugins |
| `migrate_tools` | Drush commands for migrations |
| `migrate_file` | File migration handling |

## D7 to D11 Setup

```php
// settings.php — add legacy database connection
$databases['migrate']['default'] = [
  'driver' => 'mysql',
  'database' => 'drupal7_db',
  'username' => 'db_user',
  'password' => 'db_pass',
  'host' => 'localhost',
  'prefix' => '',
];
```

```bash
# Generate migrations from D7 source (configure only, don't run yet)
drush migrate:upgrade --legacy-db-key=migrate --configure-only

# Then review and run
drush migrate:status
drush migrate:import --all
```

## CSV Migration Example

```yaml
id: import_products
source:
  plugin: csv
  path: 'modules/custom/my_module/data/products.csv'
  ids:
    - sku
  header_row_count: 1
  column_names:
    0:
      sku: 'Product SKU'
    1:
      name: 'Product Name'
    2:
      price: 'Price'

process:
  type:
    plugin: default_value
    default_value: product
  title: name
  field_sku: sku

destination:
  plugin: 'entity:node'
  default_bundle: product
```

## JSON/API Migration Example

```yaml
id: import_api_users
source:
  plugin: url
  data_fetcher_plugin: http
  data_parser_plugin: json
  urls:
    - 'https://api.example.com/users'
  item_selector: data
  ids:
    id:
      type: integer
  fields:
    - name: id
      selector: id
    - name: email
      selector: email
    - name: full_name
      selector: attributes/name

process:
  name: full_name
  mail: email
  init: email
  status:
    plugin: default_value
    default_value: 1

destination:
  plugin: 'entity:user'
```

## Basic Process Transformations

```yaml
process:
  # Static mapping
  field_type:
    plugin: static_map
    source: type
    map:
      old_type: new_type
    default_value: fallback_type

  # Concatenate fields
  title:
    plugin: concat
    source:
      - first_name
      - last_name
    delimiter: ' '

  # Explode string to array, then generate terms
  field_keywords:
    - plugin: explode
      source: keywords
      delimiter: ','
    - plugin: entity_generate
      entity_type: taxonomy_term
      bundle: keywords
      value_key: name
```

## Debugging Migrations

```bash
# Verbose output
drush migrate:import migration_id -vvv

# Show per-row error messages
drush migrate:messages migration_id
```

```php
// Log from a custom process plugin
\Drupal::logger('my_migration')->notice('Processing: @value', ['@value' => $value]);
```

**Common issues:**
- "Migration is busy" → `drush migrate:reset-status migration_id`
- Memory errors → use `--limit=500` to batch
- Missing dependencies → check `migration_dependencies` IDs match `drush migrate:status` output

## Migration Module Structure

```
my_migration/
├── my_migration.info.yml
├── config/
│   └── install/
│       ├── migrate_plus.migration_group.my_group.yml
│       ├── migrate_plus.migration.users.yml
│       └── migrate_plus.migration.content.yml
├── src/
│   └── Plugin/
│       └── migrate/
│           ├── source/
│           └── process/
└── data/
    └── import.csv
```

## Best Practices

- Always use `migration_group` to organize related migrations
- Set `migration_dependencies` to ensure correct execution order
- Test with `--limit=10` before a full import
- Use `--update` for re-running updated migrations
- Keep source data until migration is verified in production
