---
name: drupal-javascript
description: Drupal JavaScript behaviors, libraries.yml, drupalSettings, attach_library(), and custom client-side AJAX commands using Drupal.AjaxCommands.prototype.
---

# Drupal JavaScript

## Defining a Library (*.libraries.yml)

```yaml
# my_module.libraries.yml
my-behavior:
  version: 1.0
  js:
    js/my-behavior.js: {}
  css:
    component:
      css/my-style.css: {}
  dependencies:
    - core/drupal
    - core/jquery
    - core/once
```

## Drupal Behavior Pattern

```javascript
// js/my-behavior.js
(function (Drupal, once) {
  'use strict';

  Drupal.behaviors.myBehavior = {
    attach(context, settings) {
      // Use `once` to prevent double-processing
      once('my-behavior', '.my-selector', context).forEach(function (element) {
        // Process element
        element.addEventListener('click', function (e) {
          e.preventDefault();
          // Handle click
        });
      });
    },
    detach(context, settings, trigger) {
      // Clean up if needed (e.g., 'unload' trigger)
    },
  };
}(Drupal, once));
```

## Attaching a Library in Twig

Attach a JavaScript/CSS library from a Twig template:

```twig
{{ attach_library('my_module/my-behavior') }}
```

## Accessing drupalSettings in JS

```javascript
Drupal.behaviors.myBehavior = {
  attach(context, settings) {
    const myKey = settings.myModule?.key;
    if (myKey) {
      console.log('Value:', myKey);
    }
  },
};
```

## AJAX Commands from PHP

```php
use Drupal\Core\Ajax\AjaxResponse;
use Drupal\Core\Ajax\ReplaceCommand;
use Drupal\Core\Ajax\InvokeCommand;
use Drupal\Core\Ajax\HtmlCommand;

$response = new AjaxResponse();
$response->addCommand(new ReplaceCommand('#wrapper', $build));
$response->addCommand(new HtmlCommand('#message', $this->t('Done!')));
$response->addCommand(new InvokeCommand('.my-class', 'addClass', ['active']));
return $response;
```

## Custom AJAX Command

```javascript
// Register command
Drupal.AjaxCommands.prototype.myCommand = function (ajax, response, status) {
  document.querySelector(response.selector).textContent = response.data;
};
```

```php
// PHP side
use Drupal\Core\Ajax\CommandInterface;

final class MyCommand implements CommandInterface {
  public function __construct(
    private readonly string $selector,
    private readonly string $data,
  ) {}

  public function render(): array {
    return [
      'command' => 'myCommand',
      'selector' => $this->selector,
      'data' => $this->data,
    ];
  }
}
```

## Custom Drupal AJAX Commands

Use this pattern when creating a custom AJAX command with:

- `Drupal.AjaxCommands.prototype`
- a matching PHP `CommandInterface` class
- a custom command name returned in the AJAX response

This is for defining new AJAX command types, not general form AJAX callbacks.
