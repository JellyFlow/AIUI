# Base (base)

## Methods

### `wx.canIUse(schema)`

Returns whether `schema` is a non-empty string. It is currently a compatibility placeholder and does not check whether an API, parameter, or component is actually available.

### `wx.arrayBufferToBase64(buffer)`

Encodes an `ArrayBuffer` as a standard Base64 string. A detached ArrayBuffer throws an exception.

`wx.env` and `wx.base64ToArrayBuffer()` are not currently provided.
