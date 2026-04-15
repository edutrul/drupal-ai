# drupal-menus skill — Developer Notes

## When to use this skill

Use when working with:

- Defining menu links in `links.menu.yml`
- Adding local tasks (tabs) in `links.task.yml`
- Adding local actions (buttons) in `links.action.yml`
- Adding contextual links in `links.contextual.yml`
- Manipulating menus or menu links programmatically
- Creating dynamic menu links via `MenuLinkDefault` or custom plugins

## Mental Model

| File | Produces |
|---|---|
| `links.menu.yml` | Navigation menu links |
| `links.task.yml` | Local tasks (tabs on entity pages) |
| `links.action.yml` | Local action buttons (e.g., "Add item") |
| `links.contextual.yml` | Contextual links (gear icon on blocks/nodes) |

## Example Prompts

- Add a menu link to the admin toolbar
- Create local task tabs on a custom entity
- Create a Drupal links.action.yml local action for an "Add item" button
- Programmatically load and render a menu tree

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

## Sources

- [Menu API](https://www.drupal.org/docs/drupal-apis/menu-api)
- [Menu Link Plugins](https://www.drupal.org/docs/drupal-apis/menu-api/menu-link-plugins)
- [Local tasks](https://www.drupal.org/docs/drupal-apis/routing-system/local-tasks)
