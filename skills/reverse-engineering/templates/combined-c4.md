# Combined C4 Architecture

**Workspace**: {WORKSPACE_NAME}
**Last Generated**: {ISO_TIMESTAMP}

## Level 1: System Context

The bounded context as a system, showing external actors and external systems.

```mermaid
C4Context
    title {WORKSPACE_NAME} — System Context

    Person(user, "{primary-user-role}", "{user-description}")

    System_Boundary(workspace, "{WORKSPACE_NAME}") {
        System(system, "{WORKSPACE_NAME}", "{system-description}")
    }

    System_Ext(ext1, "{external-system}", "{description}")

    Rel(user, system, "{relationship}")
    Rel(system, ext1, "{relationship}")
```

## Level 2: Container

Each repository is a container. Shows relationships between repos.

```mermaid
C4Container
    title {WORKSPACE_NAME} — Container Diagram

    Person(user, "{primary-user-role}")

    System_Boundary(workspace, "{WORKSPACE_NAME}") {
        Container(repo1, "{repo-name}", "{technology}", "{description}")
        Container(repo2, "{repo-name}", "{technology}", "{description}")
        ContainerDb(db1, "{database}", "{technology}", "{description}")
    }

    System_Ext(ext1, "{external-system}", "{description}")

    Rel(user, repo1, "{relationship}", "{protocol}")
    Rel(repo1, repo2, "{relationship}", "{protocol}")
    Rel(repo2, db1, "{relationship}", "{protocol}")
    Rel(repo1, ext1, "{relationship}", "{protocol}")
```

## Level 3: Component (Cross-Repo Flows)

Key components within each repo that participate in cross-repo flows.

### {Flow Name 1}

```mermaid
C4Component
    title {Flow Name} — Component View

    Container_Boundary(repo1, "{repo-name}") {
        Component(comp1, "{component}", "{technology}", "{description}")
    }

    Container_Boundary(repo2, "{repo-name}") {
        Component(comp2, "{component}", "{technology}", "{description}")
    }

    Rel(comp1, comp2, "{relationship}", "{protocol}")
```

{Repeat for each major cross-repo flow.}

## Level 4

Omitted at workspace level. Available in per-repo `c4-architecture.md` files:

| Repository | Per-Repo C4 Location |
|------------|---------------------|
| {repo-name} | `{repo}/reverse-engineering/c4-architecture.md` |
