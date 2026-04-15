# drupal-unit skill — Developer Notes

## When to use this skill

Use when working with:

- Testing isolated PHP logic with no Drupal bootstrap
- Mocking service dependencies with PHPUnit mocks
- Testing value objects, utility classes, or pure business logic
- Writing fast unit tests that don't require a database
- Using `UnitTestCase` as the base class

## Mental Model

| Test type | Base class | Bootstrap | DB? |
|---|---|---|---|
| Unit | `UnitTestCase` | None | No |
| Kernel | `KernelTestBase` | Minimal Drupal | Yes |
| ExistingSite (DTT) | `ExistingSiteBase` | Full Drupal | Yes (live) |

> Unit tests are the fastest. Use them for logic that can be tested without Drupal's container.

## Example Prompts

- Write a Drupal unit test for a service method using UnitTestCase
- Mock EntityTypeManagerInterface in a unit test
- Test a value transformation function with no dependencies
- Set up PHPUnit for a custom Drupal module

## Generating a Test Scaffold with Drush

```bash
drush generate test:unit --answers='{
  "module": "my_module",
  "class": "MyServiceTest"
}'
```

## Sources

- [PHPUnit in Drupal](https://www.drupal.org/docs/develop/automated-testing/phpunit-in-drupal)
- [UnitTestCase](https://api.drupal.org/api/drupal/core!tests!Drupal!Tests!UnitTestCase.php/class/UnitTestCase/11)
- [Drupal Testing Types](https://www.drupal.org/docs/develop/automated-testing/types-of-tests)
