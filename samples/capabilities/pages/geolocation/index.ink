<script type="application/json" def>
{
  "navigationBarTitleText": "Geolocation"
}
</script>

<script setup>
const LOG_LIMIT = 40;

function nowLabel() {
  return new Date().toISOString().slice(11, 19);
}

function hasGeolocation() {
  return typeof navigator !== 'undefined' && !!navigator.geolocation;
}

function formatCoordinate(value) {
  if (typeof value !== 'number' || !Number.isFinite(value)) {
    return '--';
  }
  return value.toFixed(6);
}

function formatAccuracy(value) {
  if (typeof value !== 'number' || !Number.isFinite(value)) {
    return '--';
  }
  return `${value.toFixed(1)} m`;
}

function formatTimestamp(value) {
  if (typeof value !== 'number' || !Number.isFinite(value)) {
    return 'N/A';
  }
  return new Date(value).toISOString();
}

function getErrorMessage(error) {
  if (!error) {
    return 'Unknown geolocation error';
  }

  const code = typeof error.code === 'number' ? `code ${error.code}` : 'code unknown';
  const message = error.message || 'Unknown geolocation error';
  return `${code}: ${message}`;
}

function positionSummary(position) {
  if (!position || !position.coords) {
    return 'No position';
  }

  const { latitude, longitude, accuracy } = position.coords;
  return `lat=${formatCoordinate(latitude)} lon=${formatCoordinate(longitude)} acc=${formatAccuracy(accuracy)}`;
}

export default {
  data: {
    available: false,
    watching: false,
    hasPosition: false,
    watchIdText: 'inactive',
    latitudeText: '--',
    longitudeText: '--',
    accuracyText: '--',
    timestampText: 'N/A',
    statusText: 'Waiting for geolocation capability',
    lastError: '',
    logCount: 1,
    logs: ['Geolocation demo ready'],
  },

  onLoad() {
    const available = hasGeolocation();
    this.watchId = null;
    this.setData({
      available,
      statusText: available
        ? 'Geolocation capability is ready for one-shot requests and watch sessions'
        : 'Geolocation is unavailable in this runtime or host configuration',
    });
    if (!available) {
      this.log('Geolocation is not available in this runtime');
    }
  },

  onUnload() {
    this.stopWatch();
  },

  log(message) {
    const nextLogs = [`${nowLabel()} ${message}`, ...(this.data.logs || [])].slice(0, LOG_LIMIT);
    this.setData({
      logs: nextLogs,
      logCount: nextLogs.length,
    });
  },

  setError(message) {
    this.setData({
      lastError: message,
      statusText: message,
    });
    this.log(`Error: ${message}`);
  },

  clearError() {
    if (!this.data.lastError) {
      return;
    }
    this.setData({ lastError: '' });
  },

  ensureAvailable() {
    const available = hasGeolocation();
    if (!available) {
      this.setData({
        available: false,
        statusText: 'Geolocation is unavailable in this runtime or host configuration',
      });
      this.setError('Geolocation is unavailable');
      return false;
    }
    if (!this.data.available) {
      this.setData({ available: true });
    }
    return true;
  },

  applyPosition(position, source) {
    const coords = (position && position.coords) || {};
    this.clearError();
    this.setData({
      hasPosition: true,
      latitudeText: formatCoordinate(coords.latitude),
      longitudeText: formatCoordinate(coords.longitude),
      accuracyText: formatAccuracy(coords.accuracy),
      timestampText: formatTimestamp(position && position.timestamp),
      statusText: source === 'watch' ? 'Watching live geolocation updates' : 'Received current position',
    });
    this.log(`${source === 'watch' ? 'Watch update' : 'Current position'}: ${positionSummary(position)}`);
  },

  getCurrentPosition() {
    if (!this.ensureAvailable()) {
      return;
    }

    this.clearError();
    this.setData({
      statusText: 'Requesting current position...',
    });
    this.log('Calling navigator.geolocation.getCurrentPosition()');
    try {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          this.applyPosition(position, 'current');
        },
        (error) => {
          this.setError(getErrorMessage(error));
        },
        {
          enableHighAccuracy: true,
          timeout: 10000,
          maximumAge: 0,
        }
      );
    } catch (error) {
      this.setError(String(error));
    }
  },

  startWatch() {
    if (!this.ensureAvailable()) {
      return;
    }

    if (this.watchId !== null) {
      this.log(`Watch already active: ${this.watchId}`);
      this.setData({
        watching: true,
        watchIdText: String(this.watchId),
        statusText: 'Geolocation watch is already running',
      });
      return;
    }

    this.clearError();
    this.setData({
      statusText: 'Starting geolocation watch...',
    });
    this.log('Calling navigator.geolocation.watchPosition()');
    try {
      this.watchId = navigator.geolocation.watchPosition(
        (position) => {
          this.setData({
            watching: true,
            watchIdText: String(this.watchId),
          });
          this.applyPosition(position, 'watch');
        },
        (error) => {
          this.setData({
            watching: false,
            watchIdText: 'inactive',
          });
          this.watchId = null;
          this.setError(getErrorMessage(error));
        },
        {
          enableHighAccuracy: true,
          timeout: 10000,
          maximumAge: 0,
        }
      );
    } catch (error) {
      this.setError(String(error));
      return;
    }

    this.setData({
      watching: true,
      watchIdText: String(this.watchId),
      statusText: 'Geolocation watch started',
    });
    this.log(`Watch started: ${this.watchId}`);
  },

  stopWatch() {
    if (this.watchId === null) {
      this.setData({
        watching: false,
        watchIdText: 'inactive',
        statusText: this.data.available
          ? 'No active geolocation watch'
          : 'Geolocation is unavailable in this runtime or host configuration',
      });
      return;
    }

    const activeWatchId = this.watchId;
    try {
      navigator.geolocation.clearWatch(activeWatchId);
      this.log(`Watch stopped: ${activeWatchId}`);
    } catch (error) {
      this.setError(String(error));
      return;
    }

    this.watchId = null;
    this.setData({
      watching: false,
      watchIdText: 'inactive',
      statusText: 'Geolocation watch stopped',
    });
  },

  clearLogs() {
    this.setData({
      logs: ['Logs cleared'],
      logCount: 1,
    });
  },
};
</script>

