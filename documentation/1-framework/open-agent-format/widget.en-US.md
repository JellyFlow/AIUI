# Widget

A Widget is a small, independent interface provided by an agent. It works well for weather, playback status, device data, and quick actions that should be understood at a glance. Widgets use the same `.ink` syntax, data binding, components, and styles as Pages, but have their own entry and a smaller set of lifecycle callbacks.

## Declare a Widget

Declare each Widget in the `widgets` array in `app.json`. Each entry describes the Widget's entry point, size family, and presentation mode.

```json
{
  "pages": ["pages/index/index"],
  "widgets": [
    {
      "path": "widgets/clock/index",
      "family": "1x1",
      "placement": "persistent"
    },
    {
      "path": "widgets/weather/index",
      "family": "1x2",
      "placement": "overlay"
    }
  ]
}
```

### `app.json.widgets` Fields

| Field | Type | Required | Default | Description |
| :--- | :--- | :--- | :--- | :--- |
| `path` | `string` | Yes | - | Project-relative Widget path without the `.ink` extension. The path must resolve to an existing `.ink` file. |
| `family` | `"1x1" \| "1x2"` | Yes | - | Size category occupied by the Widget. For 0.18 compatibility, the same value must also be declared in the Widget file's `<script def>`. |
| `placement` | `"persistent" \| "overlay"` | No | `"persistent"` | How the Widget is presented. Declare this field only in `app.json`, not in the Widget file. |

For example, `widgets/weather/index` maps to `widgets/weather/index.ink`. Keep `path` unique; do not declare the same path more than once in the `widgets` array.

`family` is a size category, not a fixed pixel size. Build the Widget layout to adapt to the actual available width and height.

## Choose a Placement

`placement` determines whether a Widget stays in a fixed position or is presented as temporary content over the current window. It does not change the Widget file structure, data binding, or lifecycle API.

### Persistent Widgets

Set `placement` to `persistent` for content that should remain visible, keep a stable position, or stay readily available for interaction, such as a clock, device status, or fixed quick action.

```json
{
  "path": "widgets/clock/index",
  "family": "1x1",
  "placement": "persistent"
}
```

After a persistent Widget is added to the layout, it keeps its position and is not removed when overlay content is opened or closed. Omitting `placement` selects this behavior, so existing Widget declarations remain compatible.

### Overlay Widgets

Set `placement` to `overlay` for a Widget that can be presented over the current window with `window.open(url, '_widget')`. The current Widget can call `window.close()` to close itself and leave the current overlay layer. This mode suits weather details, playback controls, temporary status, and quick actions.

```json
{
  "path": "widgets/weather/index",
  "family": "1x2",
  "placement": "overlay"
}
```

`overlay` means that the Widget enters and leaves the overlay layer through open and close operations. The runtime calls `onAttach()` and `onDetach()` as the Widget is shown and hidden. Do not use these callbacks for state that must be initialized only once, and do not assume the current instance remains after the overlay is closed.

Use `persistent` when content must stay visible or should not be opened temporarily with `window.open()`. Use `overlay` when content should be entered interactively and can correctly handle opening, closing, and repeated attachment and detachment.

## Create the Widget Interface

Use `<widget>` as the interface root. For 0.18 compatibility, keep declaring `family` in `<script def>` and keep it equal to the value in `app.json`. `placement` and future presentation scheduling fields belong only in `app.json`, not in the `.ink` file.

```html
<script def>
{
  "widget": { "family": "1x2" },
  "usingComponents": {
    "weather-icon": "/components/weather-icon/index"
  }
}
</script>

<script setup>
export default {
  data: {
    city: 'Hangzhou',
    temperature: 24,
  },
  refresh() {
    this.setData({ temperature: this.data.temperature + 1 });
  },
};
</script>

<widget>
  <view class="weather" bindtap="refresh">
    <weather-icon />
    <text>{{city}}</text>
    <text>{{temperature}}°C</text>
  </view>
</widget>

<style>
.weather {
  display: flex;
  flex-direction: column;
  padding: 12px;
}
</style>
```

An `.ink` file cannot contain both `<page>` and `<widget>`. A Widget also fails to load when its `family` does not match the declaration in `app.json`.

## Update Displayed Content

Widgets store interface data in `data` and update it with `setData()`. You can update top-level values or use dotted paths for nested values.

```javascript
export default {
  data: {
    status: { label: 'Idle' },
    count: 0,
  },
  activate() {
    this.setData({
      count: this.data.count + 1,
      'status.label': 'Active',
    });
  },
};
```

## Respond to Widget State Changes

Widgets provide four optional callbacks:

| Callback | Typical use |
| :--- | :--- |
| `onCreate()` | Initialize Widget data and resources that are created once |
| `onAttach()` | Refresh data about to be shown and resume visible work |
| `onDetach()` | Pause work that is only needed while the Widget is shown |
| `onDestroy()` | Cancel requests, remove listeners, and release resources |

```javascript
export default {
  data: { updatedAt: 0 },
  refresh() {
    this.setData({ updatedAt: Date.now() });
  },
  onCreate() {
    console.log('Widget created');
  },
  onAttach() {
    this.refreshTimer = setInterval(() => this.refresh(), 60_000);
  },
  onDetach() {
    clearInterval(this.refreshTimer);
  },
  onDestroy() {
    clearInterval(this.refreshTimer);
  },
};
```

`onAttach()` and `onDetach()` may run more than once, so resume and pause logic should be safe to repeat.

## Widget and Page Differences

- Widgets do not enter the Page navigation stack.
- Widgets use `onCreate()`, `onAttach()`, `onDetach()`, and `onDestroy()` instead of the Page callbacks `onLoad()`, `onShow()`, `onReady()`, `onHide()`, and `onUnload()`.
- Widgets do not provide Page-only features such as `enableWorldAwareness()` and `finish()`.
- Widgets can use data binding, custom components, event handlers, images, and Canvas.
- `family` describes the Widget size category; layouts should still adapt to the available width and height.

## Continue Reading

- [Widget API](/AIUI/api/framework-widget): inspect `data`, `setData()`, size, and state properties
- [app.json](/AIUI/framework/open-agent-format-app-json): configure application entries
- [Components](/AIUI/framework/open-agent-format-custom-components): reuse interface components in a Widget
- [Canvas](/AIUI/api/canvas): draw graphics in a Widget
