---
name: argocd
description: Reference for the argocd CLI - manage ArgoCD applications, projects, sync operations, and deployment status. Covers listing, inspecting, diffing, syncing, and monitoring applications.
---

# ArgoCD CLI Reference

## CRITICAL: State-Modifying Commands Require Explicit User Authorization

**NEVER run state-modifying commands without explicit user confirmation.** Before executing any command listed in the "State-Modifying Commands" section, you MUST:

1. Tell the user exactly which command you intend to run and why
2. Wait for explicit approval (e.g. "yes", "go ahead", "do it")
3. Only then execute the command

State-modifying commands include: `app sync`, `app terminate-op`, `app rollback`, `app delete`, `app delete-resource`, `app patch`, `app patch-resource`, `app set`, `app unset`, and any `proj` write operations.

Read-only commands (`list`, `get`, `resources`, `diff`, `history`, `logs`, `wait`) are safe to run without prior approval.

## Projects

### List projects

```sh
argocd proj list                         # All projects (wide format)
argocd proj list -o json                 # JSON output
argocd proj list -o name                 # Names only
```

### Get project details

```sh
argocd proj get PROJECT                  # Project details (wide format)
argocd proj get PROJECT -o yaml          # YAML output
```

## Applications

### List applications

```sh
argocd app list                          # All applications (wide format)
argocd app list -o json                  # JSON output
argocd app list -o name                  # Names only
argocd app list -p PROJECT               # Filter by project
argocd app list -l KEY=VALUE             # Filter by label
argocd app list -l 'KEY notin (A,B)'     # Label not-in filter
argocd app list --cluster CLUSTER        # Filter by cluster name or URL
argocd app list --repo REPO_URL          # Filter by source repo
argocd app list -N NAMESPACE             # Filter by app namespace
```

### Get application details

```sh
argocd app get APPNAME                   # Summary with sync/health status and resources
argocd app get APPNAME -o json           # Full details as JSON
argocd app get APPNAME -o yaml           # Full details as YAML
argocd app get APPNAME -o tree           # Resource tree view
argocd app get APPNAME -o tree=detailed  # Detailed resource tree
argocd app get APPNAME --refresh         # Force refresh from git before showing
argocd app get APPNAME --hard-refresh    # Refresh data + manifests cache
argocd app get APPNAME --show-operation  # Include current/last operation details
argocd app get APPNAME --show-params     # Show Helm/Kustomize parameters
```

### List application resources

```sh
argocd app resources APPNAME             # All managed resources
argocd app resources APPNAME --orphaned  # Only orphaned resources
```

### View application diff

```sh
argocd app diff APPNAME                  # Diff live state vs target state
argocd app diff APPNAME --refresh        # Refresh before diffing
argocd app diff APPNAME --hard-refresh   # Hard refresh before diffing
```

Exit codes: 0 = no diff, 1 = diff found, 2 = error. Kubernetes Secrets are excluded from diff output.

### Deployment history

```sh
argocd app history APPNAME               # Show deployment history
argocd app history APPNAME -o wide       # Wide format (default)
```

### Application logs

```sh
argocd app logs APPNAME                  # Logs from all pods
argocd app logs APPNAME --tail 100       # Last 100 lines
argocd app logs APPNAME -f               # Stream logs
argocd app logs APPNAME -c CONTAINER     # Specific container
argocd app logs APPNAME --name RESOURCE  # Specific resource name
argocd app logs APPNAME --kind Deployment --name MY-DEPLOY
argocd app logs APPNAME --filter "error" # Filter log lines
argocd app logs APPNAME --since-seconds 3600  # Last hour
argocd app logs APPNAME -p               # Previous (terminated) container
```

## State-Modifying Commands

**All commands in this section require explicit user authorization before execution.**

### Sync an application

```sh
argocd app sync APPNAME                  # Sync to target state (waits for completion)
argocd app sync APPNAME --async          # Trigger sync without waiting
argocd app sync APPNAME --dry-run        # Preview only, no changes applied
argocd app sync APPNAME --prune          # Delete resources not in target state
argocd app sync APPNAME --force          # Force apply
argocd app sync APPNAME --apply-out-of-sync-only  # Only sync out-of-sync resources
argocd app sync APPNAME --revision REV   # Sync to specific revision
argocd app sync APPNAME --resource :Service:my-svc  # Sync specific resource (GROUP:KIND:NAME)
argocd app sync APPNAME --resource apps:Deployment:my-deploy  # With group
argocd app sync APPNAME --resource '!apps:Deployment:skip-this'  # Exclude resource
argocd app sync -l KEY=VALUE             # Sync apps matching label
argocd app sync --project PROJECT        # Sync all apps in a project
```

Resource format: `GROUP:KIND:NAME` (omit GROUP for core resources, e.g. `:Service:my-svc`). Prefix with `!` to exclude. Use `*` as wildcard.

### Terminate a running operation

```sh
argocd app terminate-op APPNAME          # Cancel in-progress sync/operation
```

### Rollback

```sh
argocd app rollback APPNAME HISTORY_ID   # Rollback to a previous deployment (get ID from `app history`)
```

## Monitoring Sync Progress

### Wait for sync/health

```sh
argocd app wait APPNAME                  # Wait for sync + healthy state
argocd app wait APPNAME --sync           # Wait for sync only
argocd app wait APPNAME --health         # Wait for health only
argocd app wait APPNAME --operation      # Wait for pending operation to complete
argocd app wait APPNAME --timeout 300    # Timeout after 300 seconds
argocd app wait APPNAME --resource :Service:my-svc  # Wait for specific resource
argocd app wait -l KEY=VALUE             # Wait for apps matching label
```

### Recommended sync-then-monitor workflow

```sh
# 1. Check current state
argocd app get APPNAME

# 2. Preview what will change
argocd app diff APPNAME

# 3. (requires user approval) Trigger sync asynchronously
argocd app sync APPNAME --async

# 4. Monitor progress
argocd app wait APPNAME --timeout 300

# 5. Verify final state
argocd app get APPNAME
```

## Output Formats

Most commands support `-o` / `--output`:

| Format | Description |
|--------|-------------|
| `wide` | Human-readable table (default) |
| `json` | JSON output |
| `yaml` | YAML output |
| `name` | Names only (list commands) |
| `tree` | Resource tree (get/sync/wait) |
| `tree=detailed` | Detailed resource tree |

## Common Global Flags

These can be appended to any command:

| Flag | Description |
|------|-------------|
| `--argocd-context` | Select ArgoCD server context |
| `--grpc-web` | Use gRPC-web (needed behind some proxies) |
| `--plaintext` | Disable TLS |
| `--insecure` | Skip TLS verification |

## Notes

- Authentication is handled via `argocd login` or the `ARGOCD_AUTH_TOKEN` env var.
- Use `argocd context` to switch between ArgoCD server contexts.
- The `--core` flag talks directly to Kubernetes instead of the ArgoCD API server.
