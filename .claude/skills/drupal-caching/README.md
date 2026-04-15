# drupal-caching skill — Developer Notes

## When to use this skill

Use when working with:

- Adding `#cache` metadata to render arrays
- Cache tags (`node:123`, `node_list`, `config:my_module.settings`)
- Cache contexts (`user.permissions`, `url.path`, `languages`)
- Reading and writing to cache bins
- Invalidating cache tags programmatically
- Injecting `CacheBackendInterface` into services
- Avoiding stale content due to missing cache metadata

## Mental Model

| Concept | Purpose |
|---|---|
| **Cache tags** | What invalidates this cache (entity saved, config changed) |
| **Cache contexts** | What varies this cache (user, URL, language) |
| **Max-age** | How long to cache (seconds, or `Cache::PERMANENT`) |
| **Cache bins** | Where data is stored (`default`, `render`, `data`) |

## Example Prompts

- Add cache metadata to a render array in the custom module
- In Drupal 11, implement cache tag invalidation using Cache::invalidateTags when a node is saved. In the custom module for the node type invalidate cache tags.
- Cache expensive computed data with tags
- In Drupal 11, which cache context should be used for user-specific content?. Answer using Drupal Cache API and render array examples.

## Cache Bins Reference

```php
\Drupal::cache('default');
\Drupal::cache('render');
\Drupal::cache('data');
\Drupal::cache('bootstrap');
\Drupal::cache('config');
\Drupal::cache('discovery');
\Drupal::cache('menu');
```

## Full Service Caching Pattern

```php
public function getExpensiveData(): array {
  $cid = 'my_module:expensive_data';
  $cached = $this->cacheBackend->get($cid);

  if ($cached !== FALSE) {
    return $cached->data;
  }

  $data = $this->computeExpensiveData();

  $this->cacheBackend->set($cid, $data, Cache::PERMANENT, ['node_list']);

  return $data;
}
```

## Sources

- [Cache API](https://www.drupal.org/docs/drupal-apis/cache-api)
- [Cache tags](https://www.drupal.org/docs/drupal-apis/cache-api/cache-tags)
- [Cache contexts](https://www.drupal.org/docs/drupal-apis/cache-api/cache-contexts)
