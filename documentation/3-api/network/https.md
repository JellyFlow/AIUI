# HTTPS

在 AIUI 中，`HTTPS` 适合“一次请求，一次返回”的通信模式。

如果你在做普通业务接口、配置拉取、提交表单、调用智能体服务，通常优先使用 `HTTPS`。

## 什么时候用 HTTPS

- 拉取页面初始化数据
- 调用普通 REST 接口
- 提交一次性表单或指令
- 请求一个完整结果，而不是持续流式输出

## HTTPS 示例

### `fetch`

```javascript
const response = await fetch('/api/agent/chat', {
  method: 'POST',
  headers: {
    'content-type': 'application/json',
  },
  body: JSON.stringify({
    message: '帮我总结今天的会议内容',
  }),
});

const data = await response.json();
console.log(data);
```

### `wx.request`

```javascript
wx.request({
  url: '/api/agent/chat',
  method: 'POST',
  header: {
    'content-type': 'application/json'
  },
  data: {
    message: '帮我总结今天的会议内容',
  },
  success(res) {
    console.log(res.data);
  },
  fail(error) {
    console.error(error);
  }
});
```

## HTTPS 使用建议

- 优先把一次业务动作建模成一次明确的请求。
- 为请求设置清晰的超时、失败提示和重试策略。
- 对于需要鉴权的接口，把认证信息统一放在请求头或会话机制里处理。
- 如果返回体较大或处理时间较长，要在 UI 上明确展示加载状态。

## 什么时候不用 HTTPS

- 需要服务端持续推送文本增量时
- 需要持续展示任务进度流时
- 需要建立客户端和服务端双向实时通信时

对于服务端单向持续推送的场景，继续参考 [Event Source](/AIUI/api/network-event-source)。如果需要双向实时通信，改用 [WebSocket](/AIUI/api/network-websocket)。

## 继续阅读

- **[Event Source](/AIUI/api/network-event-source)**：查看服务端单向流式推送的典型使用方式。
- **[WebSocket](/AIUI/api/network-websocket)**：查看双向实时长连接场景如何设计与管理。
- **[网络请求 (networking)](/AIUI/api/weixin-compatible-apis-networking)**：查看 `wx.request` 与 `EventSource` 兼容接口细节。
