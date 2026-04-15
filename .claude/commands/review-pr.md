---
name: review-pr
description: Review a GitHub Pull Request end to end. Use when the user shares a GitHub PR URL or PR number and wants the PR prepared locally for review, analyzed using project rules, optionally commented on in GitHub, and optionally synchronized to Jira based on the review outcome.
allowed-tools: Bash(gh auth status:), Bash(gh auth switch:), Bash(gh pr view:), Bash(gh pr diff:), Bash(gh pr comment:), Bash(gh pr review:), Bash(git fetch:), Bash(git checkout:), Bash(git pull:), Bash(git stash:), Bash(ddev describe:), Bash(ddev start:), Bash(composer install:), Bash(drush cim:), Bash(drush updb:), Bash(drush cr:), Bash(drush uli:), Bash(phpcs *:), Bash(open *:), Bash(acli jira auth status:), Bash(acli jira workitem view:), Bash(acli jira workitem transition:), Bash(acli jira workitem assign:), Bash(acli jira workitem comment create:), Bash(cat .claude/data/mappings.json:*), Read, Glob, Grep
---

# Review PR

Prepare a GitHub Pull Request locally, analyze it using project rules, optionally post a GitHub review comment, and optionally synchronize the related Jira ticket.

## Purpose

Use this command when the user provides a PR URL or number and wants to:
- prepare PR locally
- review code using project standards
- generate a review summary
- optionally post a GitHub comment
- optionally update Jira based on review outcome

## Input

- GitHub PR URL or number  
  If missing → ask for it.

## Assumptions

- Inside correct repo
- Uses GitHub (`gh`)
- Uses DDEV + Drupal
- Uses Jira via `acli`
- Mappings at `.claude/data/mappings.json`

---

## Workflow

### 1. Validate GitHub access

Run:
```bash
gh auth status
```

If fails:
```bash
gh auth switch --user <account>
```

---

### 2. Resolve PR details

Run:
```bash
gh pr view <number-or-url> --json headRefName,title,files,author,body
```

Show:
- title
- branch
- changed files

---

### 3. Detect Jira ticket

Search in:
- PR title
- body
- branch

Example: `COS-703`

If none found:
- continue without Jira

---

### 4. Ensure DDEV running

Run:
```bash
ddev describe || ddev start
```

---

### 5. Checkout branch

Run:
```bash
git fetch origin
git checkout -b <branch_name> origin/<branch_name>
```

If exists:
```bash
git checkout <branch_name>
git pull origin <branch_name>
```

If blocked → ask to stash.

---

### 6. Prepare environment

Run:
```bash
composer install
drush cim -y
drush updb -y
drush cr
```

Stop on failure.

---

### 7. Generate login link

Run:
```bash
ULI=$(drush uli) && echo "$ULI" && open "$ULI"
```

---

### 8. Run PHPCS on changed files

From the changed files list gathered in step 2, filter to PHP files that fall within PHPCS scope:
- `docroot/modules/custom/`
- `docroot/themes/custom/`
- `docroot/sites/default/settings.php`

For each matching file, run:
```bash
phpcs <file-path>
```

Collect all output. If no PHP files are in scope, skip this step silently.

Store the raw PHPCS output — it will be used directly in the Analysis Phase.

---

### 9. Run PHPStan

```bash
phpstan
```

Collect output. Store raw results — use them as-is in the Analysis Phase.

---

# Analysis Phase

Analyze only changed files.

## PHPCS
Use the actual output from step 8. Do not guess or infer PHPCS issues — report only what the tool output.
If PHPCS produced no errors or warnings, state "PHPCS: clean" and move on.
If PHPCS was skipped (no in-scope PHP files), state "PHPCS: no in-scope files".

## PHPStan
Use the actual output from step 9. Do not guess or infer issues — report only what the tool output.
If PHPStan produced no errors, state "PHPStan: clean" and move on.

## PHP Design
- prefer final when appropriate
- no public properties
- private by default
- clean structure

## DocBlocks
- missing docblocks
- missing `@var` when needed
- clear `@param` / `@return`
- examples when helpful

## Drupal
- DI over `\Drupal::`
- correct module placement
- naming conventions

---

# Review Output

## Summary
- PR title
- number of files
- overall: clean / minor / needs work

## Issues
Grouped:
- PHPCS
- PHPStan
- PHP
- DocBlocks
- Drupal

## Good Practices
(optional)

---

# Build GitHub Comment

## 🔍 PR Review Summary

### PHPCS
- ...

### PHPStan
- ...

