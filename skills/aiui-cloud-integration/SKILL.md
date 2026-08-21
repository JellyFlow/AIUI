---
name: "aiui-cloud-integration"
description: "Integrate third-party AIUI agents with Rokid Glasses cloud notifications using @yodaos-pkg/cloud-integration. Invoke when implementing notification delivery, notification-triggered page navigation, or related agent configuration."
---

# AIUI Cloud Integration

Use this skill when an AIUI agent needs to send a notification to a Rokid
Glasses user from a server-side or other Node.js 20+ integration.

## Package

Install the zero-runtime-dependency package:

```bash
npm install @yodaos-pkg/cloud-integration
```

Import `CloudIntegration` from the package and construct it with the Rokid
account SK. Keep the token in an environment variable or secret manager; do
not put it in AIUI page code, source control, logs, or user-visible data.

```js
import { CloudIntegration } from '@yodaos-pkg/cloud-integration'

const cloud = new CloudIntegration({
  token: process.env.ROKID_SK,
})

await cloud.sendNotification({
  messageId: 'message-unique-id',
  accountId: 'target-account-id',
  message: {
    agentId: 'agent-id',
    content: 'Notification text shown on the Glasses.',
  },
})
```

## Notification navigation

To open an AIUI page when the user selects the notification, pass a `tool`
whose `name` exactly matches a registered AIUI route. Put page input in
`parameters.properties`; values are passed through unchanged.

```js
await cloud.sendNotification({
  messageId: 'outfit-message-id',
  accountId: 'target-account-id',
  message: {
    agentId: 'agent-id',
    content: '查看穿搭建议',
    tool: {
      name: 'pages/cloth/index',
      parameters: {
        type: 'object',
        properties: {
          field: 'value',
        },
      },
    },
  },
})
```

The destination page must be registered in `app.json`, and its input schema
should document the values expected in `parameters.properties`.

## Required fields and failures

- `messageId`, `accountId`, `message.agentId`, and `message.content` are
  required non-empty strings.
- `tool.name` and `tool.parameters` are required when `tool` is present.
- `tool.parameters.type` must be `"object"` and `properties` must be an
  object.
- `sendNotification()` resolves with the complete server response only when
  `code === 1` and `data.success === true`.
- Handle `CloudIntegrationValidationError` for invalid input and
  `CloudIntegrationError` for network, HTTP, parsing, or server-side business
  failures. Use the response payload and UUID for diagnostics, but never log
  the SK.

For the package's complete API and request details, read
[`packages/cloud-integration/README.md`](../../packages/cloud-integration/README.md)
when working in this repository.
