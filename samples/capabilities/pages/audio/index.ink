<script type="application/json" def>
{
  "navigationBarTitleText": "Audio Retreat"
}
</script>

<script setup>
import { AudioPlayer, Sound } from 'audio';

const AMBIENT_SRC = '/assets/meditation-white-noise.wav';
const SHORT_CUE_SRC = '/assets/meditation-cue-short.wav';
const TRANSCRIPT_LIMIT = 12;

function nowLabel() {
  return new Date().toISOString().slice(11, 19);
}

function formatTime(seconds) {
  if (typeof seconds !== 'number' || !Number.isFinite(seconds) || seconds < 0) {
    return '00:00';
  }
  const wholeSeconds = Math.floor(seconds);
  const minutes = Math.floor(wholeSeconds / 60);
  const remainSeconds = wholeSeconds % 60;
  return `${String(minutes).padStart(2, '0')}:${String(remainSeconds).padStart(2, '0')}`;
}

function safeMessage(error) {
  if (!error) {
    return 'Unknown error';
  }
  if (typeof error === 'string') {
    return error;
  }
  if (error && error.message) {
    return error.message;
  }
  return String(error);
}

function presentationForState(state) {
  switch (state) {
    case 'starting':
      return {
        statusLabel: 'Preparing ambience',
        summaryLabel: 'Short cue triggered and the white-noise bed is starting.',
        primaryActionLabel: 'Pause',
      };
    case 'playing':
      return {
        statusLabel: 'Playing',
        summaryLabel: 'White-noise playback is active for a calm breathing session.',
        primaryActionLabel: 'Pause',
      };
    case 'paused':
      return {
        statusLabel: 'Paused',
        summaryLabel: 'Session is paused. Resume when you are ready.',
        primaryActionLabel: 'Resume',
      };
    case 'restarting':
      return {
        statusLabel: 'Restarting',
        summaryLabel: 'Cue is replaying and the white-noise bed is returning to the beginning.',
        primaryActionLabel: 'Pause',
      };
    case 'completed':
      return {
        statusLabel: 'Session complete',
        summaryLabel: 'Completion cue played and the white-noise bed has been reset.',
        primaryActionLabel: 'Start Session',
      };
    case 'error':
      return {
        statusLabel: 'Needs attention',
        summaryLabel: 'Open diagnostics to inspect the most recent playback failure.',
        primaryActionLabel: 'Try Again',
      };
    default:
      return {
        statusLabel: 'Ready',
        summaryLabel: 'Bundled white noise and short cue are prepared for a calm start.',
        primaryActionLabel: 'Start Session',
      };
  }
}

