# Media (media)

Media APIs are mounted under `wx.media` and depend on the current app instance. Both APIs return `undefined` when the app uses `lifetime: 'cut'`.

## Camera

### `wx.media.createCameraContext()`

Takes no parameters.

**Returns:** `CameraContext | undefined`. It returns `undefined` when no current app instance is available or when the app uses `lifetime: 'cut'`. See [Camera](/AIUI/api/media-camera).

## Recording

### `wx.media.getRecorderManager()`

Takes no parameters.

**Returns:** `RecorderManager | undefined`. Returns a wrapper for the current app's native recorder manager; it returns `undefined` on wasm32, in an app with `lifetime: 'cut'`, or when the app has no recorder manager. See [Recorder](/AIUI/api/media-recorder).
