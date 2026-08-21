# Speech (speech)

## Methods

### `wx.speech.playTTS(text)`

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `text` | `string` | Yes | Text to synthesize and play. |

**Returns:** `string`, the underlying speech-request identifier, or an empty string if no request can be created. Synthesis is queued for playback.

### `wx.speech.startRecognition()`

Takes no parameters.

**Returns:** `string`, the recognition session ID. Recognition is fixed to one non-continuous session with no interim results and at most one alternative. It must be called from a valid user interaction or throws an invalid-state exception.
