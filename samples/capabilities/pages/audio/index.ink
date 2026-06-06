<script type="application/json" def>
{
  "navigationBarTitleText": "Audio Test"
}
</script>

<script setup>
import { AudioPlayer } from 'audio';
import importedAudioBlob, {
  mimeType as IMPORTED_ASSET_MIME_TYPE,
  path as IMPORTED_ASSET_PATH,
} from '../../assets/mixkit-arcade-retro-game-over-213.wav';

const ASSET_PATH = IMPORTED_ASSET_PATH;
const LOG_LIMIT = 60;
const POLL_INTERVAL_MS = 500;
const AUDIO_EVENT_NAMES = [
  'canplay',
  'play',
  'pause',
  'stop',
  'ended',
  'timeUpdate',
  'error',
  'waiting',
  'seeking',
  'seeked',
];
const TIME_UPDATE_LOG_EVERY = 4;
const TIME_UPDATE_SUMMARY_EVERY = 4;

function createEmptyEventState() {
  return AUDIO_EVENT_NAMES.reduce((state, name) => {
    state[name] = {
      count: 0,
      last: 'Never',
    };
    return state;
  }, {});
}

function buildEventSummaryLines(eventState) {
  return AUDIO_EVENT_NAMES.map((name) => {
    const summary = eventState[name];
    return `${name}: count=${summary.count} last=${summary.last}`;
  });
}

function formatNumber(value) {
  if (typeof value !== 'number' || !Number.isFinite(value)) {
    return '0.00';
  }
  return value.toFixed(2);
}

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

async function playSound(src) {
  const player = new AudioPlayer();
  let settled = false;

  try {
    player.src = src;
    return await new Promise((resolve, reject) => {
      const cleanup = () => {
        player.offEnded();
        player.offError();
      };

      const handleEnded = () => {
        if (settled) {
          return;
        }
        settled = true;
        cleanup();
        resolve(true);
      };

      const handleError = (error) => {
        if (settled) {
          return;
        }
        settled = true;
        cleanup();
        reject(error || new Error('Audio playback failed'));
      };

      player.onEnded(handleEnded);
      player.onError(handleError);
      player.play();
    });
  } finally {
    if (!settled) {
      player.offEnded();
      player.offError();
    }
    player.destroy();
  }
}

