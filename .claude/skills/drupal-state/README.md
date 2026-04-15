# drupal-state skill — Developer Notes

## When to use this skill

Use when working with:

- Storing runtime operational data that persists across requests
- Tracking cron run times, migration offsets, or feature flags
- Reading and writing state via `StateInterface`
- Inspecting or setting state values with `drush state:get/set`
- Deciding between State, Config, and Cache for a given use case

## Mental Model

| Storage | Use for | Exported? |
|---|---|---|
| **State** | Runtime ops data (cron times, counters, flags) | No |
| **Config** | User-managed settings | Yes (cex/cim) |
| **Cache** | Expensive computed data | No (temporary) |
| **UserData** | Per-user preferences | No |

> Key naming: always namespace — `my_module.key_name`.

## Example Prompts

- Store the last cron run timestamp using Drupal State API
- Track a migration offset using Drupal State API
- Read a value using Drupal State API with a default fallback
- Access taxonomy term entities from a reference field in Drupal Twig

## Sources

- [State API](https://www.drupal.org/docs/drupal-apis/state-api)
