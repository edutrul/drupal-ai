---
name: drupal-plugins
description: Drupal plugin system — Block, Field, Condition, Filter plugins with PHP attributes and ContainerFactoryPluginInterface.
---

# Drupal Plugins (Drupal 11)

## Example (Best Practice)

```php
// src/Plugin/Block/MyBlock.php
namespace Drupal\my_module\Plugin\Block;

use Drupal\Core\Block\Attribute\Block;
use Drupal\Core\Block\BlockBase;
use Drupal\Core\Plugin\ContainerFactoryPluginInterface;
use Drupal\Core\StringTranslation\StringTranslationTrait;
use Drupal\Core\StringTranslation\TranslatableMarkup;
use Drupal\Core\Entity\EntityTypeManagerInterface;
use Symfony\Component\DependencyInjection\ContainerInterface;

#[Block(
  id: 'my_block',
  admin_label: new TranslatableMarkup('My Block'),
  category: new TranslatableMarkup('Custom'),
)]
final class MyBlock extends BlockBase implements ContainerFactoryPluginInterface {

  use StringTranslationTrait;

  public function __construct(
    array $configuration,
    string $plugin_id,
    mixed $plugin_definition,
    private readonly EntityTypeManagerInterface $entityTypeManager,
  ) {
    parent::__construct($configuration, $plugin_id, $plugin_definition);
  }

  public static function create(ContainerInterface $container, array $configuration, $plugin_id, $plugin_definition): static {
    return new static(
      $configuration,
      $plugin_id,
      $plugin_definition,
      $container->get('entity_type.manager'),
    );
  }

  public function build(): array {
    return [
      '#markup' => $this->t('Hello from my block.'),
      '#cache' => [
        'tags' => ['node_list'],
        'contexts' => ['user.permissions'],
      ],
    ];
  }

}
```

Note: Plugins are discovered via attributes (or annotations in legacy code), not services.yml.

## PHP Attributes vs Annotations

Use PHP attributes (Drupal 10.2+, required style for Drupal 11):

```php
#[Block(id: 'my_block', admin_label: new TranslatableMarkup('My Block'))]
```
Legacy (discouraged):
```php
// @Block(id = "my_block", admin_label = @Translation("My Block"))
```

## Configurable Block (blockForm / blockSubmit)

```php
public function defaultConfiguration(): array {
  return ['limit' => 5];
}

public function blockForm(array $form, FormStateInterface $form_state): array {
  $form['limit'] = [
    '#type' => 'number',
    '#title' => $this->t('Limit'),
    '#default_value' => $this->configuration['limit'],
  ];
  return $form;
}

public function blockSubmit(array $form, FormStateInterface $form_state): void {
  $this->configuration['limit'] = $form_state->getValue('limit');
}
```

## Plugin Generators

```bash
drush generate plugin:block
drush generate plugin:field:formatter
drush generate plugin:field:widget
drush generate plugin:field:type
drush generate plugin:condition
drush generate plugin:filter
```

## Mental Model

| | |
|---|---|
| **Discovery** | Via PHP attributes (or legacy annotations) — not services.yml |
| **Instantiation** | By plugin managers, not the service container |
| **DI** | Requires `ContainerFactoryPluginInterface` |
| **Manager** | Each plugin type has its own manager (e.g., `BlockManager`) |
| **Plugin ID** | Must be unique — used internally by Drupal to identify the plugin |

