# Camera

Get a camera context through `wx.media.createCameraContext()`:

```javascript
const cameraContext = wx.media.createCameraContext();
```

It depends on the current app instance and returns `undefined` when there is no app context or when the app uses `lifetime: 'cut'`.

## `CameraContext.takePhoto(options)`

Takes a photo from a valid user interaction and returns a Promise:

```javascript
const image = await cameraContext.takePhoto(options);
// image.data: ArrayBuffer
// image.mimeType: string
```

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `options.quality` | `'high' \| 'normal' \| 'low'` | Yes | Requested image quality. |
| `options.enableSystemPreview` | `boolean` | No | Whether to open the system camera preview before capture; defaults to `false`. |

**Returns:** `Promise<{ data: ArrayBuffer, mimeType: string }>`. `data` is image binary data and `mimeType` is its media type. The Promise rejects when capture fails, and an invalid-state exception is thrown when the call is not made from a user interaction.

## Recommendations

- Check that `cameraContext` is not `undefined` before use.
- Call `takePhoto()` only from an interaction callback such as a user tap.
- Process, persist, or upload image data using `data` and `mimeType`.

## Continue Reading

- **[Media (media)](/AIUI/api/weixin-compatible-apis-media)**: View the entry point and availability limits.
- **[Recorder](/AIUI/api/media-recorder)**: Learn about the native recorder manager API.
