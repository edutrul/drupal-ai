---
name: drupal-htmx
description: HTMX in Drupal 11.3+ core — the Htmx PHP fluent builder, dynamic forms with swapOob, partial routes with _htmx_route, response headers, and Drupal.behaviors integration. Use when building interactive UI without full-page reloads using Drupal's native HTMX support.
---

# Drupal HTMX

HTMX 2.0.4 ships in Drupal 11.3+ core as `core/htmx`. No contrib module needed.

## When to use HTMX vs AJAX Form API

| Scenario | Use |
|---|---|
| Form fields that update other fields | HTMX (`swapOob`) |
| Simple form submit with partial page update | HTMX or AJAX Form API |
| Complex multi-step AJAX with `AjaxResponse` commands | AJAX Form API |
| Non-form UI interactions (lazy load, infinite scroll, boost) | HTMX |
| Existing forms you're modifying | AJAX Form API (less disruption) |

## Attaching the Library

```yaml
# mymodule.libraries.yml
mymodule/htmx-feature:
  dependencies:
    - core/drupal.htmx
```

`core/drupal.htmx` includes: htmx vendor JS + Drupal behaviors bridge + asset loader + drupalSettings integration.

## The `Htmx` PHP Fluent Builder

```php
use Drupal\Core\Htmx\Htmx;
use Drupal\Core\Url;

$htmx = new Htmx();
$htmx->post($url)->target('#my-wrapper')->swap('outerHTML');
$htmx->applyTo($element);
```

`applyTo()` writes `data-hx-*` attributes directly onto the render array element. Pass `'#wrapper_attributes'` as second argument to target the wrapper div instead.

```php
$htmx->applyTo($form['field'], '#wrapper_attributes');
```

### Request Attributes

```php
$htmx->get(?Url $url)          // data-hx-get
$htmx->post(?Url $url)         // data-hx-post
$htmx->put(?Url $url)
$htmx->patch(?Url $url)
$htmx->delete(?Url $url)
$htmx->target('#selector')     // data-hx-target
$htmx->swap('outerHTML')       // data-hx-swap: innerHTML|outerHTML|beforebegin|afterbegin|beforeend|afterend|delete|none
$htmx->swapOob('true')         // data-hx-swap-oob: out-of-band swap
$htmx->select('css selector')  // data-hx-select: pick part of response
$htmx->selectOob(['#id:outerHTML']) // data-hx-select-oob
$htmx->trigger('click')        // data-hx-trigger
$htmx->vals(['key' => 'val'])  // data-hx-vals: extra POST values
$htmx->boost()                 // data-hx-boost: SPA-like link/form enhancement
$htmx->confirm('Are you sure?')
$htmx->on('click', 'alert()')  // data-hx-on:click
$htmx->pushUrl(true)           // data-hx-push-url
$htmx->onlyMainContent()       // adds data-hx-drupal-only-main-content (triggers HtmxRenderer)
```

### Response Headers (applied to render array, sent with response)

```php
$htmx->pushUrlHeader($url)                  // HX-Push-Url
$htmx->redirectHeader($url)                 // HX-Redirect
$htmx->triggerHeader('myEvent')             // HX-Trigger (also accepts array with data)
$htmx->triggerAfterSettleHeader('myEvent')  // HX-Trigger-After-Settle
$htmx->refreshHeader(true)                  // HX-Refresh
// Also: replaceUrlHeader, locationHeader, reswapHeader, retargetHeader, reselectHeader, triggerAfterSwapHeader
```

## Pattern: Dependent Selects (Dynamic Forms)

A select that updates another select without page reload. Each field posts to `<current>` with `swapOob` so both fields re-render out-of-band.

