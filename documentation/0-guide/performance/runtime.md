# 运行时性能

运行时性能关注页面打开之后是否一直流畅。常见问题包括：按钮点击后卡顿、列表越用越慢、流式文本抖动、音视频播放断续，以及离开页面后设备仍然发热。

初学者可以先记住一个原则：**不要让数据产生的速度，长期超过页面、网络或播放器消费的速度。** 下面按照数据更新、网络流、音视频、页面结构和生命周期五组常见问题说明如何处理。

## 数据与界面更新

这部分解决 `setData()` 调用过多、更新范围过大，以及高频数据让页面来不及渲染的问题。

### 一次操作只提交一次更新

一次请求结束后，经常需要同时更新加载状态、列表和总数。不要为每个字段分别调用 `setData()`。

```javascript
// 不推荐：一次操作触发了三轮更新
this.setData({ loading: false });
this.setData({ items: result.items });
this.setData({ total: result.total });
```

```javascript
// 推荐：把同一次操作产生的变化一起提交
this.setData({
  loading: false,
  items: result.items,
  total: result.total
});
```

判断标准：如果几个字段来自同一次点击、请求或业务事件，就尽量在一次 `setData()` 中更新。

### 只更新真正变化的字段

如果播放器只改变了当前进度，不需要把整个 `player` 对象重新提交。

```javascript
// 不推荐：未变化的字段也被重新提交
this.setData({
  player: {
    ...this.data.player,
    position: nextPosition
  }
});
```

```javascript
// 推荐：使用精确的数据路径
this.setData({
  'player.position': nextPosition
});
```

页面 `data` 也应只保存模板需要响应式读取的内容。接口原始响应、缓存和调试信息可以保存在普通实例字段或专门的数据模块中。

判断标准：模板不需要读取的数据，不必放入页面 `data`；只变化一个子字段时，优先更新该字段的路径。

### 高频数据只显示最新值

进度、传感器读数和流式文本可能在一帧内变化多次。界面来不及展示每个中间值时，可以只在下一帧提交最新值。

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

“最新值优先”只适用于可以被新值替代的状态。聊天消息、订单变化和控制命令不能静默丢弃，仍需按顺序处理，只把界面更新合并。

判断标准：旧值已经没有展示意义时可以覆盖；每一条都代表独立业务结果时不能覆盖。

## 网络通信与数据流

这部分关注网络速度和处理速度不一致时，如何避免消息、内存和界面更新不断积压。

### WebSocket 发送前检查积压

网络变慢时，连续调用 `send()` 会让待发送数据不断堆积。标准 `WebSocket` 可以通过 `bufferedAmount` 查看尚未发送完成的字节数。

```javascript
const MAX_BUFFERED_BYTES = 256 * 1024;

function sendLatestState(socket, state) {
  if (socket.readyState !== WebSocket.OPEN) return false;

  if (socket.bufferedAmount > MAX_BUFFERED_BYTES) {
    // 当前位置会很快被新位置替代，暂时不再追加旧状态。
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

`256 KB` 只是示例起点，应根据消息大小、网络和设备测试后调整。位置、姿态和进度可以保留最新值；消息、交易和命令必须保序，并在积压时暂停生产或明确报错。

二进制音频、图像和传感器数据优先发送 `ArrayBuffer`，不要先转换为体积更大的 Base64。断线重连应逐步增加等待时间并加入随机抖动；鉴权失败或用户主动退出不应无限重试。

判断标准：任何发送或接收队列都要有上限，并提前决定“等待、合并、丢弃还是失败”。

完整接口参见 [WebSocket](/AIUI/api/network-websocket) 和 [Event Source](/AIUI/api/network-event-source)。

### 按顺序读取网络数据流

读取 `fetch()` 响应流时，每次处理完当前分片再读取下一段，可以让处理速度自然限制读取速度。

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

// 用户取消时：
// controller.abort();
```

不要先把所有分片存进数组，再统一处理。使用 `WritableStream` 时，应在写入前等待 `writer.ready`，并关注 `desiredSize`；创建流时通过 `highWaterMark` 限制队列。

判断标准：处理一段、再读取一段；用户离开或任务取消时，立即取消上游读取。

完整接口参见[数据流](/AIUI/api/network-streams)。

## 音频与视频流

这部分关注持续产生的音视频数据。重点是按顺序处理、限制缓冲，并在结束后释放设备资源。

### 边接收边播放音频

长音频不需要全部下载完再播放。创建流式播放器后，按收到顺序追加分片，并在输入结束后调用一次 `finish()`。

```javascript
const player = new AudioPlayer({ format: 'ogg_opus' });

const playbackEnded = new Promise((resolve, reject) => {
  player.onEnded(resolve);
  player.onError(reject);
});

player.play();

try {
  for await (const chunk of audioChunks) {
    // 缓冲过多时暂停读取，避免内存持续增长。
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

`5` 秒缓冲只是示例，需要在目标设备上调整。Ogg/Opus 的第一段必须包含初始化所需的 Ogg 头；不要重排、遗漏或重复追加分片。原始 PCM 则应将 `format` 设为 `pcm`，并确保采样格式一致。

判断标准：按顺序追加、限制缓冲时长、结束时 `finish()`、取消或播放完成后 `destroy()`。

完整接口参见[音频播放](/AIUI/api/media-audio-player)。

### 录音分片边产生边上传

长时间录音如果把所有 `Blob` 都保存在数组里，内存会持续增长。更合适的方式是给录制设置分片间隔，并按顺序上传。

```javascript
const MAX_PENDING_CHUNKS = 8;
let pendingChunks = 0;
let uploadChain = Promise.resolve();

