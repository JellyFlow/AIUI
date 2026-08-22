# 基础 (base)

## 方法

### `wx.canIUse(schema)`

| 参数 | 类型 | 必填 | 说明 |
| --- | --- | --- | --- |
| `schema` | `string` | 是 | 兼容性查询字符串。 |

**返回值：** `boolean`。非空字符串返回 `true`，空字符串返回 `false`；当前不校验 API、参数或组件是否实际可用。

### `wx.arrayBufferToBase64(buffer)`

| 参数 | 类型 | 必填 | 说明 |
| --- | --- | --- | --- |
| `buffer` | `ArrayBuffer` | 是 | 要编码的二进制数据。 |

**返回值：** `string`，标准 Base64 编码结果。传入已分离的 ArrayBuffer 会抛出异常。
