# drupal-javascript skill — Developer Notes

## When to use this skill

Use when working with:

- Defining JS libraries in `*.libraries.yml`
- Writing Drupal behavior patterns (`Drupal.behaviors.myBehavior`)
- Using `once()` to prevent double-initialization
- Passing PHP data to JavaScript via `drupalSettings`
- Attaching libraries to render arrays or Twig templates
- Creating custom AJAX commands (PHP + JS pair)

## Mental Model

| Concept | Details |
|---|---|
| **Library** | Defined in `*.libraries.yml`, attached via PHP or Twig |
| **Behavior** | `Drupal.behaviors.name = { attach(context, settings) {} }` |
| **`once()`** | Prevents double-processing on AJAX-loaded content |
| **drupalSettings** | `$build['#attached']['drupalSettings']['ns']['key']` |
| **AJAX commands** | PHP `AjaxResponse` + matching JS `Drupal.AjaxCommands.prototype` |

## Example Prompts

- Create a Drupal behavior that initializes a slider
- Pass a PHP value to JavaScript via drupalSettings
- Load a JavaScript library in Twig
- Register a custom AJAX command in JavaScript and return it from PHP

## Library Conditions (conditional loading)

```yaml
# Load only if a module is installed
my-conditional:
  js:
    js/conditional.js: {}
  dependencies:
    - core/drupal
```

```php
// Load conditionally in PHP
if ($this->moduleHandler->moduleExists('views')) {
  $build['#attached']['library'][] = 'my_module/views-integration';
}
```

## Sources

- [JavaScript API](https://www.drupal.org/docs/develop/standards/javascript)
- [Libraries API](https://www.drupal.org/docs/develop/creating-modules/adding-stylesheets-css-and-javascript-js-to-a-drupal-module)
- [AJAX API](https://www.drupal.org/docs/drupal-apis/ajax-api)