export default {
  data: {
    title: 'White Noise Reset',
    subtitle: 'A bundled white-noise bed for breathing, focus, and loop regression checks.',
    sessionState: 'idle',
    statusLabel: 'Ready',
    summaryLabel: 'Bundled ambience and short cue are prepared for a calm start.',
    primaryActionLabel: 'Start Session',
    ambientReady: false,
    cueReady: false,
    loopEnabled: true,
    currentTimeLabel: '00:00',
    durationLabel: '--:--',
    sourceBadge: 'Package-root white noise',
    cueBadge: 'Cue loading',
    lastCueTrigger: 'Never',
    diagnosticsOpen: false,
    ambientSource: AMBIENT_SRC,
    cueSource: SHORT_CUE_SRC,
    lastError: '',
    transcript: ['Audio retreat page ready'],
  },

  onLoad() {
    this.ambientPlayer = null;
    this.cueSound = null;
    this.pendingStopState = '';
    this.initAmbientPlayer();
    this.prepareCueSound();
    this.refreshSessionPresentation();
  },

  onUnload() {
    this.destroyAmbientPlayer();
    this.destroyCueSound();
  },

  log(message) {
    const nextTranscript = [`${nowLabel()} ${message}`, ...(this.data.transcript || [])].slice(
      0,
      TRANSCRIPT_LIMIT
    );
    this.setData({ transcript: nextTranscript });
  },

  refreshSessionPresentation() {
    const presentation = presentationForState(this.data.sessionState);
    this.setData(presentation);
  },

  setSessionState(nextState) {
    this.setData({ sessionState: nextState });
    this.refreshSessionPresentation();
  },

  setError(message) {
    this.setData({ lastError: message });
    this.setSessionState('error');
    this.log(`Error: ${message}`);
  },

  clearError() {
    if (this.data.lastError) {
      this.setData({ lastError: '' });
    }
  },

  updateCueBadge() {
    this.setData({
      cueBadge: this.data.cueReady ? 'Cue ready' : 'Cue unavailable',
    });
  },

  updateDurationAndTime() {
    if (!this.ambientPlayer) {
      this.setData({
        currentTimeLabel: '00:00',
        durationLabel: '--:--',
      });
      return;
    }

    this.setData({
      currentTimeLabel: formatTime(this.ambientPlayer.currentTime),
      durationLabel:
        typeof this.ambientPlayer.duration === 'number' && this.ambientPlayer.duration > 0
          ? formatTime(this.ambientPlayer.duration)
          : '--:--',
    });
  },

  bindAmbientEvents(player) {
    player.onCanplay(() => {
      this.setData({ ambientReady: true });
      this.updateDurationAndTime();
      this.log('Bundled white-noise track is ready');
    });

    player.onPlay(() => {
      this.clearError();
      if (this.data.sessionState === 'starting' || this.data.sessionState === 'restarting') {
        this.setSessionState('playing');
      } else if (this.data.sessionState !== 'playing') {
        this.setSessionState('playing');
      } else {
        this.refreshSessionPresentation();
      }
      this.updateDurationAndTime();
      this.log('White-noise loop is playing');
    });

    player.onPause(() => {
      if (this.data.sessionState !== 'completed') {
        this.setSessionState('paused');
      }
      this.updateDurationAndTime();
      this.log('White-noise loop paused');
    });

    player.onStop(() => {
      const nextState = this.pendingStopState || 'idle';
      this.pendingStopState = '';
      this.setSessionState(nextState);
      this.updateDurationAndTime();
      if (nextState === 'completed') {
        this.log('White-noise loop stopped for session completion');
      } else if (nextState === 'restarting') {
        this.log('White-noise loop rewound for restart');
      } else {
        this.log('White-noise loop stopped');
      }
    });

    player.onEnded(() => {
      this.setSessionState(this.data.loopEnabled ? 'playing' : 'completed');
      this.log(
        this.data.loopEnabled ? 'White-noise loop cycled seamlessly' : 'White-noise playback ended'
      );
    });

    player.onTimeUpdate(() => {
      this.updateDurationAndTime();
    });

    player.onError((error) => {
      this.setError(`White-noise playback failed: ${safeMessage(error)}`);
    });
  },

  initAmbientPlayer() {
    this.destroyAmbientPlayer();

    try {
      const player = new AudioPlayer();
      this.bindAmbientEvents(player);
      player.loop = this.data.loopEnabled;
      player.src = AMBIENT_SRC;
      this.ambientPlayer = player;
      this.log('Created bundled white-noise player');
    } catch (error) {
      this.setError(`Failed to create white-noise player: ${safeMessage(error)}`);
    }
  },

  destroyAmbientPlayer() {
    if (!this.ambientPlayer) {
      return;
    }
    try {
      this.ambientPlayer.destroy();
    } catch (_error) {
    }
    this.ambientPlayer = null;
  },

  prepareCueSound() {
    this.destroyCueSound();

    try {
      this.cueSound = new Sound(SHORT_CUE_SRC);
      this.setData({ cueReady: true });
      this.updateCueBadge();
      this.log('Prepared bundled short cue');
    } catch (error) {
      this.setData({ cueReady: false });
      this.updateCueBadge();
      this.setError(`Failed to prepare short cue: ${safeMessage(error)}`);
    }
  },

  destroyCueSound() {
    if (!this.cueSound) {
      return;
    }
    try {
      this.cueSound.destroy();
    } catch (_error) {
    }
    this.cueSound = null;
  },

  triggerCue(reason) {
    if (!this.cueSound) {
      this.prepareCueSound();
    }

    if (!this.cueSound) {
      return false;
    }

    try {
      this.cueSound.play();
      this.setData({
        cueReady: true,
        lastCueTrigger: `${reason} · ${nowLabel()}`,
      });
      this.updateCueBadge();
      this.log(`${reason} cue triggered`);
      return true;
    } catch (error) {
      this.setData({
        cueReady: false,
        lastCueTrigger: `${reason} failed · ${nowLabel()}`,
      });
      this.updateCueBadge();
      this.setError(`Short cue playback failed: ${safeMessage(error)}`);
      return false;
    }
  },

  ensureAmbientPlayer() {
    if (this.ambientPlayer) {
      return this.ambientPlayer;
    }
    this.initAmbientPlayer();
    return this.ambientPlayer;
  },

  handlePrimaryAction() {
    if (this.data.sessionState === 'playing') {
      this.pauseSession();
      return;
    }

    this.startOrResumeSession();
  },

  startOrResumeSession() {
    const player = this.ensureAmbientPlayer();
    if (!player) {
      return;
    }

    const isResume = this.data.sessionState === 'paused';
    const isFreshStart =
      this.data.sessionState === 'idle' ||
      this.data.sessionState === 'completed' ||
      this.data.sessionState === 'error';

    try {
      if (isFreshStart) {
        this.pendingStopState = '';
        this.setSessionState('starting');
        this.triggerCue('Start');
        player.seek(0);
      } else if (isResume) {
        this.log('Resuming white-noise loop');
      }

      this.clearError();
      player.play();
      if (isResume) {
        this.setSessionState('playing');
      }
    } catch (error) {
      this.setError(`White-noise start failed: ${safeMessage(error)}`);
    }
  },

  pauseSession() {
    if (!this.ambientPlayer) {
      return;
    }

    try {
      this.ambientPlayer.pause();
      this.clearError();
    } catch (error) {
      this.setError(`White-noise pause failed: ${safeMessage(error)}`);
    }
  },

  restartSession() {
    const player = this.ensureAmbientPlayer();
    if (!player) {
      return;
    }

    try {
      this.pendingStopState = 'restarting';
      this.setSessionState('restarting');
      this.triggerCue('Restart');
      player.stop();
      player.seek(0);
      this.clearError();
      player.play();
    } catch (error) {
      this.setError(`White-noise restart failed: ${safeMessage(error)}`);
    }
  },

  finishSession() {
    const player = this.ensureAmbientPlayer();
    if (!player) {
      return;
    }

    try {
      this.pendingStopState = 'completed';
      player.stop();
      player.seek(0);
      this.triggerCue('Complete');
      this.clearError();
      this.setSessionState('completed');
    } catch (error) {
      this.setError(`Session completion failed: ${safeMessage(error)}`);
    }
  },

  toggleLoop() {
    const player = this.ensureAmbientPlayer();
    if (!player) {
      return;
    }

    try {
      const nextLoop = !player.loop;
      player.loop = nextLoop;
      this.setData({ loopEnabled: nextLoop });
      this.log(`Ambient loop ${nextLoop ? 'enabled' : 'disabled'}`);
      this.clearError();
    } catch (error) {
      this.setError(`Loop toggle failed: ${safeMessage(error)}`);
    }
  },

  toggleDiagnostics() {
    this.setData({ diagnosticsOpen: !this.data.diagnosticsOpen });
  },
};
</script>

