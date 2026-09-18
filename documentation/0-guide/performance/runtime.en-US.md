# Runtime Performance

Runtime performance describes whether a Page stays responsive after it opens. Common symptoms include delayed taps, lists that slow down over time, jittery streamed text, interrupted media playback, and devices that remain warm after leaving a Page.

Beginners can start with one rule: **do not let data production continuously outpace the Page, network, or player that consumes it.** The following cases are grouped into data updates, network streams, media, Page structure, and lifecycle concerns.

## Data and Interface Updates

This section addresses excessive `setData()` calls, overly broad updates, and high-frequency data that the Page cannot render in time.

### Submit One Update per Operation

One request often changes the loading state, list, and total together. Do not call `setData()` separately for every field.

```javascript
// Not recommended: one operation triggers three updates
this.setData({ loading: false });
this.setData({ items: result.items });
this.setData({ total: result.total });
```

```javascript
// Recommended: submit related changes together
this.setData({
  loading: false,
  items: result.items,
  total: result.total
});
```

Rule of thumb: fields produced by the same tap, request, or business event should usually be updated in one `setData()` call.

### Update Only the Field That Changed

If only the playback position changed, there is no need to resubmit the complete `player` object.

```javascript
// Not recommended: unchanged fields are submitted again
this.setData({
  player: {
    ...this.data.player,
    position: nextPosition
  }
});
```

```javascript
// Recommended: use a precise data path
this.setData({
  'player.position': nextPosition
});
```

Page `data` should contain only values that the template reads reactively. Keep raw responses, caches, and debugging information in ordinary instance fields or a dedicated data module.

Rule of thumb: data that the template does not read does not need to be in Page `data`; when one nested field changes, update that field's path.

### Show Only the Latest High-Frequency Value

Progress, sensor readings, and streamed text may change several times in one frame. When the interface cannot display every intermediate value, submit only the latest value on the next frame.

```html
<script setup>
export default {
  data: {
    progress: 0
  },

  updateProgress(progress) {
    this.pendingProgress = progress;
    if (this.progressFrame) return;

    this.progressFrame = requestAnimationFrame(() => {
      this.progressFrame = 0;
      this.setData({ progress: this.pendingProgress });
    });
  },

  onHide() {
    if (this.progressFrame) {
      cancelAnimationFrame(this.progressFrame);
      this.progressFrame = 0;
    }
  }
};
</script>
```

Latest-value-wins applies only when a new state replaces the value of an old state. Chat messages, order changes, and control commands must still be processed in order; only their visible updates may be batched.

Rule of thumb: replace an old value only when it no longer matters. Do not replace independent business results.

## Network Communication and Data Streams

This section explains how to prevent messages, memory, and interface updates from accumulating when network and processing speeds differ.

### Check WebSocket Backlog Before Sending

When the network slows down, repeated `send()` calls can create a growing backlog. A standard `WebSocket` exposes unsent bytes through `bufferedAmount`.

```javascript
const MAX_BUFFERED_BYTES = 256 * 1024;

function sendLatestState(socket, state) {
  if (socket.readyState !== WebSocket.OPEN) return false;

  if (socket.bufferedAmount > MAX_BUFFERED_BYTES) {
    // A newer position will replace this one soon.
    return false;
  }

  socket.send(JSON.stringify({
    type: 'position',
    sessionId: state.sessionId,
    sequence: state.sequence,
    value: state.position
  }));
  return true;
}
```

`256 KB` is only a starting point; adjust it after testing message size, network conditions, and target devices. Position, pose, and progress may keep only the latest value. Messages, transactions, and commands must preserve order and should pause production or fail explicitly when backlogged.

Prefer `ArrayBuffer` for binary audio, image, and sensor data instead of converting it to larger Base64 strings. Reconnect with increasing delays and random jitter. Do not retry authentication failures or an explicit user exit forever.

Rule of thumb: every inbound and outbound queue needs a limit and a predefined action: wait, combine, drop, or fail.

See [WebSocket](/AIUI/api/network-websocket) and [Event Source](/AIUI/api/network-event-source) for complete APIs.

### Read Network Streams Sequentially

