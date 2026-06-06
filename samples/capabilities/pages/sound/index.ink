<script type="application/json" def>
{
  "navigationBarTitleText": "Sound Test"
}
</script>

<script setup>
import { Sound } from 'audio';

const ASSET_PATH = '../../assets/mixkit-arcade-retro-game-over-213.wav';
const MISSING_ASSET_PATH = '../../assets/does-not-exist.wav';
const REMOTE_ASSET_PATH = 'https://example.com/test.wav';
const LOG_LIMIT = 20;

function clampVolume(value) {
  if (typeof value !== 'number' || !Number.isFinite(value)) {
    return 1;
  }
  return Math.max(0, Math.min(1, value));
}

function formatVolume(value) {
  return clampVolume(value).toFixed(2);
}

function nowLabel() {
  return new Date().toISOString().slice(11, 19);
}

export default {
  data: {
    soundReady: false,
    status: 'idle',
    sourcePath: '',
    volume: '1.00',
    lastError: '',
    logs: ['Sound test page ready'],
  },

  onLoad() {
    this.sound = null;
  },

  onUnload() {
    this.destroySoundSilently();
  },

  log(message) {
    const nextLogs = [`${nowLabel()} ${message}`, ...(this.data.logs || [])].slice(0, LOG_LIMIT);
    this.setData({ logs: nextLogs });
  },

  setError(message) {
    this.setData({
      lastError: message,
      status: 'error',
    });
    this.log(`Error: ${message}`);
  },

  clearError() {
    if (this.data.lastError) {
      this.setData({ lastError: '' });
    }
  },

  updateReadyState(sourcePath, status, volume) {
    this.setData({
      soundReady: true,
      sourcePath,
      status,
      volume: formatVolume(volume),
    });
  },

  updateEmptyState(status = 'idle') {
    this.setData({
      soundReady: false,
      sourcePath: '',
      status,
      volume: '1.00',
    });
  },

  destroySoundSilently() {
    if (!this.sound) {
      this.updateEmptyState('idle');
      return;
    }

    this.sound.destroy();
    this.sound = null;
    this.updateEmptyState('destroyed');
  },

  replaceSound(sourcePath) {
    this.destroySoundSilently();

    const sound = new Sound(sourcePath);
    this.sound = sound;
    this.clearError();
    this.updateReadyState(sourcePath, 'ready', sound.volume);
    this.log(`Created Sound from ${sourcePath}`);
  },

  createLocalSound() {
    try {
      this.replaceSound(ASSET_PATH);
    } catch (error) {
      this.sound = null;
      this.updateEmptyState('error');
      this.setError(String(error));
    }
  },

  createMissingSound() {
    try {
      this.replaceSound(MISSING_ASSET_PATH);
    } catch (error) {
      this.sound = null;
      this.updateEmptyState('error');
      this.setError(String(error));
    }
  },

  createRemoteSound() {
    try {
      this.replaceSound(REMOTE_ASSET_PATH);
    } catch (error) {
      this.sound = null;
      this.updateEmptyState('error');
      this.setError(String(error));
    }
  },

  requireSound(action) {
    if (this.sound) {
      return true;
    }
    this.log(`${action} skipped: no active Sound`);
    return false;
  },

  playSound() {
    if (!this.requireSound('Play')) {
      return;
    }

    try {
      this.sound.play();
      this.clearError();
      this.setData({
        status: 'playing',
        volume: formatVolume(this.sound.volume),
      });
      this.log('Play requested');
    } catch (error) {
      this.setError(String(error));
    }
  },

  replaySound() {
    if (!this.requireSound('Replay')) {
      return;
    }

    try {
      this.sound.play();
      this.clearError();
      this.setData({
        status: 'replaying',
        volume: formatVolume(this.sound.volume),
      });
      this.log('Replay requested');
    } catch (error) {
      this.setError(String(error));
    }
  },

  stopSound() {
    if (!this.requireSound('Stop')) {
      return;
    }

    try {
      this.sound.stop();
      this.clearError();
      this.setData({
        status: 'stopped',
        volume: formatVolume(this.sound.volume),
      });
      this.log('Stop requested');
    } catch (error) {
      this.setError(String(error));
    }
  },

  destroySound() {
    if (!this.requireSound('Destroy')) {
      return;
    }

    try {
      this.sound.destroy();
      this.sound = null;
      this.clearError();
      this.updateEmptyState('destroyed');
      this.log('Destroyed Sound instance');
    } catch (error) {
      this.setError(String(error));
    }
  },

  adjustVolume(delta) {
    if (!this.requireSound('Volume')) {
      return;
    }

    try {
      const nextVolume = clampVolume(this.sound.volume + delta);
      this.sound.volume = nextVolume;
      this.clearError();
      this.setData({
        volume: formatVolume(this.sound.volume),
        status: 'ready',
      });
      this.log(`Volume set to ${formatVolume(this.sound.volume)}`);
    } catch (error) {
      this.setError(String(error));
    }
  },

  volumeDown() {
    this.adjustVolume(-0.1);
  },

  volumeUp() {
    this.adjustVolume(0.1);
  },
};
</script>

