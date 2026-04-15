# drupal-queries skill — Developer Notes

## When to use this skill

Use when working with:

- Writing raw database queries when Entity Query is insufficient
- Using the Drupal database abstraction layer (Select, Insert, Update, Delete, Upsert)
- Joining tables in custom queries
- Wrapping operations in transactions
- Injecting `Connection` into a service
- Ensuring SQL injection prevention with parameterized queries

## Mental Model

| Operation | Method |
|---|---|
| Select | `$this->database->select(...)` |
| Insert | `$this->database->insert(...)` |
| Update | `$this->database->update(...)` |
| Delete | `$this->database->delete(...)` |
| Upsert | `$this->database->upsert(...)` |
| Transaction | `$this->database->startTransaction()` |

> Prefer Entity Query for entity data. Use raw queries only for custom tables or complex joins.

## Example Prompts

- Query a custom table with a join
- Insert a row into a custom table
- Use Drupal database upsert() to insert or update a row by a key
- Wrap two Drupal database operations in a transaction using startTransaction()

## Sources

- [Database API](https://www.drupal.org/docs/drupal-apis/database-api)
- [Entity Query](https://www.drupal.org/docs/drupal-apis/entity-api/introduction-to-entity-api-in-drupal-8)
