# Skill: gh-pr-comments

## Overview

Reply to GitHub PR review comments using `gh api`. Covers inline review comments (left by reviewers on specific lines) and top-level PR comments.

## Reply to an inline review comment

Inline review comments (the ones on specific lines/diffs) use the **pull request review comments** API. To reply to one, POST to the pulls comments endpoint with `in_reply_to` set to the comment ID.

### 1. Find comment IDs

```sh
# List all inline review comments on a PR
gh api "repos/{owner}/{repo}/pulls/{pr_number}/comments" \
  --jq '.[] | {id, author: .user.login, path, line, body: (.body | .[0:120])}'

# Filter by author
gh api "repos/{owner}/{repo}/pulls/{pr_number}/comments" \
  --jq '.[] | select(.user.login == "some-bot[bot]") | {id, path, line, body: (.body | .[0:120])}'
```

### 2. Reply to a comment

```sh
gh api "repos/{owner}/{repo}/pulls/{pr_number}/comments" -X POST \
  -f body='Your reply here' \
  -F in_reply_to=COMMENT_ID
```

The `in_reply_to` field threads your reply under the original comment.

### 3. Batch replies

```sh
# Reply to multiple comments in sequence
for id in 12345 67890 11111; do
  gh api "repos/{owner}/{repo}/pulls/{pr_number}/comments" -X POST \
    -f body='Fixed in abc1234.' \
    -F in_reply_to=$id --jq '.html_url'
done
```

## Top-level PR comments (issue comments)

These are the non-inline comments in the PR conversation thread. They use a different API.

```sh
# List top-level comments
gh api "repos/{owner}/{repo}/issues/{pr_number}/comments" \
  --jq '.[] | {id, author: .user.login, body: (.body | .[0:120])}'

# Post a new top-level comment
gh api "repos/{owner}/{repo}/issues/{pr_number}/comments" -X POST \
  -f body='Your comment here'
```

## Common patterns

### Get the HTML URL of a comment (for sharing)

```sh
gh api "repos/{owner}/{repo}/pulls/{pr_number}/comments" \
  --jq '.[] | select(.id == COMMENT_ID) | .html_url'
```

### Get comment details by ID

```sh
gh api "repos/{owner}/{repo}/pulls/comments/COMMENT_ID" \
  --jq '{id, author: .user.login, path, line, in_reply_to_id, body}'
```

## Notes

- Inline review comments and top-level issue comments are **different APIs** — don't mix them.
- `in_reply_to` must reference an existing inline review comment ID on the same PR.
- Use `-F` (not `-f`) for `in_reply_to` so it's sent as an integer.
- Use `--jq '.html_url'` to get a clickable link after posting.
