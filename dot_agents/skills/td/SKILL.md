---
name: td
description: Reference for the td CLI - a local task and session management tool for AI-assisted development workflows. Load this skill at the start of every conversation.
---

## First thing to do

At the **very start of every conversation**, create a new session and check status:

```sh
td session --new
td status
```

This ensures session continuity so your work is properly tracked.

## Issue lifecycle

Statuses: `open` -> `in_progress` -> `in_review` -> `closed`
An issue can also be `blocked` from any active state.

Workflow: create -> start -> (work) -> handoff -> review -> approve (by different session)

Use `td close` only for administrative closures (duplicates, won't-fix). Completed work must go through `td review` + `td approve`.

## Core Commands

### Create an issue

```sh
td create "Title" -t task -p P2 -d "Description"
td create "Title" -t bug -p P1 --parent <epic-id>
td create "Title" -t epic
# Types: bug, feature, task, epic, chore
# Priorities: P0 (critical) through P4 (low)
# Flags: --labels, --due, --depends-on, --blocks, --points, --defer, --minor
```

### List issues

```sh
td list                          # Open issues (default)
td list -s open -t bug           # Open bugs
td list -p P0,P1                 # High priority
td list --epic <id>              # Tasks within an epic
td list -m                       # My issues (current session is implementer)
td list -a                       # All including closed/deferred
td list --overdue                # Past due date
td list --due-soon               # Due within 3 days
td list --deferred               # Currently deferred
td list --long                   # Detailed output
```

### Show issue details

```sh
td show <id>                     # Full details
td show <id> --children          # With child tasks
td show <id> --short             # Compact summary
```

### Update an issue

```sh
td update <id> --title "New title"
td update <id> -d "New description"
td update <id> --priority P1
td update <id> --labels "auth,backend"
td update <id> --parent <epic-id>
td update <id> --status open     # Direct status change
td update <id> -d "Appended text" --append
```

### Delete / restore

```sh
td delete <id>                   # Soft-delete
td restore <id>                  # Undo delete
```

## Workflow Commands

### Start work

```sh
td start <id>                    # Begin work, records you as implementer
td focus <id>                    # Set as current working issue (for td log, td done, etc.)
td unfocus                       # Clear focus
```

### Log progress

```sh
td log "Made progress on X"             # Log to focused issue
td log <id> "Fixed the auth bug"        # Log to specific issue
td log "Hit a wall on Y" --blocker      # Mark as blocker
td log "Decided to use approach Z" --decision
# Types: progress, blocker, decision, hypothesis, tried, result
```

### Handoff (required before review)

```sh
td handoff <id> -m "Simple summary of what was done"
td handoff <id> --done "Implemented auth" --done "Added tests" --remaining "Update docs"
# Structured flags: --done, --remaining, --decision, --uncertain
```

### Submit for review

```sh
td review <id>                   # Submit for review (auto-creates minimal handoff if missing)
td review <id> --minor           # Minor task, allows self-review
td review <id> -m "Ready for review"
```

### Approve / reject (must be different session than implementer)

```sh
td approve <id>                  # Approve and close
td approve <id> -m "Looks good"
td reject <id> -m "Needs changes to X"
```

### Close (administrative only)

```sh
td close <id> -m "Duplicate of <other-id>"
td close <id> --self-close-exception "Trivial config change"
```

### Block / unblock

```sh
td block <id> --reason "Waiting on API access"
td unblock <id>
```

### Dependencies

```sh
td dep add <id> <depends-on-id>  # Add dependency
td dep rm <id> <depends-on-id>   # Remove dependency
td dep <id>                      # Show dependencies
td dep <id> --blocking           # Show what depends on this issue
```

### Defer / due dates

```sh
td defer <id> +7d                # Defer for 7 days
td defer <id> monday             # Defer until Monday
td defer <id> --clear            # Remove deferral
td due <id> friday               # Set due date
td due <id> +2w                  # Due in 2 weeks
td due <id> --clear              # Remove due date
```

### Comments

```sh
td comment <id> "This is a comment"
td comments <id>                 # List comments
```

## Session Commands

```sh
td session --new                 # Create new session (do this at conversation start)
td session "session-name"        # Name the current session
td status                        # Dashboard: session, focus, reviews, blocked, ready
td whoami                        # Current session identity
td resume <id>                   # Show context and set focus
td usage                         # Generate context block for AI agents
td usage --new-session           # Create new session + context (alternative to session --new)
```

## Query & Discovery

```sh
td ready                         # Open issues sorted by priority
td next                          # Highest-priority open issue
td search "auth"                 # Full-text search
td tree <id>                     # Visualize parent/child tree
td critical-path                 # Sequence of issues that unblocks the most work
```

### TDQ query language

```sh
td query "status = open AND type = bug"
td query "priority <= P1"
td query "created >= -7d"
td query "implementer = @me AND is(in_progress)"
td query "log.type = blocker"
td query "title ~ auth OR description ~ auth"
td query "descendant_of(<epic-id>)"
# Operators: =, !=, ~, !~, <, >, <=, >=, AND, OR, NOT
# Functions: has(), is(), any(), blocks(), blocked_by(), descendant_of(), rework()
# Special: @me (current session), EMPTY, -7d, today, this_week, etc.
```

## File Tracking

```sh
td link <id> src/main.go         # Link file to issue
td link <id> "src/*.go"          # Link via glob
td link <id> file.go --role test # Roles: implementation, test, reference, config
td files <id>                    # List linked files
td files <id> --changed          # Only changed files
```

## Shortcuts

```sh
td task create "Title"           # Create with type=task
td epic create "Title"           # Create with type=epic
td blocked                       # List blocked issues
td in-review                     # List issues in review
td reviewable                    # Issues you can review (different implementer)
td deleted                       # Show soft-deleted issues
```
