# DocBlock Rules

- Drupal-style docblocks on all classes and public methods; protected methods with non-trivial logic.
- Inline `@var` only when type is non-obvious (entities, entity refs, paragraphs, menu links, field items, plugin instances). Skip for typed params/properties/returns and scalars.
- `@param`: describe intent, not just type; document complex array shapes.
- `@return`: document complex structures and render array keys when non-obvious.
- `@throws`: include when relevant to the caller.
- Avoid docblocks that only restate the method/class name.
