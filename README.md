# Drupal AI

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Drupal 11](https://img.shields.io/badge/Drupal-11-0678BE?logo=drupal&logoColor=white)](https://www.drupal.org)
[![Claude Code](https://img.shields.io/badge/Claude_Code-compatible-blueviolet)](https://claude.ai/code)
[![Codex](https://img.shields.io/badge/Codex-compatible-412991)](https://openai.com/codex)
[![skills.sh](https://img.shields.io/badge/skills.sh-listed-brightgreen)](https://skills.sh)

A production-tested AI toolkit for Drupal 11 development — compatible with Claude Code, OpenAI Codex, Cursor, and GitHub Copilot.

This repository serves a dual purpose:

1. **Active Drupal 11 project** — the AI configuration is actively used on a real Drupal 11 / DDEV / Acquia Cloud project.
2. **Reusable contribution** — the `.claude/` folder is project-agnostic and can be dropped into any Drupal project.

---

## What's Included

### Skills (`/skills`)

Invoke-on-demand reference knowledge loaded only when the task requires it, keeping context lean.

| Skill | Description |
|---|---|
| `ddev-expert` | DDEV local environment configuration and troubleshooting |
| `docker-local` | Docker Compose local development patterns |
| `drupal-access` | Permissions, access callbacks, `AccessResult`, entity access |
| `drupal-caching` | Cache tags, contexts, max-age, bins, invalidation |
| `drupal-composer` | Requiring modules, updates, patches via `composer-patches` |
| `drupal-config` | Config import/export, preview, splits, environment syncing |
| `drupal-contrib-mgmt` | Contrib upgrade triage, patches, D11 compatibility |
| `drupal-debugging` | Devel, Drush watchdog, Twig debug, XDebug |
| `drupal-drush` | Drush commands, generators, field creation, scaffolding |
| `drupal-dtt` | DTT ExistingSite tests against a live Drupal site |
| `drupal-entity-api` | Loading, creating, updating, deleting entities |
| `drupal-events` | Symfony events, `KernelEvents`, services.yml tags |
| `drupal-fields` | Field types, widgets, formatters, storage, multi-value access |
| `drupal-form-ajax` | AJAX form callbacks and custom `AjaxCommands` |
| `drupal-form-alter` | `hook_form_alter`, OOP hooks, hiding fields, adding handlers |
| `drupal-form-api` | `FormBase`/`ConfigFormBase`, elements, validate/submit, DI |
| `drupal-form-validation` | `validateForm()`, inline errors, conditional validation |
| `drupal-hooks` | Drupal 11 OOP and procedural hooks |
| `drupal-javascript` | Behaviors, `libraries.yml`, `drupalSettings`, AJAX commands |
| `drupal-kernel` | `KernelTestBase` tests for services, DB, hooks, entities |
| `drupal-menus` | `links.menu.yml`, `links.task.yml`, programmatic manipulation |
| `drupal-migrations` | D7-to-D11 upgrades, CSV/JSON API imports, custom plugins |
| `drupal-paragraphs` | Accessing, rendering, altering paragraph entities |
| `drupal-plugins` | Block, Field, Condition, Filter plugins with attributes |
| `drupal-queries` | Database abstraction layer — Select, Insert, Update, Delete |
| `drupal-render` | Render arrays, cache metadata, elements, markup safety |
| `drupal-routes` | `routing.yml`, controllers, parameters, upcasting, links |
| `drupal-search-api` | Index config, boost processors, field types, reindexing |
| `drupal-security` | CSRF, XSS, SQL injection, route permissions, file uploads |
| `drupal-services` | DI for controllers, forms, plugins, `services.yml` |
| `drupal-state` | State API for runtime persistence across requests |
| `drupal-taxonomy` | Terms, vocabularies, hierarchy, reference fields |
| `drupal-twig` | Templates, auto-escaping, translation, SDC components |
| `drupal-unit` | `UnitTestCase` for isolated PHP logic, no bootstrap |

### Agents (`/agents`)

Specialized subagents Claude can delegate to for focused work.

| Agent | Role |
|---|---|
| `code-reviewer` | Bug detection, security issues, quality review |
| `done-gate` | Runtime validator — builds, tests, `drush cr` |
| `drupal-backend-dev` | Modules, hooks, services, routing, Drush commands |
| `drupal-contributor` | Writing patches, contributing code to drupal.org |
| `drupal-frontend-dev` | Twig templates, PostCSS, JavaScript in Drupal themes |
| `drupal-reviewer` | Drupal-specific code review (quality, security, best practices) |
| `drupal-site-builder` | Content types, fields, taxonomy, menus, paragraphs |
| `drupal-test-writer` | ExistingSite tests that reproduce bugs and verify fixes |
| `quality-gate` | Static code review before committing |
| `researcher` | Codebase exploration, architecture, execution path tracing |

### Commands (`/commands`)

Slash commands for common workflows.

| Command | What it does |
|---|---|
| `/code-review` | Full review of a branch, PR, or Jira ticket — PHPCS, PHPStan, best practices |
| `/config-export` | Export Drupal configuration with proper workflow |
| `/create-pr` | Create a PR targeting the base branch with standard title format |
| `/drush-check` | Common Drush checks to verify site health |
| `/performance-check` | Analyze site performance and caching configuration |
| `/ready-pr-in-review` | Move a PR from Draft to Ready for Review, assign reviewer |
| `/review-pr` | Review a GitHub PR end to end |
| `/security-audit` | Audit the site for security issues and vulnerabilities |

### Rules (`/rules`)

Always-loaded context files that shape AI behavior in this project.

| Rule | What it enforces |
|---|---|
| `docblocks.md` | Drupal-style docblocks, `@param`/`@return`/`@throws` conventions |
| `drupal.md` | Prefer DI, follow module conventions, use Drupal patterns |
| `frontend.md` | SDC components, Twig escaping, `libraries.yml`, Storybook-first |
| `php.md` | `final` classes, `private` properties, `readonly` DI, immutability |
| `phpcs.md` | `phpcs.xml` as source of truth, flag violations during review |
| `project.md` | Generic fallback — **copy from `project.example.md`** to add your prefix conventions |
| `testing.md` | DTT ExistingSite only, location, structure, what to test |
| `tooling.md` | All commands run inside DDEV |
| `workflow.md` | Branch naming, commit message format, PR target branch |

### Hooks (`/hooks`)

Shell scripts triggered automatically by AI tool events (Claude Code hooks).

- `session-start.sh` — runs on startup and resume; checks DDEV status, git branch, site health
- `session-resume.sh` — runs after `/clear` or `/compact`; re-establishes context

> **Note:** Both hooks suppress the branch name when on `develop`, treating it as the default branch. If your project uses `main` as the default, update the `BRANCH != "develop"` check in both scripts.

---

## Setup for a New Project

### 1. Copy the `.claude/` folder

```bash
cp -r /path/to/this-repo/.claude /path/to/your-project/.claude
```

### 2. Generate your `CLAUDE.md` / `AGENTS.md`

`CLAUDE.example.md` (Claude Code) and `AGENTS.example.md` (Codex) are production-grade references. Rather than editing by hand, paste this prompt into your AI tool:

```
Read `CLAUDE.example.md` and help me create my own `CLAUDE.md` for a new Drupal project.
Ask me one section at a time about: DDEV project name, module prefix, theme name,
custom modules, hosting platform, base branch, and CI/CD setup.
```

### 3. Set up team mappings (GitHub + Jira users)

If your project uses GitHub PRs and Jira, the PR commands (`/create-pr`, `/review-pr`, `/ready-pr-in-review`) rely on a GitHub username → Jira name/email mapping. Without it, reviewer assignment and Jira sync won't work.

```bash
cp .claude/data/mappings.example.json .claude/data/mappings.json
```

Edit `mappings.json` and add your team's entries.

### 4. Adjust `settings.json`

Review `.claude/settings.json` and update the `permissions` block to match your toolchain. The defaults assume DDEV + GitHub CLI. If you use Acquia CLI, copy `settings.local.example.json` to `settings.local.json` and add the `acli` entries.

### 5. Adjust workflow rules

Edit `.claude/rules/workflow.md` to match your branch naming, commit format, and PR conventions.

---

## Project-Specific Files (gitignored)

These files are gitignored because they contain project-specific or sensitive data. Create them from the provided examples:

| Gitignored file | Create from |
|---|---|
| `CLAUDE.md` | `CLAUDE.example.md` |
| `AGENTS.md` | `AGENTS.example.md` |
| `.claude/data/mappings.json` | `.claude/data/mappings.example.json` |
| `.claude/settings.local.json` | `.claude/settings.local.example.json` |

---

## Author

**Eduardo Telaya** — [eduardotelaya.com](https://eduardotelaya.com) · [LinkedIn](https://www.linkedin.com/in/edutrul/)

---

## Credits

Inspired by and built with reference to:

- [drupal-at-your-fingertips](https://skills.sh/grasmash/drupal-claude-skills/drupal-at-your-fingertips) by Selwyn Polit / Greg Sherwood — the original Drupal Claude skills reference
- [drupal-expert](https://skills.sh/madsnorgaard/agent-resources/drupal-expert) by Mads Nørgaard — comprehensive Drupal agent resource

---

## About This Project

This configuration is battle-tested on a production Drupal 11 platform powering 150+ sites, running on DDEV locally and deployed to Acquia Cloud via GitHub Actions.

Stack: Drupal 11 / PHP 8.3 / MySQL 8.0 / DDEV / Acquia Cloud / Storybook 9 + ViteJS 6.

The `.claude/` folder is intentionally decoupled from the Drupal codebase so it can be maintained and contributed independently. Codex users can symlink `.claude/skills` into `.codex/skills` — see [`.codex/README.md`](.codex/README.md).
