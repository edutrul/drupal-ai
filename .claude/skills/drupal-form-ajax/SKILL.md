---
name: drupal-form-ajax
description: Drupal AJAX form callbacks, #ajax properties, AjaxResponse commands, and dynamic form rebuilding.
---

# Drupal AJAX Forms

## AJAX Callback Pattern

```php
public function buildForm(array $form, FormStateInterface $form_state): array {
  $form['type'] = [
    '#type' => 'select',
    '#title' => $this->t('Type'),
    '#options' => ['a' => 'Type A', 'b' => 'Type B'],
    '#ajax' => [
      'callback' => '::updateOptions',
      'wrapper' => 'options-wrapper',
      'event' => 'change',
    ],
  ];

  $form['options_wrapper'] = [
    '#type' => 'container',
    '#attributes' => ['id' => 'options-wrapper'],
  ];

  $type = $form_state->getValue('type', 'a');
  $form['options_wrapper']['value'] = [
    '#type' => 'textfield',
    '#title' => $this->t('Value for @type', ['@type' => $type]),
  ];

  return $form;
}

public function updateOptions(array &$form, FormStateInterface $form_state): array {
  return $form['options_wrapper'];
}
```

## AjaxResponse with Commands

```php
use Drupal\Core\Ajax\AjaxResponse;
use Drupal\Core\Ajax\ReplaceCommand;
use Drupal\Core\Ajax\HtmlCommand;
use Drupal\Core\Ajax\InvokeCommand;
use Drupal\Core\Ajax\MessageCommand;

public function ajaxCallback(array &$form, FormStateInterface $form_state): AjaxResponse {
  $response = new AjaxResponse();
  $response->addCommand(new ReplaceCommand('#my-wrapper', $form['my_element']));
  $response->addCommand(new HtmlCommand('#message', $this->t('Updated!')));
  $response->addCommand(new InvokeCommand('#my-input', 'val', ['new value']));
  $response->addCommand(new MessageCommand($this->t('Success!'), NULL, ['type' => 'status']));
  return $response;
}
```

## #ajax Properties

```php
'#ajax' => [
  'callback' => '::myCallback',   // Method or [ClassName, 'method']
  'wrapper' => 'wrapper-id',      // DOM ID to replace/update
  'event' => 'change',            // JS event (change, click, blur, etc.)
  'method' => 'replaceWith',      // replaceWith, append, prepend, etc.
  'effect' => 'fade',             // none, slide, fade
  'progress' => [
    'type' => 'throbber',         // throbber or bar
    'message' => NULL,
  ],
  'url' => NULL,                  // Custom URL (leave NULL for default)
  'options' => [],                // Additional jQuery.ajax options
],
```

## Trigger Form Rebuild

```php
public function submitForm(array &$form, FormStateInterface $form_state): void {
  $form_state->setRebuild(TRUE);
}
```

