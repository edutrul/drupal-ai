# drupal-events skill — Developer Notes

## When to use this skill

Use when working with:

- Reacting to HTTP request/response lifecycle (`KernelEvents`)
- Building event subscribers with `EventSubscriberInterface`
- Registering event subscribers in `services.yml`
- Controlling subscriber execution order with priority
- Deciding between an event subscriber and an OOP hook

## Mental Model

| Pattern | Location | Registration |
|---|---|---|
| Event subscriber | `src/EventSubscriber/` | `services.yml` with `event_subscriber` tag |
| OOP Hook | `src/Hook/` | Auto (Drupal 11.1+) |

| Use Events When | Use Hooks When |
|---|---|
| HTTP lifecycle (request, response, exception) | form_alter, entity hooks, theme hooks |
| Symfony / PSR-14 events | Extending Drupal core/contrib behavior |

## Example Prompts

- Create an event subscriber for kernel.request
- In Drupal, create an event subscriber to redirect unauthenticated users to login on certain routes.
- React to the kernel.response event to modify headers
- Should I use an event subscriber or a hook?

## Hooks vs Events Decision Guide

Use **event subscribers** when:
- Reacting to HTTP lifecycle (request, response, exception)
- Working with Symfony or PSR-14 events
- Building decoupled, service-oriented logic

Prefer **hooks** when:
- Altering forms, entities, or render arrays
- Extending Drupal core or contrib behavior
- Using standard Drupal extension points

## Mental Model

- Event subscribers are services tagged with `event_subscriber`
- They react to dispatched events (Symfony / PSR-14)
- Execution order is controlled by priority (higher runs earlier)

## Source

[Hooks vs Events](https://www.specbee.com/blogs/hooks-vs-events-in-drupal-making-informed-choice)
