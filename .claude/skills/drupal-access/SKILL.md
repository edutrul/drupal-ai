---
name: drupal-access
description: Drupal access control — permissions.yml, access callbacks, AccessResult, custom access checkers, and entity access.
---

# Drupal Access Control

## Defining Permissions (permissions.yml)

```yaml
administer my module:
  title: 'Administer My Module'
  restrict access: true

view my content:
  title: 'View My Content'
```

## Route Requirements

```yaml
requirements:
  _permission: 'administer my module'   # Permission check
  _role: 'administrator'                # Role check
  _custom_access: '\Drupal\my_module\Access\MyAccessCheck::access'
  _entity_access: 'node.update'
  _access: 'TRUE'
```

## Custom Access Checker

```php
namespace Drupal\my_module\Access;

use Drupal\Core\Access\AccessResult;
use Drupal\Core\Access\AccessResultInterface;
use Drupal\Core\Routing\Access\AccessInterface;
use Drupal\Core\Session\AccountInterface;

final class MyAccessCheck implements AccessInterface {

  public function access(AccountInterface $account): AccessResultInterface {
    if ($account->hasPermission('administer site configuration')) {
      return AccessResult::allowed()->cachePerPermissions();
    }
    if ($account->hasPermission('view my content')) {
      return AccessResult::allowed()->cachePerPermissions();
    }
    return AccessResult::forbidden()->cachePerPermissions();
  }

}
```

## AccessResult Patterns

```php
AccessResult::allowed();
AccessResult::forbidden();
AccessResult::neutral();
AccessResult::allowedIf($condition);
AccessResult::forbiddenIf($condition);
AccessResult::allowedIfHasPermission($account, 'my permission');

// Cache correctly
$result->cachePerPermissions();         // Varies by user permissions
$result->cachePerUser();                // Varies by user identity
$result->addCacheableDependency($node); // Varies by entity
$result->setCacheMaxAge(0);             // Not cacheable
```

## Checking Access in Code

```php
$node->access('view', $account);
$node->access('update', $account);
$account->hasPermission('administer content');
$account->hasRole('editor');
```

## Entity Access Hook

```php
#[Hook('node_access')]
public function nodeAccess(NodeInterface $node, string $op, AccountInterface $account): AccessResultInterface {
  if ($op === 'view' && $node->bundle() === 'private') {
    return AccessResult::forbiddenIf(
      !$account->hasPermission('view private content')
    )->cachePerPermissions()->addCacheableDependency($node);
  }
  return AccessResult::neutral();
}
```
