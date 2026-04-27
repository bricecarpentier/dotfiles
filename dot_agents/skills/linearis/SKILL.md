---
name: linearis
description: Reference for the linearis CLI - a JSON-output CLI for Linear.app issue tracking. Covers issues, comments, projects, cycles, milestones, documents, and team/user lookups.
---

## Overview

`linearis` is a CLI wrapper for the Linear API. All output is JSON. It accepts both UUIDs and human-readable identifiers (e.g. `ABC-123`) for issue IDs. Many flags accept names or IDs interchangeably (teams, projects, milestones, cycles, labels).

Authentication is via `--api-token <token>` flag or the `LINEAR_API_KEY` environment variable.

## Issues

### List issues

```sh
linearis issues list                     # List issues (default limit 25)
linearis issues list -l 50               # Custom limit
```

### Read issue details

```sh
linearis issues read ABC-123             # By identifier
linearis issues read <uuid>              # By UUID
```

### Search issues

```sh
linearis issues search "query text"
linearis issues search "auth bug" --team ENG --status "In Progress,Todo"
linearis issues search "login" --project "Backend" --assignee <userId> -l 20
```

### Create an issue

```sh
linearis issues create "Title" --team ENG
linearis issues create "Title" --team ENG -d "Description" -p 2
linearis issues create "Title" --team ENG --project "Backend" --labels "bug,urgent"
linearis issues create "Title" --team ENG --cycle "Sprint 12" --status "In Progress"
linearis issues create "Title" --team ENG --parent-ticket ABC-100 --project-milestone "v2.0"
# --team is required
# Priority: 1 (urgent) to 4 (low)
# Flags: -d, -a (assignee), -p, --project, --team, --labels, --project-milestone, --cycle, --status, --parent-ticket
```

### Update an issue

```sh
linearis issues update ABC-123 -t "New title"
linearis issues update ABC-123 -s "Done" -p 1
linearis issues update ABC-123 --labels "bug,backend"              # Adds labels (default mode)
linearis issues update ABC-123 --labels "bug" --label-by overwriting  # Replaces all labels
linearis issues update ABC-123 --clear-labels                      # Remove all labels
linearis issues update ABC-123 --parent-ticket ABC-100             # Set parent
linearis issues update ABC-123 --clear-parent-ticket               # Remove parent
linearis issues update ABC-123 --project-milestone "v2.0"          # Set milestone
linearis issues update ABC-123 --clear-project-milestone           # Clear milestone
linearis issues update ABC-123 --cycle "Sprint 12"                 # Set cycle
linearis issues update ABC-123 --clear-cycle                       # Clear cycle
linearis issues update ABC-123 --assignee <userId> --project "Backend"
```

## Comments

```sh
linearis comments create ABC-123 --body "Comment text here"
```

## Labels

```sh
linearis labels list                     # All labels
linearis labels list --team ENG          # Labels for a team
```

## Projects

```sh
linearis projects list                   # All projects
linearis projects list -l 50             # Custom limit
```

## Cycles

```sh
linearis cycles list                     # All cycles
linearis cycles list --team ENG --active # Active cycles for a team
linearis cycles list --team ENG --around-active 1  # Active +/- 1 cycle
linearis cycles read "Sprint 12" --team ENG        # Cycle details with issues
linearis cycles read <cycleId> --issues-first 100  # More issues
```

## Project Milestones

```sh
linearis project-milestones list --project "Backend"
linearis project-milestones read "v2.0" --project "Backend"
linearis project-milestones read <milestoneId> --issues-first 100
linearis project-milestones create "v3.0" --project "Backend" -d "Description" --target-date 2026-06-01
linearis project-milestones update "v3.0" --project "Backend" -n "v3.1" --target-date 2026-07-01
```

## Documents

```sh
linearis documents list                                # All documents
linearis documents list --project "Backend"            # By project
linearis documents list --issue ABC-123                # Attached to issue
linearis documents read <documentId>
linearis documents create --title "Doc" --content "# Markdown" --project "Backend"
linearis documents create --title "Doc" --content "text" --attach-to ABC-123
linearis documents update <documentId> --title "New" --content "Updated"
linearis documents delete <documentId>
```

## Teams & Users

```sh
linearis teams list                      # All teams
linearis users list                      # All users
linearis users list --active             # Active users only
```

## Project Updates (Pulse Updates)

The linearis CLI does not support project updates natively. Use the Linear GraphQL API directly.

### Authentication

The linearis CLI uses the `LINEAR_API_TOKEN` environment variable (not `LINEAR_API_KEY`). Use the same env var for direct API calls. To verify: `echo $LINEAR_API_TOKEN`.

### Create a project update

Use a Python script to handle JSON escaping of markdown content cleanly:

```python
python3 << 'PYEOF'
import json, os, urllib.request

content = """your markdown content here"""

query = """mutation ProjectUpdateCreate($projectId: String!, $body: String!, $health: ProjectUpdateHealthType!) {
  projectUpdateCreate(input: { projectId: $projectId, body: $body, health: $health }) {
    success
    projectUpdate { id url createdAt }
  }
}"""

payload = json.dumps({
    "query": query,
    "variables": {
        "projectId": "<project-uuid>",
        "body": content,
        "health": "offTrack"  # onTrack | atRisk | offTrack
    }
}).encode()

req = urllib.request.Request(
    "https://api.linear.app/graphql",
    data=payload,
    headers={
        "Authorization": os.environ["LINEAR_API_TOKEN"],
        "Content-Type": "application/json"
    },
    method="POST"
)
resp = urllib.request.urlopen(req)
print(resp.read().decode())
PYEOF
```

### Finding the project ID

Use linearis to look up the project UUID:

```sh
linearis projects list | jq -r '.[] | select(.name | test("keyword"; "i")) | "\(.id) \(.name)"'
```

### Health values

- `onTrack` -- project is progressing as planned
- `atRisk` -- project may miss deadlines
- `offTrack` -- project has missed deadlines or is significantly behind

## File Embeds

```sh
linearis embeds upload ./file.png        # Upload, returns URL
linearis embeds download <url> --output ./local.png --overwrite
```
