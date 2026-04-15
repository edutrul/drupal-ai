---
name: create-pr
description: Create a Pull Request from the current branch targeting develop, with correct COS-XXX title format, Jira link in the body, and optional Jira status sync.
allowed-tools: Bash(git branch --show-current:), Bash(git log *:), Bash(git push *:), Bash(gh pr create:), Bash(gh pr view:), Bash(acli jira auth status:), Bash(acli jira workitem view:), Bash(acli jira workitem transition:), Bash(cat .claude/data/mappings.json:)
---

# Create PR

Create a Pull Request from the current branch targeting `develop`, following project conventions.

## Input

No arguments required. Operates on the current branch.

---

## Workflow

### 1. Get current branch

```bash
git branch --show-current
```

Detect the Jira ticket from the branch name (e.g. `COS-356-lucidworks-indexing-endpoints` → `COS-356`).

If no ticket detected → ask the user for the ticket ID before continuing.

---

### 2. Get recent commits for context

```bash
git log origin/develop..HEAD --oneline
```

Use commit messages to understand the scope of the PR.

---

### 3. Push branch if needed

Check if the branch has a remote tracking branch. If not:

```bash
git push -u origin <branch>
```

---

### 4. Single ask — PR details

Display detected info and ask once:

> Branch: **<branch>**
> Jira ticket: **<ticket>**
>
> PR title: (pre-filled as `COS-XXX: <description inferred from commits>`)
> PR description: (leave blank to auto-generate from commits, or type your own)
> Create as draft? (Y/n)

- If user accepts the pre-filled title → use it
- If user edits → use their version
- Default is draft (`Y`)

---

### 5. Create the PR

```bash
gh pr create \
  --base develop \
  --title "<title>" \
  --body "<body>" \
  --draft
```

PR body template:

```text
## Summary

<bullet points from commit messages>

## Jira

<ticket-url>

## Test plan

- [ ]
```

If user chose not to draft → omit `--draft`.

---

### 6. Jira auth check

```bash
acli jira auth status
```

If fails → skip Jira steps silently, list as manual action in summary.

---

### 7. Move Jira ticket to In Progress (if not already)

```bash
acli jira workitem view <ticket>
```

If current status is not `In Progress` → transition it:

```bash
acli jira workitem transition --key <ticket> --status "In Progress"
```

If already `In Progress` → skip silently.

---

### 8. Final summary

| Action | Result |
|--------|--------|
| Branch pushed | ✓ / already up to date |
| PR created | #<number> — <title> |
| Draft | yes / no |
| Jira ticket | <ticket> |
| Jira status | In Progress / skipped (reason) |

Include the PR URL.

---

## Rules

- Always target `develop`
- Title must follow `COS-XXX: Description` format
- Default to draft — the `/ready-pr-in-review` command promotes it when ready
- Never commit or push unrelated changes
- Jira failure must never block PR creation
- Never run `acli jira auth login` automatically — it is interactive
