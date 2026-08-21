# Recorder

The recorder API wraps the browser's `MediaDevices.getUserMedia()` and `MediaRecorder` through a WeChat Mini Program compatibility API. It captures microphone audio and delivers audio frames as they arrive.

## Entry

Create a recorder manager with `wx.media.getRecorderManager()`:

```javascript
const recorderManager = wx.media.getRecorderManager();
```

Each call creates a new recorder manager. The API is unavailable and returns `undefined` when the app is configured with `lifetime: 'cut'`.

## Basic Usage

Register event handlers before calling `start()`. `start()` is asynchronous and requests microphone permission, so handle a rejected promise.

```javascript
export default {
  onLoad() {
    const recorderManager = wx.media.getRecorderManager();
    this.recorderManager = recorderManager;

    recorderManager.onStart(() => {
      this.setData({ recording: true });
    });
    recorderManager.onFrameRecorded(({ frameBuffer }) => {
      // Process this recorded frame.
      console.log(frameBuffer.byteLength);
    });
    recorderManager.onStop(({ duration, fileSize }) => {
      this.setData({ recording: false });
      console.log(`Duration: ${duration} ms; data size: ${fileSize} bytes`);
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

## Core APIs

### `wx.media.getRecorderManager()`

- **Return value**: `RecorderManager | undefined`
- **Description**: Creates a recorder manager. It returns `undefined` in an app with `lifetime: 'cut'`.

### `RecorderManager.start(options)`

Starts recording and requests microphone permission. If recording is already active, the call returns immediately.

`options` supports the following fields:

| Field | Type | Description |
| --- | --- | --- |
| `format` | `'pcm' \| 'opus'` | Requested audio format. Omit it, or provide any value other than `opus`, to use `pcm`. PCM prefers a WAV container; Opus prefers `audio/ogg;codecs=opus`. If the preferred format is unsupported but Opus is available, recording falls back to Opus. |
| `sampleRate` | `number` | Requested microphone sample rate. The actual rate is determined by the runtime. |
| `numberOfChannels` | `number` | Requested channel count. The actual channel count is determined by the runtime. |
| `frameSize` | `number` | Interval between audio-frame callbacks in milliseconds. Positive values take effect; the default is `250`. |

### `RecorderManager.pause()` / `resume()` / `stop()`

- `pause()`: Pauses an active recording.
- `resume()`: Resumes a paused recording.
- `stop()`: Stops recording. Once stopped, it emits `onStop` and releases microphone tracks; calling it before recording starts or after it has stopped also cleans up any held microphone tracks.

All three methods are asynchronous. A method does not invoke the underlying recorder when its state does not match.

## Events

Each `on*` method sets one callback for its event. Calling it again for the same event replaces the previous callback.

| Method | Callback arguments | Description |
| --- | --- | --- |
| `onStart(callback)` | None | Fires when recording starts. |
| `onPause(callback)` | None | Fires when recording pauses. |
| `onResume(callback)` | None | Fires when recording resumes. |
| `onFrameRecorded(callback)` | `{ frameBuffer: ArrayBuffer, isLastFrame: false }` | Fires for an audio frame. PCM frames have their WAV container header removed, so the callback receives raw PCM data. |
| `onHeader(callback)` | `(format: 'opus', buffer: ArrayBuffer)` | Fires once for the first Opus data frame to provide the Opus/Ogg header data. |
| `onStop(callback)` | `{ tempFilePath: '', duration: number, fileSize: number }` | Fires after recording stops and pending frames have been processed. No temporary file is created, so `tempFilePath` is an empty string. `duration` is in milliseconds and `fileSize` is the total byte count of forwarded audio frames. |
| `onError(callback)` | `{ errMsg: string }` | Fires when the underlying recorder reports an error. |
| `onInterruptionBegin(callback)` | None | A callback can be registered, but the current implementation does not emit this event. |
| `onInterruptionEnd(callback)` | None | A callback can be registered, but the current implementation does not emit this event. |

## Recommendations

- Register `onStart`, `onFrameRecorded`, `onStop`, and `onError` before `start()`, and handle promise rejection when microphone permission is denied or no device is available.
- Set options according to the requirements of the downstream speech service, but do not assume that the runtime will satisfy every requested audio constraint.
- This API delivers audio through frame callbacks and does not create a temporary audio file. Persist or upload `frameBuffer` yourself in `onFrameRecorded` when needed.
- Call `stop()` when the page exits or the recording flow ends to release microphone tracks.

## Continue Reading

- **[Media](/AIUI/api/media)**: Return to the media capability overview.
- **[Camera](/AIUI/api/media-camera)**: Learn about camera capabilities and the camera context.
- **[Media (media)](/AIUI/api/weixin-compatible-apis-media)**: View the entry documentation for WeChat Mini Program compatible APIs.
