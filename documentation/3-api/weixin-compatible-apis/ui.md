# 界面 (ui)

## 方法

### `wx.setBackgroundColor(options)`

| 参数 | 类型 | 必填 | 说明 |
| --- | --- | --- | --- |
| `options.backgroundColor` | `string` | 否 | 页面背景色。 |
| `options.backgroundColorTop` | `string` | 否 | 顶部背景色。 |
| `options.backgroundColorBottom` | `string` | 否 | 底部背景色。 |
| `options.success` | `Function` | 否 | 调用成功回调。 |
| `options.complete` | `Function` | 否 | 调用结束回调。 |

**返回值：** `undefined`。当前绑定不将颜色应用到渲染器，但会依次调用提供的 `success` 和 `complete`。
