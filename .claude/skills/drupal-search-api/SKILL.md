---
name: drupal-search-api
description: Search API — index configuration, boost processors, field types, number field boosting, engagement metrics, and reindexing workflows.
---

# Drupal Search API

## Index Configuration

### Field Type Requirements

**Boolean Fields for Boosting**
- Boolean fields work best with custom boost processors
- Integer fields can cause issues with boolean-based boost logic
- Always configure boolean fields as `type: boolean` in index settings

```yaml
field_settings:
  field_featured:
    label: Featured
    datasource_id: 'entity:node'
    property_path: field_featured
    type: boolean  # NOT integer
    boost: 8.0
```

**Configuration Command**
```bash
ddev drush config:set search_api.index.{index_name} \
  field_settings.field_featured.type boolean
```

### Numeric Fields for Engagement Boosting

**Flag Count Fields**
- Use `type: integer` for count fields
- Managed by `flag_search_api` module
- Automatically indexed and updated

```yaml
field_settings:
  flag_bookmark_count:
    label: 'Bookmark count'
    property_path: flag_bookmark_count
    type: integer
  flag_favorite_count:
    label: 'Favorite count'
    property_path: flag_favorite_count
    type: integer
```

## Boost Processors

### Custom Boolean Boost Processor

**When to Use**
- Boolean field boosting (featured flags, promoted content)
- Needs 100% control over boost logic
- Complex conditional boosting

**Pattern: FeaturedContentBoost.php** — extends `ProcessorPluginBase`, stage `preprocess_index`

```php
// Use #[SearchApiProcessor(...)] attribute (use Drupal\search_api\Attribute\SearchApiProcessor) — see README for full class
final class FeaturedContentBoost extends ProcessorPluginBase {
  public function preprocessIndexItems(array $items) {
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

**Key Points**
- Use multiplicative boost: `$item->setBoost($old_boost * boost_factor)`
- Pattern from `search_api_boolean_field_boost` module
- Boost at index time via `preprocess_index` stage
- Always get old boost first to preserve other boosts

**Recommended Boost Factors**
- Featured content: `2.0x` (modest but effective)
- Featured content: `1.5x - 3.0x`
- Premium content: `1.5x - 2.0x`

### Number Field Boost Processor

**When to Use**
- Engagement metrics (likes, bookmarks, views)
- Numeric quality scores
- Time-based decay factors

**Configuration Pattern**

```yaml
processor_settings:
  number_field_boost:
    weights:
      preprocess_index: 0
    boosts:
      flag_bookmark_count:
        boost_factor: 0.01
        aggregation: max
      flag_favorite_count:
        boost_factor: 0.1
        aggregation: max
```

**How It Works**
- Adds to boost based on field value
- Formula: `boost += (field_value * boost_factor)`
- Example: 138 bookmarks x 0.01 = +1.38 boost

**Configuration Commands**
```bash
# Set bookmark count boost (0.01 per bookmark)
ddev drush config:set search_api.index.{index_name} \
  processor_settings.number_field_boost.boosts.flag_bookmark_count.boost_factor 0.01

# Set favorite count boost (0.1 per favorite)
ddev drush config:set search_api.index.{index_name} \
  processor_settings.number_field_boost.boosts.flag_favorite_count.boost_factor 0.1
```

**Recommended Boost Factors**
- Bookmark count: `0.01 - 0.05` (for counts in 10-1000 range)
- Favorite count: `0.1 - 0.5` (for counts in 1-50 range)
- View count: `0.001 - 0.01` (for counts in 100-10000 range)

### Processor Conflicts

**Problem: Multiple Processors on Same Field**

If multiple processors target the same field, they can conflict:
- One overrides the other
- Boosts don't combine as expected
- Unpredictable results

**Solution: Remove Conflicting Configuration**

```bash
# Remove field from number_field_boost if using custom processor
ddev drush config:set search_api.index.{index_name} \
  processor_settings.number_field_boost.boosts.field_featured null
