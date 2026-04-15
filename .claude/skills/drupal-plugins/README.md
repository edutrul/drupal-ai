# drupal-plugins skill — Developer Notes

## When to use this skill

Use when working with:

- Building custom Block plugins (`BlockBase`)
- Creating field formatters, widgets, or field types
- Implementing Condition or Filter plugins
- Using `ContainerFactoryPluginInterface` for DI in plugins
- Converting annotation-based plugins to PHP attributes (Drupal 11)
- Generating plugin scaffolding with `drush generate plugin:block`

## Mental Model

| Plugin Type | Base Class | Attribute |
|---|---|---|
| Block | `BlockBase` | `#[Block]` |
| Field Formatter | `FormatterBase` | `#[FieldFormatter]` |
| Field Widget | `WidgetBase` | `#[FieldWidget]` |
| Field Type | `FieldItemBase` | `#[FieldType]` |
| Condition | `ConditionPluginBase` | `#[Condition]` |
| Filter | `FilterBase` | `#[Filter]` |

| Concept | Detail |
|---|---|
| Discovery | PHP attributes (not services.yml) |
| DI | Requires `ContainerFactoryPluginInterface` |
| Manager | Each type has its own plugin manager |

## Example Prompts

- Create a custom block plugin with a service injected
- Build a block with configurable settings (blockForm/blockSubmit)
- Create a field formatter plugin for a custom display
- Convert a @Block annotation to a PHP attribute

## Plugin Generators

```bash
drush generate plugin:block
drush generate plugin:field:formatter
drush generate plugin:field:widget
drush generate plugin:field:type
drush generate plugin:condition
drush generate plugin:filter
```

Non-interactive (for scripted scaffolding):

```bash
drush generate plugin:block --answers='{
  "module": "my_module",
  "plugin_id": "my_block",
  "admin_label": "My Block",
  "category": "Custom",
  "class": "MyBlock",
  "services": ["entity_type.manager"],
  "configurable": "no",
  "access": "no"
}'
```

## Sources

- [Block API](https://www.drupal.org/docs/drupal-apis/block-api)
- [Plugin API](https://www.drupal.org/docs/drupal-apis/plugin-api)
