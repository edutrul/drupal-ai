---
name: drupal-render
description: Drupal render arrays — structure, cache metadata (tags, contexts, max-age), render elements, and markup safety.
---

# Drupal Render Arrays

## Basic Structure

```php
$build = [
  '#type' => 'container',
  '#attributes' => ['class' => ['my-wrapper']],
  'content' => [
    '#markup' => $this->t('Hello world'),
  ],
];
```

## Cache Metadata (Always Required)

```php
$build['content'] = [
  '#markup' => $output,
  '#cache' => [
    'tags' => ['node:' . $node->id(), 'node_list'],
    'contexts' => ['user.permissions', 'url.query_args'],
    'max-age' => 3600,
  ],
];
```

### Cache Tag Conventions

| Tag | Invalidates when |
|---|---|
| `node:123` | Node 123 is saved |
| `node_list` | Any node is created/deleted |
| `user:456` | User 456 is saved |
| `taxonomy_term:789` | Term 789 is saved |
| `config:my_module.settings` | Config is saved |
| `block_content:1` | Block content is saved |

### Cache Contexts

| Context | Varies by |
|---|---|
| `user` | Current user identity |
| `user.permissions` | User's permissions |
| `user.roles` | User's roles |
| `url` | Full URL |
| `url.path` | URL path only |
| `url.query_args` | Query string |
| `languages` | Current language |
| `session` | Session data |
| `theme` | Active theme |

## Markup Safety

```php
// Plain text — always safe
$build['#plain_text'] = $user_input;

// Trusted markup — use Markup class
use Drupal\Core\Render\Markup;
$build['#markup'] = Markup::create('<strong>Safe</strong>');

// User input in markup — filter first
use Drupal\Component\Utility\Xss;
$build['#markup'] = Markup::create(Xss::filter($user_input));

// Admin-level markup — allows more tags
$build['#markup'] = Markup::create(Xss::filterAdmin($html));
```

## Render Elements

```php
// HTML tag
$build['heading'] = [
  '#type' => 'html_tag',
  '#tag' => 'h2',
  '#value' => $this->t('Title'),
  '#attributes' => ['class' => ['my-heading']],
];

// Link
$build['link'] = [
  '#type' => 'link',
  '#title' => $this->t('Go'),
  '#url' => Url::fromRoute('entity.node.canonical', ['node' => $nid]),
  '#attributes' => ['class' => ['button']],
];

// Entity view
$build['node'] = $this->entityTypeManager
  ->getViewBuilder('node')
  ->view($node, 'teaser');

// Inline template
$build['inline'] = [
  '#type' => 'inline_template',
  '#template' => '<div class="{{ class }}">{{ content }}</div>',
  '#context' => ['class' => 'my-class', 'content' => $content],
];
```

## Lazy Builder (Uncacheable Content)

```php
$build['dynamic'] = [
  '#lazy_builder' => [
    'my_module.service:buildDynamicContent',
    [$arg1, $arg2],
  ],
  '#create_placeholder' => TRUE,
];
```

## Rendering Programmatically

```php
// Inject renderer service
public function __construct(
  private readonly RendererInterface $renderer,
) {}

// Render to string
$html = $this->renderer->render($build);

// Render in isolated context (doesn't bubble cache)
$html = $this->renderer->renderInIsolation($build);
```

