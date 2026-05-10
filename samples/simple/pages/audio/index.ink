<script type="application/json" def>
{
  "navigationBarTitleText": "Audio Test"
}
</script>

<script setup>
import { AudioPlayer } from 'audio';

const ASSET_PATH = '../../assets/mixkit-arcade-retro-game-over-213.wav';
const LOG_LIMIT = 60;
const POLL_INTERVAL_MS = 250;

function formatNumber(value) {
  if (typeof value !== 'number' || !Number.isFinite(value)) {
    return '0.00';
  }
  return value.toFixed(2);
}

export default {
  data: {
    assetPath: ASSET_PATH,
    playerCreated: false,
    srcLoaded: false,
    playCount: 0,
    recreateCount: 0,
    lastError: '',
    actualSrc: '',
    paused: true,
    currentTime: '0.00',
    duration: '0.00',
    buffered: '0.00',
    loop: false,
    volume: '1.00',
    logs: ['Audio test page ready'],
  },

  onLoad() {
    this.player = null;
    this.pollTimer = setInterval(() => this.refreshPlayerState(false), POLL_INTERVAL_MS);
    this.repeatSequenceToken = 0;
    this.lastPausedValue = true;
    this.lastActiveSrc = '';
    this.lastCurrentTimeValue = 0;
    this.log('Page loaded');
  },

  onUnload() {
    if (this.pollTimer) {
      clearInterval(this.pollTimer);
      this.pollTimer = null;
    }
    this.repeatSequenceToken += 1;
    this.destroyPlayerInternal(false);
  },

  log(message) {
    const timestamp = new Date().toISOString().slice(11, 19);
    const nextLogs = [`${timestamp} ${message}`, ...(this.data.logs || [])].slice(0, LOG_LIMIT);
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

  snapshotState() {
    if (!this.player) {
      return {
        actualSrc: '',
        paused: true,
        currentTime: '0.00',
        duration: '0.00',
        buffered: '0.00',
        loop: false,
        volume: '1.00',
      };
    }

    return {
      actualSrc: this.player.src || '',
      paused: !!this.player.paused,
      currentTime: formatNumber(this.player.currentTime),
      duration: formatNumber(this.player.duration),
      buffered: formatNumber(this.player.buffered),
      loop: !!this.player.loop,
      volume: formatNumber(this.player.volume),
    };
  },

  refreshPlayerState(withLog = false) {
    const snapshot = this.snapshotState();
    this.setData(snapshot);

    const currentTimeValue = this.player ? Number(this.player.currentTime) || 0 : 0;
    if (withLog) {
      this.log(
        `State paused=${snapshot.paused} time=${snapshot.currentTime} duration=${snapshot.duration} loop=${snapshot.loop} volume=${snapshot.volume}`
      );
    } else if (this.player) {
      if (snapshot.actualSrc && snapshot.actualSrc !== this.lastActiveSrc) {
        this.lastActiveSrc = snapshot.actualSrc;
        this.log(`Actual src updated: ${snapshot.actualSrc}`);
      }
      if (snapshot.paused !== this.lastPausedValue) {
        this.lastPausedValue = snapshot.paused;
        this.log(`Paused changed to ${snapshot.paused}`);
      }
    } else {
      this.lastActiveSrc = '';
      this.lastPausedValue = true;
    }

    this.lastCurrentTimeValue = currentTimeValue;
  },

  ensurePlayer() {
    if (this.player) {
      return this.player;
    }
    return this.createPlayerInternal();
  },

  createPlayerInternal() {
    this.player = new AudioPlayer();
    this.lastPausedValue = !!this.player.paused;
    this.lastActiveSrc = this.player.src || '';
    this.lastCurrentTimeValue = Number(this.player.currentTime) || 0;
    this.setData({ playerCreated: true });
    this.clearError();
    this.log('Created AudioPlayer instance');
    this.refreshPlayerState(true);
    return this.player;
  },

  createPlayer() {
    if (this.player) {
      this.log('Create skipped: player already exists');
      return;
    }
    try {
      this.createPlayerInternal();
    } catch (error) {
      this.setError(String(error));
    }
  },

  destroyPlayerInternal(withLog = true) {
    if (!this.player) {
      if (withLog) {
        this.log('Destroy skipped: no active player');
      }
      this.setData({
        playerCreated: false,
        srcLoaded: false,
        actualSrc: '',
        paused: true,
        currentTime: '0.00',
        duration: '0.00',
        buffered: '0.00',
        loop: false,
        volume: '1.00',
      });
      return;
    }

    try {
      this.player.destroy();
      if (withLog) {
        this.log('Destroyed AudioPlayer instance');
      }
    } catch (error) {
      this.setError(String(error));
    }

    this.player = null;
    this.lastPausedValue = true;
    this.lastActiveSrc = '';
    this.lastCurrentTimeValue = 0;
    this.setData({
      playerCreated: false,
      srcLoaded: false,
      actualSrc: '',
      paused: true,
      currentTime: '0.00',
      duration: '0.00',
      buffered: '0.00',
      loop: false,
      volume: '1.00',
    });
  },

  destroyPlayer() {
    this.repeatSequenceToken += 1;
    this.destroyPlayerInternal(true);
  },

  loadSource() {
    try {
      const player = this.ensurePlayer();
      player.src = ASSET_PATH;
      this.setData({ srcLoaded: true });
      this.clearError();
      this.log(`Loaded source ${ASSET_PATH}`);
      this.refreshPlayerState(true);
    } catch (error) {
      this.setError(String(error));
    }
  },

  ensureSourceLoaded() {
    const player = this.ensurePlayer();
    if (!this.data.srcLoaded || !player.src) {
      player.src = ASSET_PATH;
      this.setData({ srcLoaded: true });
      this.log(`Auto-loaded source ${ASSET_PATH}`);
    }
    return player;
  },

  async playAudio() {
    try {
      const player = this.ensureSourceLoaded();
      player.play();
      this.setData({ playCount: this.data.playCount + 1 });
      this.clearError();
      this.log('Play requested');
      this.refreshPlayerState(true);
    } catch (error) {
      this.setError(String(error));
    }
  },

  pauseAudio() {
    if (!this.player) {
      this.log('Pause skipped: no active player');
      return;
    }
    try {
      this.player.pause();
      this.clearError();
      this.log('Pause requested');
      this.refreshPlayerState(true);
    } catch (error) {
      this.setError(String(error));
    }
  },

  stopAudio() {
    if (!this.player) {
      this.log('Stop skipped: no active player');
      return;
    }
    try {
      this.player.stop();
      this.clearError();
      this.log('Stop requested');
      this.refreshPlayerState(true);
    } catch (error) {
      this.setError(String(error));
    }
  },

  seekToStart() {
    this.seekTo(0);
  },

  seekToOneSecond() {
    this.seekTo(1);
  },

  seekTo(position) {
    if (!this.player) {
      this.log(`Seek to ${position}s skipped: no active player`);
      return;
    }
    try {
      this.player.seek(position);
      this.clearError();
      this.log(`Seek requested to ${position}s`);
      this.refreshPlayerState(true);
    } catch (error) {
      this.setError(String(error));
    }
  },

  toggleLoop() {
    try {
      const player = this.ensureSourceLoaded();
      player.loop = !player.loop;
      this.clearError();
      this.log(`Loop set to ${player.loop}`);
      this.refreshPlayerState(true);
    } catch (error) {
      this.setError(String(error));
    }
  },

  setVolume0() {
    this.setVolume(0);
  },

  setVolumeHalf() {
    this.setVolume(0.5);
  },

  setVolumeFull() {
    this.setVolume(1);
  },

  setVolume(value) {
    try {
      const player = this.ensureSourceLoaded();
      player.volume = value;
      this.clearError();
      this.log(`Volume set to ${formatNumber(value)}`);
      this.refreshPlayerState(true);
    } catch (error) {
      this.setError(String(error));
    }
  },

  sleep(ms) {
    return new Promise((resolve) => setTimeout(resolve, ms));
  },

  async waitFor(check, timeoutMs, description) {
    const startedAt = Date.now();
    while (Date.now() - startedAt < timeoutMs) {
      if (check()) {
        return true;
      }
      await this.sleep(100);
    }
    this.log(`Timeout while waiting for ${description}`);
    return false;
  },

  async playThreeTimes() {
    const token = ++this.repeatSequenceToken;
    try {
      const player = this.ensureSourceLoaded();
      this.clearError();
      this.log('Starting Play x3 sequence');

      for (let index = 0; index < 3; index += 1) {
        if (token !== this.repeatSequenceToken) {
          this.log('Play x3 sequence cancelled');
          return;
        }

        player.stop();
        player.seek(0);
        this.log(`Play x3 attempt ${index + 1}/3`);
        player.play();
        this.setData({ playCount: this.data.playCount + 1 });
        this.refreshPlayerState(true);

        const started = await this.waitFor(() => {
          if (!this.player || token !== this.repeatSequenceToken) {
            return true;
          }
          return !this.player.paused || (Number(this.player.currentTime) || 0) > 0.05;
        }, 3000, `playback start ${index + 1}`);
        if (!started || token !== this.repeatSequenceToken || !this.player) {
          return;
        }

        await this.waitFor(() => {
          if (!this.player || token !== this.repeatSequenceToken) {
            return true;
          }
          const currentTime = Number(this.player.currentTime) || 0;
          const duration = Number(this.player.duration) || 0;
          return this.player.paused && (
            currentTime < 0.1 ||
            (duration > 0 && currentTime >= Math.max(0, duration - 0.05))
          );
        }, 10000, `playback completion ${index + 1}`);
      }

      this.log('Completed Play x3 sequence');
      this.refreshPlayerState(true);
    } catch (error) {
      this.setError(String(error));
    }
  },

  destroyAndRecreate() {
    this.repeatSequenceToken += 1;
    const hadPlayer = !!this.player;
    this.destroyPlayerInternal(hadPlayer);
    try {
      this.createPlayerInternal();
      this.setData({ recreateCount: this.data.recreateCount + 1 });
      this.log('Destroyed and recreated player');
    } catch (error) {
      this.setError(String(error));
    }
  },

  newInstanceAndPlay() {
    this.repeatSequenceToken += 1;
    this.destroyPlayerInternal(false);
    try {
      const player = this.createPlayerInternal();
      player.src = ASSET_PATH;
      player.play();
      this.setData({
        srcLoaded: true,
        recreateCount: this.data.recreateCount + 1,
        playCount: this.data.playCount + 1,
      });
      this.clearError();
      this.log('Created fresh instance and requested play');
      this.refreshPlayerState(true);
    } catch (error) {
      this.setError(String(error));
    }
  },
};
</script>

<page>
  <view class="container">
    <view class="page-title">Audio Test</view>
    <view class="subtitle">Manual regression page for AudioPlayer playback and repeat scenarios.</view>

    <view class="card">
      <text class="section-title">Summary</text>
      <text class="meta-line">Asset: {{assetPath}}</text>
      <text class="meta-line">Player Created: {{playerCreated}}</text>
      <text class="meta-line">Source Loaded: {{srcLoaded}}</text>
      <text class="meta-line">Play Count: {{playCount}}</text>
      <text class="meta-line">Recreate Count: {{recreateCount}}</text>
      <text class="meta-line">Last Error: {{lastError || 'None'}}</text>
    </view>

    <view class="card">
      <text class="section-title">Live Status</text>
      <text class="meta-line">Actual Src: {{actualSrc || 'Not loaded yet'}}</text>
      <text class="meta-line">Paused: {{paused}}</text>
      <text class="meta-line">Current Time: {{currentTime}}</text>
      <text class="meta-line">Duration: {{duration}}</text>
      <text class="meta-line">Buffered: {{buffered}}</text>
      <text class="meta-line">Loop: {{loop}}</text>
      <text class="meta-line">Volume: {{volume}}</text>
    </view>

    <view class="card">
      <text class="section-title">Core Controls</text>
      <view class="button-grid">
        <button class="btn" bindtap="createPlayer">Create Player</button>
        <button class="btn" bindtap="loadSource">Load Source</button>
        <button class="btn" bindtap="playAudio">Play</button>
        <button class="btn" bindtap="pauseAudio">Pause</button>
        <button class="btn" bindtap="stopAudio">Stop</button>
        <button class="btn" bindtap="seekToStart">Seek 0s</button>
        <button class="btn" bindtap="seekToOneSecond">Seek 1s</button>
        <button class="btn btn-danger" bindtap="destroyPlayer">Destroy</button>
      </view>
    </view>

    <view class="card">
      <text class="section-title">Regression Actions</text>
      <view class="button-grid">
        <button class="btn btn-secondary" bindtap="playThreeTimes">Play x3</button>
        <button class="btn btn-secondary" bindtap="destroyAndRecreate">Destroy And Recreate</button>
        <button class="btn btn-secondary" bindtap="newInstanceAndPlay">New Instance And Play</button>
        <button class="btn btn-secondary" bindtap="toggleLoop">Toggle Loop</button>
        <button class="btn btn-secondary" bindtap="setVolume0">Volume 0</button>
        <button class="btn btn-secondary" bindtap="setVolumeHalf">Volume 0.5</button>
        <button class="btn btn-secondary" bindtap="setVolumeFull">Volume 1</button>
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
    --audio-page-background: var(--color-background);
    --audio-surface-background: var(--color-surface);
    --audio-surface-muted-background: var(--color-surface-highlight);
    --audio-text-color: var(--color-text-primary);
    --audio-muted-text-color: var(--color-text-secondary);
    --audio-primary-background: var(--color-primary);
    --audio-primary-text: #ffffff;
    --audio-secondary-background: var(--audio-surface-muted-background, #edf2f7);
    --audio-secondary-text: var(--audio-text-color);
    --audio-danger-background: var(--border-color-danger, #ff3b30);
    display: flex;
    flex-direction: column;
    padding: 24px;
    gap: 16px;
    background-color: var(--audio-page-background);
  }

  .page-title {
    font-size: 28px;
    font-weight: bold;
    color: var(--audio-text-color);
  }

  .subtitle {
    font-size: 14px;
    color: var(--audio-muted-text-color);
    margin-bottom: 4px;
  }

  .card {
    display: flex;
    flex-direction: column;
    gap: 8px;
    padding: 16px;
    border-radius: 12px;
    background-color: var(--audio-surface-background);
    border: var(--border-width-thin, 1px) solid var(--border-color-default, #e5e7eb);
  }

  .section-title {
    font-size: 18px;
    font-weight: bold;
    color: var(--audio-text-color);
    margin-bottom: 4px;
  }

  .meta-line {
    font-size: 14px;
    color: var(--audio-text-color);
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
    background-color: var(--audio-primary-background);
    color: var(--audio-primary-text);
    border-radius: 10px;
    font-size: 14px;
    font-weight: 600;
    padding: 12px 14px;
  }

  .btn-secondary {
    background-color: var(--audio-secondary-background);
    color: var(--audio-secondary-text);
  }

  .btn-danger {
    background-color: var(--audio-danger-background);
    color: #ffffff;
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
    border-radius: 8px;
    background-color: var(--audio-surface-muted-background, #f7fafc);
  }

  .log-text {
    font-size: 12px;
    color: var(--audio-text-color);
    font-family: monospace;
  }
</style>
