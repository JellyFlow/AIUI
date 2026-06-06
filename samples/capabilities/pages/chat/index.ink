<script type="application/json" def>
{
  "navigationBarTitleText": "Chat"
}
</script>

<script setup>
import wx from 'wx';

const STREAM_POLL_MS = 16;
const ASR_IDLE_TIMEOUT_MS = 5000;
const SPEECH_LANG = 'zh-CN';
const EMPTY_TRANSCRIPT_TEXT = '未识别到有效语音，请再试一次。';
const ASR_IDLE_TIMEOUT_TEXT = 'ASR 5 秒无事件，已自动关闭。';
const PHOTO_PROMPT_TEXT = '请描述这张照片中的主要内容，并指出关键物体或场景。回答尽量简洁自然。';
const PHOTO_USER_TEXT = '我拍了一张照片，请帮我识别内容。';
const SESSION_OPTIONS = {
  initialPrompts: [
    {
      role: 'system',
      content:
        'You are a concise and friendly voice assistant demo for Ink. Reply in the same language as the user when possible. Keep responses easy to read and short enough to sound natural when spoken aloud.',
    },
  ],
};

function makeId(prefix) {
  return `${prefix}-${Date.now()}-${Math.random().toString(16).slice(2)}`;
}

function makeMessage(role, content = '', extra = {}) {
  return {
    id: makeId(role),
    role,
    content,
    pending: false,
    ...extra,
  };
}

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

function normalizeText(value) {
  if (typeof value !== 'string') {
    return '';
  }
  return value.replace(/[ \t]+/g, ' ').replace(/\n{3,}/g, '\n\n').trim();
}

function getErrorMessage(error) {
  if (!error) {
    return 'Unknown error';
  }
  if (typeof error === 'string') {
    return error;
  }
  if (error.message) {
    return error.message;
  }
  if (error.errMsg) {
    return error.errMsg;
  }
  return String(error);
}

function toArrayBuffer(data) {
  if (data instanceof ArrayBuffer) {
    return data;
  }
  if (ArrayBuffer.isView(data)) {
    return data.buffer.slice(data.byteOffset, data.byteOffset + data.byteLength);
  }
  return null;
}

function extractTranscript(event) {
  const results = event && event.results ? event.results : null;
  if (!results || typeof results.length !== 'number') {
    return { transcript: '', hasFinal: false };
  }

  const parts = [];
  let hasFinal = false;
  for (let index = 0; index < results.length; index += 1) {
    const result = results[index];
    const alternative = result && result[0];
    if (!alternative || !alternative.transcript) {
      continue;
    }
    parts.push(alternative.transcript);
    if (result.isFinal) {
      hasFinal = true;
    }
  }

  return {
    transcript: normalizeText(parts.join('')),
    hasFinal,
  };
}

