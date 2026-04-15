# drupal-kernel skill — Developer Notes

## When to use this skill

Use when working with:

- Writing `KernelTestBase` tests for services and database operations
- Installing entity schemas and module config in test setup
- Testing hooks (entity presave, form alter) in isolation
- Testing config operations without a full browser
- Deciding between a Unit test, Kernel test, or DTT test

## Mental Model

| Test Type | Bootstrap | Use for |
|---|---|---|
| **Unit** | None | Pure PHP logic, fully mockable |
| **Kernel** | Partial (DB, container) | Services, DB, hooks, config |
| **DTT ExistingSite** | Full running site | Integration, real content |

| Setup method | Purpose |
|---|---|
| `installEntitySchema('node')` | Create entity DB tables |
| `installSchema('system', [...])` | Create specific DB tables |
| `installConfig('my_module')` | Load module's config/install/ |

## Example Prompts

- Write a kernel test for a service that queries the database
- Create a Drupal kernel test for hook_node_presave that changes a field value
- Set up a kernel test with a node type and custom fields
- Run kernel tests for a specific module with DDEV

## Running Tests

Examples assume a `docroot/`-based Drupal project. If your project uses `web/` or another document root, adjust paths accordingly.

```bash
# Run kernel tests for a module
ddev exec vendor/bin/phpunit docroot/modules/custom/my_module/tests/src/Kernel/

# Run specific test
ddev exec vendor/bin/phpunit docroot/modules/custom/my_module/tests/src/Kernel/MyServiceTest.php
```

## Generate Scaffold

```bash
drush generate test:kernel --answers='{
  "module": "my_module",
  "class": "MyServiceTest"
}'
```

## Sources

- [Kernel Tests](https://www.drupal.org/docs/develop/automated-testing/types-of-tests#kernel)
- [KernelTestBase API](https://api.drupal.org/api/drupal/core!tests!Drupal!KernelTests!KernelTestBase.php/class/KernelTestBase/11)
