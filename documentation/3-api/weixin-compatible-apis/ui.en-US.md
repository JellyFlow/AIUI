# UI (ui)

## Methods

### `wx.setBackgroundColor(options)`

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `options.backgroundColor` | `string` | No | Page background color. |
| `options.backgroundColorTop` | `string` | No | Top background color. |
| `options.backgroundColorBottom` | `string` | No | Bottom background color. |
| `options.success` | `Function` | No | Success callback. |
| `options.complete` | `Function` | No | Completion callback. |

**Returns:** `undefined`. The current binding does not apply colors to the renderer, but invokes supplied `success` and `complete` callbacks in that order.
