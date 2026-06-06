<script type="application/json" def>
{
  "navigationBarTitleText": "Recorder Test"
}
</script>

<script setup>
import wx from 'wx';
const LOG_LIMIT = 80;

function formatBytes(value) {
  if (typeof value !== 'number' || !Number.isFinite(value)) {
    return '0 B';
  }
  if (value < 1024) {
    return `${value} B`;
  }
  if (value < 1024 * 1024) {
    return `${(value / 1024).toFixed(2)} KB`;
  }
  return `${(value / (1024 * 1024)).toFixed(2)} MB`;
}

function nowLabel() {
  return new Date().toISOString().slice(11, 19);
}

export default {
  data: {
    available: false,
    currentFormat: 'pcm',
    state: 'idle',
    headerCount: 0,
    frameCount: 0,
    lastHeaderSize: '0 B',
    lastFrameSize: '0 B',
    lastStopPath: '',
    lastError: '',
    logs: ['Recorder test page ready'],
  },

  onLoad() {
    this.recorder = null;
    this.bindRecorder();
  },

  onUnload() {
    this.stopRecordingSilently();
  },

  log(message) {
    const nextLogs = [`${nowLabel()} ${message}`, ...(this.data.logs || [])].slice(0, LOG_LIMIT);
    this.setData({ logs: nextLogs });
  },

  setError(message) {
    this.setData({ lastError: message, state: 'error' });
    this.log(`Error: ${message}`);
  },

  clearError() {
    if (this.data.lastError) {
      this.setData({ lastError: '' });
    }
  },

  bindRecorder() {
    try {
      const recorder = wx.media.getRecorderManager();
      if (!recorder) {
        this.setData({ available: false });
        this.setError('wx.media.getRecorderManager() returned undefined');
        return;
      }

      this.recorder = recorder;
      this.setData({ available: true });
      this.log('RecorderManager acquired');

      recorder.onStart(() => {
        this.clearError();
        this.setData({ state: 'recording' });
        this.log(`Recording started (${this.data.currentFormat})`);
      });

      recorder.onPause(() => {
        this.setData({ state: 'paused' });
        this.log('Recording paused');
      });

      recorder.onResume(() => {
        this.setData({ state: 'recording' });
        this.log('Recording resumed');
      });

      recorder.onStop((payload) => {
        const tempFilePath = payload && payload.tempFilePath ? payload.tempFilePath : '';
        this.setData({
          state: 'idle',
          lastStopPath: tempFilePath,
        });
        this.log(`Recording stopped${tempFilePath ? `: ${tempFilePath}` : ''}`);
      });

      recorder.onHeader((format, buffer) => {
        const size = buffer && typeof buffer.byteLength === 'number' ? buffer.byteLength : 0;
        this.setData({
          headerCount: this.data.headerCount + 1,
          lastHeaderSize: formatBytes(size),
        });
        this.log(`Header received format=${format} size=${formatBytes(size)}`);
      });

      recorder.onFrameRecorded((payload) => {
        const frameBuffer = payload && payload.frameBuffer ? payload.frameBuffer : null;
        const size =
          frameBuffer && typeof frameBuffer.byteLength === 'number' ? frameBuffer.byteLength : 0;
        this.setData({
          frameCount: this.data.frameCount + 1,
          lastFrameSize: formatBytes(size),
        });
        if ((this.data.frameCount + 1) <= 5 || (this.data.frameCount + 1) % 20 === 0) {
          this.log(
            `Frame #${this.data.frameCount + 1} recorded size=${formatBytes(size)}`
          );
        }
      });

      recorder.onError((payload) => {
        const message = payload && payload.errMsg ? payload.errMsg : 'Unknown recorder error';
        this.setError(message);
      });

      recorder.onInterruptionBegin(() => {
        this.log('Recording interruption begin');
      });

      recorder.onInterruptionEnd(() => {
        this.log('Recording interruption end');
      });
    } catch (error) {
      this.setData({ available: false });
      this.setError(String(error));
    }
  },

  setFormat(format) {
    if (this.data.state === 'recording' || this.data.state === 'paused') {
      this.log('Format switch ignored while recording is active');
      return;
    }
    this.setData({ currentFormat: format });
    this.clearError();
    this.log(`Format set to ${format}`);
  },

  usePCM() {
    this.setFormat('pcm');
  },

  useOpus() {
    this.setFormat('opus');
  },

  resetCounters() {
    this.setData({
      headerCount: 0,
      frameCount: 0,
      lastHeaderSize: '0 B',
      lastFrameSize: '0 B',
      lastStopPath: '',
      lastError: '',
    });
    this.log('Counters reset');
  },

  async startRecording() {
    if (!this.recorder) {
      this.setError('RecorderManager is unavailable');
      return;
    }
    if (this.data.state === 'recording' || this.data.state === 'paused') {
      this.log('Start ignored: recording already active');
      return;
    }

    try {
      this.clearError();
      this.setData({
        state: 'starting',
        headerCount: 0,
        frameCount: 0,
        lastHeaderSize: '0 B',
        lastFrameSize: '0 B',
        lastStopPath: '',
      });
      this.log(`Start requested with format=${this.data.currentFormat}`);
      await this.recorder.start({
        sampleRate: 16000,
        numberOfChannels: 1,
        format: this.data.currentFormat,
      });
    } catch (error) {
      this.setError(String(error));
    }
  },

  async pauseRecording() {
    if (!this.recorder) {
      this.setError('RecorderManager is unavailable');
      return;
    }
    try {
      this.log('Pause requested');
      await this.recorder.pause();
    } catch (error) {
      this.setError(String(error));
    }
  },

  async resumeRecording() {
    if (!this.recorder) {
      this.setError('RecorderManager is unavailable');
      return;
    }
    try {
      this.log('Resume requested');
      await this.recorder.resume();
    } catch (error) {
      this.setError(String(error));
    }
  },

  async stopRecording() {
    if (!this.recorder) {
      this.setError('RecorderManager is unavailable');
      return;
    }
    try {
      this.log('Stop requested');
      await this.recorder.stop();
    } catch (error) {
      this.setError(String(error));
    }
  },

  stopRecordingSilently() {
    if (!this.recorder) {
      return;
    }
    if (this.data.state !== 'recording' && this.data.state !== 'paused') {
      return;
    }
    this.recorder.stop().catch(() => {});
  },
};
</script>

