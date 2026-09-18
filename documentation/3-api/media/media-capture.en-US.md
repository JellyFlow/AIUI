# Media Capture

AIUI provides `navigator.mediaDevices`, `ImageCapture`, and `MediaRecorder` for camera or microphone streams, still-image capture, and audio/video recording.

## Acquire Camera and Microphone Streams

Media capture must begin during a valid user interaction while the AIUI application window is focused:

```javascript
const stream = await navigator.mediaDevices.getUserMedia({
  audio: true,
  video: {
    width: { ideal: 1280 },
    height: { ideal: 720 },
  },
});

console.log(stream.getAudioTracks(), stream.getVideoTracks());
```

Stop every track after use to release its device:

```javascript
for (const track of stream.getTracks()) {
  track.stop();
}
```

## Capture an Image for Scanning

To scan a QR code or barcode, use `wide` mode to capture an image with a default resolution of `2688 × 2016`:

<!-- aiui-api-style default=web -->

**Web**

```javascript api-style=web
const stream = await navigator.mediaDevices.getUserMedia({ video: true });
const [videoTrack] = stream.getVideoTracks();
const capture = new ImageCapture(videoTrack);

const scanImage = await capture.takePhoto({
  quality: 'high',
  mode: 'wide',
  enableSystemPreview: true,
});

console.log(scanImage.type, scanImage.size);
videoTrack.stop();
```

**wx**

```javascript api-style=wx
const camera = wx.media.createCameraContext();
if (!camera) throw new Error('Camera is unavailable');

const scanImage = await camera.takePhoto({
  quality: 'high',
  mode: 'wide',
  enableSystemPreview: true,
});

console.log(scanImage.mimeType, scanImage.data.byteLength);
```

<!-- /aiui-api-style -->

The result is an encoded image that can be passed to a QR-code or barcode recognition workflow.

## Capture an Image for a Reading Agent

When a reading agent needs to analyze text, a document, or an object, use `telephoto` mode to capture a portrait-oriented image with a default resolution of `1512 × 2016`:

<!-- aiui-api-style default=web -->

**Web**

```javascript api-style=web
const stream = await navigator.mediaDevices.getUserMedia({ video: true });
const [videoTrack] = stream.getVideoTracks();
const capture = new ImageCapture(videoTrack);

const readingImage = await capture.takePhoto({
  quality: 'high',
  mode: 'telephoto',
  enableSystemPreview: true,
});

console.log(readingImage.type, readingImage.size);
videoTrack.stop();
```

**wx**

```javascript api-style=wx
const camera = wx.media.createCameraContext();
if (!camera) throw new Error('Camera is unavailable');

const readingImage = await camera.takePhoto({
  quality: 'high',
  mode: 'telephoto',
  enableSystemPreview: true,
});

console.log(readingImage.mimeType, readingImage.data.byteLength);
```

<!-- /aiui-api-style -->

The result can be used as image input for a reading agent or an AI image-understanding workflow.

## Capture a Photo

To capture a photo, use either the Web `ImageCapture` API or the compatible API provided by `wx.media`:

<!-- aiui-api-style default=web -->

**Web**

```javascript api-style=web
const stream = await navigator.mediaDevices.getUserMedia({ video: true });
const [videoTrack] = stream.getVideoTracks();
const capture = new ImageCapture(videoTrack);

const photo = await capture.takePhoto({
  quality: 'high',
  mode: 'default',
  enableSystemPreview: true,
});

console.log(photo.type, photo.size);
videoTrack.stop();
```

**wx**

```javascript api-style=wx
const camera = wx.media.createCameraContext();
if (!camera) throw new Error('Camera is unavailable');

const photo = await camera.takePhoto({
  quality: 'high',
  mode: 'default',
  enableSystemPreview: true,
});

console.log(photo.mimeType, photo.data.byteLength);
```

<!-- /aiui-api-style -->

The Web `ImageCapture` API requires a video track. `takePhoto()` returns an encoded `Blob`, while `grabFrame()` can capture an in-memory `ImageBitmap`. Stop the video track after use.

## Record Audio

Both API styles continuously deliver data chunks that the application can process:

