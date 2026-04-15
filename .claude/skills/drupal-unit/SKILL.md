---
name: drupal-unit
description: Drupal Unit tests with UnitTestCase — testing isolated PHP logic with no Drupal bootstrap, mocking dependencies.
---

# Drupal Unit Tests

## When to Use

- Pure PHP logic with no Drupal dependencies
- Utility functions, data transformations, value objects
- Classes where all dependencies can be mocked

## Basic Structure

```php
// tests/src/Unit/MyServiceTest.php
namespace Drupal\Tests\my_module\Unit;

use Drupal\Tests\UnitTestCase;
use Drupal\my_module\Service\MyService;
use Psr\Log\LoggerInterface;

/**
 * @coversDefaultClass \Drupal\my_module\Service\MyService
 * @group my_module
 */
final class MyServiceTest extends UnitTestCase {

  private MyService $service;

  protected function setUp(): void {
    parent::setUp();

    $logger = $this->createMock(LoggerInterface::class);
    $this->service = new MyService($logger);
  }

  /**
   * @covers ::processData
   */
  public function testProcessData(): void {
    $input = ['foo' => 'bar'];
    $result = $this->service->processData($input);

    $this->assertArrayHasKey('processed', $result);
    $this->assertTrue($result['processed']);
  }

  /**
   * @covers ::processData
   */
  public function testProcessDataWithEmptyInput(): void {
    $this->expectException(\InvalidArgumentException::class);
    $this->service->processData([]);
  }

}
```

## Mocking with PHPUnit

```php
// Mock a simple interface
$mock = $this->createMock(SomeInterface::class);
$mock->method('someMethod')->willReturn('value');

// Mock with argument matching
$mock->expects($this->once())
  ->method('someMethod')
  ->with($this->equalTo('expected-arg'))
  ->willReturn('result');

// Mock throwing exception
$mock->method('someMethod')->willThrowException(new \RuntimeException('Error'));

// Stub multiple calls
$mock->method('someMethod')
  ->willReturnMap([
    ['arg1', 'result1'],
    ['arg2', 'result2'],
  ]);
```

## Mocking Drupal Translation (t())

```php
// UnitTestCase provides getStringTranslationStub()
$this->service = new MyService(
  $this->getStringTranslationStub()
);
```

## Mocking Logger

```php
// Expect a specific log message
$logger = $this->createMock(LoggerInterface::class);
$logger->expects($this->once())
  ->method('error')
  ->with($this->stringContains('Failed to process'));
```

## Running Tests

Examples assume a `docroot/`-based Drupal project. If your project uses `web/` or another document root, adjust paths accordingly.

```bash
# Run specific test file
ddev exec vendor/bin/phpunit docroot/modules/custom/my_module/tests/src/Unit/MyServiceTest.php

# Run all unit tests for a module
ddev exec vendor/bin/phpunit docroot/modules/custom/my_module/tests/src/Unit/

# Run with verbose output
ddev exec vendor/bin/phpunit --verbose docroot/modules/custom/my_module/tests/
```
