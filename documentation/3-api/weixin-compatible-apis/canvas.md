# 画布 (canvas)

## 方法

### `wx.createCanvasContext(canvasId)`

根据当前页面中 `<canvas>` 组件的 ID 创建并返回 2D 绘图上下文；找不到当前页面、对应节点或 Canvas 时返回 `undefined`。

当前不提供 `canvasToTempFilePath`、`canvasGetImageData` 或 `canvasPutImageData`。
