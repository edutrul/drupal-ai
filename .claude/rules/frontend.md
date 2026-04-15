---
name: frontend
description: Frontend conventions — SDC components, Twig templates, libraries, and theme tooling
---

# Frontend Rules

> Replace `YOUR_THEME` with your theme's machine name (e.g. `custom_theme`).

## Theme Location

`docroot/themes/custom/YOUR_THEME/` — Storybook 9 + ViteJS 6, PostCSS, ESLint, Stylelint, Prettier.

## Components (SDC)

- All UI components live in `components/` as Single Directory Components (SDC)
- Prefer SDC components over ad-hoc Twig templates
- Each component has its own directory: `components/my-component/`
  - `my-component.twig` — template
  - `my-component.component.yml` — component definition
  - `my-component.css` (PostCSS) — scoped styles
  - `my-component.js` (optional) — behavior

## Twig

- Use `{{ variable|t }}` for translatable strings
- Always escape untrusted output — Twig auto-escapes by default, do not use `|raw` unless output is already sanitized markup
- Use `attach_library('YOUR_THEME/library-name')` to attach assets — never inline `<script>` or `<style>` tags
- Debug templates with `{{ dump() }}` locally; never commit debug output

## Libraries

- All JS and CSS must be defined in `YOUR_THEME.libraries.yml` and attached via `attach_library()`
- This enables aggregation in production — inline assets bypass it
- Use `dependencies` in library definitions for load order

## Tooling

- Lint JS with ESLint, CSS with Stylelint — both run in CI
- Format with Prettier — run before committing
- Storybook is the development environment for components — build components there first

## Storybook-First

Develop new components in Storybook before wiring them into Drupal templates. This keeps components decoupled and testable in isolation.
