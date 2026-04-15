---
name: drupal-services
description: Drupal services and dependency injection for controllers, forms, and plugins. Inject services into block plugins, custom plugins, and services using ContainerFactoryPluginInterface and services.yml.
---

# Drupal Services & Dependency Injection

## Core Principle

**Never use `\Drupal::service()` in classes — inject via constructor.**

## Dependency Injection Patterns

### Controllers & Forms (ContainerInjectionInterface)

```php
use Drupal\Core\DependencyInjection\ContainerInjectionInterface;
use Symfony\Component\DependencyInjection\ContainerInterface;

final class MyController implements ContainerInjectionInterface {
  public function __construct(
    private readonly AccountProxyInterface $currentUser,
    private readonly EntityTypeManagerInterface $entityTypeManager,
  ) {}

  public static function create(ContainerInterface $container): static {
    return new static(
      $container->get('current_user'),
      $container->get('entity_type.manager'),
    );
  }
}
```

### Plugins (ContainerFactoryPluginInterface)

```php
use Drupal\Core\Plugin\ContainerFactoryPluginInterface;

final class MyBlock extends BlockBase implements ContainerFactoryPluginInterface {
  public function __construct(
    array $configuration,
    string $plugin_id,
    mixed $plugin_definition,
    private readonly EntityTypeManagerInterface $entityTypeManager,
  ) {
    parent::__construct($configuration, $plugin_id, $plugin_definition);
  }

  public static function create(ContainerInterface $container, array $configuration, $plugin_id, $plugin_definition): static {
    return new static(
      $configuration,
      $plugin_id,
      $plugin_definition,
      $container->get('entity_type.manager'),
    );
  }
}
```

## Service Definition (services.yml)

```yaml
services:
  my_module.my_service:
    class: Drupal\my_module\Service\MyService
    arguments:
      - '@entity_type.manager'
      - '@current_user'
      - '@logger.factory'

  # With autowiring (Drupal 10.3+)
  Drupal\my_module\Hook\MyModuleHooks:
    autowire: true
```

## Common Service IDs

| Service ID | Interface |
|---|---|
| `entity_type.manager` | `EntityTypeManagerInterface` |
| `current_user` | `AccountProxyInterface` |
| `logger.factory` | `LoggerChannelFactoryInterface` |
| `database` | `Connection` |
| `config.factory` | `ConfigFactoryInterface` |
| `renderer` | `RendererInterface` |
| `messenger` | `MessengerInterface` |
| `date.formatter` | `DateFormatterInterface` |
| `language_manager` | `LanguageManagerInterface` |
| `path_alias.manager` | `AliasManagerInterface` |
| `module_handler` | `ModuleHandlerInterface` |
| `cache.default` | `CacheBackendInterface` |

## StringTranslationTrait

Add `use StringTranslationTrait;` to classes that need `$this->t()` without full DI of the translation service.

## Generating Services with Drush

```bash
drush generate service --answers='{
  "module": "my_module",
  "service_name": "my_module.helper",
  "class": "HelperService",
  "services": ["entity_type.manager", "logger.factory"]
}'
```