To inspect microphone volume, waveform, or frequency data in real time, pass the same `MediaStream` to `AudioContext.createMediaStreamSource()`. See [Audio Processing (Web Audio)](/AIUI/api/media-web-audio#analyse-microphone-input) for a complete example.

<!-- aiui-api-style default=web -->

**Web**

```javascript api-style=web
const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
const recorder = new MediaRecorder(stream, {
  mimeType: 'audio/ogg;codecs=opus',
});

recorder.addEventListener('dataavailable', async (event) => {
  const chunk = await event.data.arrayBuffer();
  console.log(chunk.byteLength);
});

recorder.start(250);
// Call recorder.stop() when recording is complete.
```

**wx**

```javascript api-style=wx
const recorder = wx.media.getRecorderManager();
if (!recorder) throw new Error('Recorder is unavailable');

recorder.onHeader((format, headerBuffer) => {
  console.log(format, headerBuffer.byteLength);
});
recorder.onFrameRecorded(({ frameBuffer }) => {
  console.log(frameBuffer.byteLength);
});

await recorder.start({
  sampleRate: 16000,
  numberOfChannels: 1,
  format: 'opus',
  frameSize: 250,
});
```

<!-- /aiui-api-style -->

## Permissions and Current Limits

- `getUserMedia()` and `MediaRecorder.start()` must run during a valid user interaction while the AIUI application window is focused.
- Media capture is unavailable when `app.config.lifetime === 'cut'`.
- The Agent Manifest must declare the corresponding camera or microphone permission; permission denial rejects the Promise.
- `MediaRecorder` currently recognizes `audio/wav`, `audio/ogg;codecs=opus`, `video/webm;codecs=vp8,opus`, and `video/mp4`.
- Constraints are requests. A device may return different compatible settings; read the final result with `track.getSettings()`.

## API Reference

### `navigator.mediaDevices`

#### `getUserMedia(constraints)`

Requests an audio or video media stream and returns `Promise<MediaStream>`. `constraints.audio` and `constraints.video` can be booleans or constraint objects; enable at least one media type. Current fields include `deviceId`, `sampleRate`, `channelCount`, `echoCancellation`, `facingMode`, `width`, `height`, and `frameRate`.

Call this method during a valid user interaction while the AIUI application window is focused. Constraints express requested targets; read the settings ultimately selected for each track with `getSettings()`. The promise rejects when permission is denied, a device is unavailable, or the constraints cannot be satisfied.

#### `enumerateDevices()`

Enumerates available audio-input and video-input devices and returns `Promise<MediaDeviceInfo[]>`. Each entry contains `deviceId`, `groupId`, `kind`, and `label`; `kind` is either `'audioinput'` or `'videoinput'`. Use `deviceId` in a later `getUserMedia()` constraint to select a specific device.

```javascript
const devices = await navigator.mediaDevices.enumerateDevices();
const cameras = devices.filter((device) => device.kind === 'videoinput');
if (cameras.length === 0) throw new Error('No camera is available');

const stream = await navigator.mediaDevices.getUserMedia({
  video: { deviceId: { exact: cameras[0].deviceId } },
});
```

#### `getSupportedConstraints()`

Returns `MediaTrackSupportedConstraints`. A field whose value is `true` can be used in a `getUserMedia()` constraint object; this only means that AIUI recognizes the field, not that the current device can satisfy every possible value.

### `MediaStream`

#### `new MediaStream()`

Creates an empty media stream with no tracks. A new empty stream has `active === false` and is useful when a flow needs a stream container before tracks are supplied elsewhere.

#### `id`

A read-only `string` that remains unchanged for the lifetime of the media stream. Use it to distinguish streams, not devices; device selection uses `MediaDeviceInfo.deviceId`.

#### `active`

A read-only `boolean` that is `true` while the stream contains at least one track whose `readyState` is `'live'`. It becomes `false` after every track ends. Reading this property does not start or stop capture.

#### `getTracks()`

Returns a new `MediaStreamTrack[]` containing every audio and video track in the stream. Changing the returned array does not change the stream. To end capture, call `stop()` on each track.

#### `getAudioTracks()`

Returns a new `MediaStreamTrack[]` containing only tracks whose `kind` is `'audio'`. Returns an empty array when the stream has no audio track.

#### `getVideoTracks()`

Returns a new `MediaStreamTrack[]` containing only tracks whose `kind` is `'video'`. Returns an empty array when the stream has no video track.

#### `getTrackById(id)`

Finds a track by an exact track `id`. Returns the same `MediaStreamTrack` object when one matches, or `null` otherwise. This method does not search by device `deviceId`.

### `MediaStreamTrack`

#### `id`

A read-only `string` that remains unchanged for the lifetime of the track. Pass it to `MediaStream.getTrackById()` to retrieve that track again from the same stream.

#### `kind`

A read-only value of either `'audio'` or `'video'`, indicating the type of media carried by the track. Use it to distinguish microphone and camera tracks in a mixed stream.

#### `label`

A read-only `string` describing the media source associated with the track. The display name can vary with the device and permission state. Use `id` or the settings `deviceId` for application logic instead of depending on label text.

#### `enabled`

A writable `boolean`. Set it to `false` to stop the track from supplying usable media data downstream without ending the track or releasing its device. Set it back to `true` to continue. Call `stop()` when capture must end completely.

```javascript
const [microphone] = stream.getAudioTracks();
microphone.enabled = false; // Temporarily mute.
microphone.enabled = true;  // Resume capture.
```

#### `muted`

A read-only `boolean` indicating whether the media source is currently unable to provide data, for example during a temporary system interruption. Unlike `enabled`, which the application controls, `muted` reflects the current source state.

#### `readyState`

A read-only value of either `'live'` or `'ended'`. A live track can continue providing data. Calling `stop()` or permanently losing the media source changes it to `'ended'`. An ended track cannot be restarted; call `getUserMedia()` again to obtain a new one.

#### `getConstraints()`

Returns `MediaTrackConstraints` containing the constraints requested when the track was acquired. These are application requests and may differ from the settings ultimately selected by the device; use `getSettings()` for actual values.

#### `getSettings()`

Returns `MediaTrackSettings` containing the device and media settings ultimately selected for the track, such as `deviceId`, audio sample rate and channel count, or video dimensions and frame rate. Available fields depend on the track type and device.

```javascript
const [videoTrack] = stream.getVideoTracks();
const { deviceId, width, height, frameRate } = videoTrack.getSettings();
console.log({ deviceId, width, height, frameRate });
```

#### `stop()`

Stops the track and changes `readyState` to `'ended'`. Returns no value. Calling it again on an ended track has no additional effect. Other tracks using the same device are unaffected, so stop every track when releasing a complete stream.

```javascript
for (const track of stream.getTracks()) {
  track.stop();
}
```

### `ImageCapture`

#### `new ImageCapture(videoTrack)`

Creates an image capture object from a video `MediaStreamTrack` whose `readyState` is still `'live'`. Passing a value that is not a `MediaStreamTrack`, or a track whose `kind` is not `'video'`, throws a `TypeError`. Passing an ended track throws `InvalidStateError`.

#### `takePhoto(settings?)`

Captures an encoded image and returns `Promise<Blob>`. `Blob.type` is the actual image MIME type and `Blob.size` is its encoded byte size. Call it during a valid user interaction while the AIUI application window is focused. An ended video track causes `InvalidStateError`; capture failures reject the promise.

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `settings.quality` | `'high' \| 'normal' \| 'low'` | No | Image quality. Defaults to `'high'`. |
| `settings.mode` | `'default' \| 'wide' \| 'telephoto'` | No | Capture mode. Defaults to `'default'`. |
| `settings.enableSystemPreview` | `boolean` | No | Whether to show the system camera preview first. Defaults to `true`. |

#### `grabFrame()`

Captures the current video frame and returns `Promise<ImageBitmap>`. The result contains decoded in-memory pixels, not the original JPEG or PNG bytes; use `takePhoto()` when an encoded image is required. Call it during a valid user interaction while the AIUI application window is focused. An ended video track causes `InvalidStateError`.

```javascript
const bitmap = await capture.grabFrame();
const canvas = document.createElement('canvas');
canvas.width = bitmap.width;
canvas.height = bitmap.height;

const context = canvas.getContext('2d');
context.drawImage(bitmap, 0, 0);
const pixels = context.getImageData(0, 0, bitmap.width, bitmap.height).data;

console.log(pixels.length); // Number of RGBA bytes.
bitmap.close();
```

### `MediaRecorder`

#### `new MediaRecorder(stream, options?)`

Creates a recorder for the specified `MediaStream`. Its initial `state` is `'inactive'`. `options.mimeType` selects the output format and defaults to `audio/wav`. AIUI currently supports `audio/wav`, `audio/ogg;codecs=opus`, `video/webm;codecs=vp8,opus`, and `video/mp4`; an unsupported value throws a `TypeError`. The stream must contain at least one audio or video track when recording starts.

#### `state`

A read-only value of `'inactive'`, `'recording'`, or `'paused'`. A new or stopped recorder is inactive, an active recorder is recording, and a paused recorder is paused. Check this property before control calls to avoid `InvalidStateError`.

#### `mimeType`

A read-only `string` containing the output MIME type actually used by the recorder. It comes from the constructor option or defaults to `audio/wav`. Use this value or `event.data.type` to choose how to decode `dataavailable` blobs.

#### `start(timeslice?)`

Starts recording. The optional `timeslice` specifies the data-chunk interval in milliseconds; when provided, the recorder dispatches `dataavailable` events at that cadence. Returns no value. Call it during a valid user interaction while the AIUI application window is focused. It can only be called while `state === 'inactive'`; otherwise it throws `InvalidStateError`.

#### `pause()`

Pauses an active recording and changes `state` to `'paused'`. Returns no value. It can only be called while `state === 'recording'`; otherwise it throws `InvalidStateError`. Pausing does not end the current recording session.

#### `resume()`

Resumes a paused recording and changes `state` to `'recording'`. Returns no value. It can only be called while `state === 'paused'`; otherwise it throws `InvalidStateError`. The AIUI application window must be focused when it is called.

#### `requestData()`

Requests immediate delivery of the currently accumulated chunk through a `dataavailable` event without ending the recording session. Returns no value. Calling it while the recorder is `'inactive'` throws `InvalidStateError`.

```javascript
recorder.addEventListener('dataavailable', ({ data }) => {
  console.log('Immediate chunk', data.size);
});

recorder.start();
recorder.requestData();
```

#### `stop()`

Stops recording, requests delivery of remaining data, and then dispatches the `stop` event. Its `state` changes to `'inactive'`. Returns no value. Calling it while already inactive has no additional effect.

#### `MediaRecorder.isTypeSupported(type)`

Checks whether the specified MIME type can be recorded and returns a `boolean`. Call it before constructing `MediaRecorder` to avoid a `TypeError` for an unsupported format.

```javascript
const preferredType = 'audio/ogg;codecs=opus';
const mimeType = MediaRecorder.isTypeSupported(preferredType)
  ? preferredType
  : 'audio/wav';

const recorder = new MediaRecorder(stream, { mimeType });
```

#### `dataavailable` event

Dispatched when a new recorded data chunk is available. `event.data` is a `Blob` containing encoded data. A chunk can be produced by `timeslice`, `requestData()`, or `stop()`. Preserve chunk order during asynchronous processing and interpret the encoding using `Blob.type`.

#### `start` event

Dispatched after `start()` successfully enters the recording state. At this point, `state === 'recording'`.

#### `pause` event

Dispatched after `pause()` successfully pauses recording. At this point, `state === 'paused'`.

#### `resume` event

Dispatched after `resume()` successfully resumes recording. At this point, `state === 'recording'`.

#### `stop` event

Dispatched after recording stops and the remaining `dataavailable` data has been delivered. Use it to finalize chunk assembly or release media tracks.

#### `error` event

Dispatched when an error occurs during recording. The error ends the current recording session and returns the recorder to `'inactive'`. Stop media tracks that are no longer needed and provide a retry path to the user.

### `wx.media`

#### `wx.media.createCameraContext()`

Returns a `CameraContext` available to the current AIUI application. It returns `undefined` on wasm32, when `app.config.lifetime === 'cut'`, when no current app exists, or when camera capture is unavailable in the current environment. Check the result before taking a photo. The object does not require manual disposal.

#### `wx.media.getRecorderManager()`

Returns a `RecorderManager` available to the current AIUI application. It returns `undefined` on wasm32, when `app.config.lifetime === 'cut'`, when no current app exists, or when audio recording is unavailable in the current environment. Check the result and register the required callbacks before recording.

### `CameraContext`

#### `CameraContext.takePhoto(options)`

Captures an encoded image and returns `Promise<{ data: ArrayBuffer, mimeType: string }>`. `data` contains the complete encoded image bytes and `mimeType` identifies the actual encoding. The pair can be passed directly to file upload, code recognition, or agent image-input workflows.

Call it during a valid user interaction while the AIUI application window is focused. A failed interaction check throws immediately; a failure during capture rejects the promise.

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `options.quality` | `'high' \| 'normal' \| 'low'` | No | Image quality. Defaults to `'high'`. |
| `options.mode` | `'default' \| 'wide' \| 'telephoto'` | No | Semantic capture mode. Defaults to `'default'`. See the table below for each mode's default output resolution and recommended use cases. |
| `options.enableSystemPreview` | `boolean` | No | Whether to show the system camera preview first. Defaults to `true`. |

`mode` selects an AIUI-defined capture capability. Each mode behaves as follows:

| Mode | Default output resolution | Framing | Recommended use cases |
| --- | --- | --- | --- |
| `'default'` | `4032 × 3024` | Uses the full field of view (FOV) and full resolution to preserve the most scene and image detail. | General photography; used when `mode` is omitted. |
| `'wide'` | `2688 × 2016` | Provides an image size suited to recognition in scanning workflows. | QR-code and barcode scanning, including payment scenarios. |
| `'telephoto'` | `1512 × 2016` | Produces a portrait-oriented image suited to downstream agent analysis. | Reading agents, AI image understanding, and text or object recognition. |

### `RecorderManager`

#### `start(options)`

Starts a new recording session and returns `Promise<void>`. Call it during a valid user interaction while the AIUI application window is focused. Register `onFrameRecorded()`, `onError()`, and `onStop()` first so an early event is not missed. Calling it again while already recording does not create a second session.

| `start()` Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `options.sampleRate` | `number` | No | `16000` | Requested sample rate. |
| `options.numberOfChannels` | `number` | No | `1` | Requested channel count. |
| `options.format` | `'pcm' \| 'opus'` | No | `'pcm'` | Requested encoding format. |
| `options.frameSize` | `number` | No | `250` | Audio-frame callback interval in milliseconds; only positive values apply. |

#### `pause()`

Pauses the current recording and returns `Promise<void>`. State changes only while recording; after success, the callback registered with `onPause()` runs. Pausing does not end the session, so it can later be resumed.

#### `resume()`

Resumes a paused recording and returns `Promise<void>`. The AIUI application window must be focused when this method is called. After success, the callback registered with `onResume()` runs. Calling it when no session is paused does not start a new recording.

#### `stop()`

Stops the current recording and returns `Promise<void>`. `onStop()` runs after remaining audio-frame processing finishes, and the related media tracks are then released. Calling it before recording starts or after recording stops is safe.

#### `onStart(callback)`

Registers a recording-start callback. The callback receives no arguments and runs after the recorder actually begins producing data. Registering again replaces the previous start callback.

#### `onPause(callback)`

Registers a recording-pause callback. The callback receives no arguments and runs after `pause()` completes its state transition. Registering again replaces the previous pause callback.

#### `onResume(callback)`

Registers a recording-resume callback. The callback receives no arguments and runs after `resume()` completes its state transition. Registering again replaces the previous resume callback.

#### `onStop(callback)`

Registers a recording-stop callback. It receives `{ tempFilePath: '', duration: number, fileSize: number }`: `duration` is the recording length in milliseconds and `fileSize` is the total number of bytes delivered through audio frames. No temporary file is currently generated, so `tempFilePath` is always an empty string. Registering again replaces the previous stop callback.

#### `onFrameRecorded(callback)`

Registers an audio-frame callback. It receives `{ frameBuffer: ArrayBuffer, isLastFrame: false }`. Each `frameBuffer` contains only that chunk, not bytes delivered earlier. The current implementation does not use `isLastFrame` to mark the final chunk; use `onStop()` for completion.

In PCM mode, `frameBuffer` contains a raw PCM chunk with the WAV container header removed. In Opus mode, it contains the Opus payload.

```javascript
const audioChunks = [];
recorder.onFrameRecorded(({ frameBuffer }) => {
  audioChunks.push(frameBuffer.slice(0));
});
```

#### `onHeader(callback)`

Registers the Opus initialization-header callback. It receives two positional arguments: `format` is `'opus'`, and `headerBuffer` is an `ArrayBuffer` containing the initialization header. This callback runs before the first Opus payload. When storing or transmitting Opus as a stream, process the header first and then process `onFrameRecorded()` chunks in order. PCM mode does not invoke this callback.

#### `onError(callback)`

Registers an error callback. It receives `{ errMsg: string }` containing a message suitable for logging or a user-facing failure notice. After an error, do not assume the current session is still recording; clean it up before deciding whether to call `start()` again.

#### `onInterruptionBegin(callback)`

Registers a callback for the beginning of a recording interruption. It receives no arguments. When notified, pause agent interactions that depend on live audio and update the interface state as needed.

#### `onInterruptionEnd(callback)`

Registers a callback for the end of a recording interruption. It receives no arguments. When notified, update the interface or resume the business flow as needed. The application should still decide explicitly whether recording continues.
