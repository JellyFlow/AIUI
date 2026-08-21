# System (system)

## Methods

### `wx.getWindowInfo()`

Returns `{ pixelRatio, screenWidth, screenHeight, windowWidth, windowHeight, statusBarHeight, safeArea }`. Width and height are logical pixels; `statusBarHeight` is currently always `0`.

### `wx.exitMiniProgram(options?)`

Requests that the current Mini Program instance be closed. `success()` and `complete()` callbacks are supported and are invoked before sending the close request.

`getSystemInfo`, `getSystemInfoSync`, `getDeviceInfo`, `getAppBaseInfo`, and `getAppAuthorizeSetting` are not currently provided.
