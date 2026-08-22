# Base (base)

## Methods

### `wx.canIUse(schema)`

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `schema` | `string` | Yes | Compatibility-query string. |

**Returns:** `boolean`. A non-empty string returns `true`, while an empty string returns `false`; it does not currently check actual API, parameter, or component availability.

### `wx.arrayBufferToBase64(buffer)`

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `buffer` | `ArrayBuffer` | Yes | Binary data to encode. |

**Returns:** `string`, encoded using standard Base64. A detached ArrayBuffer throws an exception.
