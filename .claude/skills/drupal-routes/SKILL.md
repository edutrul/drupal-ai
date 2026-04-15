---
name: drupal-routes
description: Drupal routing — routing.yml, admin routes, settings form routes, controllers, route parameters, title callbacks, entity upcasting, permissions, and URL/link generation.
---

# Drupal Routes

## routing.yml

```yaml
# my_module.routing.yml

my_module.page:
  path: '/my-page'
  defaults:
    _controller: '\Drupal\my_module\Controller\MyController::content'
    _title: 'My Page'
  requirements:
    _permission: 'access content'

# Route with parameter
my_module.entity_page:
  path: '/items/{item_id}'
  defaults:
    _controller: '\Drupal\my_module\Controller\ItemController::view'
    _title_callback: '\Drupal\my_module\Controller\ItemController::title'
  requirements:
    _permission: 'access content'
    item_id: '\d+'

# Admin route
my_module.admin:
  path: '/admin/config/my-module'
  defaults:
    _form: '\Drupal\my_module\Form\SettingsForm'
    _title: 'My Module Settings'
  requirements:
    _permission: 'administer my module'

# Route with entity upcasting
my_module.node_page:
  path: '/custom/{node}'
  defaults:
    _controller: '\Drupal\my_module\Controller\NodeController::view'
    _title: 'Node Custom Page'
  requirements:
    _entity_access: 'node.view'
  options:
    parameters:
      node:
        type: entity:node
```

## Controller

```php
// src/Controller/MyController.php
namespace Drupal\my_module\Controller;

use Drupal\Core\Controller\ControllerBase;

final class MyController extends ControllerBase {

  public function content(): array {
    return [
      '#markup' => $this->t('Hello world'),
      '#cache' => [
        'contexts' => ['user.permissions'],
      ],
    ];
  }

  public function view(int $item_id): array {
    // $item_id is from route parameter
    return ['#markup' => $this->t('Item @id', ['@id' => $item_id])];
  }

  public function title(int $item_id): string {
    return $this->t('Item @id', ['@id' => $item_id]);
  }

}
```

## Generating URLs and Links

```php
use Drupal\Core\Url;
use Drupal\Core\Link;

// URL from route
$url = Url::fromRoute('my_module.page');
$url = Url::fromRoute('my_module.entity_page', ['item_id' => 42]);
$url = Url::fromRoute('entity.node.canonical', ['node' => $nid]);

// Absolute URL
$url = Url::fromRoute('my_module.page', [], ['absolute' => TRUE]);

// URL from path
$url = Url::fromUserInput('/my-page');

// Link
$link = Link::fromTextAndUrl($this->t('My Link'), $url);
$render = $link->toRenderable();
```

