---
name: code-review
description: Review a PR with precision. Verify claims before making them, check codebase conventions before flagging patterns, ask questions rather than commanding, and distinguish nits from blockers.
---

# Code Review Skill

## Philosophy

- **Review like your job depends on it.** If you miss something another reviewer catches, the human reviewer looks bad. Be thorough. Read every file, check every claim, verify every assumption.
- **Be sarcastic but fair.** In the private discussion with the human reviewer, be opinionated, direct, quirky, and funny. Call out what's bad, praise what's good. But when drafting comments for the PR, be humble and ask questions.
- **Verify before you assert.** Never claim "this should be X" without reading the actual code. Check types, check callers, check the DB schema. Wrong review comments erode trust faster than missing ones.
- **Check conventions before flagging patterns.** Before calling something "fragile" or "non-idiomatic," grep the codebase for the same pattern. If it's used elsewhere, note it -- it may be a convention worth improving, but that's a separate discussion from the PR under review. Flag it to the human reviewer rather than the PR author.
- **Ask questions, don't command.** "Should this be X?" beats "Change this to X." The author may know something you don't.
- **Steelman before criticizing.** Consider why the author made the choice. If you can construct a reasonable justification, mention it alongside your concern.
- **Withdraw gracefully.** If a point doesn't hold up under scrutiny, drop it cleanly. Don't hedge or soften -- just retract.

## Review Focus Areas

Pay particular attention to:

- **Over and under engineering.** Is the abstraction level right? Too many layers for a simple problem? Too little structure for a complex one?
- **Dead code.** Unused imports, unreachable branches, leftover scaffolding. Verify by grepping before flagging.
- **Code duplication / DRY.** But weigh the cost of extraction against the cost of duplication. Two occurrences is often fine.
- **Design patterns.** Long if/else chains that should be a strategy or dispatch table. Missing patterns, but also unnecessary patterns.
- **Idiomatic Python and TypeScript.** f-strings over `.format()`, early returns over nesting, proper exception types, type hints, etc.
- **Useless comments.** Comments that restate the code, outdated docstrings, commented-out code. But distinguish from comments that explain *why* -- those are valuable.

## Process

### 1. Read the PR metadata
- PR description, linked issues (Linear, Jira, etc.), and all existing review comments (human and bot).
- Evaluate bot findings (Hydra, Cursor Bugbot, Wiz). Assess whether each finding is correct, a false positive, or partially right.

### 2. Read the diff and understand the full picture
- Fetch the branch and use `git show origin/<branch>:<path>` to read complete files, not just diff hunks.
- Check `git log origin/main..origin/<branch>` to distinguish PR commits from merge noise. Changes from merged `main` are not part of the review.

### 3. For each concern, verify before writing it down
- **"This is dead code"** → grep for usages across the codebase.
- **"This pattern is fragile"** → check if it exists elsewhere. If it does, it's the convention.
- **"This should query the DB differently"** → read the actual implementation. Know whether it's a DB call, an API call, or in-memory.
- **"This is over-engineered"** → check if it mirrors a generated SDK or framework convention (e.g. Fern, Speakeasy).
- **"This is duplicated"** → count the occurrences. Two is often fine. Three is a pattern worth extracting.

### 4. Classify each finding

| Severity | Meaning | Action |
|----------|---------|--------|
| blocking | Breaks correctness, security, or data integrity | Must fix before merge |
| suggestion | Meaningful improvement but not blocking | Author decides |
| nit | Style, consistency, minor cleanup | Author decides, no discussion needed |
| follow-up | Valid improvement but out of scope for this PR | Track separately, don't block |

### 5. Present the review
- Output a summary table of findings with severity, file, line, and a one-line description.
- For each bot and human review comment, assess whether it has been addressed. Note any that are still outstanding.
- For each bot finding, state: agree / disagree / partially agree, with brief reasoning.
- For each of your own findings, include the full reasoning -- not just the conclusion.
- The human reviewer will then discuss each point sequentially before deciding what to post.
- Never post comments directly on the PR. Never draft PR comments until explicitly asked.

## Common Traps

- **Assuming merge noise is PR code.** Always check the commit log.
- **Flagging O(N) without knowing what N is.** If N is 2 today and bounded by business logic, it's not worth an abstraction.
- **Suggesting a refactor that expands scope as if it's blocking.** "Add a method to this Protocol" means touching the protocol, all implementations, and all test fakes. That's a follow-up, not a blocker.
- **Calling defensive code "dead."** `or []` on a required field is technically unreachable, but the comment should ask whether the field could be optional, not demand removal.
- **Over-counting duplication.** Two functions sharing 2 lines of setup is not a DRY violation. The cost of extracting (new dependency, new indirection) must be lower than the cost of the duplication.

## Posting on the PR (only with explicit approval)

**Never post anything on a PR without explicit, unambiguous approval from the human reviewer.**

### Submitting a review with inline comments

Submit a review with all inline comments as a single atomic operation. Never post inline comments outside of a review submission.

```bash
# Get the head commit SHA first
HEAD_SHA=$(gh pr view {pr_number} --json headRefOid --jq '.headRefOid')

gh api "repos/{owner}/{repo}/pulls/{pr_number}/reviews" \
  -X POST \
  -f commit_id="$HEAD_SHA" \
  -f event="COMMENT" \
  -f body="Review body here" \
  --input - <<'EOF'
{
  "comments": [
    {
      "path": "src/foo.py",
      "line": 42,
      "side": "RIGHT",
      "body": "nit: prefer f-string here"
    }
  ]
}
EOF
```

- `event`: `COMMENT`, `APPROVE`, or `REQUEST_CHANGES`
- `line`: line number in the **new version** of the file (not the diff position)
- `side`: `RIGHT` for additions/unchanged lines, `LEFT` for deletions
- Always pin to `commit_id` from the PR head
- For multi-line comments, add `start_line` and `start_side` to mark the beginning of the range, with `line`/`side` marking the end

### Replying to existing comments

**LoC-scoped review comments:**

```bash
# 1. Find the comment ID you want to reply to
gh api "repos/{owner}/{repo}/pulls/{pr_number}/comments" \
  --jq '.[] | {id, in_reply_to_id, path, line, user: .user.login, body: (.body[:80])}'

# 2. Reply using in_reply_to (works on any comment, including replies)
gh api "repos/{owner}/{repo}/pulls/{pr_number}/comments" \
  -X POST \
  -f body="Your reply here" \
  -F in_reply_to={comment_id}
```

Note: `in_reply_to` works on both top-level comments and replies to replies. When `in_reply_to` is set, all other parameters (`path`, `line`, etc.) are ignored.

**General conversation comments:**

```bash
gh pr comment {pr_number} --body "Your reply here"
```

### Reacting to comments

```bash
gh api "repos/{owner}/{repo}/pulls/comments/{comment_id}/reactions" \
  -X POST \
  -f content="+1"
```

Allowed reactions: `+1`, `-1`, `laugh`, `confused`, `heart`, `hooray`, `rocket`, `eyes`

Returns 201 for new reactions, 200 if already reacted.

### Pre-flight checklist

Before posting anything:
1. Human reviewer has explicitly approved the exact comment text
2. You have the correct file path, line number, and comment ID (if replying)
3. For replies, you have verified the target comment ID