For a streamed `fetch()` response, process the current chunk before reading the next one. Processing speed then naturally constrains reading speed.

```javascript
const controller = new AbortController();
const response = await fetch(url, { signal: controller.signal });
const reader = response.body.getReader();

try {
  while (true) {
    const { done, value } = await reader.read();
    if (done) break;

    await handleChunk(value);
  }
} finally {
  reader.releaseLock();
}

// When the user cancels:
// controller.abort();
```

Do not collect every chunk in an array before processing it. With a `WritableStream`, wait for `writer.ready` before writing and observe `desiredSize`. Use `highWaterMark` when creating a stream to bound its queue.

Rule of thumb: process one chunk before reading the next, and cancel upstream work as soon as the user leaves or the task is cancelled.

See [Streams](/AIUI/api/network-streams) for complete APIs.

## Audio and Video Streams

This section covers continuously produced media data. The key practices are preserving order, bounding buffers, and releasing device resources when work ends.

### Play Audio While Receiving It

A long audio response does not need to finish downloading before playback begins. Append chunks in arrival order, then call `finish()` once when the input ends.

```javascript
const player = new AudioPlayer({ format: 'ogg_opus' });

const playbackEnded = new Promise((resolve, reject) => {
  player.onEnded(resolve);
  player.onError(reject);
});

player.play();

try {
  for await (const chunk of audioChunks) {
    // Pause reading when too much audio is buffered.
    while (player.buffered > 5) {
      await new Promise(resolve => setTimeout(resolve, 50));
    }
    player.append(chunk);
  }

  player.finish();
  await playbackEnded;
} finally {
  player.destroy();
}
```

The five-second buffer is only an example and should be tuned on target devices. The first Ogg/Opus chunk must include the required Ogg headers. Do not reorder, omit, or append chunks twice. For raw PCM, set `format` to `pcm` and keep the sample format consistent.

Rule of thumb: append in order, bound buffered duration, call `finish()` at the end, and call `destroy()` after cancellation or playback completion.

See [Audio Playback](/AIUI/api/media-audio-player) for complete APIs.

### Upload Recording Chunks as They Arrive

Keeping every recording `Blob` in an array makes memory grow throughout a long session. Give the recorder a chunk interval and upload chunks in order instead.

```javascript
const MAX_PENDING_CHUNKS = 8;
let pendingChunks = 0;
let uploadChain = Promise.resolve();

recorder.addEventListener('dataavailable', event => {
  if (!event.data.size) return;

  if (pendingChunks >= MAX_PENDING_CHUNKS) {
    if (recorder.state !== 'inactive') recorder.stop();
    reportError('The network is too slow. Recording stopped.');
    return;
  }

  pendingChunks += 1;
  uploadChain = uploadChain
    .then(() => uploadChunk(event.data))
    .catch(error => {
      reportError(error.message);
      if (recorder.state !== 'inactive') recorder.stop();
    })
    .finally(() => {
      pendingChunks -= 1;
    });
});

recorder.start(500);
```

`500 ms` and eight pending chunks are examples. Smaller chunks add callback and protocol overhead; larger chunks add latency and peak memory use. After stopping, wait for the last data event and `uploadChain` before closing the upload session. Finally, call `stop()` on every microphone track.

Rule of thumb: never cache a recording without a bound. Pause, stop, or report failure when the upload queue reaches its limit.

See [Media Capture](/AIUI/api/media-media-capture) and [Audio Processing](/AIUI/api/media-web-audio) for complete APIs.

### Load Video Only When Needed

Using `preload="auto"` for every video in a list can consume network, memory, and decode resources even when the user never plays them. Loading metadata is usually enough at first.

```html
<!-- Recommended: load duration, dimensions, and other metadata first -->
<video
  id="previewVideo"
  src="{{ videoUrl }}"
  preload="metadata"
  controls
/>
```

```javascript
export default {
  onReady() {
    this.videoContext = wx.createVideoContext('previewVideo');
  },

  onHide() {
    this.videoContext?.pause();
  }
};
```

