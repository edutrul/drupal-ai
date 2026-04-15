# drupal-drush skill — Developer Notes

## When to use this skill

Use when working with:

- Daily Drush commands (`cr`, `cex`, `cim`, `updb`, `ws`)
- Drush code generators (`drush generate module`, `service`, `controller`)
- Creating fields non-interactively with `drush field:create`
- Non-interactive generation with `--answers` JSON
- Managing users, state, and config via CLI
- Scaffolding modules and classes for AI-assisted development

## Mental Model

| Category | Commands |
|---|---|
| **Cache/Config** | `cr`, `cex -y`, `cim -y` |
| **Modules** | `en`, `pmu` |
| **Generate** | `generate module`, `generate service`, `generate controller` |
| **Fields** | `field:create node article --field-name=...` |
| **Logs** | `ws --severity=error --count=20` |
| **Users** | `user:login`, `user:create`, `user:role:add` |

## Example Prompts

- Generate a new service with Drush
- Use Drush to create a field on the article content type non-interactively.
- Use Drush to list all code generators available.
- Use Drush generate to scaffold a block plugin, then update it to use dependency injection.

## Sources

- [Drush Commands](https://www.drush.org/13.x/commands/)
- [Drush Code Generators](https://drupalize.me/tutorial/develop-drupal-modules-faster-drush-code-generators)
- [drush field:create](https://www.drush.org/13.x/commands/field_create/)
