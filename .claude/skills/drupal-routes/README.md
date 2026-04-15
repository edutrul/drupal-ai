# drupal-routes skill — Developer Notes

## When to use this skill

Use when working with:

- Defining routes in `routing.yml` with controllers or forms
- Adding route parameters (plain values or entity upcasting)
- Setting route permissions (`_permission`, `_custom_access`, `_entity_access`)
- Writing title callbacks for dynamic page titles
- Generating URLs and links from route names
- Scaffolding controllers with `drush generate controller`

## Mental Model

| Requirement | Use |
|---|---|
| Simple permission | `_permission: 'my permission'` |
| Role | `_role: 'administrator'` |
| Entity access | `_entity_access: 'node.update'` |
| Custom logic | `_custom_access: '\Drupal\...\MyCheck::access'` |
| Public route | `_access: 'TRUE'` |

| URL generation | Pattern |
|---|---|
| From route | `Url::fromRoute('my_module.page', ['id' => 1])` |
| From path | `Url::fromUserInput('/my-path')` |
| Absolute | `Url::fromRoute(..., [], ['absolute' => TRUE])` |

## Example Prompts

- Create a route with a controller and permission check
- Creating admin settings routes under `/admin/config`
- Generate a URL from a route name in PHP
- Add entity upcasting to a route parameter
- Create a route with a dynamic title callback

## Scaffolding

```bash
drush generate controller --answers='{
  "module": "my_module",
  "class": "MyController",
  "services": ["entity_type.manager", "current_user"]
}'
```

## Sources

- [Routing API](https://www.drupal.org/docs/drupal-apis/routing-system)
- [Controllers](https://www.drupal.org/docs/drupal-apis/routing-system/controllers)
