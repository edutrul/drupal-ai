# drupal-render skill — Developer Notes

## When to use this skill

Use when working with:

- Building render arrays in controllers, blocks, or services
- Adding `#cache` metadata (tags, contexts, max-age)
- Safely rendering user-provided HTML (XSS prevention)
- Using render elements (`html_tag`, `link`, `inline_template`)
- Rendering entities programmatically with view builders
- Using `#lazy_builder` for uncacheable dynamic content
- Rendering to string with `RendererInterface`

## Mental Model

| Key | Purpose |
|---|---|
| `#markup` | Trusted HTML — must use `Markup::create()` |
| `#plain_text` | Auto-escaped plain text — always safe for user input |
| `#type` | Render element type (`html_tag`, `link`, `container`, etc.) |
| `#cache` | Cache tags, contexts, max-age |
| `#lazy_builder` | Deferred render for uncacheable content |

## Example Prompts

- Build a render array with correct cache metadata
- Safely render user-provided HTML in a render array
- Render a node entity as a teaser in code
- Use Drupal render array #type = inline_template to build a small custom template

## Sources

- [Render API](https://www.drupal.org/docs/drupal-apis/render-api)
- [Cache API](https://www.drupal.org/docs/drupal-apis/cache-api)
