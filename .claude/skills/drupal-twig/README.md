# drupal-twig skill — Developer Notes

## When to use this skill

Use when working with:

- Creating or modifying Twig templates for nodes, blocks, paragraphs, fields
- Using `{% trans %}` for translatable strings in templates
- Attaching libraries with `{{ attach_library() }}`
- Debugging with `{{ dump() }}` and Twig debug HTML comments
- Using SDC (Single Directory Components) in templates
- Adding template suggestions via `hook_theme_suggestions_*_alter`
- Understanding Twig auto-escaping and when to use `|raw`

## Mental Model

| Template naming | Pattern |
|---|---|
| Node | `node--TYPE--VIEW-MODE.html.twig` |
| Block | `block--BLOCK-ID.html.twig` |
| Paragraph | `paragraph--TYPE.html.twig` |
| Field | `field--FIELD-NAME.html.twig` |
| Page | `page--PATH.html.twig` |

| Output | Auto-escaped? |
|---|---|
| `{{ variable }}` | Yes — safe |
| `{{ variable\|raw }}` | No — only for trusted HTML |
| `{{ content.body }}` | Yes — already sanitized by Drupal |

## Example Prompts

- Create a Drupal Twig node template for article teaser view mode
- Add a translatable string with a variable in Twig
- Debug which template is being used for a block
- Use an SDC component in a template
- How do I add a custom Twig template suggestion for a view mode in Drupal?

## Enabling Twig Debug

Add to `services.yml` (local dev only — never commit with cache disabled):

```yaml
parameters:
  twig.config:
    debug: true
    auto_reload: true
    cache: false
```

## Template Naming — Full Reference

| Entity | Template | Example |
|---|---|---|
| Node | `node--TYPE--VIEW-MODE.html.twig` | `node--article--teaser.html.twig` |
| Block | `block--BLOCK-ID.html.twig` | `block--my-module-my-block.html.twig` |
| Paragraph | `paragraph--TYPE.html.twig` | `paragraph--text-block.html.twig` |
| Page | `page--PATH.html.twig` | `page--node--article.html.twig` |
| Field | `field--FIELD-NAME.html.twig` | `field--field-image.html.twig` |

## Sources

- [Twig in Drupal](https://www.drupal.org/docs/theming-drupal/twig-in-drupal)
- [SDC Components](https://www.drupal.org/docs/develop/theming-drupal/using-single-directory-components)
