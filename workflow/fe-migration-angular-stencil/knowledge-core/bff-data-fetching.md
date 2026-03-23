# BFF Data Fetching — Three Mandatory Rules

All BFF endpoints return a `Response<T>` envelope `{ data: T, responseContext, responseCode, responseResults }` ([General Agreed Info](https://betssongroup.atlassian.net/wiki/spaces/SB/pages/751894885/General+Agreed+Info#Responses-from-SB-UI-BFF)). The HTTP client unwraps this into `HttpResponse<T>` (from `libs/contracts/src/types/http.types.ts`).

## Rule 1 — Export a named response type alias

Every widget must export a named type alias from its types file:

```typescript
// libs/contracts/src/types/my-widget.types.ts
export type GetMyWidgetResponse = HttpResponse<MyWidgetData>;
```

## Rule 2 — Guard on `responseCode` as well as `ok`

The BFF can signal a business-level failure inside a 200 response by setting `responseCode: 'Failure'`. The component must guard on both conditions:

```typescript
import { ResponseCode } from '@sb-xp/contracts';
import type { GetMyWidgetResponse } from '@sb-xp/contracts';

this.eventBus.emit('sb-xp:data:fetch:v1', request, (response: GetMyWidgetResponse) => {
  if (!response?.ok || !response.data || response.responseCode === ResponseCode.Failure) {
    this.hasError = true;
    return;
  }
  this.data = response.data;
});
```

## Rule 3 — Storybook mocks and unit test stubs must include the full envelope

Never mock with just `{ ok, data }`. Include the complete BFF response shape:

```javascript
callback({
  ok: true,
  status: 200,
  data: sampleData,
  responseContext: { correlationId: 'storybook-correlation-id' },
  responseCode: 'Success',
  responseResults: [],
});
```

## Impact

These rules affect:
- **Type files** in `libs/contracts/src/types/` (Rule 1)
- **Component fetch logic** in root components (Rule 2)
- **Storybook mocks** in `.storybook/mocks/` (Rule 3)
- **Unit test stubs** in `*.spec.tsx` and `__mocks__/contracts.js` (Rule 3)
- **Code review** — verify all three rules are satisfied during the review step
