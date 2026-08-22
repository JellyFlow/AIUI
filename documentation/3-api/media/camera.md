# 相机

通过 `wx.media.createCameraContext()` 获取相机上下文：

```javascript
const cameraContext = wx.media.createCameraContext();
```

该方法依赖当前应用实例；应用配置 `lifetime: 'cut'` 或应用上下文不存在时返回 `undefined`。

## `CameraContext.takePhoto(options)`

在有效用户交互中拍照。`options` 必须传入，并且必须包含 `quality`：

```javascript
const image = await cameraContext.takePhoto(options);
// image.data: ArrayBuffer
// image.mimeType: string
```

| 参数 | 类型 | 必填 | 说明 |
| --- | --- | --- | --- |
| `options` | `object` | 是 | 拍照配置对象。 |
| `options.quality` | `'high' \| 'normal' \| 'low'` | 是 | 图像质量：`high` 为高质量、`normal` 为普通质量、`low` 为低质量。 |
| `options.enableSystemPreview` | `boolean` | 否 | `true` 时先显示系统相机预览界面再拍摄；`false` 时直接请求拍摄。省略时为 `true`。 |

**返回值：** `Promise<{ data: ArrayBuffer, mimeType: string }>`。

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `data` | `ArrayBuffer` | 图像的完整二进制内容。 |
| `mimeType` | `string` | 图像 MIME 类型，例如 `image/jpeg`。 |

拍照失败时 Promise 拒绝；未传入 `options`、缺少 `quality` 或调用不在用户交互中时会抛出异常。

```javascript
const image = await cameraContext.takePhoto({
  quality: 'high',
  enableSystemPreview: true,
});
```

## 使用建议

- 在使用前检查 `cameraContext` 是否为 `undefined`。
- 仅在用户点击等交互回调内调用 `takePhoto()`。
- 使用 `data` 和 `mimeType` 自行处理、保存或上传图像数据。

## 继续阅读

- **[多媒体 (media)](/AIUI/api/weixin-compatible-apis-media)**：查看入口和可用性限制。
- **[录音](/AIUI/api/media-recorder)**：查看原生录音管理器接口。