recorder.addEventListener('dataavailable', event => {
  if (!event.data.size) return;

  if (pendingChunks >= MAX_PENDING_CHUNKS) {
    if (recorder.state !== 'inactive') recorder.stop();
    reportError('网络过慢，录音已停止');
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

`500 ms` 和 8 个待上传分片只是示例。分片过小会增加回调和协议开销，过大则会增加延迟和单次内存峰值。停止后应等待最后的数据事件和 `uploadChain` 完成，再关闭上传会话；最后对所有麦克风轨道调用 `stop()`。

判断标准：不要无限缓存录音；上传队列达到上限时，应暂停、停止或提示失败。

完整接口参见[媒体采集](/AIUI/api/media-media-capture)和[音频处理](/AIUI/api/media-web-audio)。

### 视频按实际需要加载

视频列表如果全部使用 `preload="auto"`，即使用户没有播放，也可能同时消耗网络、内存和解码资源。通常先加载元数据就足够了。

```html
<!-- 推荐：先获取时长、尺寸等元数据 -->
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

当前 `<video>` 适合 progressive MP4，不要把任意 WebSocket 视频分片直接追加给它。录制视频时也要持续处理 `dataavailable` 分片，结束或失败后停止 `MediaRecorder`，并对 `MediaStream` 中的每条轨道调用 `stop()`。

判断标准：用户很可能立即播放时才考虑 `auto`；列表、预览页通常使用 `none` 或 `metadata`。

完整接口参见[视频播放](/AIUI/api/media-video)。

## 页面结构与渲染

这部分关注列表复用和页面组织方式，避免节点反复创建或把不相关的功能堆在一个 Page 中。

### 动态列表使用稳定的 key

列表插入、删除或重排时，稳定且唯一的 `ink:key` 可以帮助运行时复用已有节点。

```html
<!-- 不推荐：顺序变化后，下标不再代表同一条消息 -->
<view ink:for="{{ messages }}" ink:key="index">
  <text>{{ item.title }}</text>
</view>
```

```html
<!-- 推荐：使用不会变化的业务 ID -->
<view ink:for="{{ messages }}" ink:key="id">
  <text>{{ item.title }}</text>
</view>
```

稳定 key 不能解决列表无限增长的问题。聊天记录、搜索结果等大型列表仍应分页、截断，或只保留当前需要显示的窗口。

判断标准：同一条数据无论移动到哪里，都应拥有同一个 key。

### 小区域切换与页面切换分开处理

`ink:if` 为 `false` 时不会保留内容，重新显示时需要再次创建；`hidden` 会一直保留节点，只改变可见性。

```html
<!-- 偶尔出现、长期不需要：使用 ink:if -->
<view ink:if="{{ showAdvancedPanel }}">
  <advanced-panel />
</view>

<!-- 频繁切换的小区域：使用 hidden -->
<view hidden="{{ !showPlaybackControls }}">
  <playback-controls />
</view>
```

首页、详情页和设置页属于不同页面单元，不要把它们全部塞进一个 Page，再用多个 `ink:if` 根据状态切换。

```javascript
// 推荐：进入独立详情页
wx.navigateTo({
  url: `/pages/detail/index?id=${item.id}`
});
```

拆成不同 Page 后，每个页面只维护自己的数据、事件和资源，代码更容易理解，也能避免所有逻辑集中在一个大页面中。不再需要返回当前页时，可以使用 `wx.redirectTo()` 替换它。

判断标准：局部显示隐藏使用 `ink:if` 或 `hidden`；拥有独立标题、数据加载和生命周期的整屏内容，应拆成 Page。

## 页面生命周期与性能验证

这部分用于检查页面离开后是否仍有后台任务，并确认优化在真实设备上确实有效。

### 页面隐藏时暂停，卸载时释放

通过 `wx.navigateTo()` 打开的旧 Page 会保留在页面栈中。`onHide()` 只表示暂时不可见，并不等于页面已经销毁。

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

在 `onShow()` 中只恢复当前页面确实需要的任务。不同资源有不同释放方法：定时器需要取消，连接需要 `close()`，媒体轨道需要 `stop()`，播放器或会话通常需要 `destroy()`。

判断标准：暂时离开时暂停可恢复的工作；确定页面不会再使用时彻底释放资源。

### 如何在真机上验证

桌面环境通常比目标设备拥有更多 CPU、GPU 和内存。优化完成后，应使用真实数据量在目标设备上反复滚动、切页和运行流式任务。

可以先用性能标记测量一段业务代码：

```javascript
performance.mark('message-start');
await handleMessage(message);
performance.mark('message-end');
performance.measure('handle-message', 'message-start', 'message-end');
```

同时检查以下现象：

- 连续交互时是否稳定掉帧。
- 列表或流式内容运行一段时间后，内存是否持续增长。
- 网络变慢时，待发送、待上传或播放缓冲是否有明确上限。
- 页面反复进入和返回后，定时器、连接、摄像头和麦克风是否仍在后台工作。

不要只比较一次结果。使用相同输入重复测试，并比较中位数或分位数。继续阅读[性能数据](/AIUI/guide/performance-data)建立基线；如果问题发生在首个有效画面出现之前，请参考[启动性能](/AIUI/guide/performance-startup)。
