# drupal-access skill — Developer Notes

## When to use this skill

Use when working with:

- Defining custom permissions in `permissions.yml`
- Setting `_permission`, `_role`, or `_custom_access` in `routing.yml`
- Writing custom access checkers (`AccessInterface`)
- Using `AccessResult::allowed()`, `forbidden()`, or `neutral()`
- Checking entity access with `$entity->access()`
- Implementing `hook_node_access` or other entity access hooks
- Adding correct cache metadata to access results

## Mental Model

| Pattern | Where | Use for |
|---|---|---|
| `_permission` in routing.yml | Route definition | Simple permission checks |
| `_custom_access` in routing.yml | Route definition | Complex conditions |
| `AccessResult` | Access checker / hook | Programmatic checks |
| `$entity->access()` | PHP code | Entity-level access |
| `hook_node_access` | OOP Hook | Per-node access logic |

## Example Prompts

- Define a custom permission for my module
- Create a custom access checker for a route
- In Drupal 11, check if the current user can update a node using $node->access() /
- In Drupal 11, implement access control for private content using hook_node_access and AccessResult

## Sources

- [Access API](https://www.drupal.org/docs/drupal-apis/access-api)
- [Permissions overview](https://www.drupal.org/docs/drupal-apis/access-api/overview-of-permissions)
