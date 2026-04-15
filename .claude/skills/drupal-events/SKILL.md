---
name: drupal-events
description: Drupal event subscribers — Symfony events (PSR-14), KernelEvents, services.yml tags, and hooks vs events decision guide.
---

# Drupal Event Subscribers

## Example (Best Practice)

```php
// src/EventSubscriber/MyEventSubscriber.php
namespace Drupal\my_module\EventSubscriber;

use Drupal\Core\Session\AccountProxyInterface;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Symfony\Component\HttpKernel\Event\RequestEvent;
use Symfony\Component\HttpKernel\KernelEvents;

final class MyEventSubscriber implements EventSubscriberInterface {

  public function __construct(
    private readonly AccountProxyInterface $currentUser,
  ) {}

  public static function getSubscribedEvents(): array {
    return [
      // Note: Higher priority runs earlier. Default is 0.
      KernelEvents::REQUEST => ['onRequest', 100],
    ];
  }

  public function onRequest(RequestEvent $event): void {
    if (!$event->isMainRequest()) {
      return;
    }

    if (!$this->currentUser->isAuthenticated()) {
      return;
    }

    // Example: log or modify behavior for authenticated users.
  }

}
```

## Register in services.yml

```yaml
services:
  my_module.my_event_subscriber:
    class: Drupal\my_module\EventSubscriber\MyEventSubscriber
    arguments: ['@current_user']
    tags:
      - { name: event_subscriber }
```

## Common Events

| Event | Constant | When |
|---|---|---|
| Request | `KernelEvents::REQUEST` | Every request |
| Response | `KernelEvents::RESPONSE` | Before response sent |
| Terminate | `KernelEvents::TERMINATE` | After response sent |
| Exception | `KernelEvents::EXCEPTION` | On uncaught exception |

## Generate with Drush

```bash
drush generate event-subscriber --answers='{
  "module": "my_module",
  "class": "MyEventSubscriber",
  "event": "kernel.request"
}'
```
