# Media (media)

Media APIs are mounted under `wx.media` and depend on the current app instance. Both APIs return `undefined` when the app uses `lifetime: 'cut'`.

## Camera

### `wx.media.createCameraContext()`

Creates a `CameraContext`; it returns `undefined` when no current app instance is available. See [Camera](/AIUI/api/media-camera).

## Recording

### `wx.media.getRecorderManager()`

Returns a wrapper for the current app's native `RecorderManager`. It returns `undefined` on wasm32, in an app with `lifetime: 'cut'`, or when the app has no recorder manager. See [Recorder](/AIUI/api/media-recorder).
