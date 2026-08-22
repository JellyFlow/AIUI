# System (system)

## Methods

### `wx.getWindowInfo()`

Takes no parameters.

**Returns:** `{ pixelRatio, screenWidth, screenHeight, windowWidth, windowHeight, statusBarHeight, safeArea }`. Dimensions are logical pixels; `safeArea` contains `left`, `right`, `top`, `bottom`, `width`, and `height`; `statusBarHeight` is currently always `0`. Without an app context, dimensions are `0` and `pixelRatio` is `1`.

### `wx.exitMiniProgram(options?)`

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `options.success` | `Function` | No | Called before the close request is sent. |
| `options.complete` | `Function` | No | Called before the close request is sent. |

**Returns:** `undefined`. Requests closure of the current Mini Program instance; callbacks do not indicate that the host has finished closing.
