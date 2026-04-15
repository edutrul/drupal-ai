---
name: drupal-paragraphs
description: Drupal Paragraphs module — accessing paragraph entities, rendering, altering paragraph forms, and patterns for custom paragraph behavior.
---

# Drupal Paragraphs

## Accessing Paragraphs from a Node

```php
use Drupal\paragraphs\Entity\Paragraph;

// Get all paragraphs from a field
$items = $node->get('field_content')->referencedEntities();
foreach ($items as $paragraph) {
  /** @var \Drupal\paragraphs\Entity\Paragraph $paragraph */
  $bundle = $paragraph->bundle();
  $value = $paragraph->get('field_text')->value;
}

// Get first paragraph
$paragraph = $node->get('field_content')->first()?->entity;
```

## Creating Paragraphs Programmatically

```php
$paragraph = Paragraph::create([
  'type' => 'text_block',
  'field_title' => 'My Title',
  'field_body' => [
    'value' => 'Body content',
    'format' => 'basic_html',
  ],
]);
$paragraph->save();

$node->get('field_content')->appendItem([
  'target_id' => $paragraph->id(),
  'target_revision_id' => $paragraph->getRevisionId(),
]);
$node->save();
```

## Altering Paragraph Forms

```php
#[Hook('field_widget_single_element_paragraphs_form_alter')]
public function fieldWidgetParagraphsFormAlter(array &$element, FormStateInterface $form_state, array $context): void {
  $paragraph = $element['#paragraph'];
  if ($paragraph->bundle() === 'text_block') {
    // Alter the text_block paragraph form element.
    $element['subform']['field_title']['#access'] = FALSE;
  }
}
```

## Rendering Paragraphs

```php
// Build render array for a paragraph
$view_builder = $this->entityTypeManager->getViewBuilder('paragraph');
$build = $view_builder->view($paragraph, 'default');
```

## Paragraph in Twig

```twig
{# Render paragraph field #}
{{ content.field_content }}

{# Iterate paragraphs #}
{% for item in content.field_content['#items'] %}
  {{ item.entity.field_text.value }}
{% endfor %}
```

## Common Bundle Check Pattern

```php
foreach ($node->get('field_content')->referencedEntities() as $paragraph) {
  /** @var \Drupal\paragraphs\Entity\Paragraph $paragraph */
  switch ($paragraph->bundle()) {
    case 'text_block':
      // Handle text block.
      break;
    case 'image_block':
      // Handle image block.
      break;
  }
}
```

