---
name: drupal-entity-api
description: Drupal Entity API — loading, creating, updating, and deleting entities using entity_type.manager. Node, User, Term, Media patterns.
---

# Drupal Entity API

## Loading Entities

```php
// Load a single node
$node = $this->entityTypeManager->getStorage('node')->load($nid);

// Load multiple nodes
$nodes = $this->entityTypeManager->getStorage('node')->loadMultiple([1, 2, 3]);

// Load by properties
$nodes = $this->entityTypeManager->getStorage('node')->loadByProperties([
  'type' => 'article',
  'status' => 1,
  'uid' => $uid,
]);

// Load user
$user = $this->entityTypeManager->getStorage('user')->load($uid);

// Load term
$term = $this->entityTypeManager->getStorage('taxonomy_term')->load($tid);

// Load media
$media = $this->entityTypeManager->getStorage('media')->load($mid);
```

## Entity Query

```php
$query = $this->entityTypeManager->getStorage('node')->getQuery()
  ->accessCheck(TRUE)
  ->condition('type', 'article')
  ->condition('status', 1)
  ->condition('field_tags', $tid)
  ->sort('created', 'DESC')
  ->range(0, 10);

$nids = $query->execute();
$nodes = $this->entityTypeManager->getStorage('node')->loadMultiple($nids);
```

## Creating Entities

```php
// Create a node
$node = $this->entityTypeManager->getStorage('node')->create([
  'type' => 'article',
  'title' => 'My Article',
  'status' => 1,
  'uid' => $this->currentUser->id(),
  'field_body' => [
    'value' => 'Content here',
    'format' => 'basic_html',
  ],
]);
$node->save();

// Create a taxonomy term
$term = $this->entityTypeManager->getStorage('taxonomy_term')->create([
  'vid' => 'tags',
  'name' => 'New Tag',
]);
$term->save();
```

## Updating Entities

```php
$node = $this->entityTypeManager->getStorage('node')->load($nid);
if ($node instanceof NodeInterface) {
  $node->set('title', 'Updated Title');
  $node->set('field_body', ['value' => 'New content', 'format' => 'basic_html']);
  $node->save();
}
```

## Deleting Entities

```php
$node = $this->entityTypeManager->getStorage('node')->load($nid);
if ($node) {
  $node->delete();
}

// Delete multiple
$storage = $this->entityTypeManager->getStorage('node');
$nodes = $storage->loadMultiple($nids);
$storage->delete($nodes);
```

## Accessing Field Values

```php
// Simple field
$title = $node->get('title')->value;
$status = $node->get('status')->value;

// Text with format
$body = $node->get('body')->value;
$format = $node->get('body')->format;

// Reference field
$tid = $node->get('field_tags')->target_id;
$term = $node->get('field_tags')->entity;

// Multi-value field
foreach ($node->get('field_images') as $item) {
  $fid = $item->target_id;
  $file = $item->entity;
}

// Check if field is empty
if (!$node->get('field_image')->isEmpty()) { ... }
```

## Access Checking

```php
// Always add access checks
$query->accessCheck(TRUE);

// Check entity access
if ($node->access('view', $account)) { ... }
if ($node->access('update', $account)) { ... }
```

## Inject EntityTypeManager

```php
public function __construct(
  private readonly EntityTypeManagerInterface $entityTypeManager,
) {}
```

