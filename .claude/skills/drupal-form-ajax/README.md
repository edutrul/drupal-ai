# drupal-form-ajax skill — Developer Notes

## When to use this skill

Use when working with:

- Adding `#ajax` to a form element to trigger partial page updates
- Writing AJAX callback methods that return updated form parts
- Using `AjaxResponse` with commands (`ReplaceCommand`, `HtmlCommand`)
- Rebuilding a form dynamically based on user input
- Triggering form rebuild with `$form_state->setRebuild(TRUE)`

## Mental Model

| Pattern | When to use |
|---|---|
| Return form element | Simple wrapper replacement — just return `$form['wrapper']` |
| `AjaxResponse` + commands | Multiple DOM updates, messages, or JS invocations |
| `setRebuild(TRUE)` | Rebuild the whole form after AJAX interaction |
| `#ajax['wrapper']` | DOM ID of the element to replace |

## Example Prompts

- Update a select list when another field changes via AJAX
- Return an AjaxResponse with a status message
- Rebuild a form dynamically based on a dropdown selection
- Show/hide a field using AJAX without a full page reload

## Sources

- [AJAX Forms in Drupal](https://www.drupal.org/docs/drupal-apis/ajax-api/basic-concepts)
- [Ajax API Reference](https://api.drupal.org/api/drupal/core!core.api.php/group/ajax/11)
