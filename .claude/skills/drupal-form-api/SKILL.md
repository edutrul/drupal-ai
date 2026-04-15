---
name: drupal-form-api
description: Drupal Form API — building forms with FormBase/ConfigFormBase, form elements, validate/submit handlers, DI, and generating forms with Drush including routes.
---

# Drupal Form API

## Simple Form (FormBase)

```php
// src/Form/MyForm.php
namespace Drupal\my_module\Form;

use Drupal\Core\Form\FormBase;
use Drupal\Core\Form\FormStateInterface;
use Symfony\Component\DependencyInjection\ContainerInterface;

final class MyForm extends FormBase {

  public function __construct(
    private readonly EntityTypeManagerInterface $entityTypeManager,
  ) {}

  public static function create(ContainerInterface $container): static {
    return new static(
      $container->get('entity_type.manager'),
    );
  }

  public function getFormId(): string {
    return 'my_module_my_form';
  }

  public function buildForm(array $form, FormStateInterface $form_state): array {
    $form['name'] = [
      '#type' => 'textfield',
      '#title' => $this->t('Name'),
      '#required' => TRUE,
    ];
    $form['submit'] = [
      '#type' => 'submit',
      '#value' => $this->t('Submit'),
    ];
    return $form;
  }

  public function submitForm(array &$form, FormStateInterface $form_state): void {
    $name = $form_state->getValue('name');
    $this->messenger()->addStatus($this->t('Hello @name!', ['@name' => $name]));
  }

}
```

## Config Form (ConfigFormBase)

```php
final class MySettingsForm extends ConfigFormBase {

  protected function getEditableConfigNames(): array {
    return ['my_module.settings'];
  }

  public function getFormId(): string {
    return 'my_module_settings';
  }

  public function buildForm(array $form, FormStateInterface $form_state): array {
    $config = $this->config('my_module.settings');
    $form['enabled'] = [
      '#type' => 'checkbox',
      '#title' => $this->t('Enable feature'),
      '#default_value' => $config->get('enabled'),
    ];
    return parent::buildForm($form, $form_state);
  }

  public function submitForm(array &$form, FormStateInterface $form_state): void {
    $this->config('my_module.settings')
      ->set('enabled', $form_state->getValue('enabled'))
      ->save();
    parent::submitForm($form, $form_state);
  }

}
```

## Common Form Elements

| Type | Description |
|---|---|
| `textfield` | Single line text |
| `textarea` | Multi-line text |
| `select` | Dropdown |
| `checkboxes` | Multiple checkboxes |
| `radios` | Radio buttons |
| `checkbox` | Single checkbox |
| `number` | Numeric input |
| `email` | Email input |
| `managed_file` | Managed file upload |
| `entity_autocomplete` | Entity reference autocomplete |
| `date` | Date picker |
| `details` | Collapsible group |
| `container` | Non-visual wrapper |
| `hidden` | Hidden field |
| `submit` | Submit button |