<page>
  <view class="container">
    <view class="page-title">Sound API</view>
    <text class="page-description">
      Test the local-file-only Sound wrapper built on top of AudioPlayer.
    </text>

    <view class="card section">
      <view class="title">Create Sound</view>
      <text class="hint">Valid asset: {{soundReady ? sourcePath : '../../assets/mixkit-arcade-retro-game-over-213.wav'}}</text>
      <view class="btn-row" role="navigation">
        <button class="btn btn-primary" bindtap="createLocalSound">Create Local</button>
        <button class="btn btn-secondary" bindtap="createMissingSound">Create Missing</button>
      </view>
      <view class="btn-row" role="navigation">
        <button class="btn btn-danger" bindtap="createRemoteSound">Create Remote</button>
      </view>
    </view>

    <view class="card section">
      <view class="title">Controls</view>
      <view class="btn-row" role="navigation">
        <button class="btn btn-primary" bindtap="playSound">Play</button>
        <button class="btn btn-secondary" bindtap="replaySound">Replay</button>
      </view>
      <view class="btn-row" role="navigation">
        <button class="btn btn-secondary" bindtap="stopSound">Stop</button>
        <button class="btn btn-danger" bindtap="destroySound">Destroy</button>
      </view>
      <view class="btn-row" role="navigation">
        <button class="btn btn-secondary" bindtap="volumeDown">Volume -</button>
        <button class="btn btn-secondary" bindtap="volumeUp">Volume +</button>
      </view>
    </view>

    <view class="card section">
      <view class="title">State</view>
      <text class="state-line">Ready: {{soundReady}}</text>
      <text class="state-line">Status: {{status}}</text>
      <text class="state-line">Source: {{sourcePath || 'None'}}</text>
      <text class="state-line">Volume: {{volume}}</text>
      <text class="state-line error-text" ink:if="{{lastError}}">Last Error: {{lastError}}</text>
    </view>

    <view class="card section">
      <view class="title">Operation Log</view>
      <view ink:if="{{logs.length}}">
        <view class="log-item" ink:for="{{logs}}" ink:key="*this">
          <text class="log-message">{{item}}</text>
        </view>
      </view>
      <text class="hint" ink:else>No operations yet.</text>
    </view>
  </view>
</page>

<style>
  .container {
    display: flex;
    flex-direction: column;
    padding: var(--theme-padding, 20px);
    gap: 16px;
  }

  .page-title {
    font-size: 28px;
    font-weight: 600;
    color: #f5f5f5;
  }

  .page-description {
    font-size: 14px;
    line-height: 20px;
    color: rgba(255, 255, 255, 0.72);
  }

  .card {
    display: flex;
    flex-direction: column;
    gap: 12px;
    padding: var(--spacing-md, 16px);
    border-radius: 16px;
    background: rgba(255, 255, 255, 0.06);
  }

  .section {
    margin-bottom: 4px;
  }

  .title {
    font-size: 18px;
    font-weight: 600;
    color: #ffffff;
  }

  .hint {
    font-size: 13px;
    line-height: 18px;
    color: rgba(255, 255, 255, 0.64);
  }

  .btn-row {
    display: flex;
    flex-direction: row;
    gap: 12px;
  }

  .btn {
    flex: 1;
    min-height: 44px;
  }

  .state-line {
    font-size: 14px;
    line-height: 20px;
    color: rgba(255, 255, 255, 0.88);
  }

  .error-text {
    color: #ff8e8e;
  }

  .log-item {
    padding: 10px 0;
    border-bottom: 1px solid rgba(255, 255, 255, 0.08);
  }

  .log-message {
    font-size: 13px;
    line-height: 18px;
    color: rgba(255, 255, 255, 0.78);
  }
</style>
