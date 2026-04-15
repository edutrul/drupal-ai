---
name: drupal-queries
description: Drupal database queries — Select, Insert, Update, Delete using the database abstraction layer. Never concatenate SQL.
---

# Drupal Database Queries

## CRITICAL: Never Concatenate SQL

```php
// WRONG — SQL injection risk
$result = $this->database->query("SELECT * FROM {node} WHERE type = '$type'");

// CORRECT — parameterized query
$result = $this->database->query(
  "SELECT nid, title FROM {node} WHERE type = :type",
  [':type' => $type]
);
```

## Select Query

```php
$query = $this->database->select('node_field_data', 'n');
$query->fields('n', ['nid', 'title', 'status']);
$query->condition('n.type', 'article');
$query->condition('n.status', 1);
$query->orderBy('n.created', 'DESC');
$query->range(0, 10);

$results = $query->execute()->fetchAll();

// Fetch as associative array
$results = $query->execute()->fetchAllAssoc('nid');

// Fetch single value
$count = $query->countQuery()->execute()->fetchField();
```

## Select with Join

```php
$query = $this->database->select('node_field_data', 'n');
$query->join('node__field_tags', 'tags', 'n.nid = tags.entity_id');
$query->fields('n', ['nid', 'title']);
$query->condition('tags.field_tags_target_id', $tid);
$query->condition('n.status', 1);
```

## Insert

```php
$this->database->insert('my_table')
  ->fields([
    'uid' => $uid,
    'data' => serialize($data),
    'created' => \Drupal::time()->getRequestTime(),
  ])
  ->execute();
```

## Upsert (Insert or Update)

```php
$this->database->upsert('my_table')
  ->key('uid')
  ->fields(['uid', 'data', 'updated'])
  ->values([
    'uid' => $uid,
    'data' => serialize($data),
    'updated' => \Drupal::time()->getRequestTime(),
  ])
  ->execute();
```

## Update

```php
$this->database->update('my_table')
  ->fields(['data' => serialize($data)])
  ->condition('uid', $uid)
  ->execute();
```

## Delete

```php
$this->database->delete('my_table')
  ->condition('uid', $uid)
  ->execute();
```

## Entity Query (preferred for entities)

```php
// Always prefer EntityQuery over raw SQL for entities
$query = $this->entityTypeManager->getStorage('node')->getQuery()
  ->accessCheck(TRUE)
  ->condition('type', 'article')
  ->condition('status', 1)
  ->sort('created', 'DESC')
  ->range(0, 10);

$nids = $query->execute();
```

## Inject Database Service

```php
use Drupal\Core\Database\Connection;

public function __construct(
  private readonly Connection $database,
) {}
```

Service ID: `database`

## Transactions

```php
$transaction = $this->database->startTransaction();
try {
  $this->database->insert('my_table')->fields([...])->execute();
  $this->database->update('other_table')->fields([...])->execute();
}
catch (\Exception $e) {
  $transaction->rollBack();
  throw $e;
}
// Transaction commits when $transaction goes out of scope
```

