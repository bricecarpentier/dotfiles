---
name: stacked-prs
description: Add git-spice-style stack navigation comments to stacked pull request descriptions. Use when the user wants to annotate PRs that depend on each other, identify stacked PRs, or update PR descriptions with stack info.
---

# Stacked PR Navigation Comments

Add navigation comments to stacked pull request descriptions so reviewers can see the full stack and where each PR sits in it. Uses the git-spice visual style.

## Step 1: Identify the Stack

List the user's open PRs and find stacking by looking at `baseRefName`:

```sh
gh pr list --author @me --state open \
  --json number,title,headRefName,baseRefName,url
```

PRs are stacked when a PR's `baseRefName` matches another PR's `headRefName` (instead of targeting `main`/`master`).

Build a tree from the results. Example output:

```
main
 +-- #101 shared library
      +-- #102 feature A (targets #101's branch)
      +-- #103 feature B (targets #101's branch)
```

Present the tree to the user and confirm before editing any descriptions.

## Step 2: Build the Navigation Block

Use an indented Markdown list inside a `> [!NOTE]` callout. Mark the current PR with the `◀` glyph.

### Format

```markdown
> [!NOTE]
> This change is part of the following stack:
>
> - #101 `scope-a` short description
>     - #102 `scope-b` short description ◀
>     - #103 `scope-c` short description
```

### Rules

1. **One root list item per base branch.** Children are indented with 4 spaces.
2. **Use backtick-wrapped scope** extracted from the PR title's conventional-commit prefix (e.g. `feat(scope)` becomes `` `scope` ``). If no scope, omit.
3. **Short description** is the PR title minus the conventional-commit prefix.
4. **The `◀` marker** goes after the description of the current PR only.
5. **For the root PR**, append a merge-order hint after the list:
   - Linear stack: `> Merge from top to bottom.`
   - Fan-out (siblings): `> Merge #NNN first. Then #NNN and #NNN (in any order).`
6. **No code fences inside the callout.** The indented list is plain Markdown -- it renders correctly on GitHub without fences.
7. **PR numbers are auto-linked** by GitHub (`#123` becomes a link). Do not wrap them in `[#123](url)`.

### Nested Example (3 levels)

```markdown
> [!NOTE]
> This change is part of the following stack:
>
> - #10 `core` add base types
>     - #11 `api` expose endpoints
>         - #12 `web` connect UI ◀
>     - #13 `cli` add CLI commands
```

### Merged PRs

If a PR in the stack has already been merged, strike it through:

```markdown
> - ~~#10 `core` add base types~~ (merged)
>     - #11 `api` expose endpoints ◀
```

## Step 3: Read Current Descriptions

For each PR in the stack, fetch its current body:

```sh
gh pr view NUMBER --json body -q .body
```

**Never edit a description you haven't read first.**

## Step 4: Insert the Navigation Block

Place the `> [!NOTE]` block in the `## Context` section, after the first paragraph and before any `Fixes`/`Closes` line. If no `## Context` section exists, place it at the very top of the body.

Remove any pre-existing dependency lines like:
- `Depends on #NNN`
- `**Depends on:** #NNN`
- `Based on #NNN`

These are superseded by the stack block.

## Step 5: Apply Changes Safely

Write the full body to a temp file and use `--body-file`:

```sh
cat > /tmp/prNNN.md << 'EOF'
... full body ...
EOF
gh pr edit NUMBER --body-file /tmp/prNNN.md
```

**Do not** pipe `gh pr view` output through `sed` into `gh pr edit --body`. This risks data loss if the pipe produces empty output.

## Step 6: Verify

After editing, read back each PR to confirm the body is intact:

```sh
gh pr view NUMBER --json body -q .body | head -20
```

Confirm the `> [!NOTE]` block appears and the rest of the description is unchanged.

## Quick Reference

| Element | Value |
|---|---|
| Current-PR marker | `◀` (U+25C0) |
| Callout type | `> [!NOTE]` |
| Indent per level | 4 spaces |
| Scope format | backtick-wrapped, from conventional commit |
| Merged PR style | `~~#NNN description~~ (merged)` |
