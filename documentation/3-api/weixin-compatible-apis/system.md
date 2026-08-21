# 系统 (system)

## 方法

### `wx.getWindowInfo()`

返回 `{ pixelRatio, screenWidth, screenHeight, windowWidth, windowHeight, statusBarHeight, safeArea }`。宽高为逻辑像素；当前 `statusBarHeight` 固定为 `0`。

### `wx.exitMiniProgram(options?)`

请求关闭当前小程序实例。可传入 `success()` 与 `complete()` 回调；两者会在关闭请求发送前调用。

`getSystemInfo`、`getSystemInfoSync`、`getDeviceInfo`、`getAppBaseInfo` 和 `getAppAuthorizeSetting` 当前未提供。