```

**Best Practice**
- Use custom processor for boolean/complex logic
- Use number_field_boost for simple numeric boosts
- Don't configure same field in multiple processors

## Configuration Management

### Direct Config Updates with PHP

When `drush config:set` fails or produces unexpected results (e.g., side effects on unrelated config), use PHP to directly update active configuration:

```bash
ddev drush php:eval "
\$config = \Drupal::configFactory()->getEditable('search_api.index.{index_name}');

// Set field type
\$config->set('field_settings.field_featured.type', 'boolean');

// Remove from number_field_boost
\$boosts = \$config->get('processor_settings.number_field_boost.boosts');
unset(\$boosts['field_featured']);
\$config->set('processor_settings.number_field_boost.boosts', \$boosts);

// Set boost factors
\$config->set('processor_settings.number_field_boost.boosts.flag_bookmark_count.boost_factor', 0.01);
\$config->set('processor_settings.number_field_boost.boosts.flag_favorite_count.boost_factor', 0.1);

\$config->save();
echo \"Configuration updated\n\";
"
```

**When to Use PHP Instead of drush config:set:**
- When config:set creates unwanted side effects (e.g., changing `server: {server_name}` to `server: null`)
- When removing array keys (unset pattern works better than `null`)
- When making multiple related changes atomically
- When field type changes cause Drupal to fallback to generic types

**After PHP Config Updates:**
1. Verify changes: `ddev drush config:get search_api.index.{index_name} field_settings.field_featured`
2. Export to files: `ddev drush config:export -y`
3. Review exported changes: `git diff config/sync/`
4. Revert any unintended changes (e.g., ngram fields changed to plain text)

### Field Type Preservation

**Problem:** When Solr server config is modified (e.g., pointing to a different backend), config export may downgrade custom field types to generic types:

```yaml
# BEFORE (correct)
field_display_name:
  type: 'solr_text_custom:ngramstring'

# AFTER export (incorrect)
field_display_name:
  type: text
```

**Solution:** After exporting, restore custom field types via PHP:

```bash
ddev drush php:eval "
\$config = \Drupal::configFactory()->getEditable('search_api.index.{index_name}');
\$config->set('field_settings.field_display_name.type', 'solr_text_custom:ngramstring');
\$config->set('field_settings.label.type', 'solr_text_custom:ngramstring');
\$config->set('field_settings.name.type', 'solr_text_custom:ngramstring');
\$config->set('field_settings.title.type', 'solr_text_custom:ngramstring');
\$config->save();
"
ddev drush config:export -y
```

**Fields Using ngram Tokenization:**
- `field_display_name` - Display names (partial matching for autocomplete)
- `label` - Entity labels/titles
- `name` - User account names
- `title` - Node titles

**Never change these to `type: text`** - it breaks partial name matching (e.g., "mich" won't find "Michael").

### Config Export Side Effects

When modifying Search API server config (e.g., for local development), Drupal may update index configs to remove server dependencies:

```yaml
# Unintended change in search_api.index.{index_name}.yml
dependencies:
  config:
-    - search_api.server.{server_name}  # Removed
server: null  # Changed from {server_name}
```

**Prevention:**
1. Don't modify `search_api.server.{server_name}.yml` for local development
2. Use DDEV's built-in Solr service without changing server config
3. If server config changes are needed, use config splits for environment-specific settings
4. Always review `git diff config/sync/` before committing

**Recovery:**
```bash
# Revert index files if server was set to null
git checkout HEAD -- config/sync/search_api.index.*.yml
```

## Reindexing After Changes

### When Reindexing is Required

**Always reindex after:**
- Changing field type (integer -> boolean)
- Changing boost factors
- Adding/removing processors
- Modifying processor configuration

**Reindex Commands**

```bash
# Full reindex workflow
ddev drush cr
ddev drush search-api:clear {index_name}
ddev drush search-api:index {index_name}

# Check index status
ddev drush search-api:status {index_name}
```

## Debug Commands

```bash
# Check processor configuration
ddev drush config:get search_api.index.{index_name} processor_settings

# Check field configuration
ddev drush config:get search_api.index.{index_name} field_settings

# Verify index status
ddev drush search-api:status {index_name}
```

**Boost not applying checklist:** processor enabled → field type correct (boolean/integer) → full reindex completed → no conflicting processors → cache cleared.