<page>
  <view class="container">
    <view class="hero-card">
      <text class="page-kicker">Field Toolkit</text>
      <view class="hero-header">
        <text class="page-title">Geolocation Session Panel</text>
        <text class="hero-chip">{{watching ? 'WATCHING' : available ? 'READY' : 'UNAVAILABLE'}}</text>
      </view>
      <text class="subtitle">
        演示一次定位、持续监听、停止监听和错误提示，方便在 capability playground 里快速验证 geolocation bridge 是否可用。
      </text>
    </view>

    <view class="status-grid">
      <view class="status-card">
        <text class="status-label">Capability</text>
        <text class="status-value">{{available}}</text>
      </view>
      <view class="status-card">
        <text class="status-label">Watching</text>
        <text class="status-value">{{watching}}</text>
      </view>
      <view class="status-card">
        <text class="status-label">Last Position</text>
        <text class="status-value">{{hasPosition}}</text>
      </view>
      <view class="status-card">
        <text class="status-label">Watch ID</text>
        <text class="status-value">{{watchIdText}}</text>
      </view>
    </view>

    <view class="data-card">
      <view class="section-header">
        <text class="section-title">Latest Position</text>
        <text class="section-meta">{{watching ? 'Live updates' : 'Idle session'}}</text>
      </view>

      <view class="axis-grid">
        <view class="axis-card axis-latitude">
          <text class="axis-label">Latitude</text>
          <text class="axis-value">{{latitudeText}}</text>
        </view>
        <view class="axis-card axis-longitude">
          <text class="axis-label">Longitude</text>
          <text class="axis-value">{{longitudeText}}</text>
        </view>
      </view>

      <view class="reading-meta">
        <text class="meta-line">Accuracy: {{accuracyText}}</text>
        <text class="meta-line">Timestamp: {{timestampText}}</text>
        <text class="meta-line">Status: {{statusText}}</text>
        <text class="meta-line">Last Error: {{lastError || 'None'}}</text>
      </view>
    </view>

    <view class="control-card">
      <text class="section-title">Session Controls</text>
      <view class="button-grid" role="navigation">
        <button class="btn" bindtap="getCurrentPosition">Get Current Position</button>
        <button class="btn" bindtap="startWatch">Start Watch</button>
        <button class="btn btn-secondary" bindtap="stopWatch">Stop Watch</button>
        <button class="btn btn-secondary" bindtap="clearLogs">Clear Logs</button>
      </view>
    </view>

    <view class="log-card">
      <view class="section-header">
        <text class="section-title">Result Log</text>
        <text class="section-meta">{{logCount}} entries</text>
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
  --geo-page-background: var(--color-background);
  --geo-surface-background: var(--color-surface);
  --geo-surface-muted-background: var(--color-surface-highlight);
  --geo-text-color: var(--color-text-primary);
  --geo-muted-text-color: var(--color-text-secondary);
  --geo-border-color: var(--border-color-default, #e5e7eb);
  --geo-secondary-background: var(--geo-surface-muted-background, #edf2f7);
  --geo-glow-latitude: rgba(10, 132, 255, 0.12);
  --geo-glow-longitude: rgba(52, 199, 89, 0.12);
  display: flex;
  flex-direction: column;
  gap: 16px;
  padding: 24px;
  background-color: var(--geo-page-background);
}

.hero-card,
.data-card,
.control-card,
.log-card,
.status-card {
  border-radius: 16px;
  border: var(--border-width-thin, 1px) solid var(--geo-border-color);
  background-color: var(--geo-surface-background);
  box-sizing: border-box;
}

.hero-card {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-sm, 10px);
  padding: 18px;
}

