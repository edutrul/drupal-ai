---
name: drupal-form-validation
description: Drupal form validation — validateForm(), #element_validate, setError(), setErrorByName(), conditional validation (require fields based on other values), and custom validators.
---

# Drupal Form Validation

## validateForm() Method

```php
public function validateForm(array &$form, FormStateInterface $form_state): void {
  $name = $form_state->getValue('name');

  if (strlen($name) < 3) {
    $form_state->setErrorByName('name', $this->t('Name must be at least 3 characters.'));
  }

  if (!preg_match('/^[a-zA-Z\s]+$/', $name)) {
    $form_state->setErrorByName('name', $this->t('Name may only contain letters and spaces.'));
  }
}
```

## setError vs setErrorByName

```php
// Target a specific form element by name
$form_state->setErrorByName('field_date', $this->t('Invalid date.'));

// Target a nested element
$form_state->setErrorByName('field_date][0][value', $this->t('Invalid date.'));

// Target a specific render element directly
$form_state->setError($form['field_date'], $this->t('Invalid date.'));
```

## #element_validate

Attach a validator directly to an element:

```php
$form['email'] = [
  '#type' => 'email',
  '#title' => $this->t('Email'),
  '#element_validate' => [
    [static::class, 'validateUniqueEmail'],
  ],
];

public static function validateUniqueEmail(array &$element, FormStateInterface $form_state, array &$form): void {
  $email = $element['#value'];
  // Check uniqueness...
  if ($emailExists) {
    $form_state->setError($element, t('This email is already registered.'));
  }
}
```

## Conditional Validation

```php
public function validateForm(array &$form, FormStateInterface $form_state): void {
  $type = $form_state->getValue('type');

  if ($type === 'external') {
    $url = $form_state->getValue('url');
    if (empty($url)) {
      $form_state->setErrorByName('url', $this->t('URL is required for external type.'));
    }
    elseif (!UrlHelper::isValid($url, TRUE)) {
      $form_state->setErrorByName('url', $this->t('Please enter a valid URL.'));
    }
  }
}
```

## Accessing Values in Validation

```php
// Get a single value
$value = $form_state->getValue('my_field');

// Get nested value
$value = $form_state->getValue(['field_date', 0, 'value']);

// Get all values
$values = $form_state->getValues();

// Check if field has errors
if ($form_state->getError($form['my_field'])) { ... }
```

## Adding Validation via hook_form_alter

```php
#[Hook('form_node_article_form_alter')]
public function formNodeArticleFormAlter(array &$form, FormStateInterface $form_state): void {
  // Add before existing validators
  array_unshift($form['#validate'], [static::class, 'validateArticle']);

  // Add after existing validators
  $form['#validate'][] = [static::class, 'validateArticle'];
}

public static function validateArticle(array &$form, FormStateInterface $form_state): void {
  // Validation logic here.
}
```

