# drupal-htmx skill — Developer Notes

## When to use this skill

Use when working with:

- Making form fields update other fields without a full page reload
- Building partial routes that return HTML fragments (not full pages)
- Applying the `Htmx` PHP fluent builder to render arrays
- Using `_htmx_route: true` in `routing.yml` for HTMX-only endpoints
- Triggering browser URL updates from HTMX responses (`pushUrlHeader`)
- Lazy-loading content as the user scrolls (`hx-trigger="revealed"`)
- Sending custom JS events from server responses (`triggerAfterSettleHeader`)
- Deciding between HTMX and the classic AJAX Form API

## Mental Model

| Concept | What it means |
|---|---|
| `core/drupal.htmx` | The library to attach — includes htmx vendor + Drupal bridge |
| `Htmx` class | PHP fluent builder that writes `data-hx-*` attributes onto render arrays |
| `applyTo($element)` | Writes the built attributes onto the element's `#attributes` |
| `applyTo($el, '#wrapper_attributes')` | Targets the wrapper div instead |
| `swap('none') + swapOob('true')` | Key combo for dependent selects — don't replace trigger, replace elsewhere |
| `_htmx_route: true` | Route option that uses `HtmxRenderer` — returns fragment only, no page shell |
| `onlyMainContent()` | Adds `data-hx-drupal-only-main-content` — JS bridge appends `?_wrapper_format=drupal_htmx` |
| Response headers | Set on the render array via `$htmx->pushUrlHeader()` etc., sent with the response |
| `Drupal.behaviors` | Auto-attached/detached on every HTMX swap — no extra wiring needed |

## HTMX vs AJAX Form API

| Scenario | Recommended |
|---|---|
| Dependent selects / cascading dropdowns | HTMX |
| Non-form UI (lazy load, infinite scroll, boost) | HTMX |
| Complex multi-step AJAX with many DOM commands | AJAX Form API |
| Existing forms you're lightly modifying | AJAX Form API |
| Need `AjaxResponse` commands (InvokeCommand, etc.) | AJAX Form API |

## Available in Drupal since

HTMX 2.0.4 landed in **Drupal 11.3.0** as a core library. No contrib module required. Check with `ddev drush core:status` that the site runs 11.3+.

## Example Prompts

- Build a form where selecting a category updates the subcategory dropdown using HTMX
- Create a route that returns a content card fragment for HTMX to swap in
- Lazy-load a list of nodes when the user scrolls to the bottom of the page
- Push a new browser URL after the user makes a selection in an HTMX form
- Trigger a custom JS event from a Drupal controller after an HTMX swap
- Add a delete button that asks for confirmation before sending an HTMX DELETE request

## Sources

- [`web/core/lib/Drupal/Core/Htmx/Htmx.php`](https://git.drupalcode.org/project/drupal/-/blob/11.x/core/lib/Drupal/Core/Htmx/Htmx.php) — the PHP API
- [`web/core/misc/htmx/`](https://git.drupalcode.org/project/drupal/-/tree/11.x/core/misc/htmx) — JS integration layer
- [`web/core/modules/system/tests/modules/test_htmx/`](https://git.drupalcode.org/project/drupal/-/tree/11.x/core/modules/system/tests/modules/test_htmx) — official usage examples in core
- [HTMX Reference](https://htmx.org/reference/)
- [Drupal change record: HTMX in core](https://www.drupal.org/node/3494912)
