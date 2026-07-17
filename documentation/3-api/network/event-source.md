# Event Source

在 AIUI 中，`EventSource` 适合“由服务端持续向前端单向推送增量内容”的通信模式。

如果你已经有一个服务端接口需要持续输出文本流、状态流或任务进度，可以优先考虑 `EventSource`，而不是为了流式输出直接切到 `WebSocket`。

## 什么时候用 Event Source

- 服务端会持续推送文本增量
- 需要展示任务执行进度
- 只需要服务端单向推送，不需要客户端持续反向发送消息
- 希望保留接近 HTTP 的接入方式，同时获得流式体验

## Event Source 示例

```javascript
const eventSource = new EventSource('/api/agent/stream');

eventSource.onmessage = (event) => {
  console.log('收到增量内容:', event.data);
};

eventSource.onerror = () => {
  console.error('Event Source 连接异常');
  eventSource.close();
};
```

## Event Source 使用建议

- 当服务端只负责持续推送时，优先考虑 `EventSource`。
- 把每条推送消息设计成可独立消费的片段，例如文本增量、阶段状态、进度更新。
- 在界面上明确区分“连接已建立”“流式输出中”“已完成”“已中断”这几种状态。
- 连接结束后及时关闭实例，避免页面切换后继续占用资源。

## 什么时候不用 Event Source

- 只是请求一次完整结果时
- 只是调用普通接口时
- 需要客户端向服务端持续发送实时消息时

如果只需要一次请求一次返回，改用 [HTTPS](/AIUI/api/network-https)。如果需要双向实时通信，改用 [WebSocket](/AIUI/api/network-websocket)。

## 继续阅读

- **[HTTPS](/AIUI/api/network-https)**：查看普通请求响应场景的使用方式。
- **[WebSocket](/AIUI/api/network-websocket)**：查看双向实时长连接场景如何设计与管理。
- **[网络请求 (networking)](/AIUI/api/weixin-compatible-apis-networking)**：查看 `wx.request` 与 `EventSource` 兼容接口细节。
