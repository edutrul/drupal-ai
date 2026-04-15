---
name: drupal-caching
description: Drupal Cache API — cache tags, contexts, max-age, cache bins, invalidation, and adding cache metadata to render arrays.
---

# Drupal Caching

**Always add cache metadata. Missing cache metadata causes stale content.**

## Cache Metadata in Render Arrays

```php
$build['content'] = [
  '#markup' => $output,
  '#cache' => [
    'tags' => ['node:' . $node->id(), 'node_list'],
    'contexts' => ['user.permissions', 'url.query_args'],
    'max-age' => Cache::PERMANENT,
  ],
];
```

## Cache Tags

| Tag | Invalidated when |
|---|---|
| `node:{nid}` | Node {nid} is saved/deleted |
| `node_list` | Any node is created or deleted |
| `user:{uid}` | User {uid} is saved |
| `taxonomy_term:{tid}` | Term {tid} is saved |
| `config:{name}` | Config object {name} is saved |

## Cache Contexts

| Context | Varies by |
|---|---|
| `user.permissions` | User's permissions (prefer over `user`) |
| `user.roles` | User's roles |
| `url.path` | URL path |
| `url.query_args` | Query parameters |
| `languages` | Current language |

## Reading/Writing Cache

```php
$cached = $this->cacheBackend->get('my_module:my_key');
if ($cached !== FALSE) {
  return $cached->data;
}

$this->cacheBackend->set('my_module:my_key', $data, Cache::PERMANENT, ['node_list']);
$this->cacheBackend->set('my_module:my_key', $data, \Drupal::time()->getRequestTime() + 3600, ['node_list']);
$this->cacheBackend->delete('my_module:my_key');

Cache::invalidateTags(['node:123', 'node_list']);
```

## Inject Cache Service

```php
use Drupal\Core\Cache\CacheBackendInterface;

public function __construct(
  private readonly CacheBackendInterface $cacheBackend,
) {}
```

```yaml
# services.yml
my_module.my_service:
  arguments: ['@cache.default']
```

## CacheableDependencyInterface

```php
$build['#cache']['tags'] = Cache::mergeTags(
  $build['#cache']['tags'] ?? [],
  $node->getCacheTags()
);
```
