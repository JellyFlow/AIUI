# LAN

AIUI does not currently expose a stable public LAN communication capability. This page keeps the structure declared in `toc.json` and explains the current status together with practical alternatives.

## Current Status

- This capability is marked as `unsupported` in `toc.json`
- It should not be treated as a public API that production apps can depend on today

## Recommended Alternatives

- For standard networking guidance, start with [Usage](/AIUI/guide/basic-network-usage)
- For server communication, prefer [HTTPS](/AIUI/api/network-https)
- For real-time bidirectional messaging, prefer [WebSocket](/AIUI/api/network-websocket)
- For nearby device interaction, consider [Bluetooth](/AIUI/guide/basic-device-bluetooth)

## Guidance

If your product depends on peer discovery, broadcast, or direct LAN transport, keep the protocol layer abstract in your app so you can integrate an official AIUI capability later.
