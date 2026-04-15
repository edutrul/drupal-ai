# Drupal Claude — AI Skills for Drupal 11 Development

A production-tested collection of Claude Code skills, agents, commands, and rules for Drupal 11 development. Battle-tested on a platform powering 150+ sites.

## Install a skill

```bash
npx skills add https://github.com/edutrul/drupal-ai --skill SKILL_NAME
```

## Available Skills

### Local Development
| Skill | Description |
|---|---|
| `ddev-expert` | DDEV local environment configuration and troubleshooting |
| `docker-local` | Docker Compose local development patterns |

### Drupal Core Patterns
| Skill | Description |
|---|---|
| `drupal-access` | Permissions, access callbacks, `AccessResult`, entity access |
| `drupal-caching` | Cache tags, contexts, max-age, bins, invalidation |
| `drupal-entity-api` | Loading, creating, updating, deleting entities |
| `drupal-events` | Symfony events, `KernelEvents`, services.yml tags |
| `drupal-hooks` | Drupal 11 OOP and procedural hooks |
| `drupal-menus` | `links.menu.yml`, `links.task.yml`, programmatic manipulation |
| `drupal-plugins` | Block, Field, Condition, Filter plugins with attributes |
| `drupal-render` | Render arrays, cache metadata, elements, markup safety |
| `drupal-routes` | `routing.yml`, controllers, parameters, upcasting, links |
| `drupal-security` | CSRF, XSS, SQL injection, route permissions, file uploads |
| `drupal-services` | DI for controllers, forms, plugins, `services.yml` |
| `drupal-state` | State API for runtime persistence across requests |
| `drupal-taxonomy` | Terms, vocabularies, hierarchy, reference fields |

### Forms
| Skill | Description |
|---|---|
| `drupal-form-ajax` | AJAX form callbacks and custom `AjaxCommands` |
| `drupal-form-alter` | `hook_form_alter`, OOP hooks, hiding fields, adding handlers |
| `drupal-form-api` | `FormBase`/`ConfigFormBase`, elements, validate/submit, DI |
| `drupal-form-validation` | `validateForm()`, inline errors, conditional validation |

### Fields & Content
| Skill | Description |
|---|---|
| `drupal-fields` | Field types, widgets, formatters, storage, multi-value access |
| `drupal-paragraphs` | Accessing, rendering, altering paragraph entities |
| `drupal-taxonomy` | Terms, vocabularies, hierarchy, reference fields |

### Frontend
| Skill | Description |
|---|---|
| `drupal-javascript` | Behaviors, `libraries.yml`, `drupalSettings`, AJAX commands |
| `drupal-twig` | Templates, auto-escaping, translation, SDC components |

### Data & Search
| Skill | Description |
|---|---|
| `drupal-queries` | Database abstraction layer — Select, Insert, Update, Delete |
| `drupal-search-api` | Index config, boost processors, field types, reindexing |
| `drupal-migrations` | D7-to-D11 upgrades, CSV/JSON API imports, custom plugins |

### Configuration & Tooling
| Skill | Description |
|---|---|
| `drupal-composer` | Requiring modules, updates, patches via `composer-patches` |
| `drupal-config` | Config import/export, preview, splits, environment syncing |
| `drupal-contrib-mgmt` | Contrib upgrade triage, patches, D11 compatibility |
| `drupal-debugging` | Devel, Drush watchdog, Twig debug, XDebug |
| `drupal-drush` | Drush commands, generators, field creation, scaffolding |

### Testing
| Skill | Description |
|---|---|
| `drupal-dtt` | DTT ExistingSite tests against a live Drupal site |
| `drupal-kernel` | `KernelTestBase` tests for services, DB, hooks, entities |
| `drupal-unit` | `UnitTestCase` for isolated PHP logic, no bootstrap |

## Using with Other AI Tools

Skills are native to Claude Code, but the underlying knowledge is plain markdown — reusable anywhere.

### OpenAI Codex

Codex reads skills from `.codex/skills/`. Symlink it to `.claude/skills/` so both tools share the same installed skills automatically:

```bash
ln -s ../.claude/skills .codex/skills
```

Run once after cloning. Any skill added via `npx skills add` is immediately available to both Claude Code and Codex. See [`.codex/README.md`](.codex/README.md) for details.

### Cursor

Drop skill files into `.cursor/rules/` — Cursor loads them automatically as context rules.

**Manual step:** after installing skills via `npx skills add`, symlink or copy them:

```bash
mkdir -p .cursor/rules
# Symlink all installed skills as Cursor rules
ln -s ../.claude/skills/*.md .cursor/rules/
```

### GitHub Copilot

Copilot reads `.github/copilot-instructions.md` as custom instructions.

**Manual step:** concatenate the skills you want into that file:

```bash
cat .claude/skills/drupal-hooks.md .claude/skills/drupal-services.md >> .github/copilot-instructions.md
```

### Where skill content lives

After running `npx skills add`, skill files are stored in `.claude/skills/`. These are plain markdown — copy, symlink, or paste them into any tool's context system.

```
.claude/skills/
├── drupal-hooks.md
├── drupal-services.md
└── ...
```

## Sponsors

Development time sponsored by [heydru!](https://heydru.com)

## Credits

Inspired by and built with reference to:
- [drupal-at-your-fingertips](https://skills.sh/grasmash/drupal-claude-skills/drupal-at-your-fingertips) by Selwyn Polit / Greg Sherwood
- [drupal-expert](https://skills.sh/madsnorgaard/agent-resources/drupal-expert) by Mads Nørgaard

## License

MIT — see [LICENSE](LICENSE)
