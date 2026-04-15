---
name: config-export
description: Export Drupal configuration with proper workflow
---

# Drupal Configuration Export

Safely export configuration changes with proper review.

**Usage:** `/config-export`

This command takes no arguments. It guides you through a safe configuration export workflow with review steps.

## Workflow

1. **Check current status**
   ```bash
   drush config:status
   ```

2. **Review what will be exported**
   Show the user what configurations have changed and let them confirm.

3. **Export configuration**
   ```bash
   drush config:export -y
   ```

4. **Review exported files**

   Base config (adjust path to match your project's config sync directory):
   ```bash
   git status config/sync/
   git diff config/sync/
   ```

   If your project uses `config_split` for environment overrides, also check those directories:
   ```bash
   # Only if config_split is configured — path varies by project (e.g. config/envs/, config/splits/)
   git status config/envs/
   git diff config/envs/
   ```

5. **Stage for commit**
   After user reviews, stage the relevant config changes:
   ```bash
   git add config/sync/
   # If env-specific config changed (config_split users only):
   git add config/envs/
   ```

## Important Notes

- Never auto-commit without user confirmation
- The config sync directory path (`config/sync/` by default) may differ per project — check `$settings['config_sync_directory']` in `settings.php` if unsure
- Environment override directories (e.g. `config/envs/`) only exist when `config_split` is in use — skip if not applicable
- Review UUIDs - they should match across environments
- Check for sensitive data in exported config
- Verify config schema exists for custom config
