# drupal-search-api skill — Developer Notes

## When to use this skill

Use when working with:

- Configuring Search API indexes and fields
- Building custom boost processors for featured or promoted content
- Boosting results by numeric engagement metrics (flags, views)
- Resolving processor conflicts on the same field
- Reindexing after configuration changes
- Debugging boost factors that aren't applying as expected

## Mental Model

| Boost Type | Processor | Formula |
|---|---|---|
| Boolean flag (featured) | Custom `ProcessorPluginBase` | Multiplicative: `$boost * 2.0` |
| Numeric engagement | `number_field_boost` | Additive: `$boost + (value * factor)` |

| Stage | When to use |
|---|---|
| `preprocess_index` | Index-time boost (preferred — computed once) |
| Query-time | Dynamic boost (avoid — impacts every query) |

## Example Prompts

- Create a Drupal Search API custom boost processor for featured content
- Set up Search API bookmark count boosting with number_field_boost
- Why is my Drupal Search API custom processor not changing indexed boost?
- Reindex a Drupal Search API index after changing a field type from integer to boolean
- Prevent conflicts between two Drupal Search API processors on the same field

## FeaturedContentBoost — Full Class

```php
namespace Drupal\custom_search\Plugin\search_api\processor;

use Drupal\Core\StringTranslation\TranslatableMarkup;
use Drupal\search_api\Attribute\SearchApiProcessor;
use Drupal\search_api\Processor\ProcessorPluginBase;

/**
 * Adds a boost to indexed items marked as featured.
 */
#[SearchApiProcessor(
  id: 'featured_content_boost',
  label: new TranslatableMarkup('Featured content boost'),
  description: new TranslatableMarkup('Adds a boost to indexed items marked as featured.'),
  stages: ['preprocess_index' => 0],
)]
final class FeaturedContentBoost extends ProcessorPluginBase {

  public function preprocessIndexItems(array $items): void {
    foreach ($items as $item) {
      try {
        $entity = $item->getOriginalObject()->getValue();
        if ($entity->hasField('field_featured') &&
            !$entity->get('field_featured')->isEmpty() &&
            $entity->get('field_featured')->value == 1) {
          $item->setBoost($item->getBoost() * 2.0);
        }
      }
      catch (\Exception $e) {
        continue;
      }
    }
  }

}
```

## Performance: Index-Time vs Query-Time Boosting

Index-time boosting (via `preprocess_index`) is preferred — computed once, scales with query volume. Query-time boosting is dynamic but impacts every query.

## Boost Stacking Example

```
Node: featured + 138 bookmarks
- Base: 1.0 → Featured x2.0 = 2.0 → +138*0.01 = 3.38

Node: 12 favorites
- Base: 1.0 → +12*0.1 = 2.2
```

## Validation Queries

```sql
-- Bookmark counts
SELECT n.nid, n.title, fcl.count AS bookmark_count
FROM node_field_data n
INNER JOIN flag_counts fcl ON fcl.entity_type = 'node'
  AND fcl.entity_id = n.nid AND fcl.flag_id = 'bookmark'
ORDER BY fcl.count DESC LIMIT 10;
```

## Module Dependencies

- `search_api` — Core Search API
- `search_api_solr` — Solr backend
- `flag_search_api` — Index flag counts (bookmark, favorite)
- `search_api_boolean_field_boost` — Reference for boost patterns

## Sources

- [Search API Processors](https://www.drupal.org/docs/contributed-modules/search-api/developer-documentation/processors)
- [Search API Boost Module](https://www.drupal.org/project/search_api_boost)