export default {
  data: {
    assetPath: ASSET_PATH,
    assetImportType: IMPORTED_ASSET_MIME_TYPE || 'unknown',
    assetImportSize: '0 B',
    playerCreated: false,
    srcLoaded: false,
    playCount: 0,
    recreateCount: 0,
    autoDestroyCount: 0,
    lastError: '',
    actualSrc: '',
    paused: true,
    currentTime: '0.00',
    duration: '0.00',
    buffered: '0.00',
    loop: false,
    volume: '1.00',
    logs: ['Audio test page ready'],
    eventSummaryLines: buildEventSummaryLines(createEmptyEventState()),
    callbackSmokeRuns: 0,
    callbackSmokePasses: 0,
    callbackSmokeLastResult: 'Not run',
  },

  onLoad() {
    this.player = null;
    this.pollTimer = setInterval(() => this.refreshPlayerState(false), POLL_INTERVAL_MS);
    this.repeatSequenceToken = 0;
    this.eventState = createEmptyEventState();
    this.playerEventHandlers = null;
    this.lastPausedValue = true;
    this.lastActiveSrc = '';
    this.lastCurrentTimeValue = 0;
    this.setData({
      assetImportSize: formatBytes(importedAudioBlob.size || 0),
    });
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

  applyDataPatch(patch) {
    const changed = {};
    let hasChanges = false;
    Object.keys(patch).forEach((key) => {
      if (this.data[key] !== patch[key]) {
        changed[key] = patch[key];
        hasChanges = true;
      }
    });
    if (hasChanges) {
      this.setData(changed);
    }
  },

  setError(message) {
    this.applyDataPatch({ lastError: message });
    this.log(`Error: ${message}`);
  },

  clearError() {
    if (this.data.lastError) {
      this.applyDataPatch({ lastError: '' });
    }
  },

  syncEventSummary() {
    const nextLines = buildEventSummaryLines(this.eventState);
    const currentLines = this.data.eventSummaryLines || [];
    if (currentLines.join('\n') !== nextLines.join('\n')) {
      this.setData({
        eventSummaryLines: nextLines,
      });
    }
  },

  resetEventTracking(withLog = true) {
    this.eventState = createEmptyEventState();
    const summaryEvery = options.summaryEvery || 1;
    if (summary.count === 1 || summary.count % summaryEvery === 0) {
      this.syncEventSummary();
    }
    if (withLog) {
      this.log('Reset audio callback counters');
    }
  },

  recordAudioEvent(name, detail = '', options = {}) {
    const summary = this.eventState[name];
    if (!summary) {
      return;
    }

    summary.count += 1;
    const stamp = new Date().toISOString().slice(11, 19);
    summary.last = detail ? `${stamp} ${detail}` : stamp;
    this.syncEventSummary();

    if (options.skipLog) {
      return;
    }

    const every = options.logEvery || 1;
    if (summary.count === 1 || summary.count % every === 0) {
      this.log(`Event ${name}#${summary.count}${detail ? ` ${detail}` : ''}`);
    }
  },

  bindPlayerEvents(player) {
    if (!player || this.playerEventHandlers) {
      return;
    }

    const handlers = {
      canplay: () => {
        this.clearError();
        this.recordAudioEvent('canplay');
      },
      play: () => this.recordAudioEvent('play'),
      pause: () => this.recordAudioEvent('pause'),
      stop: () => this.recordAudioEvent('stop'),
      ended: () => this.recordAudioEvent('ended'),
      timeUpdate: () => {
        const currentTime = formatNumber(player.currentTime);
        this.recordAudioEvent('timeUpdate', `t=${currentTime}`, {
          logEvery: TIME_UPDATE_LOG_EVERY,
          summaryEvery: TIME_UPDATE_SUMMARY_EVERY,
        });
      },
      error: (error) => {
        const message = error && error.message ? error.message : String(error || 'Unknown error');
        this.applyDataPatch({ lastError: message });
        this.recordAudioEvent('error', message);
      },
      waiting: () => this.recordAudioEvent('waiting'),
      seeking: () => this.recordAudioEvent('seeking'),
      seeked: () => {
        const currentTime = formatNumber(player.currentTime);
        this.recordAudioEvent('seeked', `t=${currentTime}`);
      },
    };

    player.onCanplay(handlers.canplay);
    player.onPlay(handlers.play);
    player.onPause(handlers.pause);
    player.onStop(handlers.stop);
    player.onEnded(handlers.ended);
    player.onTimeUpdate(handlers.timeUpdate);
    player.onError(handlers.error);
    player.onWaiting(handlers.waiting);
    player.onSeeking(handlers.seeking);
    player.onSeeked(handlers.seeked);

    this.playerEventHandlers = handlers;
    this.log('Bound AudioPlayer event listeners');
  },

  unbindPlayerEvents(player) {
    if (!player || !this.playerEventHandlers) {
      return;
    }

    const handlers = this.playerEventHandlers;
    player.offCanplay(handlers.canplay);
    player.offPlay(handlers.play);
    player.offPause(handlers.pause);
    player.offStop(handlers.stop);
    player.offEnded(handlers.ended);
    player.offTimeUpdate(handlers.timeUpdate);
    player.offError(handlers.error);
    player.offWaiting(handlers.waiting);
    player.offSeeking(handlers.seeking);
    player.offSeeked(handlers.seeked);
    this.playerEventHandlers = null;
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
    this.applyDataPatch(snapshot);

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
    this.bindPlayerEvents(this.player);
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
      this.unbindPlayerEvents(this.player);
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

  async loadImportedBuffer() {
    try {
      const player = this.ensurePlayer();
      const bytes = await importedAudioBlob.arrayBuffer();
      player.setBuffer(bytes, IMPORTED_ASSET_MIME_TYPE || 'audio/wav');
      this.setData({ srcLoaded: true });
      this.clearError();
      this.log(`Loaded imported buffer (${IMPORTED_ASSET_MIME_TYPE || 'unknown'})`);
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

  async waitForEventCount(eventName, count, timeoutMs) {
    return this.waitFor(() => {
      const summary = this.eventState[eventName];
      return !!summary && summary.count >= count;
    }, timeoutMs, `${eventName} callback`);
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

  async playThenAutoDestroy() {
    this.repeatSequenceToken += 1;
    this.destroyPlayerInternal(false);
    this.clearError();
    this.log('Started standalone auto-destroy playback');

    try {
      const completed = await playSound(ASSET_PATH);
      if (!completed) {
        this.setError('Auto-destroy playback did not complete before timeout');
        return;
      }

      this.setData({
        playCount: this.data.playCount + 1,
        autoDestroyCount: this.data.autoDestroyCount + 1,
      });
      this.clearError();
      this.log('Standalone playback completed and destroyed automatically');
      this.refreshPlayerState(true);
    } catch (error) {
      this.setError(String(error));
    }
  },

  resetEventCounters() {
    this.resetEventTracking(true);
  },

  async runCallbackSmokeTest() {
    const token = ++this.repeatSequenceToken;
    this.resetEventTracking(false);
    this.setData({
      callbackSmokeRuns: this.data.callbackSmokeRuns + 1,
      callbackSmokeLastResult: 'Running',
    });

    try {
      const player = this.ensurePlayer();
      player.src = ASSET_PATH;
      this.setData({ srcLoaded: true });
      this.clearError();
      this.log('Started callback smoke test');

      const canplay = await this.waitForEventCount('canplay', 1, 3000);
      if (!canplay || token !== this.repeatSequenceToken) {
        throw new Error('onCanplay not observed');
      }

      player.play();
      const play = await this.waitForEventCount('play', 1, 3000);
      if (!play || token !== this.repeatSequenceToken) {
        throw new Error('onPlay not observed');
      }

      player.pause();
      const pause = await this.waitForEventCount('pause', 1, 3000);
      if (!pause || token !== this.repeatSequenceToken) {
        throw new Error('onPause not observed');
      }

      player.seek(0);
      const seeking = await this.waitForEventCount('seeking', 1, 3000);
      if (!seeking || token !== this.repeatSequenceToken) {
        throw new Error('onSeeking not observed');
      }

      const seeked = await this.waitForEventCount('seeked', 1, 3000);
      if (!seeked || token !== this.repeatSequenceToken) {
        throw new Error('onSeeked not observed');
      }

      player.stop();
      const stop = await this.waitForEventCount('stop', 1, 3000);
      if (!stop || token !== this.repeatSequenceToken) {
        throw new Error('onStop not observed');
      }

      this.setData({
        callbackSmokePasses: this.data.callbackSmokePasses + 1,
        callbackSmokeLastResult: 'Passed',
      });
      this.log('Callback smoke test passed');
      this.refreshPlayerState(true);
    } catch (error) {
      const message = String(error);
      this.setData({ callbackSmokeLastResult: `Failed: ${message}` });
      this.setError(message);
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
      <text class="meta-line">Imported Blob: {{assetImportType}} / {{assetImportSize}}</text>
      <text class="meta-line">Player Created: {{playerCreated}}</text>
      <text class="meta-line">Source Loaded: {{srcLoaded}}</text>
      <text class="meta-line">Play Count: {{playCount}}</text>
      <text class="meta-line">Recreate Count: {{recreateCount}}</text>
      <text class="meta-line">Auto Destroy Count: {{autoDestroyCount}}</text>
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

    <card class="action-card">
      <text class="section-title">Core Controls</text>
      <view class="button-grid" role="navigation">
        <button bindtap="createPlayer">Create Player</button>
        <button bindtap="loadSource">Load Source</button>
        <button bindtap="loadImportedBuffer">Load Imported Buffer</button>
        <button bindtap="playAudio">Play</button>
        <button bindtap="pauseAudio">Pause</button>
        <button bindtap="stopAudio">Stop</button>
        <button bindtap="seekToStart">Seek 0s</button>
        <button bindtap="seekToOneSecond">Seek 1s</button>
        <button bindtap="destroyPlayer">Destroy</button>
      </view>
    </card>

    <card class="action-card">
      <text class="section-title">Regression Actions</text>
      <view class="button-grid" role="navigation">
        <button bindtap="playThreeTimes">Play x3</button>
        <button bindtap="destroyAndRecreate">Destroy And Recreate</button>
        <button bindtap="newInstanceAndPlay">New Instance And Play</button>
        <button bindtap="playThenAutoDestroy">Play Then Auto Destroy</button>
        <button bindtap="toggleLoop">Toggle Loop</button>
        <button bindtap="setVolume0">Volume 0</button>
        <button bindtap="setVolumeHalf">Volume 0.5</button>
        <button bindtap="setVolumeFull">Volume 1</button>
      </view>
    </card>

    <card class="action-card">
      <text class="section-title">Callback Checks</text>
      <text class="meta-line">Smoke Runs: {{callbackSmokeRuns}}</text>
      <text class="meta-line">Smoke Passes: {{callbackSmokePasses}}</text>
      <text class="meta-line">Last Smoke Result: {{callbackSmokeLastResult}}</text>
      <view class="button-grid" role="navigation">
        <button bindtap="runCallbackSmokeTest">Run Callback Smoke Test</button>
        <button bindtap="resetEventCounters">Reset Event Counters</button>
      </view>
      <view class="log-list">
        <view class="log-item" ink:for="{{eventSummaryLines}}">
          <text class="log-text">{{item}}</text>
        </view>
      </view>
    </card>

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
    padding: var(--spacing-md, 16px);
    border-radius: var(--radius-md, 12px);
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

  .action-card {
    display: flex;
    flex-direction: column;
    gap: 8px;
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
    background-color: var(--audio-surface-muted-background, #f7fafc);
  }

  .log-text {
    font-size: 12px;
    color: var(--audio-text-color);
    font-family: monospace;
  }
</style>
