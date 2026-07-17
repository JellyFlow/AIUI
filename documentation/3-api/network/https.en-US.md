# HTTPS

In AIUI, `HTTPS` is suitable for a "one request, one response" communication model.

If you are building ordinary business APIs, configuration fetching, form submission, or agent service calls, `HTTPS` is usually the first choice.

## When to Use HTTPS

- Fetching initial page data
- Calling ordinary REST APIs
- Submitting one-off forms or commands
- Requesting one complete result instead of continuous streaming output

## HTTPS Example

### `fetch`

```javascript
const response = await fetch('/api/agent/chat', {
  method: 'POST',
  headers: {
    'content-type': 'application/json',
  },
  body: JSON.stringify({
    message: 'Summarize today\'s meeting for me',
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
    message: 'Summarize today\'s meeting for me'
  },
  success(res) {
    console.log(res.data);
  },
  fail(error) {
    console.error(error);
  }
});
```

## HTTPS Recommendations

- Prefer modeling one business action as one clear request.
- Set clear timeout, failure messaging, and retry strategies for requests.
- For authenticated APIs, handle authentication information consistently in request headers or session mechanisms.
- If the response body is large or takes a long time to process, clearly show a loading state in the UI.

## When Not to Use HTTPS

- When the server needs to keep pushing text deltas
- When task progress needs to be streamed continuously
- When bidirectional real-time communication is required between client and server

For one-way continuous server push, continue with [Event Source](/AIUI/api/network-event-source). For bidirectional real-time communication, use [WebSocket](/AIUI/api/network-websocket) instead.

## Read Next

- **[Event Source](/AIUI/api/network-event-source)**: Learn the typical usage pattern for one-way streaming pushes from the server.
- **[WebSocket](/AIUI/api/network-websocket)**: Learn how to design and manage bidirectional real-time long connections.
- **[Networking](/AIUI/api/weixin-compatible-apis-networking)**: Learn details of `wx.request` and `EventSource` compatible APIs.
