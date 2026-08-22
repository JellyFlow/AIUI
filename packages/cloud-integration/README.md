# @yodaos-pkg/cloud-integration

Send agent notifications to Rokid Glasses users through the Rokid cloud
integration API.

## Installation

```bash
npm install @yodaos-pkg/cloud-integration
```

## Usage

The package requires Node.js 20 or later and uses the built-in `fetch` API.

```js
import { CloudIntegration } from '@yodaos-pkg/cloud-integration'

const client = new CloudIntegration({
  token: process.env.ROKID_SK,
})

const response = await client.sendNotification({
  messageId: '1776425100446',
  accountId: 'B5EC1E268B134EBEA857BBA35CFC7C5C',
  message: {
    agentId: 'c57ea6a751af4610b64251c9cb367b44',
    content: '咋说？',
  },
})

console.log(response.data.success)
```

## Page navigation

Add a `tool` object to open a registered Glasses page and pass parameters when
the user selects the notification:

```js
await client.sendNotification({
  messageId: '1776425100446',
  accountId: 'B5EC1E268B134EBEA857BBA35CFC7C5C',
  message: {
    agentId: 'c57ea6a751af4610b64251c9cb367b44',
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

## API

### `new CloudIntegration(options)`

- `options.token` (`string`): Rokid account SK used as the Bearer token.
- `options.endpoint` (`string`, optional): Custom API endpoint. Defaults to
  `https://rcs.rokid.com/metis/callback/message`.
- `options.fetch` (`Function`, optional): Fetch implementation, primarily
  useful for tests or custom runtimes.

### `client.sendNotification(options)`

- `messageId` (`string`): Caller-generated unique message ID.
- `accountId` (`string`): Target user's account ID.
- `message.agentId` (`string`): Agent ID that sent the notification.
- `message.content` (`string`): Notification text.
- `message.tool` (`object`, optional): Page navigation configuration with
  `name` and `parameters` (`{ type: 'object', properties: object }`).

The method resolves with the complete API response when `code` is `1` and
`data.success` is `true`. It throws `CloudIntegrationValidationError` for
invalid input and `CloudIntegrationError` for transport, HTTP, parsing, or
server-side business failures.

Keep the SK private and provide it through a secret or environment variable.