```php
public function buildForm(array $form, FormStateInterface $form_state, string $type = '', string $value = ''): array {
  $formUrl = Url::fromRoute('<current>');

  $form['type'] = [
    '#type' => 'select',
    '#options' => ['a' => 'A', 'b' => 'B'],
    '#default_value' => $type,
  ];
  (new Htmx())->post($formUrl)->swap('none')->swapOob('true')->applyTo($form['type']);

  $form['value'] = [
    '#type' => 'select',
    '#options' => $this->getOptionsFor($form_state->getValue('type', $type)),
    '#default_value' => $value,
  ];
  (new Htmx())->post($formUrl)->swap('none')->swapOob('true')->applyTo($form['value']);

  // Optionally push URL on change:
  $trigger = $form_state->getUserInput()['_triggering_element_name'] ?? FALSE;
  if ($trigger) {
    (new Htmx())->pushUrlHeader(Url::fromRoute('mymodule.form', [...]))->applyTo($form[$trigger]);
  }

  return $form;
}

public function submitForm(array &$form, FormStateInterface $form_state): void {}
```

## Pattern: Partial Route (`_htmx_route`)

A route that returns only its content fragment (no `<html>` shell). Use for controllers responding to HTMX `hx-get`/`hx-post` calls.

```yaml
# mymodule.routing.yml
mymodule.htmx_partial:
  path: '/htmx/content/{id}'
  defaults:
    _controller: '\Drupal\mymodule\Controller\HtmxController::content'
    _title: 'Content'
  options:
    _htmx_route: true   # Uses HtmxRenderer — returns HTML fragment only
  requirements:
    _permission: 'access content'
    id: '\d+'
```

```php
// Controller returns a render array normally — HtmxRenderer handles the rest.
public function content(int $id): array {
  $node = $this->entityTypeManager->getStorage('node')->load($id);
  return [
    '#theme' => 'mymodule_content_card',
    '#node' => $node,
    '#cache' => ['tags' => $node->getCacheTags()],
  ];
}
```

## Pattern: `onlyMainContent()` — Drupal Layout Bypass

Add `data-hx-drupal-only-main-content` to any HTMX element. The Drupal JS bridge automatically appends `?_wrapper_format=drupal_htmx` to the request, triggering `HtmxRenderer` (no page chrome, no blocks, no regions).

```php
$htmx = new Htmx();
$htmx->get($url)->onlyMainContent()->target('#content-area')->applyTo($element);
```

Alternatively add the attribute directly in Twig:

```twig
<a href="{{ path('mymodule.page') }}"
   data-hx-get="{{ path('mymodule.page') }}"
   data-hx-drupal-only-main-content
   data-hx-target="#content-area">
  Load content
</a>
```

## Pattern: Boost (SPA-like Navigation)

Apply `hx-boost` to a container and all links/forms inside become AJAX-driven, replacing `<body>` and updating `<title>`. Drupal's `Drupal.behaviors` re-attaches automatically on each swap.

```php
$form['#attributes']['data-hx-boost'] = 'true';
// or via Htmx builder:
(new Htmx())->boost()->applyTo($form);
```

## Pattern: Lazy Loading / Infinite Scroll

```twig
{# Load content when element scrolls into view #}
<div data-hx-get="{{ path('mymodule.more_items', {page: page}) }}"
     data-hx-trigger="revealed"
     data-hx-swap="outerHTML">
  <div class="loading-spinner">{{ 'Loading...'|t }}</div>
</div>
```

## Pattern: Confirm Before Action

```php
(new Htmx())
  ->delete(Url::fromRoute('mymodule.delete', ['id' => $id]))
  ->target('#item-' . $id)
  ->swap('outerHTML')
  ->confirm((string) $this->t('Delete this item?'))
  ->applyTo($form['delete_button']);
```

## Pattern: Trigger Custom JS Event from Response

```php
// In controller or form, trigger a JS event after swap:
(new Htmx())
  ->triggerAfterSettleHeader('mymodule:itemUpdated')
  ->applyTo($element);
```

