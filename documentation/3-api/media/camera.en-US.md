# Camera

Get a camera context through `wx.media.createCameraContext()`:

```javascript
const cameraContext = wx.media.createCameraContext();
```

It depends on the current app instance and returns `undefined` when there is no app context or when the app uses `lifetime: 'cut'`.

## `CameraContext.takePhoto(options)`

Takes a photo from a valid user interaction. `options` is required and must include `quality`:

```javascript
const image = await cameraContext.takePhoto(options);
// image.data: ArrayBuffer
// image.mimeType: string
```

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `options` | `object` | Yes | Photo-capture configuration. |
| `options.quality` | `'high' \| 'normal' \| 'low'` | Yes | Image quality: `high`, `normal`, or `low`. |
| `options.enableSystemPreview` | `boolean` | No | When `true`, shows the system camera preview before capture; when `false`, requests capture directly. Defaults to `true`. |

**Returns:** `Promise<{ data: ArrayBuffer, mimeType: string }>`.

| Field | Type | Description |
| --- | --- | --- |
| `data` | `ArrayBuffer` | Complete binary content of the image. |
| `mimeType` | `string` | Image MIME type, such as `image/jpeg`. |

The Promise rejects when capture fails. An exception is thrown when `options` is omitted, `quality` is missing, or the call is not made from a user interaction.

```javascript
const image = await cameraContext.takePhoto({
  quality: 'high',
  enableSystemPreview: true,
});
```

## Recommendations

- Check that `cameraContext` is not `undefined` before use.
- Call `takePhoto()` only from an interaction callback such as a user tap.
- Process, persist, or upload image data using `data` and `mimeType`.

## Continue Reading

- **[WeChat Mini Program Compatible APIs](/AIUI/api/weixin-compatible-apis)**: See the compatibility API list.
- **[Recorder](/AIUI/api/media-recorder)**: Learn about the native recorder manager API.
