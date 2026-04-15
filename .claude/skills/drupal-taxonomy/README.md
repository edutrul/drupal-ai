# drupal-taxonomy skill — Developer Notes

## When to use this skill

Use when working with:

- Loading taxonomy terms by ID, name, or vocabulary
- Querying terms with conditions and sorting
- Creating terms programmatically
- Traversing term hierarchy (parents, children, full tree)
- Accessing term field values in PHP or Twig
- Generating test terms with Devel

## Mental Model

| Operation | Pattern |
|---|---|
| Load by ID | `getStorage('taxonomy_term')->load($tid)` |
| Load by vocab | `getStorage('taxonomy_term')->loadByProperties(['vid' => 'tags'])` |
| Load by name | `loadByProperties(['vid' => 'tags', 'name' => 'My Tag'])` |
| Get parents | `loadParents($tid)` |
| Get children | `loadChildren($tid)` |
| Full tree | `loadTree('vocabulary_name')` |

## Example Prompts

- Load all terms in a vocabulary sorted by weight
- Get parent terms for a given term ID
- Create a new taxonomy term with a parent
- Iterate over reference field terms in Twig

## Generating Test Terms

```bash
# Requires devel module; --kill deletes existing terms first
drush devel-generate:terms 100 tags --kill
```

## Sources

- [Taxonomy API](https://www.drupal.org/docs/drupal-apis/entity-api)
- [TermStorage](https://api.drupal.org/api/drupal/core!modules!taxonomy!src!TermStorage.php/class/TermStorage/11)
