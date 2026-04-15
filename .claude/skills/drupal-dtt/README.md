# drupal-dtt skill — Developer Notes

## When to use this skill

Use when working with:

- Writing `ExistingSiteBase` integration tests with Drupal Test Traits
- Testing against a live Drupal site (real content, config, users)
- Asserting page content, status codes, and element presence
- Creating test content (nodes, users, terms) with automatic cleanup
- Submitting forms and checking results in tests
- Running DTT tests with DDEV

## Mental Model

| Pattern | Purpose |
|---|---|
| `ExistingSiteBase` | Base class — tests run on the real running site |
| `$this->createNode()` | Creates content, auto-deleted after test |
| `$this->drupalLogin()` | Log in as a test user |
| `$this->assertSession()` | Assert page content, elements, status codes |
| `$this->submitForm()` | Submit a form by field values + button label |

## Example Prompts

- Write an ExistingSite test that checks the homepage loads
- Test that an editor can create an article
- Assert that a specific CSS class exists on a page
- Run DTT tests for a specific module

## Sources

- [Drupal Test Traits](https://gitlab.com/weitzman/drupal-test-traits)
- [Drupal Testing Types](https://www.drupal.org/docs/develop/automated-testing/types-of-tests)

## Configuration (phpunit.xml)

```xml
<env name="DTT_BASE_URL" value="http://my-project.ddev.site"/>
<env name="DTT_API_TYPE" value="goutte"/>
<env name="SIMPLETEST_BASE_URL" value="http://my-project.ddev.site"/>
<env name="SIMPLETEST_DB" value="mysql://db:db@db/db"/>
```

Uses `weitzman/drupal-test-traits/src/bootstrap-fast.php` bootstrap.
