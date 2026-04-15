# drupal-hooks skill — Developer Notes

## When to use this skill

Use when working with:

- `hook_form_alter` or `hook_form_FORM_ID_alter`
- `hook_node_presave` or other entity hooks
- `hook_theme`
- `#[Hook]` attribute (OOP hooks)
- procedural hooks in `.module` files
- deciding between a hook and an event subscriber

## Mental Model

| Pattern | Location | Registration |
|---|---|---|
| Procedural | `my_module.module` | Auto |
| OOP Hook | `src/Hook/` | Auto (Drupal 11.1+) |
| Hook in service | `src/Service/` or anywhere | Manual (`services.yml`) |

## Example Prompts

- Create a hook_form_alter in Drupal 11 for the custom module
- Add an OOP node_presave hook in Drupal 11 to set a field value
- Convert a Drupal procedural hook_form_alter to an OOP hook using #[Hook] of custom module
- Create an OOP hook_theme in Drupal 11 using #[Hook] to define a custom Twig template

## Source

[Drupal.org — OOP Hooks (Drupal 11)](https://www.drupal.org/node/3442349)
