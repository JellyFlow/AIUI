# 录音

录音接口通过当前应用的原生录音管理器提供：

```javascript
const recorderManager = wx.media.getRecorderManager();
```

wasm32 目标、`lifetime: 'cut'` 应用、没有当前应用实例，或应用未配置录音管理器时，该方法返回 `undefined`。

## 方法

`start(options)`、`pause()`、`resume()` 和 `stop()` 均返回 Promise。`start()` 必须在有效用户交互中调用，且宿主窗口必须处于焦点状态；`resume()` 同样要求窗口具有焦点。

`start(options)` 的选项由原生录音后端解析，当前公开字段为 `sampleRate`（默认 `16000`）、`numberOfChannels`（默认 `1`）与 `format`（默认 `pcm`）。不同宿主平台最终支持的格式和实际音频参数可能不同。

## 事件

每个 `on*` 方法为对应事件设置一个回调；再次设置会替换前一个回调。

| 方法 | 回调参数 |
| --- | --- |
| `onStart(callback)`、`onPause(callback)`、`onResume(callback)` | 无 |
| `onStop(callback)` | `{ tempFilePath: string }` |
| `onFrameRecorded(callback)` | `{ frameBuffer: ArrayBuffer }` |
| `onHeader(callback)` | `(format: string, buffer: ArrayBuffer)` |
| `onError(callback)` | `{ errMsg: string }` |
| `onInterruptionBegin(callback)`、`onInterruptionEnd(callback)` | 无 |

## 示例

```javascript
const recorderManager = wx.media.getRecorderManager();
if (!recorderManager) return;

recorderManager.onFrameRecorded(({ frameBuffer }) => {
  // 处理原生录音后端提供的音频帧。
});
recorderManager.onError(({ errMsg }) => console.error(errMsg));

await recorderManager.start({ sampleRate: 16000, numberOfChannels: 1, format: 'pcm' });
```

## 继续阅读

- **[多媒体 (media)](/AIUI/api/weixin-compatible-apis-media)**：查看入口与平台限制。
