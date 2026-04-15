# drupal-paragraphs skill — Developer Notes

## When to use this skill

Use when working with:

- Accessing paragraph entities from a node field
- Creating or appending paragraphs programmatically
- Altering paragraph form elements via `hook_field_widget_single_element_paragraphs_form_alter`
- Rendering paragraphs programmatically with a view builder
- Iterating paragraph bundles and accessing their fields
- Theming paragraphs with Twig templates

## Mental Model

| Operation | Pattern |
|---|---|
| Get paragraphs | `$node->get('field_content')->referencedEntities()` |
| Get first | `$node->get('field_content')->first()?->entity` |
| Create & attach | `Paragraph::create([...])->save()` then `appendItem()` |
| Render | `$viewBuilder->view($paragraph, 'default')` |
| Bundle check | `$paragraph->bundle()` |

## Example Prompts

- Loop through paragraphs on a node and get field values
- Create a Drupal paragraph entity of bundle text_block and attach it to a node
- Use Drupal Paragraphs hook_field_widget_single_element_paragraphs_form_alter to modify a paragraph bundle form
- Render a paragraph entity in a custom template

## Sources

- [Paragraphs module](https://www.drupal.org/project/paragraphs)
- [Paragraphs API](https://www.drupal.org/docs/contributed-modules/paragraphs)