### PHP Design
- ...

### DocBlocks
- ...

### Drupal Best Practices
- ...

### ✅ Good Practices
- ...

---

## Confirm posting + Jira outcome (single ask)

After building the review, display the draft GitHub comment text to the user:

> Here is the GitHub comment I'll post — feel free to edit it before confirming:
>
> ---
> [draft GitHub comment]
> ---
>
> What would you like to do?
> 1. Post as-is (no Jira update)
> 2. Edit comment, then post (no Jira update)
> 3. Post + partial approval in Jira — quick note (no summary)
> 4. Post + partial approval in Jira — with review summary
> 5. Post + final approval in Jira — quick note (no summary)
> 6. Post + final approval in Jira — with review summary
> 7. Post + request changes in Jira
> 8. Skip everything
> 9. Post my own comment on GitHub PR
> 10. Approve PR on GitHub + add my own comment

If user picks option 2 → ask: "What should the comment say?" then use their version.
If user picks option 9 → ask: "What would you like your comment to say?" then post it as a plain GitHub comment.
If user picks option 10 → ask: "What would you like your comment to say?" then post a formal GitHub review approval with that message using `gh pr review --approve --body "<message>"`.

Map the answer:
- Option 1 → post GitHub comment as-is, skip Jira
- Option 2 → post edited GitHub comment, skip Jira
- Option 3 → post GitHub comment, run Jira partial approval flow (quick)
- Option 4 → post GitHub comment, run Jira partial approval flow (with summary)
- Option 5 → post GitHub comment, run Jira final approval flow (quick)
- Option 6 → post GitHub comment, run Jira final approval flow (with summary)
- Option 7 → post GitHub comment, run Jira changes-requested flow
- Option 8 → do nothing
- Option 9 → prompt user for free-form message, post as GitHub comment only, skip Jira
- Option 10 → prompt user for free-form message, post as formal GitHub review approval (`gh pr review --approve --body "<message>"`), skip Jira

If no Jira ticket was detected → options 3–7 collapse into option 1 automatically (no Jira steps).
Options 9 and 10 are always available regardless of Jira ticket detection.

---

# Jira Synchronization

If no Jira ticket → skip entirely, no ask.

---

## Jira auth check

Run:
```bash
acli jira auth status
```

If fails → skip all Jira steps silently, do not ask the user to log in.
To fix auth outside this command: `acli jira auth login`

---

## Load mappings

Run:
```bash
cat .claude/data/mappings.json
```

---

## If outcome = partial approval

Add a Jira comment only — no status change, no reassignment.

Resolve the PR author's full name from mappings (key = PR author's GitHub username).

**Quick note (option 3):**

```text
Good job <author-full-name>! I've approved <PR link>.

Still needs one more approval before we can merge.
```

**With summary (option 4):**

```text
Good job <author-full-name>! I've approved <PR link>.

Still needs one more approval before we can merge. Here's a quick summary of what I found:

<bullet points from review summary>
```

---

## If outcome = changes requested

If mapping exists:

```bash
acli jira workitem assign --key <ticket> --assignee "<mapped>"
acli jira workitem transition --key <ticket> --status "In Progress"
acli jira workitem comment create --key <ticket> --body "<comment>"
```

Resolve the PR author's full name from mappings.

Comment body:

```text
Hey <author-full-name>, left some feedback on <PR link> — just a few things to look at before we can merge.

<bullet points from review summary>

You've got this!
```

If mapping missing:
- keep assignee
- still move status

---

## If outcome = approved

If mapping exists, assign the PR author from mappings.

```bash
acli jira workitem assign --key <ticket> --assignee "<mapped>"
acli jira workitem comment create --key <ticket> --body "<comment>"
```

(No status change)

Resolve the PR author's full name from mappings.

**Quick note (option 5):**

```text
Good job <author-full-name>! I've approved <PR link>. Ready to merge when you wish.
```

**With summary (option 6):**

```text
Good job <author-full-name>! I've approved <PR link>.

Here's a quick summary of what I found:

<bullet points from review summary>

Ready to merge when you wish.
```

If mapping missing:
- keep assignee

---

# Error Handling

- stop on failure
- show command
- suggest fix

---

# Final Output

Show:
- PR title
- branch
- files
- ULI
- review summary
- GitHub comment posted or not
- Jira updated or not

---

# Rules

- no code changes
- no commits
- no pushes
- confirm before commenting
- confirm before Jira actions
- analyze only changed files
- follow `phpcs.xml`
- keep feedback concise
- use mappings.json for Jira assignment