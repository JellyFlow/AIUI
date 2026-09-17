# Window

`Window` represents the current AIUI Agent window. The global `window` object lets an Agent read the window dimensions, open a configured Widget, or request that the current Agent close.

This page describes the window capabilities in Ink `v0.18.x`.

## Read the Window Dimensions

Use `innerWidth` and `innerHeight` to read the current viewport dimensions in pixels:

```javascript
const viewport = {
  width: window.innerWidth,
  height: window.innerHeight,
};

console.log(viewport);
```

The runtime maintains both properties. Agents should treat them as read-only information.

## Open a Widget

Call `window.open()` to open a Widget declared in the current Agent's `app.json` `widgets` list. Omit the `.ink` extension from the Widget path. Query parameters may follow the path:

```javascript
window.open('widgets/weather/index?city=hangzhou');
```

The `target` argument is optional and defaults to `_widget`. You can also pass it explicitly:

```javascript
window.open('widgets/weather/index?city=hangzhou', '_widget');
```

In Ink `v0.18.x`, `window.open()` opens declared Widgets only. It cannot open Pages, external URLs, or arbitrary Widgets that are not configured in `app.json.widgets`. The call returns immediately without returning a Widget instance or an opening result. See [Widget](/AIUI/framework/open-agent-format-widget) for declaration details and [Routing](/AIUI/api/route) for the complete routing behavior.

## Close the Current Agent

Call `window.close()` to send the host a request to close the current Agent instance:

```javascript
window.close();
```

The method only sends a close request. The host controls when the Agent closes.

## Global Access

In a regular AIUI window, `window`, `self`, `globalThis`, and `global` refer to the same global object:

```javascript
console.log(window === globalThis); // true
console.log(window === self); // true
console.log(window === global); // true
```

Ink `v0.18.x` explicitly mounts a subset of Web APIs on `window`. Do not assume that every directly accessible global symbol also has a corresponding `window.xxx` property. See the corresponding API pages for exact exposure and limitations.

Agent Workers use a separate global scope and do not provide `Window`. See [AgentWorker](/AIUI/api/framework-agent-worker) for its global object and lifecycle.

## API Reference

### `window.innerWidth`

- **Type**: Read-only `number`.
- **Description**: Returns the width of the current window viewport in pixels.

### `window.innerHeight`

- **Type**: Read-only `number`.
- **Description**: Returns the height of the current window viewport in pixels.

### `window.open(url, target?)`

Requests that the host open a Widget declared by the current Agent.

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `url` | `string` | Yes | A Widget path declared in `app.json.widgets`, with optional query parameters and without the `.ink` extension. |
| `target` | `'_widget'` | No | The opening target. Defaults to `_widget`, the only currently supported value. |

**Return value**: `undefined`.

Throws a `TypeError` when `url` is empty. Do not pass a `target` other than `_widget`; Ink `v0.18.x` does not support opening other targets through this method.

### `window.close()`

Requests that the host close the current Agent instance.

**Return value**: `undefined`.

### `window.atob(encodedData)`

Decodes a Base64-encoded string into a binary string.

- **Parameter**: `encodedData`, a `string` containing the Base64 data to decode.
- **Return value**: The decoded `string`.

### `window.btoa(stringToEncode)`

Encodes a binary string as Base64.

- **Parameter**: `stringToEncode`, the binary `string` to encode.
- **Return value**: The Base64-encoded `string`.
