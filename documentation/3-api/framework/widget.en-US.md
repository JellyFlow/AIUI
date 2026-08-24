# Widget

Widget is AIUI's runtime entry for compact, persistent surfaces. A Widget file must default-export an object. The runtime copies its enumerable properties onto the Widget instance and provides reactive state, host dimensions, and lifecycle capabilities.

## Define Widget State and Interaction

```javascript
export default {
  data: {
    label: 'Ready',
    count: 0,
  },

  onAttach() {
    this.setData({ label: 'Now playing' });
  },

  increment() {
    this.setData({ count: this.data.count + 1 });
  },
};
```

A Widget template uses `<widget>` as its root. Template events call methods with matching names on the default export:

```xml
<widget>
  <view bindtap="increment">
    <text>{{label}}: {{count}}</text>
  </view>
</widget>
```

## Adapt to Host Information

Host metadata is a read-only runtime snapshot that can be used to adapt content to the Widget family or current dimensions:

```javascript
export default {
  onAttach() {
    console.log(this.widgetId, this.family);
    console.log(this.hostWidth, this.hostHeight, this.interactive);
  },
};
```

## Lifecycle and Current Behavior

- Widgets support the `onCreate()`, `onAttach()`, `onDetach()`, and `onDestroy()` lifecycle hooks.
- `setData()` supports top-level keys and dotted paths; its callback runs after native state synchronization.
- Input handlers such as `onKeyDown(event)` and template events such as `bindtap` are dispatched only when the host permits interaction.
- `family` is currently `'1x1'` or `'1x2'`, and `target` is always `'_widget'`.

## API Reference

### Instance Members

| Member | Type | Description |
| --- | --- | --- |
| `this.data` | `Record<string, any>` | Current reactive state. Defaults to `{}`. |
| `this.setData(patch, callback?)` | `Function` | Merges state and synchronizes the Widget surface. |
| `this.widgetId` | `string` | Stable runtime identifier for this Widget instance. |
| `this.family` | `'1x1' \| '1x2'` | Family declared by the manifest and Widget file. |
| `this.target` | `'_widget'` | Widget presentation target. |
| `this.isAttached` | `boolean` | Whether the Widget is attached to its host. |
| `this.interactive` | `boolean` | Whether the host currently permits input. |
| `this.hostWidth` | `number` | Current logical host width. |
| `this.hostHeight` | `number` | Current logical host height. |

### `this.setData(patch, callback?)`

`patch` must be an object. Top-level keys replace matching values, while dotted paths create intermediate objects as needed. The optional `callback` runs after state synchronization.

### Lifecycle Callbacks

| Callback | Timing |
| --- | --- |
| `onCreate()` | After the Widget loads and host state is initialized. |
| `onAttach()` | When the Widget becomes active in its host surface. |
| `onDetach()` | When the Widget is deactivated or before teardown. |
| `onDestroy()` | During final Widget teardown. |
