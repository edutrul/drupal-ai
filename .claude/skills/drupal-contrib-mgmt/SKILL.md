---
name: drupal-contrib-mgmt
description: Drupal contrib module upgrade triage — Drupal.org issue queue research, local patch creation (git diff), composer-patches workflows, Drupal 11 compatibility via core_version_requirement, Drupal Lenient handling, and upgrade_status analysis. Not for generic Composer dependency management.
---

# Drupal Contrib Module Management

## Core Update Commands

```bash
composer require drupal/module_name --with-all-dependencies
composer require drupal/module_name:^3.0 --with-all-dependencies
drush updb -y && drush cr
```

## Checking Drupal 11 Compatibility

Fastest method — check `.info.yml`:
```bash
cat docroot/modules/contrib/MODULE_NAME/MODULE_NAME.info.yml | grep core_version_requirement
```

```yaml
core_version_requirement: ^9.5 || ^10 || ^11   # D11 compatible
core_version_requirement: ^9 || ^10              # Not D11 compatible
```

- `upgrade_status` warnings ≠ incompatible — module may still declare `^11` support
- "Check manually" status is often a false positive (runtime version checks)

## Drupal Lenient Plugin

For modules that haven't updated version requirements yet:

```json
{
  "require": { "mglaman/composer-drupal-lenient": "^1.0" },
  "config": { "allow-plugins": { "mglaman/composer-drupal-lenient": true } },
  "extra": {
    "drupal-lenient": { "allowed-list": ["drupal/module_name"] }
  }
}
```

## Patch Management (cweagans/composer-patches)

**IMPORTANT**: Use 2.x — uses `git apply` (reliable). Version 1.x uses `patch` binary (fragile).

```json
{
  "require": { "cweagans/composer-patches": "^2.0" },
  "config": { "allow-plugins": { "cweagans/composer-patches": true } },
  "extra": {
    "composer-exit-on-patch-failure": true,
    "patches": {
      "drupal/module_name": {
        "Description of patch - Issue #3552531": "patches/module-fix-3552531-2.patch"
      }
    }
  }
}
```

**2.x gotcha**: Hash-based caching — patches can silently go missing after reinstalls.

### Verifying Patches Are Applied

```bash
./scripts/verify-patches.sh        # Check all critical patches
./scripts/verify-patches.sh --fix  # Auto-reinstall affected modules
```

Adding a new patch to verification — edit `scripts/verify-patches.sh`:
```bash
CRITICAL_PATCHES=(
  "docroot/modules/contrib/MODULE:src/File.php:patternToFind:Description"
)
```

**When patches go missing**:
1. `./scripts/verify-patches.sh` to identify
2. `composer reinstall drupal/module_name` or `./scripts/verify-patches.sh --fix`
3. If still failing: `composer update --lock`

### Finding Patches — Search BEFORE Creating

**CRITICAL**: Always search drupal.org issue queue before writing a custom patch.

1. Extract exact error string: e.g. `"Unsupported operand types: array + null"`
2. Search: `https://www.drupal.org/project/drupal/issues?text=Unsupported+operand+types+array+null`
3. Look for RTBC (Reviewed & Tested by Community) issues with `.patch` attachments
4. Download to `patches/` and add to `composer.json`

**Patch naming**: `module-issue-NODEID-COMMENT.patch` (e.g. `audiofield-d11-3432063-12.patch`)

**When existing patch fails after update**:
- Extract node ID from filename → visit `drupal.org/node/NODEID` → find updated patch in latest comments

### Creating Local Patches

**Always patch from a separate clone of the contrib repo, not the installed vendor copy.**

```bash
cd ~/Sites && git clone git@git.drupal.org:project/module_name.git module_name-contrib
cd module_name-contrib && git checkout 1.0.3   # match installed version
# make changes...
git diff > ~/Sites/your-project/patches/module_name-custom-fix.patch
```

Then add to `composer.json` and run `composer reinstall drupal/module_name`.

### Patch Application

```bash
composer install                       # Install with patches
composer reinstall drupal/module_name  # Re-patch a single module
composer patches-repatch               # Re-patch all patched deps
```

## Drupal 11 Deprecation Quick Reference

| Deprecated | Replacement |
|---|---|
| `REQUEST_TIME` | `\Drupal::time()->getRequestTime()` |
| `user_roles()` | `\Drupal\user\Entity\Role::loadMultiple()` |
| `file_validate_extensions()` | `file.validator` service |
| `_drupal_flush_css_js()` | `AssetQueryStringInterface::reset()` |

## Upgrade Status Scan

```bash
drush upgrade_status:analyze --all
drush upgrade_status:analyze module1 module2
drush upgrade_status:analyze --all --ignore-contrib   # custom code only
```

## Troubleshooting

| Error | Solution |
|---|---|
| `Cannot apply patch` | Module version changed — find updated patch at `drupal.org/node/NODEID` |
| `requires drupal/core ^9` | Add to `drupal-lenient` allowed-list |
| `patch has already been applied` | Patch merged upstream — remove from composer.json |
| `drush updb` fails | Try uninstall → update → re-enable module |
