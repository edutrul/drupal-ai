---
name: drupal-config
description: Drupal configuration management with Drush — import/export config, preview config changes before applying (e.g., seeing what would change without importing), config splits, and environment syncing.
---

# Drupal Configuration Management

## Safety: Avoid Accidental Remote Imports

Remote drush may default to `--yes` and auto-confirm `cim`. Always use safe patterns:

```bash
# SAFE — preview only
ssh user@remote "drush cim --no --diff"
ssh user@remote "drush config:get config.name"
ssh user@remote "drush config:status"

# DANGEROUS — may auto-import
ssh user@remote "drush cim --diff"
```

## Import / Export

```bash
ddev drush cex               # Export active config → YAML files
ddev drush cim               # Import YAML files → active config
ddev drush cim --no --diff   # Preview only (no import)
ddev drush config:status     # Show pending changes (read-only)
```

## Config Splits

### Complete vs Partial — CRITICAL distinction

| Type | Behavior | Use for |
|---|---|---|
| **Complete** | Config exists ONLY in that environment | Modules on/off (devel, stage_file_proxy) |
| **Partial** | Base config everywhere, different VALUES | API keys, SMTP, search server URLs |

**Complete split**: config is removed from `config/sync/` and lives only in `config/{split}/`.
**Partial split**: config stays in `config/sync/`, overrides live in `config/{split}/config_split.patch.*.yml`.

### Split Commands

```bash
ddev drush config-split:status            # List splits and active state
ddev drush csex {split-name}              # Export specific split
ddev drush csim {split-name}              # Import specific split
ddev drush config-split:activate {name}
ddev drush config-split:deactivate {name}
```

### Updating a Split Definition

Changes must be in **active config** (DB), not just YAML files:

```bash
# Edit YAML, then import to activate
ddev drush config:import --partial
# OR set via PHP eval
ddev drush php:eval "\$c = \Drupal::configFactory()->getEditable('config_split.config_split.local'); \$c->set('partial_list', ['config.name']); \$c->save();"
ddev drush cex
```

## Troubleshooting

### Config deleted from config/sync/ on export

**Root cause**: Config is in `complete_list` instead of `partial_list`.

```bash
# Diagnose
grep -A10 "complete_list:" config/sync/config_split.config_split.local.yml
grep -A10 "partial_list:" config/sync/config_split.config_split.local.yml
```

Fix: move the item from `complete_list` to `partial_list` in the split YAML, then import and re-export.

### Config won't import

```bash
ddev drush config:import --skip-config=system.site   # Skip specific locked config
ddev drush config:import --skip-modules=config_split  # Ignore splits
```

### Split not activating

```bash
ddev drush config-split:status
ddev drush config-split:activate {split-name}
ddev drush cex
```

## Intent → Command Mapping

| User Intent | Command |
|---|---|
| Preview config changes | `drush cim --no --diff` |
| Import config | `drush cim` |
| Export config | `drush cex` |

## Related Commands

**Read-only**: `config:get`, `config:status`
**Export**: `cex` / `config:export`
**Import**: `cim --no --diff` (preview), `cim` (apply)
**Splits**: `config-split:status`, `csex`, `csim`, `config-split:activate`

## Deep Dive

- **[full-guide.md](references/full-guide.md)** — Extended reference on Config Split 2.0, patch files, export/import internals
