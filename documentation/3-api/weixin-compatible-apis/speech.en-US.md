# Speech (speech)

## Methods

### `wx.speech.playTTS(text)`

Queues text for speech synthesis and returns the underlying speech-request identifier. It returns an empty string when the request cannot be created.

### `wx.speech.startRecognition()`

Starts one non-continuous speech-recognition session and returns its session ID. It must be called from a valid user interaction or throws an invalid-state exception.

`wx.getSpeechSynthesizer()` and `wx.getSpeechRecognizer()` are not currently provided.
