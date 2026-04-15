# drupal-fields skill — Developer Notes

## When to use this skill

Use when working with:

- Creating fields on content types with `drush field:create`
- Choosing field types (`string`, `entity_reference`, `image`, `boolean`)
- Choosing field widgets and formatters
- Accessing field values in PHP (`->get('field_name')->value`)
- Creating custom field type, widget, or formatter plugins
- Exporting field config after CLI changes

## Mental Model

| Concept | Details |
|---|---|
| **Field type** | What data is stored (`string`, `integer`, `entity_reference`) |
| **Widget** | How data is entered (textfield, autocomplete, checkbox) |
| **Formatter** | How data is displayed (plain text, image style, label) |
| **Field storage** | `field.storage.{entity}.{field_name}.yml` |
| **Field config** | `field.field.{entity}.{bundle}.{field_name}.yml` |

## Example Prompts

- Create a text field on the article content type
- Add an entity reference field pointing to taxonomy terms
- Create an image field with multiple values
- Access all values of a multi-value field in PHP

## Field Types Reference

| Type | Description |
|---|---|
| `string` | Plain text (255 chars) |
| `string_long` | Long text (textarea) |
| `text_long` | Formatted text |
| `text_with_summary` | Body field with summary |
| `integer` | Whole numbers |
| `decimal` | Decimal numbers |
| `float` | Float numbers |
| `boolean` | Checkbox |
| `datetime` | Date/time |
| `email` | Email address |
| `link` | URL |
| `image` | Image upload |
| `file` | File upload |
| `entity_reference` | Reference to other entities |
| `list_string` | Select list |
| `telephone` | Phone number |

## Field Widgets Reference

| Widget | Use for |
|---|---|
| `string_textfield` | Single line text |
| `string_textarea` | Multi-line text |
| `text_textarea` | Formatted text |
| `text_textarea_with_summary` | Body with summary |
| `number` | Number input |
| `checkbox` | Single checkbox |
| `options_select` | Select dropdown |
| `options_buttons` | Radio/checkboxes |
| `datetime_default` | Date picker |
| `email_default` | Email input |
| `link_default` | URL input |
| `image_image` | Image upload |
| `file_generic` | File upload |
| `entity_reference_autocomplete` | Autocomplete reference |

## Sources

- [Field API](https://www.drupal.org/docs/drupal-apis/entity-api/fieldable-entity)
- [drush field:create](https://www.drush.org/13.x/commands/field_create/)
