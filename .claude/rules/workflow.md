---
name: workflow
description: Git and PR workflow conventions — branch naming, commit messages, PR process, and base branch
---

# Workflow Rules

## Base Branch

- Main branch is `develop` — all feature branches are cut from and merged back into `develop`
- `main` is the production/release branch — do not target it for PRs unless explicitly instructed

## Branch Naming

Format: `COS-XXX-short-description`

- Prefix with the Jira ticket ID
- Lowercase, hyphens only
- Keep the description short and meaningful

Examples:
- `COS-356-lucidworks-indexing-endpoints`
- `COS-808-accordion-overflow-fix`

## Commit Messages

Format: `COS-XXX: Short imperative description`

- Prefix with the Jira ticket ID followed by a colon
- Use imperative mood ("Add", "Fix", "Update" — not "Added", "Fixed")
- Keep the first line concise

Examples:
- `COS-356: Add Lucidworks indexing endpoints`
- `COS-808: Fix accordion overflow with shadow indicator`

## Pull Requests

- PR title should mirror the commit message format: `COS-XXX: Description`
- Target `develop` unless otherwise specified
- Link the Jira ticket in the PR body
- Use the `/ready-pr-in-review` command to move a PR through the review workflow
