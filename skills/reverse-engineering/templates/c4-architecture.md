# C4 Architecture Model

> Follows [C4 model](https://c4model.com/). All diagrams use Mermaid C4 syntax.

## Level 1: System Context

```mermaid
C4Context
  title System Context - {System Name}
  %% Replace: Person, System, System_Ext, Rel
```

| Element | Type | Description |
|---------|------|-------------|
| {name} | {System/Person/External} | {description} |

## Level 2: Containers

```mermaid
C4Container
  title Containers - {System Name}
  %% Replace: System_Boundary, Container, ContainerDb, Rel
```

| Container | Technology | Type | Purpose |
|-----------|-----------|------|---------|
| {name} | {tech} | {type} | {purpose} |

## Level 3: Components

### {Container Name}

```mermaid
C4Component
  title Components - {Container Name}
  %% Replace: Container_Boundary, Component, Rel
```

| Component | Technology | Responsibility |
|-----------|-----------|----------------|
| {name} | {tech} | {responsibility} |

## Level 4: Code (selective)

Only for architecturally critical components.

```mermaid
classDiagram
  %% Replace with key abstractions
```