```javascript
// In your Drupal behavior:
Drupal.behaviors.mymoduleListener = {
  attach(context) {
    context.addEventListener('mymodule:itemUpdated', (e) => {
      // React to HTMX-triggered event
    });
  }
};
```

## Drupal.behaviors Integration

No extra setup needed. The `core/drupal.htmx` library auto-wires:

- `htmx:drupal:load` → calls `Drupal.attachBehaviors()` on swapped content
- `htmx:drupal:unload` → calls `Drupal.detachBehaviors()` before swap

All existing JS behaviors work transparently on HTMX-injected content.

## drupalSettings in HTMX Responses

`drupalSettings` from HTMX responses is deep-merged into the current page's `drupalSettings` automatically by `htmx-utils.js`. No action needed.

## Detecting HTMX Requests in PHP

```php
use Symfony\Component\HttpFoundation\Request;

// Check if request is from HTMX
$isHtmx = $request->headers->has('HX-Request');
$trigger = $request->headers->get('HX-Trigger-Name'); // triggering element name
$currentUrl = $request->headers->get('HX-Current-URL');
```

## Cache Considerations

HTMX partial responses go through Drupal's render cache normally. Apply cache metadata as usual:

```php
return [
  '#theme' => 'mymodule_partial',
  '#cache' => [
    'tags' => ['node:' . $node->id()],
    'contexts' => ['url.query_args'],
    'max-age' => 0, // for frequently-changing content
  ],
];
```

`HtmxRenderer` adds the `rendered` cache tag and required cache contexts automatically.

## Twig — Attaching HTMX Attributes

```twig
{# Attach htmx library #}
{{ attach_library('mymodule/htmx-feature') }}

{# Render an element with htmx attributes (set via PHP Htmx builder) #}
{{ content.my_field }}

{# Or write attributes directly in Twig #}
<button data-hx-post="{{ path('mymodule.action') }}"
        data-hx-target="#result"
        data-hx-swap="innerHTML">
  {{ 'Submit'|t }}
</button>
```

Always use `data-hx-*` (not bare `hx-*`) — Drupal's implementation uses the data- prefix convention.

## Routing for Forms with HTMX

Route parameters from the URL are passed to `buildForm()` as extra arguments:

```yaml
mymodule.form:
  path: '/mymodule/form/{type}/{value}'
  defaults:
    _form: '\Drupal\mymodule\Form\DependentSelectForm'
    _title: 'My Form'
    type: ''
    value: ''
  requirements:
    _permission: 'access content'
```

```php
public function buildForm(array $form, FormStateInterface $form_state, string $type = '', string $value = ''): array {
```

## Common Mistakes

**Missing library:** HTMX attributes render as static HTML without `core/drupal.htmx` attached. Always attach in `libraries.yml` or `#attached`.

**Using bare `hx-*`:** Drupal uses `data-hx-*`. The `Htmx` builder adds the `data-` prefix automatically. In Twig, write `data-hx-get` not `hx-get`.

**Forgetting `swap('none')` on oob triggers:** When using `swapOob`, the trigger element itself also gets swapped unless you set `swap('none')`.

**CSRF on POST:** Drupal's Form API handles CSRF tokens. For non-form HTMX POSTs to controllers, add the route requirement `_csrf_token: 'TRUE'` and append `?token={{ drupal_csrf_token(...) }}` to the URL.

**Raw markup for target placeholders:** Never use `#markup` to render a standalone HTMX target div — it bypasses Drupal's render pipeline. Use `#type => 'html_tag'` with `#attributes` instead:

```php
// Bad
'target' => ['#markup' => '<div id="greeting-target"></div>'],

// Good
'target' => [
  '#type' => 'html_tag',
  '#tag' => 'div',
  '#value' => '',
  '#attributes' => ['id' => 'greeting-target'],
],
```

If the target can be the wrapper of an existing render element, skip the separate div and use `applyTo()` with `'#wrapper_attributes'` plus an `#attributes['id']` on that element instead.
