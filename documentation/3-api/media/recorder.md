# 录音

录音能力通过微信小程序兼容接口封装浏览器的 `MediaDevices.getUserMedia()` 与 `MediaRecorder`，用于采集麦克风音频并持续接收音频帧。

## 入口

通过 `wx.media.getRecorderManager()` 创建录音管理器：

```javascript
const recorderManager = wx.media.getRecorderManager();
```

该方法每次调用都会返回一个新的录音管理器。若应用配置 `lifetime: 'cut'`，该接口不可用并返回 `undefined`。

## 基本用法

先注册事件监听器，再调用 `start()`。`start()` 是异步方法：调用时会请求麦克风权限，因此应处理其拒绝结果。

```javascript
export default {
  onLoad() {
    const recorderManager = wx.media.getRecorderManager();
    this.recorderManager = recorderManager;

    recorderManager.onStart(() => {
      this.setData({ recording: true });
    });
    recorderManager.onFrameRecorded(({ frameBuffer }) => {
      // 处理本次录音帧。
      console.log(frameBuffer.byteLength);
    });
    recorderManager.onStop(({ duration, fileSize }) => {
      this.setData({ recording: false });
      console.log(`录音时长：${duration} ms，数据大小：${fileSize} bytes`);
    });
    recorderManager.onError(({ errMsg }) => {
      console.error(errMsg);
    });
  },

  async startRecording() {
    await this.recorderManager.start({
      format: 'pcm',
      sampleRate: 16000,
      numberOfChannels: 1,
      frameSize: 250,
    });
  },

  async stopRecording() {
    await this.recorderManager.stop();
  },
};
```

## 核心接口

### `wx.media.getRecorderManager()`

- **返回值**：`RecorderManager | undefined`
- **说明**：创建录音管理器。在 `lifetime: 'cut'` 应用中返回 `undefined`。

### `RecorderManager.start(options)`

开始录音并请求麦克风权限。录音已经处于活动状态时，调用会直接返回。

`options` 支持以下字段：

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `format` | `'pcm' \| 'opus'` | 期望的音频格式；省略或非 `opus` 值使用 `pcm`。`pcm` 优先使用 WAV 容器，`opus` 优先使用 `audio/ogg;codecs=opus`。当首选格式不受支持而 Opus 可用时，会回退到 Opus。 |
| `sampleRate` | `number` | 请求麦克风使用的采样率。实际采样率由运行环境决定。 |
| `numberOfChannels` | `number` | 请求的声道数。实际声道数由运行环境决定。 |
| `frameSize` | `number` | 音频帧回调间隔，单位为毫秒；正数生效，默认值为 `250`。 |

### `RecorderManager.pause()` / `resume()` / `stop()`

- `pause()`：录音中时暂停录音。
- `resume()`：暂停时恢复录音。
- `stop()`：停止录音。停止完成后会触发 `onStop`，并释放麦克风轨道；未开始或已停止时调用也会清理已持有的麦克风轨道。

这些方法均为异步方法。状态不匹配时不会执行底层操作。

## 事件

每个 `on*` 方法为对应事件设置一个回调；对同一事件再次调用会替换前一个回调。

| 方法 | 回调参数 | 说明 |
| --- | --- | --- |
| `onStart(callback)` | 无 | 录音开始时触发。 |
| `onPause(callback)` | 无 | 录音暂停时触发。 |
| `onResume(callback)` | 无 | 录音恢复时触发。 |
| `onFrameRecorded(callback)` | `{ frameBuffer: ArrayBuffer, isLastFrame: false }` | 收到音频数据帧时触发。PCM 帧会移除 WAV 容器头，回调中提供原始 PCM 数据。 |
| `onHeader(callback)` | `(format: 'opus', buffer: ArrayBuffer)` | Opus 录音的首个数据帧会触发一次，用于提供 Opus/Ogg 头数据。 |
| `onStop(callback)` | `{ tempFilePath: '', duration: number, fileSize: number }` | 录音停止并处理完待发送的数据帧后触发。当前不生成临时文件，因此 `tempFilePath` 为空字符串；`duration` 单位为毫秒，`fileSize` 为已转发音频帧的总字节数。 |
| `onError(callback)` | `{ errMsg: string }` | 底层录音器报告错误时触发。 |
| `onInterruptionBegin(callback)` | 无 | 可注册回调；当前实现不会触发该事件。 |
| `onInterruptionEnd(callback)` | 无 | 可注册回调；当前实现不会触发该事件。 |

## 使用建议

- 在调用 `start()` 前注册 `onStart`、`onFrameRecorded`、`onStop` 和 `onError`，并处理麦克风权限被拒绝或设备不可用导致的 Promise 拒绝。
- 根据下游语音服务对采样率、声道数和帧间隔的要求设置选项，但不要假设运行环境一定会满足所请求的音频约束。
- 当前 API 通过帧回调交付音频数据，不会生成临时音频文件；需要持久化或上传时，请在 `onFrameRecorded` 中自行处理 `frameBuffer`。
- 页面退出或录音流程结束时调用 `stop()`，以释放麦克风轨道。

## 继续阅读

- **[多媒体](/AIUI/api/media)**：返回多媒体能力总览。
- **[相机](/AIUI/api/media-camera)**：查看相机能力与相机上下文。
- **[多媒体 (media)](/AIUI/api/weixin-compatible-apis-media)**：查看微信小程序兼容接口中的入口说明。
