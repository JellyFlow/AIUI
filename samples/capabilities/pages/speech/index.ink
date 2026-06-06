<script type="application/json" def>
{
  "navigationBarTitleText": "Speech Test"
}
</script>

<script setup>
import wx from 'wx';

const LOG_LIMIT = 80;
const MOCK_TRANSCRIPT = 'Hello from ink-open mock speech recognition';

function nowLabel() {
  return new Date().toISOString().slice(11, 19);
}

export default {
  data: {
    ttsAvailable: false,
    recognitionAvailable: false,
    recognitionState: 'idle',
    lastTranscript: '',
    lastError: '',
    resultCount: 0,
    mockTranscript: MOCK_TRANSCRIPT,
    logs: ['Speech test page ready'],
  },

  onLoad() {
    this.recognition = null;
    this.bindRecognition();
    this.setData({
      ttsAvailable:
        typeof wx !== 'undefined' &&
        !!wx.speech &&
        typeof wx.speech.playTTS === 'function' &&
        typeof speechSynthesis !== 'undefined',
    });
  },

  onUnload() {
    this.disposeRecognition();
  },

  log(message) {
    const nextLogs = [`${nowLabel()} ${message}`, ...(this.data.logs || [])].slice(0, LOG_LIMIT);
    this.setData({ logs: nextLogs });
  },

  setError(message) {
    this.setData({ lastError: message });
    this.log(`Error: ${message}`);
  },

  clearError() {
    if (this.data.lastError) {
      this.setData({ lastError: '' });
    }
  },

  bindRecognition() {
    if (typeof SpeechRecognition === 'undefined') {
      this.setData({ recognitionAvailable: false });
      this.log('SpeechRecognition is not available');
      return;
    }

    const recognition = new SpeechRecognition();
    recognition.lang = 'en-US';
    recognition.continuous = false;
    recognition.interimResults = false;
    recognition.maxAlternatives = 1;

    recognition.onstart = () => {
      this.setData({ recognitionState: 'listening' });
      this.log('Recognition start');
    };
    recognition.onaudiostart = () => this.log('Audio capture started');
    recognition.onsoundstart = () => this.log('Sound detected');
    recognition.onspeechstart = () => this.log('Speech detected');
    recognition.onresult = (event) => {
      const transcript =
        event &&
        event.results &&
        event.results[0] &&
        event.results[0][0] &&
        event.results[0][0].transcript
          ? event.results[0][0].transcript
          : '';
      this.setData({
        lastTranscript: transcript,
        resultCount: this.data.resultCount + 1,
      });
      this.log(`Result received: ${transcript || '(empty)'}`);
    };
    recognition.onnomatch = () => {
      this.log('Recognition finished without a confident match');
    };
    recognition.onerror = (event) => {
      const message =
        event && event.message ? `${event.error || 'error'}: ${event.message}` : 'Unknown speech error';
      this.setData({ recognitionState: 'error' });
      this.setError(message);
    };
    recognition.onspeechend = () => this.log('Speech ended');
    recognition.onsoundend = () => this.log('Sound ended');
    recognition.onaudioend = () => this.log('Audio capture ended');
    recognition.onend = () => {
      this.setData({ recognitionState: 'idle' });
      this.log('Recognition end');
    };

    this.recognition = recognition;
    this.setData({ recognitionAvailable: true });
    this.log('SpeechRecognition instance ready');
  },

  disposeRecognition() {
    if (!this.recognition) {
      return;
    }
    try {
      this.recognition.abort();
    } catch (_) {}
    this.recognition = null;
  },

  playWxTts() {
    if (!wx.speech || typeof wx.speech.playTTS !== 'function') {
      this.setError('wx.speech.playTTS is unavailable');
      return;
    }
    this.clearError();
    wx.speech.playTTS('Hello from wx speech playTTS');
    this.log('Triggered wx.speech.playTTS');
  },

  playSpeechSynthesis() {
    if (typeof speechSynthesis === 'undefined') {
      this.setError('speechSynthesis is unavailable');
      return;
    }

    try {
      const utterance = new SpeechSynthesisUtterance(
        'Hello from SpeechSynthesis in the speech test page'
      );
      utterance.lang = 'en-US';
      utterance.pitch = 1.0;
      utterance.rate = 1.0;
      utterance.volume = 1.0;
      speechSynthesis.speak(utterance);
      this.clearError();
      this.log('Triggered speechSynthesis.speak()');
    } catch (error) {
      this.setError(String(error));
    }
  },

  startRecognition() {
    if (!this.recognition) {
      this.setError('SpeechRecognition is unavailable');
      return;
    }

    try {
      this.clearError();
      this.setData({
        recognitionState: 'starting',
        lastTranscript: '',
      });
      this.log('Calling recognition.start()');
      this.recognition.start();
    } catch (error) {
      this.setError(String(error));
    }
  },

  stopRecognition() {
    if (!this.recognition) {
      return;
    }
    try {
      this.log('Calling recognition.stop()');
      this.recognition.stop();
    } catch (error) {
      this.setError(String(error));
    }
  },

  abortRecognition() {
    if (!this.recognition) {
      return;
    }
    try {
      this.log('Calling recognition.abort()');
      this.recognition.abort();
    } catch (error) {
      this.setError(String(error));
    }
  },

  clearLogs() {
    this.setData({ logs: ['Logs cleared'] });
  },
};
</script>