export default {
  data: {
    availability: 'unknown',
    recognitionAvailable: false,
    ttsAvailable: false,
    cameraAvailable: false,
    status: 'checking',
    isBusy: false,
    lastWakeKeyword: '',
    liveTranscript: '',
    lastError: '',
    messages: [],
  },

  async onLoad() {
    this.session = null;
    this.recognition = null;
    this.cameraContext = null;
    this.asrIdleTimer = null;
    this.activeUserMessageId = '';
    this.activeAssistantMessageId = '';
    this.currentTurnId = '';
    this.finalTranscript = '';
    this.recognitionFailed = false;
    this.speechPromiseResolve = null;
    this.currentSpeechMode = '';

    this.setData({
      messages: [
        makeMessage(
          'assistant',
          '你好，我是语音 Chat Demo。你可以开启 ASR 发起语音对话，或者点击“拍照识图”把照片发送给 LLM 分析。'
        ),
      ],
    });

    this.initCameraContext();
    await this.refreshAvailability();
  },

  onUnload() {
    this.recognitionFailed = true;
    this.currentTurnId = '';
    this.activeUserMessageId = '';
    this.activeAssistantMessageId = '';
    this.clearAsrIdleTimer();
    this.cancelRecognition();
    this.cancelSpeechPlayback();
    if (this.session) {
      try {
        this.session.destroy();
      } catch (_error) {}
      this.session = null;
    }
  },

  onVoiceWakeup(event) {
    const keyword = event && event.keyword ? event.keyword : '';
    this.beginVoiceTurn('wakeup', keyword);
  },

  setMessages(messages) {
    this.setData({ messages });
  },

  appendMessage(message) {
    this.setMessages([message, ...(this.data.messages || [])]);
    return message.id;
  },

  updateMessage(id, content, extra = {}) {
    const messages = (this.data.messages || []).map((message) =>
      message.id === id
        ? {
            ...message,
            content,
            ...extra,
          }
        : message
    );
    this.setMessages(messages);
  },

  appendAssistantNotice(content, extra = {}) {
    return this.appendMessage(makeMessage('assistant', content, extra));
  },

  setStatus(status, extra = {}) {
    this.setData({
      status,
      ...extra,
    });
  },

  setError(message) {
    this.setData({
      lastError: message,
      status: 'error',
      isBusy: false,
    });
  },

  setIdleError(message) {
    this.setData({
      lastError: message,
      status: 'idle',
      isBusy: false,
    });
  },

  clearError() {
    if (!this.data.lastError) {
      return;
    }
    this.setData({ lastError: '' });
  },

  detectRecognitionSupport() {
    return typeof SpeechRecognition !== 'undefined';
  },

  detectTtsSupport() {
    return (
      (typeof speechSynthesis !== 'undefined' &&
        typeof SpeechSynthesisUtterance !== 'undefined' &&
        typeof speechSynthesis.speak === 'function') ||
      !!(wx && wx.speech && typeof wx.speech.playTTS === 'function')
    );
  },

  detectCameraSupport() {
    return !!(wx && wx.media && typeof wx.media.createCameraContext === 'function');
  },

  async refreshAvailability() {
    const recognitionAvailable = this.detectRecognitionSupport();
    const ttsAvailable = this.detectTtsSupport();

    this.setData({
      status: 'checking',
      recognitionAvailable,
      ttsAvailable,
      lastError: '',
    });

    try {
      const availability = await LanguageModel.availability();
      this.setData({
        availability,
        status: availability === 'available' ? 'idle' : 'unavailable',
      });
    } catch (error) {
      this.setData({
        availability: 'unavailable',
        status: 'error',
      });
      this.setError(getErrorMessage(error));
    }
  },

  async ensureSession() {
    if (this.session) {
      return this.session;
    }

    if (this.data.availability !== 'available') {
      await this.refreshAvailability();
    }

    if (this.data.availability !== 'available') {
      throw new Error('LanguageModel 不可用，请使用带 --llm-config-file 的 ink-open 启动。');
    }

    this.session = await LanguageModel.create(SESSION_OPTIONS);
    return this.session;
  },

  releaseRecognition(recognition) {
    if (this.recognition === recognition) {
      this.recognition = null;
    }
  },

  bindRecognition() {
    if (!this.detectRecognitionSupport()) {
      this.recognition = null;
      this.setData({ recognitionAvailable: false });
      return false;
    }

    this.disposeRecognition();
    const recognition = new SpeechRecognition();
    recognition.lang = SPEECH_LANG;
    recognition.continuous = false;
    recognition.interimResults = true;
    recognition.maxAlternatives = 1;

    recognition.onstart = () => {
      this.refreshAsrIdleTimer();
      this.setStatus('listening', { isBusy: true });
    };

    recognition.onaudiostart = () => {
      this.refreshAsrIdleTimer();
    };

    recognition.onsoundstart = () => {
      this.refreshAsrIdleTimer();
    };

    recognition.onspeechstart = () => {
      this.refreshAsrIdleTimer();
    };

    recognition.onresult = (event) => {
      const { transcript, hasFinal } = extractTranscript(event);
      if (!this.currentTurnId) {
        return;
      }
      this.refreshAsrIdleTimer();
      this.setData({ liveTranscript: transcript });
      this.updatePendingUserMessage(transcript || '正在聆听...', true);
      if (hasFinal && transcript) {
        this.finalTranscript = transcript;
      }
    };

    recognition.onerror = (event) => {
      this.releaseRecognition(recognition);
      this.clearAsrIdleTimer();
      const message =
        event && event.message ? `${event.error || 'error'}: ${event.message}` : '语音识别失败。';
      this.recognitionFailed = true;
      this.updatePendingUserMessage(this.data.liveTranscript || '语音识别失败', false);
      this.failTurn(message, false);
    };

    recognition.onend = async () => {
      this.clearAsrIdleTimer();
      this.releaseRecognition(recognition);
      if (!this.currentTurnId || this.recognitionFailed) {
        return;
      }

      const transcript = normalizeText(this.finalTranscript || this.data.liveTranscript);
      if (!transcript) {
        this.updatePendingUserMessage(EMPTY_TRANSCRIPT_TEXT, false);
        this.completeTurn('idle');
        return;
      }

      this.updatePendingUserMessage(transcript, false);
      await this.generateAssistantReply(this.currentTurnId, transcript);
    };

    this.recognition = recognition;
    this.setData({ recognitionAvailable: true });
    return true;
  },

  ensureCameraContext(options = {}) {
    const { silent = false } = options;
    if (this.cameraContext && typeof this.cameraContext.takePhoto === 'function') {
      this.setData({ cameraAvailable: true });
      return true;
    }

    try {
      this.cameraContext = this.detectCameraSupport() ? wx.media.createCameraContext() : null;
      const cameraAvailable = !!(this.cameraContext && typeof this.cameraContext.takePhoto === 'function');
      this.setData({ cameraAvailable });
      if (!cameraAvailable && !silent) {
        this.setError('CameraContext 不可用。');
      }
      return cameraAvailable;
    } catch (error) {
      this.cameraContext = null;
      this.setData({ cameraAvailable: false });
      if (!silent) {
        this.setError(`CameraContext 初始化失败：${getErrorMessage(error)}`);
      }
      return false;
    }
  },

  initCameraContext() {
    this.ensureCameraContext({ silent: true });
  },

  clearAsrIdleTimer() {
    if (!this.asrIdleTimer) {
      return;
    }
    clearTimeout(this.asrIdleTimer);
    this.asrIdleTimer = null;
  },

  refreshAsrIdleTimer() {
    this.clearAsrIdleTimer();
    if (!this.currentTurnId || this.data.status !== 'listening') {
      return;
    }
    const turnId = this.currentTurnId;
    this.asrIdleTimer = setTimeout(() => {
      if (this.currentTurnId !== turnId || this.data.status !== 'listening') {
        return;
      }
      this.handleAsrIdleTimeout();
    }, ASR_IDLE_TIMEOUT_MS);
  },

  handleAsrIdleTimeout() {
    this.clearAsrIdleTimer();
    if (!this.currentTurnId || this.data.status !== 'listening') {
      return;
    }
    this.recognitionFailed = true;
    this.updatePendingUserMessage(this.data.liveTranscript || ASR_IDLE_TIMEOUT_TEXT, false);
    this.appendAssistantNotice(ASR_IDLE_TIMEOUT_TEXT);
    this.currentTurnId = '';
    this.activeUserMessageId = '';
    this.activeAssistantMessageId = '';
    this.finalTranscript = '';
    this.setData({
      status: 'idle',
      isBusy: false,
      liveTranscript: '',
    });
    this.cancelRecognition();
  },

  disposeRecognition() {
    const recognition = this.recognition;
    if (!recognition) {
      return;
    }
    try {
      recognition.onstart = null;
      recognition.onaudiostart = null;
      recognition.onsoundstart = null;
      recognition.onspeechstart = null;
      recognition.onresult = null;
      recognition.onerror = null;
      recognition.onend = null;
      recognition.abort();
    } catch (_error) {}
    this.recognition = null;
  },

  beginVoiceTurn(source = 'manual', keyword = '') {
    if (this.data.isBusy) {
      return;
    }

    if (!this.data.recognitionAvailable) {
      this.appendAssistantNotice('当前环境不支持 SpeechRecognition。');
      this.setError('SpeechRecognition 不可用。');
      return;
    }

    if (this.data.availability !== 'available') {
      this.appendAssistantNotice('LanguageModel 当前不可用，无法发起语音对话。');
      this.setError('LanguageModel 不可用。');
      return;
    }

    if (!this.bindRecognition()) {
      this.appendAssistantNotice('当前环境不支持 SpeechRecognition。');
      this.setError('SpeechRecognition 不可用。');
      return;
    }

    this.cancelSpeechPlayback();
    this.clearAsrIdleTimer();
    this.clearError();
    this.finalTranscript = '';
    this.recognitionFailed = false;
    this.currentTurnId = makeId('turn');
    this.activeAssistantMessageId = '';
    this.activeUserMessageId = this.appendMessage(
      makeMessage('user', '正在聆听...', {
        pending: true,
        source,
      })
    );

    this.setData({
      isBusy: true,
      status: 'listening',
      liveTranscript: '',
      lastWakeKeyword: keyword || (source === 'manual' ? 'manual' : ''),
    });

    try {
      this.recognition.start();
    } catch (error) {
      this.updatePendingUserMessage('语音识别启动失败', false);
      this.failTurn(getErrorMessage(error), false);
    }
  },

  updatePendingUserMessage(content, pending) {
    if (!this.activeUserMessageId) {
      return;
    }
    this.updateMessage(this.activeUserMessageId, content, { pending });
  },

  toggleAsr() {
    if (this.data.status === 'listening') {
      this.stopAsr();
      return;
    }

    if (this.data.status === 'thinking' || this.data.status === 'speaking') {
      return;
    }

    this.beginVoiceTurn('manual-asr', 'manual-asr');
  },

  buildPhotoPrompt(photoPayload, instruction) {
    if (!photoPayload || !photoPayload.data || !photoPayload.mimeType) {
      throw new Error('拍照结果缺少图片数据。');
    }

    const arrayBuffer = toArrayBuffer(photoPayload.data);
    if (!arrayBuffer) {
      throw new Error('无法读取拍照结果的二进制数据。');
    }
    if (!wx || typeof wx.arrayBufferToBase64 !== 'function') {
      throw new Error('wx.arrayBufferToBase64 不可用。');
    }

    const dataUrl = `data:${photoPayload.mimeType};base64,${wx.arrayBufferToBase64(arrayBuffer)}`;
    return [
      {
        role: 'user',
        content: [
          {
            type: 'text',
            text: instruction,
          },
          {
            type: 'image_url',
            image_url: {
              url: dataUrl,
            },
          },
        ],
      },
    ];
  },

  async generateAssistantReplyFromPhoto(turnId, photoPayload) {
    if (!turnId || this.currentTurnId !== turnId) {
      return;
    }

    const assistantMessageId = this.appendMessage(
      makeMessage('assistant', '', {
        pending: true,
        source: 'camera',
      })
    );
    this.activeAssistantMessageId = assistantMessageId;
    this.setStatus('thinking', {
      isBusy: true,
      liveTranscript: '',
    });

    try {
      const session = await this.ensureSession();
      const prompt = this.buildPhotoPrompt(photoPayload, PHOTO_PROMPT_TEXT);
      const result = await session.prompt(prompt);
      const finalText = normalizeText(result) || '我暂时没有识别出可描述的内容。';
      this.updateMessage(assistantMessageId, finalText, { pending: false });
      this.activeAssistantMessageId = '';
      await this.speakAssistantReply(turnId, finalText);
    } catch (error) {
      this.updateMessage(assistantMessageId, `出错了：${getErrorMessage(error)}`, {
        pending: false,
      });
      this.activeAssistantMessageId = '';
      this.failTurn(getErrorMessage(error), true);
    }
  },

  async capturePhoto() {
    if (this.data.isBusy) {
      return;
    }

    if (this.data.availability !== 'available') {
      this.appendAssistantNotice('LanguageModel 当前不可用，无法发起拍照识图。');
      this.setError('LanguageModel 不可用。');
      return;
    }

    if (!this.ensureCameraContext()) {
      return;
    }

    this.cancelSpeechPlayback();
    this.cancelRecognition();
    this.clearAsrIdleTimer();
    this.clearError();
    this.finalTranscript = '';
    this.recognitionFailed = false;
    this.currentTurnId = makeId('turn');
    this.activeUserMessageId = '';
    this.activeAssistantMessageId = '';
    this.setData({
      isBusy: true,
      liveTranscript: '',
    });

    let photoPayload;
    try {
      photoPayload = await this.cameraContext.takePhoto({ quality: 'high' });
    } catch (error) {
      this.currentTurnId = '';
      this.setIdleError(`拍照失败：${getErrorMessage(error)}`);
      return;
    }

    this.appendMessage(
      makeMessage('user', PHOTO_USER_TEXT, {
        source: 'camera',
      })
    );
    await this.generateAssistantReplyFromPhoto(this.currentTurnId, photoPayload);
  },

  stopAsr() {
    if (this.data.status !== 'listening') {
      return;
    }
    this.clearAsrIdleTimer();
    this.recognitionFailed = true;
    this.updatePendingUserMessage(this.data.liveTranscript || 'ASR 已手动关闭。', false);
    this.currentTurnId = '';
    this.activeUserMessageId = '';
    this.activeAssistantMessageId = '';
    this.finalTranscript = '';
    this.setData({
      status: 'idle',
      isBusy: false,
      liveTranscript: '',
    });
    this.cancelRecognition();
  },

  async readAllText(stream, assistantMessageId) {
    const chunks = [];
    while (true) {
      const { done, value } = await stream.read();
      if (done) {
        break;
      }
      if (typeof value === 'string' && value.length > 0) {
        chunks.push(value);
        this.updateMessage(assistantMessageId, chunks.join(''), {
          pending: true,
        });
      } else {
        await sleep(STREAM_POLL_MS);
      }
    }
    return chunks.join('');
  },

  async generateAssistantReply(turnId, transcript) {
    if (!turnId || this.currentTurnId !== turnId) {
      return;
    }

    const assistantMessageId = this.appendMessage(
      makeMessage('assistant', '', {
        pending: true,
      })
    );
    this.activeAssistantMessageId = assistantMessageId;
    this.setStatus('thinking', {
      isBusy: true,
      liveTranscript: transcript,
    });

    try {
      const session = await this.ensureSession();
      const stream = session.promptStreaming(transcript);
      const result = await this.readAllText(stream, assistantMessageId);
      const finalText = result || '我暂时没有生成可播报的回答。';
      this.updateMessage(assistantMessageId, finalText, { pending: false });
      this.activeAssistantMessageId = '';
      await this.speakAssistantReply(turnId, finalText);
    } catch (error) {
      this.updateMessage(assistantMessageId, `出错了：${getErrorMessage(error)}`, {
        pending: false,
      });
      this.activeAssistantMessageId = '';
      this.failTurn(getErrorMessage(error), true);
    }
  },

  async speakAssistantReply(turnId, text) {
    if (!turnId || this.currentTurnId !== turnId) {
      return;
    }

    const content = normalizeText(text) || text;
    if (!content) {
      this.completeTurn('idle');
      return;
    }

    if (!this.data.ttsAvailable) {
      this.appendAssistantNotice('TTS 不可用，本次仅展示文本回复。');
      this.completeTurn('idle');
      return;
    }

    try {
      const mode = await this.playTts(content);
      if (mode === 'cancelled') {
        this.completeTurn('idle');
        return;
      }
      this.completeTurn('idle');
    } catch (error) {
      this.failTurn(`TTS 播放失败：${getErrorMessage(error)}`, true);
    }
  },

  playTts(text) {
    if (
      typeof speechSynthesis !== 'undefined' &&
      typeof SpeechSynthesisUtterance !== 'undefined' &&
      typeof speechSynthesis.speak === 'function'
    ) {
      return new Promise((resolve, reject) => {
        try {
          this.cancelSpeechPlayback();
          const utterance = new SpeechSynthesisUtterance(text);
          utterance.lang = SPEECH_LANG;
          utterance.onstart = () => {
            this.currentSpeechMode = 'speechSynthesis';
            this.setStatus('speaking', { isBusy: true });
          };
          utterance.onend = () => {
            const nextResolve = this.speechPromiseResolve;
            this.speechPromiseResolve = null;
            this.currentSpeechMode = '';
            if (nextResolve) {
              nextResolve('finished');
            } else {
              resolve('finished');
            }
          };
          utterance.onerror = (event) => {
            this.speechPromiseResolve = null;
            this.currentSpeechMode = '';
            reject(new Error(event && event.message ? event.message : 'speechSynthesis 失败'));
          };
          this.speechPromiseResolve = resolve;
          speechSynthesis.speak(utterance);
        } catch (error) {
          reject(error);
        }
      });
    }

    if (wx && wx.speech && typeof wx.speech.playTTS === 'function') {
      this.setStatus('speaking', { isBusy: true });
      this.currentSpeechMode = 'wx';
      return new Promise((resolve, reject) => {
        wx.speech.playTTS({
          text,
          success: () => {
            this.currentSpeechMode = '';
            resolve('finished');
          },
          fail: (error) => {
            this.currentSpeechMode = '';
            reject(error);
          },
        });
      });
    }

    return Promise.resolve('unsupported');
  },

  cancelSpeechPlayback() {
    if (
      typeof speechSynthesis !== 'undefined' &&
      typeof speechSynthesis.cancel === 'function' &&
      this.currentSpeechMode === 'speechSynthesis'
    ) {
      try {
        speechSynthesis.cancel();
      } catch (_error) {}
      if (this.speechPromiseResolve) {
        const resolve = this.speechPromiseResolve;
        this.speechPromiseResolve = null;
        resolve('cancelled');
      }
      this.currentSpeechMode = '';
    }
  },

  cancelRecognition() {
    this.disposeRecognition();
  },

  simulateWakeup() {
    this.beginVoiceTurn('manual', 'manual');
  },

  failTurn(message, appendAssistantError) {
    this.clearAsrIdleTimer();
    this.setError(message);
    if (appendAssistantError) {
      this.appendAssistantNotice(`出错了：${message}`);
    }
    this.currentTurnId = '';
    this.activeUserMessageId = '';
    this.activeAssistantMessageId = '';
    this.finalTranscript = '';
    this.setData({
      isBusy: false,
    });
  },

  completeTurn(status) {
    this.clearAsrIdleTimer();
    this.currentTurnId = '';
    this.activeUserMessageId = '';
    this.activeAssistantMessageId = '';
    this.finalTranscript = '';
    this.recognitionFailed = false;
    this.setData({
      status,
      isBusy: false,
      liveTranscript: '',
    });
  },

  async resetChat() {
    this.recognitionFailed = true;
    this.currentTurnId = '';
    this.activeUserMessageId = '';
    this.activeAssistantMessageId = '';
    this.clearAsrIdleTimer();
    this.cancelRecognition();
    this.cancelSpeechPlayback();
    if (this.session) {
      try {
        this.session.destroy();
      } catch (_error) {}
      this.session = null;
    }
    this.finalTranscript = '';
    this.recognitionFailed = false;

    await this.refreshAvailability();
    this.setData({
      liveTranscript: '',
      lastWakeKeyword: '',
      lastError: '',
      isBusy: false,
      messages: [
        makeMessage(
          'assistant',
          '会话已重置。说出唤醒词或点击“模拟唤醒”重新开始语音对话。'
        ),
      ],
    });
  },
};
</script>

