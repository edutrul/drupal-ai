---
name: drupal-menus
description: Drupal menus — links.menu.yml, links.task.yml, links.action.yml, contextual links, and programmatic menu manipulation.
---

# Drupal Menus

## Menu Links (*.links.menu.yml)

```yaml
# my_module.links.menu.yml

my_module.admin:
  title: 'My Module'
  description: 'Configure My Module.'
  route_name: my_module.admin
  parent: system.admin_config
  weight: 10

my_module.admin.settings:
  title: 'Settings'
  route_name: my_module.admin.settings
  parent: my_module.admin
  weight: 0
```

## Task Links / Tabs (*.links.task.yml)

```yaml
# my_module.links.task.yml

my_module.settings_tab:
  title: 'Settings'
  route_name: my_module.admin.settings
  base_route: my_module.admin

my_module.advanced_tab:
  title: 'Advanced'
  route_name: my_module.admin.advanced
  base_route: my_module.admin
  weight: 10
```

## Action Links (*.links.action.yml)

```yaml
# my_module.links.action.yml

my_module.add_item:
  title: 'Add Item'
  route_name: my_module.add
  appears_on:
    - my_module.list
```

## Programmatic Menu Tree

```php
use Drupal\Core\Menu\MenuTreeParameters;

$menu_tree = \Drupal::menuTree();
$parameters = new MenuTreeParameters();
$parameters->setMaxDepth(2)->onlyEnabledLinks();

$tree = $menu_tree->load('main', $parameters);
$manipulators = [
  ['callable' => 'menu.default_tree_manipulators:checkAccess'],
  ['callable' => 'menu.default_tree_manipulators:generateIndexAndSort'],
];
$tree = $menu_tree->transform($tree, $manipulators);
$build = $menu_tree->build($tree);
```

## Altering Menu Links

```php
#[Hook('menu_links_discovered_alter')]
public function menuLinksDiscoveredAlter(array &$links): void {
  if (isset($links['my_module.some_link'])) {
    $links['my_module.some_link']['title'] = new TranslatableMarkup('New Title');
  }
}
```

## Dynamic Menu Links (MenuLinkDefault plugin)

```php
// src/Plugin/Menu/MyDynamicMenuLink.php
use Drupal\Core\Menu\MenuLinkDefault;

final class MyDynamicMenuLink extends MenuLinkDefault {
  public function getTitle(): string {
    return 'Dynamic Title from ' . $this->getRouteName();
  }
}
```
