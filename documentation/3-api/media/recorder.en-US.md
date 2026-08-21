# Recorder

The recorder API is provided by the current app's native recorder manager:

```javascript
const recorderManager = wx.media.getRecorderManager();
```

It returns `undefined` on wasm32, in an app with `lifetime: 'cut'`, without a current app instance, or when the app has no recorder manager.

## Methods

`start(options)`, `pause()`, `resume()`, and `stop()` return Promises. `start()` must be called from a valid user interaction while the host window is focused; `resume()` also requires a focused host window.

`start(options)` is parsed by the native recorder backend. Its current public fields are `sampleRate` (default `16000`), `numberOfChannels` (default `1`), and `format` (default `pcm`). The final audio parameters and supported formats vary by host platform.

## Events

Each `on*` method sets one callback for its event; setting it again replaces the previous callback.

| Method | Callback arguments |
| --- | --- |
| `onStart(callback)`, `onPause(callback)`, `onResume(callback)` | None |
| `onStop(callback)` | `{ tempFilePath: string }` |
| `onFrameRecorded(callback)` | `{ frameBuffer: ArrayBuffer }` |
| `onHeader(callback)` | `(format: string, buffer: ArrayBuffer)` |
| `onError(callback)` | `{ errMsg: string }` |
| `onInterruptionBegin(callback)`, `onInterruptionEnd(callback)` | None |

## Example

```javascript
const recorderManager = wx.media.getRecorderManager();
if (!recorderManager) return;

recorderManager.onFrameRecorded(({ frameBuffer }) => {
  // Process an audio frame provided by the native recorder backend.
});
recorderManager.onError(({ errMsg }) => console.error(errMsg));

await recorderManager.start({ sampleRate: 16000, numberOfChannels: 1, format: 'pcm' });
```

## Continue Reading

- **[Media (media)](/AIUI/api/weixin-compatible-apis-media)**: View the entry point and platform limits.
