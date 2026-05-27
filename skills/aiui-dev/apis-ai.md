# AIUI AI and Speech API Reference

This file documents the verified AI and speech-related APIs available to AIUI app code.

- Common scope, entry points, and authoring rules live in [apis.md](./apis.md).
- Treat these definitions as implementation truth rather than as browser-platform guarantees.
- Do not assume richer provider metadata, structured tool-call round trips, or broader Web Speech coverage unless it is explicitly listed here.

## `LanguageModel`

### Module export

- `import { LanguageModel } from 'language-model'`

### Methods

- `LanguageModel.availability()`
- `LanguageModel.create(options?)`

### Return behavior

- `availability()` returns a `Promise<'available' | 'unavailable'>`.
- `create(options?)` returns a `Promise<LanguageModelSession>`.

### Create options

- `model?: string`
- `initialPrompts?: Array<{ role: string; content: string }>`
- `tools?: Array<{ type: 'function'; function: { name: string; description?: string; parameters: object } }>`

### Behavior notes

- `LanguageModel` is a singleton capability surface and is not constructible.
- `availability()` resolves to `'available'` when the host can provide a config.
- `availability()` resolves to `'unavailable'` when no config is available or the host rejects the request.
- `availability()` does not expose provider metadata.
- `model` is optional and falls back to the host `defaultModel` when omitted.
- `initialPrompts` defaults to `[]`.
- `tools` defaults to `[]`.
- Supported `initialPrompts` roles are `system`, `user`, and `assistant`.
- `system` is only allowed as the first message in `initialPrompts`.
- Each tool must use `type: 'function'`.
- `function.name` must be a non-empty string.
- `function.parameters` must be a JSON object.
- Declared tools are forwarded into the provider request body.
- Structured tool-call execution is not yet exposed on the JavaScript API surface.

### Error behavior

- `create(options?)` throws when neither an explicit `model` nor a host `defaultModel` is available.
- `create(options?)` throws when `model` is present but is not a non-empty string.
- `create(options?)` throws when any prompt `content` is not a non-empty string.

## `LanguageModelSession`

### Constructor

`LanguageModelSession` cannot be constructed directly.

### Methods

- `prompt(input)`
- `promptStreaming(input)`
- `clone()`
- `destroy()`

### Prompt input

- `string`
- `Array<{ role: string; content: string }>`

### Return behavior

- `prompt(input)` returns a `Promise<string>`.
- `promptStreaming(input)` returns a `LanguageModelTextStream`.
- `clone()` returns a `LanguageModelSession`.
- `destroy()` returns `void`.

### Behavior notes

- Supported prompt-time roles are `user` and `assistant`.
- `system` is not allowed in per-request prompt input.
- `prompt(input)` sends one request and resolves to the final aggregated assistant text.
- `promptStreaming(input)` starts one streaming request and returns a polling wrapper.
- Final assistant text is appended to session history only after the request completes successfully.
- `clone()` copies the current message history into a new independent session.
- The cloned session keeps the same resolved runtime config.
- `destroy()` invalidates the session for future use and closes any active request task.

### Error behavior

- `prompt(input)` rejects if the session has been destroyed.
- `prompt(input)` rejects if another request is already active on the same session.
- `promptStreaming(input)` fails if the session has been destroyed or already has an active request.
- `clone()` fails if the source session has already been destroyed.

## `LanguageModelTextStream`

### Constructor

`LanguageModelTextStream` cannot be constructed directly.

### Methods

- `read()`
- `cancel()`

### Return behavior

- `read()` returns a `Promise<{ done: boolean; value?: string }>`.
- `cancel()` returns `void`.

### Behavior notes

- `LanguageModelTextStream` is not a WHATWG `ReadableStream`.
- If buffered data exists, `read()` resolves to `{ done: false, value }`.
- If the stream is still open but no chunk has arrived yet, `read()` resolves to `{ done: false, value: undefined }`.
- If the stream has finished, `read()` resolves to `{ done: true, value: undefined }`.
- `cancel()` closes the underlying SSE task and marks the stream as closed.

### Error behavior

- If the stream fails, `read()` rejects with an error.

## `speechSynthesis`

### Methods

- `speechSynthesis.speak(utterance)`

### Behavior notes

- `speak(utterance)` forwards the utterance state to the native runtime through IPC.
- `speechSynthesis` currently supports dispatching speech synthesis requests through `speak()` only.
- `cancel()`, `pause()`, `resume()`, `getVoices()`, and utterance lifecycle events are not exposed.

## `SpeechSynthesisUtterance`

### Constructor

- `new SpeechSynthesisUtterance(text?)`

### Properties

- `text`
- `lang`
- `pitch`
- `rate`
- `voice`
- `volume`

### Behavior notes

- The default initial state is `text = ''`.
- The default initial state is `lang = 'en-US'`.
- The default initial state is `pitch = 1.0`.
- The default initial state is `rate = 1.0`.
- The default initial state is `voice = null`.
- The default initial state is `volume = 1.0`.

## `SpeechRecognition`

### Constructor

- `new SpeechRecognition()`

### Properties

- `lang`
- `continuous`
- `interimResults`
- `maxAlternatives`

### Methods

- `start()`
- `stop()`
- `abort()`

### Event behavior

- `SpeechRecognition` inherits from `EventTarget`.
- Supported event names are `start`, `audiostart`, `soundstart`, `speechstart`, `result`, `nomatch`, `error`, `speechend`, `soundend`, `audioend`, and `end`.
- Supported event handler properties are `onstart`, `onaudiostart`, `onsoundstart`, `onspeechstart`, `onresult`, `onnomatch`, `onerror`, `onspeechend`, `onsoundend`, `onaudioend`, and `onend`.
- `result` events expose `resultIndex`, `results`, and `sessionId`.
- `error` events expose `error`, `message`, and `sessionId`.

### Behavior notes

- Default values are `lang = ''`, `continuous = false`, `interimResults = false`, and `maxAlternatives = 1`.
- If `lang` is left empty, the host speech capability chooses the default language for the current runtime.
- `start()` forwards a new recognition session request to the host speech capability.
- `stop()` asks the host to stop listening and finalize the active session if possible.
- `abort()` stops the active session immediately without expecting a normal final result.
- New `start()` calls require the owning InkView to remain interactive.
- Ink currently supports object-scoped recognition sessions, targeted lifecycle events, final result delivery, and explicit `stop()` / `abort()` control.

### Error behavior

- `start()` fails immediately with `InvalidStateError` when the owning InkView is non-interactive.