<page>
  <view class="container">
    <view class="page-title">Speech Test</view>
    <view class="subtitle">Manual regression page for TTS and mock SpeechRecognition in ink-open.</view>

    <view class="card">
      <text class="section-title">Summary</text>
      <text class="meta-line">TTS Available: {{ttsAvailable}}</text>
      <text class="meta-line">Recognition Available: {{recognitionAvailable}}</text>
      <text class="meta-line">Recognition State: {{recognitionState}}</text>
      <text class="meta-line">Result Count: {{resultCount}}</text>
      <text class="meta-line">Expected Transcript: {{mockTranscript}}</text>
      <text class="meta-line">Last Transcript: {{lastTranscript || 'None yet'}}</text>
      <text class="meta-line">Last Error: {{lastError || 'None'}}</text>
    </view>

    <view class="card">
      <text class="section-title">TTS</text>
      <view class="button-grid" role="navigation">
        <button class="btn" bindtap="playWxTts">wx.speech.playTTS</button>
        <button class="btn" bindtap="playSpeechSynthesis">speechSynthesis.speak</button>
      </view>
    </view>

    <view class="card">
      <text class="section-title">ASR</text>
      <view class="button-grid button-grid-vertical">
        <button class="btn" bindtap="startRecognition">Start Recognition</button>
        <button class="btn btn-secondary" bindtap="stopRecognition">Stop Recognition</button>
        <button class="btn btn-danger" bindtap="abortRecognition">Abort Recognition</button>
      </view>
    </view>

    <view class="card log-card">
      <view class="section-header">
        <text class="section-title">Event Log</text>
        <button class="btn btn-secondary btn-inline" bindtap="clearLogs">Clear</button>
      </view>
      <view class="log-list">
        <view class="log-item" ink:for="{{logs}}">
          <text class="log-text">{{item}}</text>
        </view>
      </view>
    </view>
  </view>
</page>

<style>
.container {
  --speech-page-background: var(--color-background);
  --speech-surface-background: var(--color-surface);
  --speech-surface-muted-background: var(--color-surface-highlight);
  --speech-text-color: var(--color-text-primary);
  --speech-muted-text-color: var(--color-text-secondary);
  --speech-primary-background: var(--color-primary);
  --speech-primary-text: #ffffff;
  --speech-secondary-background: var(--speech-surface-muted-background, #edf2f7);
  --speech-secondary-text: var(--speech-text-color);
  --speech-danger-background: var(--border-color-danger, #ff3b30);
  --speech-page-padding: var(--spacing-lg, 24px);
  --speech-section-gap: var(--spacing-md, 16px);
  --speech-card-gap: var(--spacing-sm, 8px);
  --speech-card-padding: var(--spacing-md, 16px);
  --speech-button-gap: var(--spacing-sm, 12px);
  --speech-log-gap: var(--spacing-sm, 8px);
  --speech-card-radius: var(--radius-md, 12px);
  --speech-item-radius: var(--radius-sm, 8px);
  --speech-card-border: var(--border-width-thin, 1px) solid
    var(--border-color-default, #e5e7eb);
  display: flex;
  flex-direction: column;
  gap: var(--speech-section-gap);
  padding: var(--speech-page-padding);
  background-color: var(--speech-page-background);
  box-sizing: border-box;
}

.page-title {
  font-size: 24px;
  font-weight: 700;
  color: var(--speech-text-color);
}

.subtitle {
  font-size: 14px;
  color: var(--speech-muted-text-color);
  line-height: 20px;
}

.card {
  display: flex;
  flex-direction: column;
  gap: var(--speech-card-gap);
  padding: var(--speech-card-padding);
  border-radius: var(--speech-card-radius);
  background-color: var(--speech-surface-background);
  border: var(--speech-card-border);
}

.section-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: var(--speech-button-gap);
}

.section-title {
  font-size: 16px;
  font-weight: 700;
  color: var(--speech-text-color);
}

.meta-line {
  font-size: 14px;
  color: var(--speech-text-color);
  line-height: 20px;
}

.button-grid {
  display: flex;
  flex-wrap: wrap;
  gap: var(--speech-button-gap);
}

.btn {
  min-width: 140px;
  padding: 12px 14px;
  font-size: 14px;
}

.btn-inline {
  min-width: 80px;
}

.button-grid-vertical {
  flex-direction: column;
  flex-wrap: nowrap;
}

.button-grid-vertical .btn {
  min-width: 0;
  width: 100%;
  box-sizing: border-box;
}

.log-card {
  flex: 1;
}

.log-list {
  display: flex;
  flex-direction: column;
  gap: var(--speech-log-gap);
}

.log-item {
  padding: 10px 12px;
  border-radius: var(--speech-item-radius);
  background-color: var(--speech-surface-muted-background, #edf2f7);
}

.log-text {
  font-size: 13px;
  color: var(--speech-text-color);
  line-height: 18px;
}
</style>
