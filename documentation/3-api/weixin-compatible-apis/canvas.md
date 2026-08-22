# 画布 (canvas)

## 方法

### `wx.createCanvasContext(canvasId)`

| 参数 | 类型 | 必填 | 说明 |
| --- | --- | --- | --- |
| `canvasId` | `string` | 是 | 当前页面中 `<canvas>` 节点的 ID。 |

**返回值：** 对应 Canvas 的 2D 绘图上下文；找不到当前页面、节点或 Canvas 时为 `undefined`。
