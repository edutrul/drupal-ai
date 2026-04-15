---
name: drupal-hooks
description: Drupal 11 OOP and procedural hooks — hook_form_alter, hook_node_presave, hook_theme, #[Hook] attribute, and when to use hooks vs event subscribers.
---

# Drupal Hooks (Drupal 11)

## OOP Hooks (Preferred)

| | |
|---|---|
| **Location** | `src/Hook/MyModuleHooks.php` |
| **Namespace** | `Drupal\my_module\Hook` |
| **Auto-registered** | Drupal 11.1+ (no services.yml needed) |
| **DI support** | Constructor injection |
| **Testable** | Yes — instantiate directly, inject mocks |

## Example (Best Practice)

```php
<?php

namespace Drupal\my_module\Hook;

use Drupal\Core\Form\FormStateInterface;
use Drupal\Core\Hook\Attribute\Hook;
use Drupal\Core\Session\AccountProxyInterface;
use Drupal\Core\StringTranslation\StringTranslationTrait;
use Drupal\node\NodeInterface;

final class MyModuleHooks {

  use StringTranslationTrait; // Provides $this->t().

  public function __construct(
    private readonly AccountProxyInterface $currentUser,
  ) {}

  /**
   * Implements hook_form_node_article_form_alter().
   *
   * Prefer targeted form hooks over generic form_alter — they only fire for
   * the specific form ID and avoid unnecessary processing.
   */
  #[Hook('form_node_article_form_alter')]
  public function formNodeArticleFormAlter(array &$form, FormStateInterface $form_state): void {
    $form['title']['#title'] = $this->t('Article title');
  }

  /**
   * Implements hook_form_alter().
   *
   * Use only when acting on multiple forms or the form ID is unknown at
   * development time. Check $form_id explicitly.
   */
  #[Hook('form_alter')]
  public function formAlter(array &$form, FormStateInterface $form_state, string $form_id): void {
    if ($form_id === 'node_page_form') {
      $form['title']['#description'] = $this->t('Enter a descriptive page title.');
    }
  }

  #[Hook('node_presave')]
  public function nodePresave(NodeInterface $node): void {
    if ($node->getType() === 'article') {
      // Example: stamp the current user's ID on save.
      $node->set('uid', $this->currentUser->id());
    }
  }

  #[Hook('theme')]
  public function theme(): array {
    return [
      'my_template' => [
        'variables' => ['content' => NULL],
      ],
    ];
  }

}
```

> **Note:** If a hook is not executed, verify namespace and location. OOP hooks outside `src/Hook/` require manual service registration.

## services.yml

| Scenario | Required? |
|---|---|
| Class in `src/Hook/`, namespace `Drupal\my_module\Hook` | No — auto-registered (Drupal 11.1+) |
| Class outside `src/Hook/` (e.g. a custom service) | Yes — register manually |

When registration is needed — autowire resolves constructor dependencies by type hint:

```php
namespace Drupal\my_module\Service;

use Drupal\Core\Hook\Attribute\Hook;
use Drupal\Core\Session\AccountProxyInterface;

final class MyCustomService {

  public function __construct(
    private readonly AccountProxyInterface $currentUser,
  ) {}

  #[Hook('form_alter')]
  public function formAlter(...): void {
    // ...
  }

}
```

```yaml
services:
  Drupal\my_module\Service\MyCustomService:
    autowire: true
```

## Procedural Hooks (.module)

Auto-discovered via `my_module_hook_name()` naming. Still valid; prefer OOP hooks for new code.

## Hooks vs Event Subscribers

| Use Hooks When | Use Event Subscribers When |
|---|---|
| `form_alter`, entity hooks, theme hooks | reacting to dispatched Symfony events |
| extending Drupal core/contrib behavior | PSR-14 / decoupled systems |
| working with existing Drupal APIs | building loosely coupled logic |

> OOP hooks in `src/Hook/` are fully testable — instantiate the class directly and inject mocked dependencies.

## RULES (IMPORTANT)

- ALWAYS prefer OOP hooks in `src/Hook/` for new implementations
- NEVER add new hooks in `.module` unless explicitly requested
- If procedural hook exists, suggest refactoring to OOP