<page>
  <view class="container">
    <view class="page-title">Recorder Test</view>
    <view class="subtitle">Manual regression page for RecorderManager state transitions and pcm/opus events.</view>

    <view class="card">
      <text class="section-title">Summary</text>
      <text class="meta-line">Available: {{available}}</text>
      <text class="meta-line">Current Format: {{currentFormat}}</text>
      <text class="meta-line">State: {{state}}</text>
      <text class="meta-line">Header Count: {{headerCount}}</text>
      <text class="meta-line">Frame Count: {{frameCount}}</text>
      <text class="meta-line">Last Error: {{lastError || 'None'}}</text>
    </view>

    <view class="card">
      <text class="section-title">Live Status</text>
      <text class="meta-line">Last Header Size: {{lastHeaderSize}}</text>
      <text class="meta-line">Last Frame Size: {{lastFrameSize}}</text>
      <text class="meta-line">Last Stop Path: {{lastStopPath || 'N/A'}}</text>
    </view>

    <view class="card">
      <text class="section-title">Format</text>
      <view class="button-grid" role="navigation">
        <button class="btn" bindtap="usePCM">Use PCM</button>
        <button class="btn btn-secondary" bindtap="useOpus">Use Opus</button>
        <button class="btn btn-secondary" bindtap="resetCounters">Reset Counters</button>
      </view>
    </view>

    <view class="card">
      <text class="section-title">Core Controls</text>
      <view class="button-grid" role="navigation">
        <button class="btn" bindtap="startRecording">Start</button>
        <button class="btn btn-secondary" bindtap="pauseRecording">Pause</button>
        <button class="btn btn-secondary" bindtap="resumeRecording">Resume</button>
        <button class="btn btn-danger" bindtap="stopRecording">Stop</button>
      </view>
    </view>

    <view class="card log-card">
      <text class="section-title">Event Log</text>
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
    --recorder-page-background: var(--color-background);
    --recorder-surface-background: var(--color-surface);
    --recorder-surface-muted-background: var(--color-surface-highlight);
    --recorder-text-color: var(--color-text-primary);
    --recorder-muted-text-color: var(--color-text-secondary);
    --recorder-primary-background: var(--color-primary);
    --recorder-primary-text: #ffffff;
    --recorder-secondary-background: var(--recorder-surface-muted-background, #edf2f7);
    --recorder-secondary-text: var(--recorder-text-color);
    --recorder-danger-background: var(--border-color-danger, #ff3b30);
    display: flex;
    flex-direction: column;
    padding: 24px;
    gap: 16px;
    background-color: var(--recorder-page-background);
  }

  .page-title {
    font-size: 28px;
    font-weight: bold;
    color: var(--recorder-text-color);
  }

  .subtitle {
    font-size: 14px;
    color: var(--recorder-muted-text-color);
    margin-bottom: 4px;
  }

  .card {
    display: flex;
    flex-direction: column;
    gap: 8px;
    padding: var(--spacing-md, 16px);
    border-radius: var(--radius-md, 12px);
    background-color: var(--recorder-surface-background);
    border: var(--border-width-thin, 1px) solid var(--border-color-default, #e5e7eb);
  }

  .section-title {
    font-size: 18px;
    font-weight: bold;
    color: var(--recorder-text-color);
    margin-bottom: 4px;
  }

  .meta-line {
    font-size: 14px;
    color: var(--recorder-text-color);
    font-family: monospace;
  }

  .button-grid {
    display: flex;
    flex-direction: row;
    flex-wrap: wrap;
    gap: 12px;
  }

  .btn {
    min-width: 150px;
    font-size: 14px;
    font-weight: 600;
    padding: 12px 14px;
  }

  .log-card {
    min-height: 280px;
  }

  .log-list {
    display: flex;
    flex-direction: column;
    gap: 6px;
  }

  .log-item {
    padding: 8px 10px;
    border-radius: var(--radius-sm, 8px);
    background-color: var(--recorder-surface-muted-background, #f7fafc);
  }

  .log-text {
    font-size: 12px;
    color: var(--recorder-text-color);
    font-family: monospace;
  }
</style>