The current `<video>` capability is intended for progressive MP4. Do not append arbitrary WebSocket video chunks to it. During recording, continuously consume `dataavailable` chunks. On completion or failure, stop `MediaRecorder` and call `stop()` on every `MediaStream` track.

Rule of thumb: consider `auto` only when playback is likely to start immediately. Lists and preview Pages usually use `none` or `metadata`.

See [Video Playback](/AIUI/api/media-video) for complete APIs.

## Page Structure and Rendering

This section covers list reuse and Page organization, avoiding unnecessary node recreation and preventing unrelated features from accumulating in one Page.

### Give Dynamic Lists a Stable Key

A stable, unique `ink:key` helps the runtime reuse existing nodes when list items are inserted, removed, or reordered.

```html
<!-- Not recommended: an index no longer identifies the same message after reordering -->
<view ink:for="{{ messages }}" ink:key="index">
  <text>{{ item.title }}</text>
</view>
```

```html
<!-- Recommended: use an immutable business ID -->
<view ink:for="{{ messages }}" ink:key="id">
  <text>{{ item.title }}</text>
</view>
```

A stable key does not solve unlimited list growth. Large chat histories and search results still need pagination, truncation, or a window containing only visible data.

Rule of thumb: the same record should keep the same key wherever it moves.

### Separate Local Visibility from Page Navigation

When `ink:if` is false, its content is not retained and must be recreated when shown again. `hidden` retains the nodes and changes only their visibility.

```html
<!-- Rarely shown and unnecessary for long periods: use ink:if -->
<view ink:if="{{ showAdvancedPanel }}">
  <advanced-panel />
</view>

<!-- A small region that switches frequently: use hidden -->
<view hidden="{{ !showPlaybackControls }}">
  <playback-controls />
</view>
```

Home, detail, and settings are independent screen units. Do not place all of them in one Page and switch complete interfaces with several `ink:if` blocks.

```javascript
// Recommended: open a dedicated detail Page
wx.navigateTo({
  url: `/pages/detail/index?id=${item.id}`
});
```

Separate Pages keep data, events, and resources focused and prevent all logic from accumulating in one large Page. Use `wx.redirectTo()` when the current Page no longer needs to remain in the back stack.

Rule of thumb: use `ink:if` or `hidden` for local visibility. A full-screen unit with its own title, data loading, and lifecycle should be a Page.

## Page Lifecycle and Performance Validation

This section checks for background work after leaving a Page and confirms that an optimization is effective on a real device.

### Pause When Hidden and Release When Unloaded

A previous Page opened through `wx.navigateTo()` remains in the Page stack. `onHide()` means that it is temporarily invisible, not destroyed.

```javascript
export default {
  onHide() {
    clearInterval(this.refreshTimer);
    this.refreshTimer = 0;
    this.videoContext?.pause();
  },

  onUnload() {
    this.socket?.close();
    this.audioPlayer?.destroy();
    this.mediaStream?.getTracks().forEach(track => track.stop());
  }
};
```

In `onShow()`, resume only work that the current Page needs. Cleanup depends on the resource: cancel timers, `close()` connections, `stop()` media tracks, and `destroy()` players or sessions.

Rule of thumb: pause resumable work when temporarily leaving, and fully release resources when the Page will no longer use them.

### Validate on a Target Device

Desktop environments usually have more CPU, GPU, and memory than target devices. After an optimization, repeatedly scroll, navigate, and run streaming tasks with realistic data on the actual device.

Start by measuring one business-code stage with performance marks:

```javascript
performance.mark('message-start');
await handleMessage(message);
performance.mark('message-end');
performance.measure('handle-message', 'message-start', 'message-end');
```

Also check whether:

- repeated interaction causes persistent dropped frames;
- memory continues to grow after a list or stream has run for a while;
- outbound, upload, and playback queues have explicit limits when the network slows down;
- timers, connections, camera, or microphone work continues after repeatedly entering and leaving a Page.

Do not compare only one sample. Repeat the same workload and compare medians or percentiles. Continue with [Performance Metrics](/AIUI/guide/performance-data) to establish a baseline. If the problem occurs before the first meaningful frame, see [Startup Performance](/AIUI/guide/performance-startup).
