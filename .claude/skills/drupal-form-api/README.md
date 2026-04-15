# drupal-form-api skill — Developer Notes

## When to use this skill

Use when working with:

- Building custom forms with `FormBase` or `ConfigFormBase`
- Defining form elements (`textfield`, `select`, `checkboxes`, `managed_file`)
- Writing `buildForm()`, `validateForm()`, and `submitForm()` methods
- Injecting services into forms via `create()`
- Reading submitted values with `$form_state->getValue()`
- Generating form scaffolding with `drush generate form-simple`

## Mental Model

| Class | Use for |
|---|---|
| `FormBase` | General-purpose forms |
| `ConfigFormBase` | Admin settings forms that save config |
| `ConfirmFormBase` | Destructive action confirmation |

## Example Prompts

- Create a simple contact form with name and email fields
- Build an admin settings form that saves to config
- Generate a form with Drush including a route
- Add a select element with dynamic options to a form

## Generate with Drush

```bash
# Simple form
drush generate form-simple --answers='{
  "module": "my_module",
  "class": "MyForm",
  "form_id": "my_module_my_form",
  "route": "yes",
  "route_path": "/my-form",
  "route_title": "My Form",
  "route_permission": "access content",
  "link": "no"
}'

# Config form
drush generate form-config --answers='{
  "module": "my_module",
  "class": "SettingsForm",
  "form_id": "my_module_settings",
  "route": "yes",
  "route_path": "/admin/config/my-module",
  "route_title": "My Module Settings"
}'
```

## Source

[Form API Reference](https://www.drupal.org/docs/drupal-apis/form-api/introduction-to-form-api)
