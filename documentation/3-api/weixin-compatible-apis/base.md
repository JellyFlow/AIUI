# 基础 (base)

## 方法

### `wx.canIUse(schema)`

返回 `schema` 是否为非空字符串。当前仅用于兼容性占位，不会校验 API、参数或组件是否实际可用。

### `wx.arrayBufferToBase64(buffer)`

将 `ArrayBuffer` 编码为标准 Base64 字符串。传入已分离的 ArrayBuffer 会抛出异常。

`wx.env` 和 `wx.base64ToArrayBuffer()` 当前未提供。
