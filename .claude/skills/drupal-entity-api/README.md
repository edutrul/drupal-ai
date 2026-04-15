# drupal-entity-api skill — Developer Notes

## When to use this skill

Use when working with:

- Loading entities by ID, by properties, or via entity query
- Creating, updating, or deleting nodes, users, terms, or media
- Accessing field values on entities (`->get('field_name')->value`)
- Running entity queries with conditions, sorting, and access checks
- Injecting `EntityTypeManagerInterface` into services

## Mental Model

| Operation | Pattern |
|---|---|
| Load single | `getStorage('node')->load($nid)` |
| Load by properties | `getStorage('node')->loadByProperties([...])` |
| Entity query | `getStorage('node')->getQuery()->condition(...)->execute()` |
| Create | `getStorage('node')->create([...])->save()` |
| Delete | `$entity->delete()` |

## Example Prompts

- Load all published articles tagged with a specific term
- In Drupal, create a taxonomy term programmatically using the Entity API and entity_type.manager.
- In Drupal, update a field on a node using Entity API and save it.
- In Drupal, use Entity API to query nodes with multiple conditions and accessCheck(TRUE).

## Sources

- [Entity API](https://www.drupal.org/docs/drupal-apis/entity-api)
- [Entity Query](https://www.drupal.org/docs/drupal-apis/entity-api/introduction-to-entity-api-in-drupal-8)
