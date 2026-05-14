# Drupal Rules

- Prefer DI; avoid `\Drupal::service()` in classes.
- Follow existing module/namespace conventions.
- Prefer placing code in an existing relevant module over creating a new one.
- Use appropriate Drupal patterns and skills/reference material.

## Hooks

- Always implement hooks using the `drupal-hooks` skill.
- Never use procedural hooks in `.module` files.
