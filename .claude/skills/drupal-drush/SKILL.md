---
name: drupal-drush
description: Drush commands for Drupal — cache, config, module management, generators, field creation, and non-interactive scaffolding for AI-assisted development.
---

# Drush Commands

## Essential Daily Commands

```bash
drush cr                      # Clear all caches
drush cex -y                  # Export configuration
drush cim -y                  # Import configuration
drush updb -y                 # Run database updates
drush en module_name          # Enable a module
drush pmu module_name         # Uninstall a module
drush ws --severity=error     # Watch error logs
drush ws --severity=error --count=20  # Last 20 errors
drush php:eval "code"         # Run PHP inline
drush sql:dump > dump.sql     # Database dump
```

## Code Generators

```bash
drush generate              # List all generators
drush gen module            # Generate module (gen is alias)
drush generate controller
drush generate form-simple
drush generate form-config
drush generate service
drush generate plugin:block
drush generate plugin:field:formatter
drush generate plugin:field:widget
drush generate plugin:field:type
drush generate event-subscriber
drush generate hook
drush generate entity:content
drush generate entity:configuration
drush generate test:unit
drush generate test:kernel
drush generate test:browser
drush generate drush:command-file
```

## Non-Interactive Generation (--answers JSON)

```bash
# Generate module
drush generate module --answers='{
  "name": "My Module",
  "machine_name": "my_module",
  "description": "A custom module",
  "package": "Custom",
  "dependencies": "",
  "install_file": "no",
  "libraries": "no",
  "permissions": "no",
  "event_subscriber": "no",
  "block_plugin": "no",
  "controller": "no",
  "settings_form": "no"
}'

# Generate service
drush generate service --answers='{
  "module": "my_module",
  "service_name": "my_module.helper",
  "class": "HelperService",
  "services": ["entity_type.manager", "logger.factory"]
}'
```

## Field Management

```bash
# Create field (interactive)
drush field:create

# Create field (non-interactive)
drush field:create node article \
  --field-name=field_subtitle \
  --field-label="Subtitle" \
  --field-type=string \
  --field-widget=string_textfield \
  --is-required=0 \
  --cardinality=1

# List fields
drush field:info node article

# Field types/widgets/formatters
drush field:types
drush field:widgets
drush field:formatters

# Delete field
drush field:delete node.article.field_subtitle
```

## Discover Generator Prompts

```bash
# Preview what answers are needed
drush generate module -vvv --dry-run

# Accept all defaults
drush generate module -y
```

## State & Config via CLI

```bash
# State
drush state:get my_module.last_run
drush state:set my_module.feature_enabled 1
drush state:del my_module.last_run

# Config
drush config:get my_module.settings
drush config:set my_module.settings enabled 1
drush config:edit my_module.settings
```

## User Management

```bash
drush user:create testuser --mail="test@example.com" --password="password"
drush user:login                        # One-time login for uid 1
drush user:login --uid=2               # One-time login for uid 2
drush user:role:add editor testuser
drush user:block testuser
drush user:unblock testuser
```

## DDEV Wrapper

```bash
ddev drush cr
ddev drush cex -y
ddev drush generate module --answers='{...}'
ddev drush field:create node article
```

## Debugging Generated Code

Examples assume a `docroot/`-based Drupal project. If your project uses `web/` or another document root, adjust paths accordingly.

```bash
# Syntax check
ddev exec php -l docroot/modules/custom/my_module/src/MyClass.php

# Check service registration
ddev drush devel:services | grep my_module

# Verify class autoloaded
ddev drush php:eval "class_exists('Drupal\my_module\MyClass') ? print 'Found' : print 'Not found';"
```
