# 语音 (speech)

## 方法

### `wx.speech.playTTS(text)`

将文本加入语音合成播放队列，并返回底层语音请求的标识；无法创建语音请求时返回空字符串。

### `wx.speech.startRecognition()`

开始一次非连续语音识别，并返回识别会话 ID。该方法必须在有效的用户交互中调用，否则会抛出状态异常。

`wx.getSpeechSynthesizer()` 和 `wx.getSpeechRecognizer()` 当前未提供。