<page>
  <view class="container">
    <view class="hero">
      <view class="page-title">Chat</view>
      <text class="page-description">
        集成唤醒、ASR、LLM 和 TTS 的语音对话页。唤醒后开始拾音，识别文本实时展示，回答完成后自动播报。
      </text>
    </view>

    <view class="card status-card">
      <view class="status-top">
        <text class="status-chip status-{{status}}">{{status}}</text>
        <text class="availability-text">LLM: {{availability}}</text>
      </view>
      <view class="status-grid">
        <text class="meta-line">ASR: {{recognitionAvailable ? 'available' : 'unavailable'}}</text>
        <text class="meta-line">TTS: {{ttsAvailable ? 'available' : 'unavailable'}}</text>
        <text class="meta-line">Camera: {{cameraAvailable ? 'available' : 'unavailable'}}</text>
        <text class="meta-line">Wake Keyword: {{lastWakeKeyword || 'None'}}</text>
      </view>
    </view>

    <view class="error-banner" ink:if="{{lastError}}">
      <text class="error-text">{{lastError}}</text>
    </view>

    <card class="card voice-card">
      <view class="section-header">
        <text class="section-title">Voice Loop</text>
        <text class="section-subtitle">{{isBusy ? '流程运行中' : '等待唤醒'}}</text>
      </view>
      <view class="transcript-box">
        <text class="transcript-label">实时听写</text>
        <text class="transcript-text">{{liveTranscript || '开启 ASR 后，这里会实时展示识别文本。'}}</text>
      </view>
      <view class="button-row">
        <button
          class="btn btn-primary"
          bindtap="toggleAsr"
          disabled="{{isBusy && status !== 'listening'}}"
        >
          {{status === 'listening' ? '关闭 ASR' : '开启 ASR'}}
        </button>
        <button class="btn" bindtap="capturePhoto" disabled="{{isBusy || !cameraAvailable}}">
          拍照识图
        </button>
        <button class="btn" bindtap="resetChat">重置会话</button>
      </view>
    </card>

    <view class="card chat-card">
      <view class="section-header">
        <text class="section-title">Messages</text>
        <text class="section-subtitle">自动流转：Wakeup -> ASR -> LLM -> TTS</text>
      </view>
      <view class="messages">
        <view class="message-row message-row-{{item.role}}" ink:for="{{messages}}" ink:key="id">
          <view class="bubble bubble-{{item.role}}">
            <text class="bubble-role">{{item.role === 'user' ? 'User' : 'Assistant'}}</text>
            <text class="bubble-text">{{item.content || (item.pending ? '...' : '')}}</text>
            <text class="bubble-meta" ink:if="{{item.pending}}">
              {{item.role === 'user' ? 'ASR 实时识别中' : 'LLM 生成中'}}
            </text>
          </view>
        </view>
      </view>
    </view>
  </view>
