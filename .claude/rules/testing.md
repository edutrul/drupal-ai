---
name: testing
description: Testing conventions — framework choice, test location, structure, and naming for this project
---

# Testing Rules

## Framework

This project uses **DTT (Drupal Test Traits) ExistingSite** tests via `weitzman\DrupalTestTraits\ExistingSiteBase`.

- Do not create Unit, Kernel, or Functional tests — use ExistingSite tests
- ExistingSite tests run against a live Drupal site (DDEV) — no mocking of the full stack

## Test Location

All tests live at the **project root** `tests/src/ExistingSite/` — not inside individual modules.

```
tests/src/ExistingSite/
└── MyFeatureTest.php
```

## Running Tests

```bash
vendor/bin/phpunit tests/
```

Filter by group:
```bash
vendor/bin/phpunit tests/ --filter=my_group
```

## Structure

- Extend `ExistingSiteBase`
- Group by module name using `@group my_group`
- Class name ends in `Test`
- Test method names start with `test`

```php
<?php

namespace Drupal\Tests\ExistingSite;

use weitzman\DrupalTestTraits\ExistingSiteBase;

/**
 * Tests for the my_group module.
 *
 * @group my_group
 */
final class MyModuleExampleTest extends ExistingSiteBase {

  public function testSomething(): void {
    // ...
  }

}
```

## What to Test

- Functional behavior visible through the site (pages, blocks, forms)
- Content creation and field values
- Access control (who can see/do what)
- Integration points between modules

## What NOT to Test

- Internal PHP logic in isolation (no unit tests)
- Database schema or entity structure directly
- Things already covered by Drupal core or contrib tests