<page>
  <view class="container">
    <view class="hero card">
      <view class="hero-copy">
        <text class="eyebrow">Meditation Audio Regression</text>
        <view class="page-title">{{title}}</view>
        <text class="page-description">{{subtitle}}</text>
        <view class="chip-row">
          <text class="chip chip-accent">{{statusLabel}}</text>
        <text class="chip">Bundled white noise</text>
          <text class="chip">{{loopEnabled ? 'Ambient Loop On' : 'Ambient Loop Off'}}</text>
        </view>
      </view>
      <view class="hero-visual">
        <view class="orb orb-large"></view>
        <view class="orb orb-small"></view>
        <view class="visual-label">
          <text class="visual-kicker">Now flowing</text>
          <text class="visual-value">{{currentTimeLabel}} / {{durationLabel}}</text>
        </view>
      </view>
    </view>

    <view class="card session-card">
      <view class="card-header">
        <text class="section-title">Session</text>
        <text class="section-hint">{{summaryLabel}}</text>
      </view>
      <view class="action-row">
        <button class="action-button action-primary" bindtap="handlePrimaryAction">
          {{primaryActionLabel}}
        </button>
        <button class="action-button action-secondary" bindtap="restartSession">
          Restart Session
        </button>
      </view>
      <view class="action-row">
        <button class="action-button action-ghost" bindtap="finishSession">
          Finish Session
        </button>
        <button class="action-button action-ghost" bindtap="toggleLoop">
          {{loopEnabled ? 'Disable Loop' : 'Enable Loop'}}
        </button>
      </view>
    </view>

    <view class="summary-grid">
      <view class="card summary-card">
        <text class="summary-label">White Noise</text>
        <text class="summary-value">{{ambientReady ? 'Ready' : 'Loading'}}</text>
        <text class="summary-meta">{{sourceBadge}}</text>
      </view>
      <view class="card summary-card">
        <text class="summary-label">Cue</text>
        <text class="summary-value">{{cueReady ? 'Ready' : 'Needs Retry'}}</text>
        <text class="summary-meta">{{cueBadge}}</text>
      </view>
      <view class="card summary-card">
        <text class="summary-label">Last Cue</text>
        <text class="summary-value">{{lastCueTrigger}}</text>
        <text class="summary-meta">Verifies the short bundled sound path</text>
      </view>
    </view>

    <view class="card diagnostics-card">
      <view class="diagnostics-header">
        <view class="card-header">
          <text class="section-title">Playback Diagnostics</text>
          <text class="section-hint">Collapsed by default so the page still reads like a real product.</text>
        </view>
        <button class="action-button action-inline" bindtap="toggleDiagnostics">
          {{diagnosticsOpen ? 'Hide' : 'Show'}}
        </button>
      </view>
      <view ink:if="{{diagnosticsOpen}}" class="diagnostics-body">
        <text class="diagnostic-line">Ambient Source: {{ambientSource}}</text>
        <text class="diagnostic-line">Cue Source: {{cueSource}}</text>
        <text class="diagnostic-line">Loop Enabled: {{loopEnabled}}</text>
        <text class="diagnostic-line">Ambient Ready: {{ambientReady}}</text>
        <text class="diagnostic-line">Cue Ready: {{cueReady}}</text>
        <text class="diagnostic-line">Playback Status: {{statusLabel}}</text>
        <text class="diagnostic-line">Current Time: {{currentTimeLabel}}</text>
        <text class="diagnostic-line">Duration: {{durationLabel}}</text>
        <text class="diagnostic-line error-line">Last Error: {{lastError || 'None'}}</text>
      </view>
    </view>

    <view class="card transcript-card">
      <view class="card-header">
        <text class="section-title">Session Transcript</text>
        <text class="section-hint">A lightweight timeline instead of a callback dashboard.</text>
      </view>
      <view class="transcript-list">
        <view class="transcript-item" ink:for="{{transcript}}" ink:key="*this">
          <text class="transcript-text">{{item}}</text>
        </view>
      </view>
    </view>
  </view>
