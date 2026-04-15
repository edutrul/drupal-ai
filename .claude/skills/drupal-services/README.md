# drupal-services skill — Developer Notes

## When to use this skill

Use when working with:

- Defining custom services in `services.yml`
- Injecting services into controllers, forms, plugins, or other services
- Using `ContainerInjectionInterface` for controllers and forms
- Using `ContainerFactoryPluginInterface` for plugins
- Using autowiring for OOP hooks and simple services
- Looking up common service IDs and their interfaces

## Mental Model

| Class type | DI pattern |
|---|---|
| Controller / Form | `ContainerInjectionInterface` + `create()` |
| Plugin (Block, etc.) | `ContainerFactoryPluginInterface` + `create()` |
| OOP Hook (`src/Hook/`) | Autowire in services.yml |
| Custom service | Constructor injection, registered in `services.yml` |

> Never use `\Drupal::service()` inside a class — always inject via constructor.

## Example Prompts

- Create a custom service with entity_type.manager and logger injected
- Inject a service into a block plugin
- What is the Drupal service ID for current_user and how do I inject it into a controller?

## Sources

- [Services and Dependency Injection](https://www.drupal.org/docs/drupal-apis/services-and-dependency-injection)
