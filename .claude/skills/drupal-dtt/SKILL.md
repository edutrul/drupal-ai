---
name: drupal-dtt
description: Drupal Test Traits (DTT) ExistingSite tests — testing against a live Drupal site, creating content, asserting pages, and running tests with DDEV.
---

# Drupal Test Traits (DTT) — ExistingSite Tests

## When to Use

- Testing against a real, running Drupal site
- Smoke tests and integration tests against production-like data
- When you need real content, config, and users
- Regression tests for bugs found in production

## Basic Structure

```php
// tests/src/ExistingSite/MyFeatureTest.php
namespace Drupal\Tests\my_module\ExistingSite;

use weitzman\DrupalTestTraits\ExistingSiteBase;

/**
 * Tests My Feature on an existing site.
 *
 * @group my_module
 * @group existing_site
 */
final class MyFeatureTest extends ExistingSiteBase {

  public function testHomepageLoads(): void {
    $this->drupalGet('/');
    $this->assertSession()->statusCodeEquals(200);
    $this->assertSession()->pageTextContains('Welcome');
  }

  public function testArticleCreation(): void {
    // Create a user with role
    $user = $this->createUser();
    $user->addRole('editor');
    $user->save();
    $this->drupalLogin($user);

    // Create a node
    $node = $this->createNode([
      'type' => 'article',
      'title' => 'Test Article',
      'status' => 1,
    ]);

    $this->drupalGet('/node/' . $node->id());
    $this->assertSession()->statusCodeEquals(200);
    $this->assertSession()->pageTextContains('Test Article');
  }

  public function testFormSubmission(): void {
    $this->drupalGet('/contact');
    $this->assertSession()->statusCodeEquals(200);

    $this->submitForm([
      'name' => 'Test User',
      'mail' => 'test@example.com',
      'message[0][value]' => 'Test message',
    ], 'Send message');

    $this->assertSession()->pageTextContains('Your message has been sent.');
  }

}
```

## Common Assertions

```php
// HTTP status
$this->assertSession()->statusCodeEquals(200);
$this->assertSession()->statusCodeEquals(403);
$this->assertSession()->statusCodeEquals(404);

// Page content
$this->assertSession()->pageTextContains('Expected text');
$this->assertSession()->pageTextNotContains('Missing text');

// Elements
$this->assertSession()->elementExists('css', '.my-class');
$this->assertSession()->elementTextContains('css', 'h1', 'Page Title');
$this->assertSession()->linkExists('My Link');
$this->assertSession()->linkByHrefExists('/my-path');

// Fields
$this->assertSession()->fieldExists('edit-title-0-value');
$this->assertSession()->fieldValueEquals('edit-title-0-value', 'My Title');

// Response headers
$this->assertSession()->responseHeaderContains('X-Drupal-Cache', 'HIT');
```

## Helpers

```php
// Navigate to URL
$this->drupalGet('/path');
$this->drupalGet(Url::fromRoute('my_module.page'));

// Login
$this->drupalLogin($user);
$this->drupalLogout();

// Create content (automatically cleaned up after test)
$node = $this->createNode(['type' => 'article', 'title' => 'Test']);
$user = $this->createUser([], NULL, FALSE, ['mail' => 'test@test.com']);
$term = $this->createTerm($vocabulary);

// Submit form
$this->submitForm(['field_name' => 'value'], 'Submit button label');

// Click link
$this->clickLink('Link text');

// Find element
$page = $this->getSession()->getPage();
$element = $page->find('css', '.my-selector');
```

## Running Tests

```bash
# Run all DTT tests
ddev exec vendor/bin/phpunit tests/

# Run specific test
ddev exec vendor/bin/phpunit tests/src/ExistingSite/MyFeatureTest.php

# Run with group filter
ddev exec vendor/bin/phpunit tests/ --group my_module

# Verbose output
ddev exec vendor/bin/phpunit tests/ --verbose
```