.page-kicker {
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 1px;
  color: var(--geo-muted-text-color);
}

.hero-header {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  gap: 12px;
}

.page-title {
  font-size: 28px;
  font-weight: 700;
  color: var(--geo-text-color);
}

.hero-chip {
  padding: 8px 12px;
  border-radius: 999px;
  background-color: var(--geo-secondary-background);
  color: var(--geo-text-color);
  font-size: 12px;
  font-weight: 700;
}

.subtitle {
  font-size: 14px;
  line-height: 20px;
  color: var(--geo-muted-text-color);
}

.status-grid {
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
  gap: 12px;
}

.status-card {
  flex: 1;
  min-width: 140px;
  display: flex;
  flex-direction: column;
  gap: 6px;
  padding: 14px 16px;
}

.status-label {
  font-size: 12px;
  color: var(--geo-muted-text-color);
  text-transform: uppercase;
}

.status-value {
  font-size: 20px;
  font-weight: 700;
  color: var(--geo-text-color);
}

.data-card,
.control-card,
.log-card {
  display: flex;
  flex-direction: column;
  gap: 12px;
  padding: 18px;
}

.section-header {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  gap: 12px;
}

.section-title {
  font-size: 18px;
  font-weight: 700;
  color: var(--geo-text-color);
}

.section-meta {
  font-size: 12px;
  color: var(--geo-muted-text-color);
}

.axis-grid {
  display: flex;
  flex-direction: row;
  gap: 12px;
}

.axis-card {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 8px;
  padding: var(--spacing-md, 16px);
  border-radius: 14px;
  border: var(--border-width-thin, 1px) solid var(--geo-border-color);
}

.axis-latitude {
  background-color: var(--geo-glow-latitude);
}

.axis-longitude {
  background-color: var(--geo-glow-longitude);
}

.axis-label {
  font-size: 12px;
  color: var(--geo-muted-text-color);
  text-transform: uppercase;
}

.axis-value {
  font-size: 24px;
  font-weight: 700;
  color: var(--geo-text-color);
}

.reading-meta {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.meta-line {
  font-size: 14px;
  color: var(--geo-text-color);
}

.button-grid {
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
  gap: 12px;
}

.btn {
  min-width: 150px;
  padding: 12px 14px;
  font-size: 14px;
  font-weight: 600;
}

.log-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.log-item {
  padding: 10px 12px;
  border-radius: var(--radius-md, 10px);
  background-color: var(--geo-secondary-background);
}

.log-text {
  font-size: 12px;
  line-height: 18px;
  color: var(--geo-text-color);
}
</style>
