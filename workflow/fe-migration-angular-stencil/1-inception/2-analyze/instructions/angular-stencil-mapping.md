# Angular to StencilJS Mapping

## Component Patterns

| Angular | StencilJS | Notes |
|---------|-----------|-------|
| `@Input()` | `@Prop()` | Immutable by default in Stencil |
| `@Output() EventEmitter` | `@Event() EventEmitter` | Custom events, not RxJS |
| `ngOnInit` | `componentWillLoad` | Async supported |
| `ngOnDestroy` | `disconnectedCallback` | Cleanup subscriptions |
| `ngOnChanges` | `@Watch('propName')` | Per-prop watchers |
| `*ngIf` | Ternary in JSX | `{condition && <el/>}` or `{condition ? <a/> : <b/>}` |
| `*ngFor` | `.map()` in JSX | `{items.map(i => <el key={i.id}/>)}` |
| `[ngClass]` | Template literal or object | `class={{'active': isActive}}` |

## State Management

| Angular | StencilJS | Notes |
|---------|-----------|-------|
| NgRx `store.select()` | `storeName.getState()` / `BaseStore` | No RxJS |
| `BehaviorSubject` | `@State()` | Triggers re-render |
| Service injection | `ServiceName.Instance` | Singleton pattern |

## Communication

| Angular | StencilJS | Notes |
|---------|-----------|-------|
| `@ViewChild` / service | Event Bus (`sb-xp:*`) | Inter-MFE only |
| Parent-child service | `@Prop()` down, `@Event()` up | Intra-widget |
| NgRx actions | Event Bus commands | `sb-xp:{domain}:{action}:{version}` |

## Config Replacement

| Angular Config | MFE Replacement |
|---------------|-----------------|
| Environment files | Omit -- not applicable |
| Feature flags (config service) | `@Prop()` from host or Event Bus context |
| App config values | BFF response or host props |
| Translation service | `@Prop()` or i18n MFE |
