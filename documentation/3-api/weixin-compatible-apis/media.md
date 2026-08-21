# 多媒体 (media)

媒体接口挂载在 `wx.media` 下，并依赖当前应用实例。应用配置 `lifetime: 'cut'` 时，两项接口均返回 `undefined`。

## 相机

### `wx.media.createCameraContext()`

无参数。

**返回值：** `CameraContext | undefined`。没有当前应用实例或应用使用 `lifetime: 'cut'` 时返回 `undefined`。详见：[相机](/AIUI/api/media-camera)。

## 录音

### `wx.media.getRecorderManager()`

无参数。

**返回值：** `RecorderManager | undefined`。返回当前应用的原生录音管理器包装对象；wasm32、`lifetime: 'cut'`，或应用未配置录音管理器时返回 `undefined`。详见：[录音](/AIUI/api/media-recorder)。
