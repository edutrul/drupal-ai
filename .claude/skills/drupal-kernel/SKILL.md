---
name: drupal-kernel
description: Drupal Kernel tests with KernelTestBase — testing services, database operations, hooks, and entity operations with minimal Drupal bootstrap.
---

# Drupal Kernel Tests

## When to Use

- Testing services that interact with Drupal's service container
- Database operations and entity CRUD
- Hook implementations
- Config operations
- Tests needing a real database but not a full browser

## Basic Structure

```php
// tests/src/Kernel/MyServiceTest.php
namespace Drupal\Tests\my_module\Kernel;

use Drupal\KernelTests\KernelTestBase;
use Drupal\node\Entity\Node;
use Drupal\node\Entity\NodeType;

/**
 * Tests MyService integration.
 *
 * @group my_module
 */
final class MyServiceTest extends KernelTestBase {

  protected static $modules = [
    'system',
    'user',
    'node',
    'field',
    'text',
    'my_module',
  ];

  protected function setUp(): void {
    parent::setUp();

    $this->installSchema('system', ['sequences']);
    $this->installSchema('node', ['node_access']);
    $this->installEntitySchema('user');
    $this->installEntitySchema('node');
    $this->installConfig('my_module');

    // Create content type
    NodeType::create(['type' => 'article', 'name' => 'Article'])->save();
  }

  public function testServiceProcessesNode(): void {
    $node = Node::create([
      'type' => 'article',
      'title' => 'Test Node',
      'status' => 1,
    ]);
    $node->save();

    $service = $this->container->get('my_module.my_service');
    $result = $service->process($node);

    $this->assertTrue($result);
  }

}
```

## installEntitySchema vs installSchema

```php
// For entity types (creates entity tables)
$this->installEntitySchema('node');
$this->installEntitySchema('user');
$this->installEntitySchema('taxonomy_term');
$this->installEntitySchema('paragraph');

// For specific table schemas (not entity-based)
$this->installSchema('system', ['sequences', 'key_value']);
$this->installSchema('node', ['node_access']);

// For config from a module's config/install
$this->installConfig('my_module');
$this->installConfig(['node', 'user']);
```

## Creating Test Users

```php
use Drupal\user\Entity\User;

$user = User::create([
  'name' => 'test_user',
  'mail' => 'test@example.com',
  'status' => 1,
]);
$user->save();

// Set as current user
$this->setCurrentUser($user);
```

## Testing Config

```php
$config = $this->config('my_module.settings');
$this->assertTrue($config->get('enabled'));

// Update config
$this->config('my_module.settings')
  ->set('enabled', FALSE)
  ->save();
```

## Testing Hooks

```php
public function testHookNodePresave(): void {
  $node = Node::create(['type' => 'article', 'title' => 'Test']);
  $node->save();

  // Reload to verify hook ran
  $node = Node::load($node->id());
  $this->assertEquals('Modified by hook', $node->get('field_processed')->value);
}
```

