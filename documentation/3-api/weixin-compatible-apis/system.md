# 系统 (system)

## 方法

### `wx.getWindowInfo()`

无参数。

**返回值：** `{ pixelRatio, screenWidth, screenHeight, windowWidth, windowHeight, statusBarHeight, safeArea }`。宽高为逻辑像素；`safeArea` 包含 `left`、`right`、`top`、`bottom`、`width`、`height`；当前 `statusBarHeight` 固定为 `0`。无应用上下文时，尺寸为 `0`、`pixelRatio` 为 `1`。

### `wx.exitMiniProgram(options?)`

| 参数 | 类型 | 必填 | 说明 |
| --- | --- | --- | --- |
| `options.success` | `Function` | 否 | 发送关闭请求前调用。 |
| `options.complete` | `Function` | 否 | 发送关闭请求前调用。 |

**返回值：** `undefined`。请求关闭当前小程序实例；回调不代表宿主已完成关闭。
