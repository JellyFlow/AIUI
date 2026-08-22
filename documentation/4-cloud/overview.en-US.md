# Cloud Overview

AIUI Cloud provides server-side integration capabilities that connect third-party systems with Rokid cloud services and Glasses devices. Business services, scheduled jobs, and external agents can use it to turn cloud events into information that users can receive and act on through their Glasses.

The primary capability currently available is agent notification delivery. A third-party system can send a text notification to a specific user or open a registered AIUI page with parameters when the notification is selected.

## Integration options

AIUI Cloud supports two ways to call the service:

- Use the `@yodaos-pkg/cloud-integration` npm package for a structured API in a Node.js service.
- Call the cloud endpoint directly with HTTP or `curl` from other languages, automation scripts, or environments where installing an npm package is not suitable.

Both options use the same account credentials, business fields, and cloud endpoint. The integration method does not change notification behavior on the Glasses.

## Install the npm package

`@yodaos-pkg/cloud-integration` requires Node.js 20 or later and uses the runtime's built-in `fetch`:

```bash
npm install @yodaos-pkg/cloud-integration
```

```js
import { CloudIntegration } from '@yodaos-pkg/cloud-integration'

const cloud = new CloudIntegration({
  token: process.env.ROKID_SK,
})
```

The SK is a sensitive credential for the account that owns the agent. Store it in a server-side environment variable or secret manager. Do not include it in AIUI page code, client bundles, source control, or logs.

## Install the Cloud Integration Skill

The `aiui-cloud-integration` Skill gives AI coding assistants integration context for npm, HTTP, `curl`, page navigation, and error handling. Add it with:

```bash
npx skills add https://github.com/jsar-project/AIUI/tree/main/skills/aiui-cloud-integration
```

The Skill assists development and code generation. It does not replace the SK or send notifications automatically.

## Next step

See [Sending notifications](./notifications.en-US.md) for credential preparation, request fields, npm and `curl` examples, page navigation, and response handling.
