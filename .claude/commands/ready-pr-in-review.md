---
name: ready-pr-in-review
description: Move a PR from Draft to Ready for Review, assign a reviewer, add labels, and sync the related Jira ticket to In Review with the correct assignee.
allowed-tools: Bash(gh pr list:), Bash(gh pr view:), Bash(gh pr ready:), Bash(gh pr edit:), Bash(gh label list:), Bash(gh label create:), Bash(acli jira auth status:), Bash(acli jira workitem view:), Bash(acli jira workitem transition:), Bash(acli jira workitem assign:), Bash(acli jira workitem comment create:), Bash(git remote -v:), Bash(cat .claude/data/mappings.json:), Read, Grep
---

# Put PR in Review

Prepares a Pull Request for technical review and synchronizes the related Jira ticket.

## Input

- PR URL or PR number
  If not provided → run `gh pr list --json number,title,isDraft,headRefName` and ask.

---

## Workflow

### 1. Identify and display the PR

```bash
gh pr view <number-or-url> --json number,title,isDraft,headRefName,body,url,author
```

Display:
- PR number, title, branch
- Draft status
- Author
- Jira ticket (detected from title, body, or branch — e.g. `COS-703`)

---

### 2. Single ask — reviewer + labels

First, load the mappings:

```bash
cat .claude/data/mappings.json
```

Build a numbered list from `github_to_jira` entries, excluding the PR author.
Format each entry as: `<N>. <name> (@<github-username>)`

Ask once:

> PR **#<number>** — <title>
>
> Who is the code reviewer?
> [numbered list from mappings, author excluded]
> (or type a different GitHub username)
>
> Any labels to add? (leave blank to skip — common: `backend`, `frontend`, `bug`, `enhancement`, `drupal`)

If reviewer picks a number → resolve to that GitHub username automatically.
If labels are left blank → skip label steps entirely, do not ask again.

---

### 3. Move PR to Ready for Review

If PR is Draft:

```bash
gh pr ready <number-or-url>
```

If already ready → skip silently.

---

### 4. Assign reviewer in GitHub

```bash
gh pr edit <number-or-url> --add-reviewer "<github-username>"
```

---

### 5. Add labels (only if provided in step 2)

Check existing labels:

```bash
gh label list
```

Create any missing ones:

```bash
gh label create "<label>" --color "84b6eb"
```

Assign:

```bash
gh pr edit <number-or-url> --add-label "<label>"
```

---

### 6. Jira auth check

```bash
acli jira auth status
```

If fails → skip all Jira steps silently, list them as manual actions in the final summary.
Do not ask the user to log in. To fix outside this command: `acli jira auth login`

---

### 7. Verify Jira ticket

```bash
acli jira workitem view <ticket>
```

If ticket not found → skip Jira steps, report in summary.

---

### 8. Move Jira ticket to In Review

> The UI shows **"Ready for Code Review"** but the CLI status name is **`In Review`**.

```bash
acli jira workitem transition --key <ticket> --status "In Review"
```

---

### 9. Resolve Jira assignee

Load shared mappings:

```bash
cat .claude/data/mappings.json
```

Resolution priority:
1. Reviewer GitHub username found in mappings → use mapped `email` directly
2. Not found → fall back to Jira user lookup
3. No confident match → ask the user before assigning

```bash
acli jira workitem assign --key <ticket> --assignee "<email>"
```

Always use email from mappings — never display names, account-id, or assignee-id.

---

### 10. Add Jira comment with full PR content

Fetch the full PR details:

```bash
gh pr view <number-or-url> --json title,body,url,author,headRefName
```

Build the Jira comment by combining:
- PR title
- PR URL
- Author (GitHub username → full name from mappings if available)
- Reviewer (full name from mappings if available)
- The **full PR body** as-is (preserve all sections, headings, code blocks)

```bash
acli jira workitem comment create --key <ticket> --body "<comment>"
```

Comment body template:

```text
This ticket is ready for code review.

PR: <github-pr-url>
Author: <full-name>
Reviewer: <reviewer-full-name>

---

<full PR body copied verbatim>
```

This gives the reviewer everything in Jira without needing to open GitHub.

---

### 11. Final summary

Display:

| Action | Result |
|--------|--------|
| PR | #<number> — <title> |
| Draft → Ready | ✓ / already ready |
| Reviewer assigned | <github-username> |
| Labels added | <labels> / skipped |
| Jira ticket | <ticket> |
| Jira status | In Review / skipped (reason) |
| Jira assignee | <name> / skipped (reason) |
| Jira comment | ✓ / skipped |

List any remaining manual steps if Jira was skipped.

---

## Rules

- Do not modify a PR without clearly identifying it
- If URL provided, do not ask for PR number
- Only create labels if the user confirmed them in step 2
- Always use `.claude/data/mappings.json` for GitHub → Jira email resolution
- Never use display names, account-id, or assignee-id for Jira assignment
- Jira auth failure → skip Jira silently, never block the GitHub flow
- Never run `acli jira auth login` automatically — it is interactive
- CLI status name is `In Review`, not the UI label "Ready for Code Review"
- `acli jira workitem view` uses a positional argument (no `--key`)
- `acli jira workitem transition`, `assign`, `comment create` use `--key`
