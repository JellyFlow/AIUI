# 相机

通过 `wx.media.createCameraContext()` 获取相机上下文：

```javascript
const cameraContext = wx.media.createCameraContext();
```

该方法依赖当前应用实例；应用配置 `lifetime: 'cut'` 或应用上下文不存在时返回 `undefined`。

## `CameraContext.takePhoto(options)`

在有效用户交互中拍照，并返回 Promise：

```javascript
const image = await cameraContext.takePhoto(options);
// image.data: ArrayBuffer
// image.mimeType: string
```

`options` 会按原样解析为宿主平台的拍照选项。拍照失败时 Promise 会拒绝；调用不在用户交互中时会抛出状态异常。

## 使用建议

- 在使用前检查 `cameraContext` 是否为 `undefined`。
- 仅在用户点击等交互回调内调用 `takePhoto()`。
- 使用 `data` 和 `mimeType` 自行处理、保存或上传图像数据。

## 继续阅读

- **[多媒体 (media)](/AIUI/api/weixin-compatible-apis-media)**：查看入口和可用性限制。
- **[录音](/AIUI/api/media-recorder)**：查看原生录音管理器接口。
