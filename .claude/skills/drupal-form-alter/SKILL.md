---
name: drupal-form-alter
description: Drupal form alter patterns — hook_form_alter, hook_form_FORM_ID_alter, OOP hooks, hiding fields with access, changing required/default values, and adding validate or submit handlers.

---

# Drupal Form Alter

## OOP Hook (Drupal 10.3+ / 11)

```php
// src/Hook/MyModuleHooks.php
namespace Drupal\my_module\Hook;

use Drupal\Core\Hook\Attribute\Hook;
use Drupal\Core\Form\FormStateInterface;

final class MyModuleHooks {

  #[Hook('form_alter')]
  public function formAlter(array &$form, FormStateInterface $form_state, string $form_id): void {
    if ($form_id === 'node_article_form' || $form_id === 'node_article_edit_form') {
      // Alter the article node form.
      $form['title']['#description'] = t('Enter a descriptive title.');
    }
  }

  // Target a specific form more efficiently
  #[Hook('form_node_article_form_alter')]
  public function formNodeArticleFormAlter(array &$form, FormStateInterface $form_state): void {
    $form['#validate'][] = [MyModuleHooks::class, 'validateArticleForm'];
    $form['actions']['submit']['#submit'][] = [MyModuleHooks::class, 'submitArticleForm'];
  }

}
```

## Common Alterations

```php
// Make a field required
$form['field_subtitle']['widget'][0]['value']['#required'] = TRUE;

// Add a field default value
$form['field_subtitle']['widget'][0]['value']['#default_value'] = 'Default';

// Hide a field
$form['field_internal']['#access'] = FALSE;

// Add a CSS class
$form['#attributes']['class'][] = 'my-custom-form';

// Change submit button label
$form['actions']['submit']['#value'] = t('Save Article');

// Add a custom submit handler (runs AFTER default)
$form['actions']['submit']['#submit'][] = '::mySubmitHandler';

// Prepend a custom validate handler
array_unshift($form['#validate'], '::myValidateHandler');
```

## Get Form Object

```php
$form_object = $form_state->getFormObject();
if ($form_object instanceof NodeForm) {
  $node = $form_object->getEntity();
}
```
