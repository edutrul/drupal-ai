---
name: drupal-taxonomy
description: Drupal Taxonomy — loading taxonomy terms, vocabularies, term hierarchy, taxonomy term reference fields, and Twig or PHP patterns for taxonomy entities.
---

# Drupal Taxonomy

## Loading Terms

```php
// Load term by ID
$term = $this->entityTypeManager->getStorage('taxonomy_term')->load($tid);

// Load multiple terms
$terms = $this->entityTypeManager->getStorage('taxonomy_term')->loadMultiple($tids);

// Load terms by vocabulary
$terms = $this->entityTypeManager->getStorage('taxonomy_term')->loadByProperties([
  'vid' => 'tags',
  'status' => 1,
]);

// Load term by name
$terms = $this->entityTypeManager->getStorage('taxonomy_term')->loadByProperties([
  'vid' => 'tags',
  'name' => 'My Tag',
]);
$term = reset($terms);
```

## Entity Query for Terms

```php
$query = $this->entityTypeManager->getStorage('taxonomy_term')->getQuery()
  ->accessCheck(TRUE)
  ->condition('vid', 'tags')
  ->condition('status', 1)
  ->sort('weight', 'ASC')
  ->sort('name', 'ASC');

$tids = $query->execute();
$terms = $this->entityTypeManager->getStorage('taxonomy_term')->loadMultiple($tids);
```

## Creating Terms

```php
$term = $this->entityTypeManager->getStorage('taxonomy_term')->create([
  'vid' => 'tags',
  'name' => 'New Tag',
  'description' => [
    'value' => 'Tag description',
    'format' => 'basic_html',
  ],
  'parent' => [['target_id' => $parent_tid]],
  'weight' => 0,
]);
$term->save();
```

## Term Hierarchy

```php
// Get parent terms
$parents = $this->entityTypeManager->getStorage('taxonomy_term')->loadParents($tid);

// Get children
$children = $this->entityTypeManager->getStorage('taxonomy_term')->loadChildren($tid);

// Get all tree (flat)
$tree = $this->entityTypeManager->getStorage('taxonomy_term')->loadTree('tags');
foreach ($tree as $item) {
  $tid = $item->tid;
  $name = $item->name;
  $depth = $item->depth;
  $parents = $item->parents;
}
```

## Term Field Values

```php
$name = $term->getName();           // getName() shortcut
$vid = $term->bundle();             // Vocabulary ID
$tid = $term->id();
$description = $term->get('description')->value;
$weight = $term->getWeight();
```

## In Twig

```twig
{# Render term field #}
{{ content.field_tags }}

{# Access term entity from a reference field #}
{% for item in node.field_tags %}
  {{ item.entity.name.value }}
{% endfor %}
```
