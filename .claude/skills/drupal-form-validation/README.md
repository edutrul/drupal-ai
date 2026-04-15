# drupal-form-validation skill — Developer Notes

## When to use this skill

Use when working with:

- Writing `validateForm()` methods on `FormBase`
- Using `$form_state->setErrorByName()` or `setError()`
- Attaching `#element_validate` callbacks to specific elements
- Conditional validation (validate field B only when field A has a value)
- Adding validators to existing forms via `hook_form_alter`
- Accessing nested values with `$form_state->getValue([...])`

## Mental Model

| Method | Use for |
|---|---|
| `setErrorByName('field_name', ...)` | Target a field by name key |
| `setError($form['field'], ...)` | Target a specific render element |
| `#element_validate` | Per-element validator, reusable |
| `$form['#validate'][]` | Add validator to entire form |

## Example Prompts

- Add Drupal form validation to ensure a date field is in the future
- Add validation to prevent duplicate emails in a Drupal form
- Add conditional validation in Drupal form to require URL when type is external
- Drupal form validation: add $form['#validate'][] in hook_form_alter for a node form

## Sources

- [Form Validation](https://www.drupal.org/docs/drupal-apis/form-api/basic-form-api)