</page>

<style>
  .container {
    display: flex;
    flex-direction: column;
    gap: var(--spacing-md, 16px);
    padding: var(--theme-padding, 20px);
    background-color: var(--color-background, #0b1020);
  }

  .card {
    display: flex;
    flex-direction: column;
    gap: var(--spacing-sm, 10px);
    padding: var(--spacing-md, 16px);
    border: var(--theme-border);
    border-radius: var(--theme-radius, 12px);
    background-color: var(--theme-bg, var(--color-surface-highlight, #f4f7fb));
  }

  .hero {
    gap: var(--spacing-lg, 20px);
  }

  .hero-copy {
    display: flex;
    flex-direction: column;
    gap: 10px;
  }

  .eyebrow {
    font-size: 12px;
    font-weight: 600;
    color: var(--theme-color, var(--color-primary, #3498db));
  }

  .page-title {
    font-size: 28px;
    font-weight: 700;
    color: var(--color-text-primary, #111827);
  }

  .page-description {
    font-size: 14px;
    line-height: 20px;
    color: var(--color-text-secondary, #4b5563);
  }

  .chip-row {
    display: flex;
    flex-direction: row;
    flex-wrap: wrap;
    gap: 8px;
  }

  .chip {
    padding: 6px 10px;
    border-radius: 999px;
    border: var(--border-width-thin, 1px) solid var(--border-color-default, #d1d5db);
    color: var(--color-text-secondary, #4b5563);
    background-color: var(--color-surface, #ffffff);
    font-size: 12px;
  }

  .chip-accent {
    border-color: var(--theme-color, var(--color-primary, #3498db));
    color: var(--theme-color, var(--color-primary, #3498db));
  }

  .hero-visual {
    position: relative;
    min-height: 180px;
    border-radius: calc(var(--theme-radius, 12px) + 8px);
    overflow: hidden;
    background-color: var(--color-surface, #ffffff);
    border: var(--border-width-thin, 1px) solid var(--border-color-default, #d1d5db);
  }

  .orb {
    position: absolute;
    border-radius: 999px;
    background-color: var(--theme-color, var(--color-primary, #3498db));
    opacity: 0.16;
  }

  .orb-large {
    width: 180px;
    height: 180px;
    top: -24px;
    right: -12px;
  }

  .orb-small {
    width: 120px;
    height: 120px;
    left: 24px;
    bottom: -16px;
    opacity: 0.1;
  }

  .visual-label {
    position: absolute;
    left: 20px;
    bottom: 20px;
    display: flex;
    flex-direction: column;
    gap: 4px;
  }

  .visual-kicker {
    font-size: 12px;
    color: var(--color-text-secondary, #4b5563);
  }

  .visual-value {
    font-size: 22px;
    font-weight: 700;
    color: var(--color-text-primary, #111827);
  }

  .card-header {
    display: flex;
    flex-direction: column;
    gap: 6px;
  }

  .section-title {
    font-size: 18px;
    font-weight: 600;
    color: var(--color-text-primary, #111827);
  }

  .section-hint {
    font-size: 13px;
    line-height: 18px;
    color: var(--color-text-secondary, #4b5563);
  }

  .action-row {
    display: flex;
    flex-direction: row;
    gap: 12px;
  }

  .action-button {
    flex: 1;
    min-height: 46px;
  }

  .action-primary {
    background-color: var(--theme-color, var(--color-primary, #3498db));
    color: var(--color-text-on-primary, #ffffff);
  }

  .action-secondary {
    background-color: var(--color-surface, #ffffff);
    color: var(--color-text-primary, #111827);
  }

  .action-ghost {
    background-color: transparent;
    color: var(--color-text-primary, #111827);
    border: var(--border-width-thin, 1px) solid var(--border-color-default, #d1d5db);
  }

  .summary-grid {
    display: flex;
    flex-direction: column;
    gap: var(--spacing-md, 16px);
  }

  .summary-card {
    gap: 8px;
    background-color: var(--color-surface, #ffffff);
  }

  .summary-label {
    font-size: 12px;
    color: var(--color-text-secondary, #4b5563);
  }

  .summary-value {
    font-size: 20px;
    font-weight: 700;
    color: var(--color-text-primary, #111827);
  }

  .summary-meta {
    font-size: 13px;
    line-height: 18px;
    color: var(--color-text-secondary, #4b5563);
  }

  .diagnostics-header {
    display: flex;
    flex-direction: row;
    gap: 12px;
    align-items: center;
    justify-content: space-between;
  }

  .action-inline {
    flex: 0;
    min-width: 92px;
    background-color: var(--color-surface, #ffffff);
    color: var(--color-text-primary, #111827);
  }

  .diagnostics-body {
    display: flex;
    flex-direction: column;
    gap: 6px;
    padding-top: 4px;
  }

  .diagnostic-line {
    font-size: 13px;
    line-height: 18px;
    color: var(--color-text-secondary, #4b5563);
    font-family: monospace;
  }

  .error-line {
    color: var(--color-danger, #d14343);
  }

  .transcript-list {
    display: flex;
    flex-direction: column;
    gap: 8px;
  }

  .transcript-item {
    padding: 10px 12px;
    border-radius: calc(var(--theme-radius, 12px) - 4px);
    background-color: var(--color-surface, #ffffff);
  }

  .transcript-text {
    font-size: 13px;
    line-height: 18px;
    color: var(--color-text-primary, #111827);
  }
</style>
