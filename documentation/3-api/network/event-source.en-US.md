# Event Source

In AIUI, `EventSource` is suitable for communication patterns where the server continuously pushes incremental content to the frontend in a one-way stream.

If you already have a server interface that needs to continuously output a text stream, status stream, or task progress, prefer `EventSource` instead of switching to `WebSocket` just for streaming output.

## When to Use Event Source

- The server continuously pushes text deltas
- Task execution progress needs to be displayed
- Only one-way server-to-client pushing is needed, without continuous reverse messages from the client
- You want to keep an HTTP-like integration model while still getting a streaming experience

## Event Source Example

```javascript
const eventSource = new EventSource('/api/agent/stream');

eventSource.onmessage = (event) => {
  console.log('Received incremental content:', event.data);
};

eventSource.onerror = () => {
  console.error('Event Source connection error');
  eventSource.close();
};
```

## Event Source Recommendations

- When the server is only responsible for continuous pushing, prefer `EventSource`.
- Design each pushed message as an independently consumable fragment, such as text deltas, phase states, or progress updates.
- Clearly distinguish UI states such as "connected", "streaming", "completed", and "interrupted".
- Close the instance promptly after the connection ends to avoid continuing to occupy resources after page switches.

## When Not to Use Event Source

- When you only need one complete result
- When you are only calling ordinary APIs
- When the client needs to keep sending real-time messages to the server

If you only need one request and one response, use [HTTPS](/AIUI/api/network-https). If you need bidirectional real-time communication, use [WebSocket](/AIUI/api/network-websocket) instead.

## Read Next

- **[HTTPS](/AIUI/api/network-https)**: Learn how to handle ordinary request-response scenarios.
- **[WebSocket](/AIUI/api/network-websocket)**: Learn how to design and manage bidirectional real-time long connections.
- **[Networking](/AIUI/api/weixin-compatible-apis-networking)**: Learn details of `wx.request` and `EventSource` compatible APIs.
