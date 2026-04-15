# drupal-debugging skill — Developer Notes

## When to use this skill

Use when working with:

- Reading Drupal error logs with `drush ws`
- Inspecting variables with `drush php:eval`
- Enabling Twig debug mode for template troubleshooting
- Using Devel module (`dpm()`, `ksm()`, `dvm()`)
- Debugging cache issues or checking cache headers
- Listing services or checking service container state
- Enabling and configuring Xdebug with DDEV

## Mental Model

| Tool | Best for |
|---|---|
| `ddev drush ws` | PHP errors, watchdog logs |
| `ddev drush php:eval` | Inspect config, services, entities inline |
| Twig debug | Finding template suggestions, dumping variables |
| Devel `dpm()` | Visual variable inspection in messages area |
| Xdebug | Step-through debugging in PHPStorm/VS Code |

## Example Prompts

- How do I see PHP errors in Drupal?
- Debug a node entity by inspecting its fields using drush php:eval from the CLI.
- Enable Twig debug to find which template is used
- Debug why a service is not being found

## Sources

- [Debugging in Drupal](https://www.drupal.org/docs/develop/development-tools/debugging-php-slow-queries-in-drupal-11)
- [Devel module](https://www.drupal.org/project/devel)
- [Twig debugging](https://www.drupal.org/docs/theming-drupal/twig-in-drupal/debugging-twig-templates)