</page>

<style>
  .container {
    display: flex;
    flex-direction: column;
    gap: 16px;
    padding: var(--theme-padding, 20px);
  }

  .hero,
  .card {
    display: flex;
    flex-direction: column;
  }

  .hero {
    gap: 8px;
  }

  .card {
    gap: 12px;
    padding: 16px;
    border-radius: var(--radius-md, 12px);
  }

  .page-title {
    font-size: 28px;
    font-weight: bold;
    color: var(--color-text-primary);
  }

  .page-description {
    font-size: 14px;
    line-height: 20px;
    color: var(--color-text-secondary);
  }

  .status-top,
  .section-header,
  .button-row {
    display: flex;
    flex-direction: row;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
    flex-wrap: wrap;
  }

  .status-chip {
    padding: 6px 10px;
    border-radius: 999px;
    border: var(--border-width-thin, 1px) solid currentColor;
    font-size: 12px;
    font-weight: bold;
    text-transform: uppercase;
    color: var(--color-text-secondary);
  }

  .status-idle {
    color: var(--border-color-success, #34c759);
  }

  .status-listening,
  .status-thinking,
  .status-speaking,
  .status-checking {
    color: var(--border-color-warning, #ff9f0a);
  }

  .status-error,
  .status-unavailable {
    color: var(--border-color-danger, #ff3b30);
  }

  .availability-text,
  .meta-line,
  .section-subtitle,
  .bubble-meta {
    font-size: 12px;
    color: var(--color-text-secondary);
  }

  .status-grid {
    display: flex;
    flex-direction: column;
    gap: 6px;
  }

  .error-banner {
    padding: 12px 14px;
    border-radius: var(--radius-md, 12px);
    border: var(--border-width-thin, 1px) solid var(--border-color-danger, #ff3b30);
    background-color: transparent;
  }

  .error-text {
    font-size: 13px;
    line-height: 18px;
    color: var(--border-color-danger, #ff3b30);
  }

  .section-title {
    font-size: 16px;
    font-weight: bold;
    color: var(--color-text-primary);
  }

  .transcript-box {
    display: flex;
    flex-direction: column;
    gap: 8px;
    padding: 12px;
    border-radius: var(--radius-md, 12px);
    border: var(--border-width-thin, 1px) solid var(--border-color-default, #d1d1d6);
  }

  .transcript-label {
    font-size: 12px;
    font-weight: bold;
    color: var(--color-text-secondary);
    text-transform: uppercase;
  }

  .transcript-text {
    font-size: 14px;
    line-height: 20px;
    color: var(--color-text-primary);
  }

  .btn {
    font-size: 14px;
    border: var(--border-width-thin, 1px) solid var(--border-color-default, #d1d1d6);
    background-color: transparent;
  }

  .btn-primary {
    border-color: var(--color-primary, #0a84ff);
  }

  .messages {
    display: flex;
    flex-direction: column;
    gap: 14px;
  }

  .message-row {
    display: flex;
    width: 100%;
  }

  .message-row-user {
    justify-content: flex-end;
  }

  .message-row-assistant {
    justify-content: flex-start;
  }

  .bubble {
    display: flex;
    flex-direction: column;
    gap: 6px;
    max-width: 86%;
    padding: 12px 14px;
    border-radius: 14px;
    border: var(--border-width-thin, 1px) solid var(--border-color-default, #d1d1d6);
    background-color: transparent;
  }

  .bubble-user {
    border-top-right-radius: 6px;
  }

  .bubble-assistant {
    border-top-left-radius: 6px;
  }

  .bubble-role {
    font-size: 11px;
    font-weight: bold;
    text-transform: uppercase;
    color: var(--color-text-secondary);
  }

  .bubble-text {
    font-size: 13px;
    line-height: 18px;
    color: var(--color-text-primary);
    white-space: pre-wrap;
  }
</style>
