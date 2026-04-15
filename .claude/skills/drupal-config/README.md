# drupal-config skill — Developer Notes

## When to use this skill

Use when working with:

- Importing or exporting configuration (`cim`, `cex`)
- Config splits — complete vs. partial, environment-specific overrides
- Syncing config from production or staging environments
- Safe inspection of config without accidentally importing
- Troubleshooting config deleted from `config/sync/` on export
- `config-split:activate`, `csex`, `csim` commands

## Mental Model

| Concept | What it means |
|---|---|
| **Complete split** | Config exists ONLY in that environment (modules on/off) |
| **Partial split** | Config exists everywhere, different VALUES per environment |
| **`config/sync/`** | Base config shared across all environments |
| **`config/{env}/`** | Environment-specific overrides |

## Example Prompts

- Show me the preview of the config import, but don't accept the import changes.
- Set up a local config split for devel module
- Sync config from production while preserving local changes
- Why is my config being deleted from config/sync on export?

## Preferred Prod Config Merge Workflow

Use when pulling production DB while preserving local feature work.

**Step 1: Commit local changes first**

Examples assume a `docroot/`-based Drupal project. If your project uses `web/` or another document root, adjust paths accordingly.

```bash
git add config/sync/your-new-field.yml docroot/modules/custom/your_module/your_module.module
git commit -m "feat: add new feature"
```

**Step 2: Pull production database**
```bash
ddev pull --environment=live
```

**Step 3: Export config from prod DB**
```bash
ddev drush config:export -y
```

**Step 4: Review git diff on config directory**
```bash
git diff --stat config/
git status --short config/
```

**Step 5: Identify files to revert vs keep**

| git status | Meaning | Action |
|---|---|---|
| `D config/sync/field.*.your_feature.yml` | Your new feature deleted | `git checkout HEAD -- <file>` |
| `M config/sync/*.yml` (UUID only) | Prod UUID sync | Keep |
| `M config/sync/views.view.*.yml` | View changed in prod | Keep (review first) |

**Step 6: Restore your local feature files**
```bash
git checkout HEAD -- config/sync/field.storage.node.your_new_field.yml
git checkout HEAD -- config/sync/field.field.node.bundle.your_new_field.yml
```

**Step 7: Verify and commit prod config**
```bash
git status --short config/
git diff config/
git add config/ && git commit -m "chore: sync config from production"
```

### Example Session

```bash
$ git status --short config/
 M config/sync/core.entity_view_display.node.article.teaser.yml
 D config/sync/field.field.node.article.field_summary.yml
 D config/sync/field.storage.node.field_summary.yml
 M config/sync/views.view.content.yml

# Restore deleted feature files
$ git checkout HEAD -- config/sync/field.field.node.article.field_summary.yml \
                       config/sync/field.storage.node.field_summary.yml

$ git add config/ && git commit -m "chore: sync config from production"
```

## Syncing Config from Upstream Environments

**Single config object**:
```bash
ssh user@remote "drush config:get config.name --format=yaml" > config/sync/config.name.yml
git add config/sync/config.name.yml && git commit -m "Update from {env}"
ddev drush config:import --partial
```

**Via database pull** (DDEV):
```bash
ddev pull --environment={env}
ddev drush cex
git diff config/ && git add config/ && git commit -m "Config from {env}"
```

## Best Practices

1. Always inspect before importing — use `config:get` and `--no --diff`
2. Edit config files directly for precision
3. One config type per commit — separate concerns for clean history
4. Reference source environment in commit messages
5. Test locally before deploying
6. Use config splits to keep environment-specific config separate

## Source

- [Configuration management](https://www.drupal.org/docs/configuration-management)
- [Config Split module](https://www.drupal.org/project/config_split)
