# Chat Sample

This sample now contains two focused demo pages:

- `pages/camera/index`: shows how to create a camera context, capture a photo, and preview the latest result
- `pages/minimax-tts/index`: shows the Minimax WebSocket TTS flow and PCM playback structure

## Sanitized By Default

This repository does not bundle any credentials or built-in authorization flow.

- No account credentials
- No API keys
- No credential exchange logic
- No live authorization defaults

The Minimax TTS page keeps the request and playback skeleton, but it will not make a usable live request until you inject your own authorization provider in `lib/tts.js` usage.
