# Combined Architecture

**Workspace**: {WORKSPACE_NAME}
**Last Generated**: {ISO_TIMESTAMP}

## System Overview

{High-level description of the bounded context as a whole — what business capabilities the repos collectively provide.}

## Repository Map

| Repository | Type | Primary Language | Role |
|------------|------|-----------------|------|
| {repo-name} | {application/shared/library} | {language} | {1-line role description} |

## Inter-Repo Relationships

```mermaid
flowchart LR
    subgraph workspace["{WORKSPACE_NAME}"]
        {repo-nodes}
    end
    {relationship-edges}
```

## Data Flows

### Event Flows (Kafka / Message Bus)

| Event / Topic | Publisher | Consumer(s) | Schema Location |
|--------------|-----------|-------------|-----------------|
| {event-name} | {repo} | {repo, repo} | {path or "inline"} |

### API Calls (REST / gRPC)

| Endpoint | Provider | Consumer(s) | Contract Location |
|----------|----------|-------------|-------------------|
| {endpoint} | {repo} | {repo, repo} | {path or "inline"} |

### Shared Libraries / Contracts

| Package / Schema | Owner Repo | Consuming Repos | Version Strategy |
|-----------------|------------|-----------------|------------------|
| {package-name} | {repo} | {repo, repo} | {semver/latest/pinned} |

## Dependency Graph

```mermaid
flowchart TD
    {dependency-edges-showing-build-and-runtime-dependencies}
```

## Cross-Repo Concerns

{List of architectural concerns that span multiple repos — e.g. shared authentication, common logging, distributed tracing, shared configuration.}

## Key Integration Points

{For each major integration point between repos, describe: what connects, how it connects, what breaks if the contract changes, and which repos need coordinated deployment.}
