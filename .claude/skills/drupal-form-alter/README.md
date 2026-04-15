# drupal-form-alter skill — Developer Notes

## When to use this skill

Use when working with:

- Altering existing Drupal forms (node forms, config forms, etc.)
- Using `#[Hook('form_alter')]` or `#[Hook('form_FORM_ID_alter')]`
- Targeting a specific form ID vs. all forms
- Modifying field properties (`#required`, `#access`, `#default_value`)
- Adding custom validate or submit handlers to existing forms
- Getting the form entity via `$form_state->getFormObject()->getEntity()`

## Mental Model

| Pattern | Use for |
|---|---|
| `form_FORM_ID_alter` | Single known form — preferred, more efficient |
| `form_alter` | Multiple forms or dynamic form IDs |
| `$form['field']['#access'] = FALSE` | Hide a field |
| `$form['#validate'][]` | Add validator |
| `$form['actions']['submit']['#submit'][]` | Add submit handler |

## Example Prompts

- Hide a field on the article node form
- Add a custom submit handler to an existing form
- Prepend a validation function to a node form
- Get the node entity being edited inside hook_form_alter

## Procedural (Legacy) Pattern

```php
// my_module.module

/**
 * Implements hook_form_FORM_ID_alter().
 */
function my_module_form_node_article_form_alter(array &$form, FormStateInterface $form_state, string $form_id): void {
  $form['#validate'][] = 'my_module_article_form_validate';
  $form['actions']['submit']['#submit'][] = 'my_module_article_form_submit';
}

function my_module_article_form_validate(array &$form, FormStateInterface $form_state): void {
  // Validate.
}

function my_module_article_form_submit(array &$form, FormStateInterface $form_state): void {
  // Submit logic.
}
```

## Source

[Form API — hook_form_alter](https://api.drupal.org/api/drupal/core!lib!Drupal!Core!Form!FormInterface.php/function/hook_form_alter/11)
