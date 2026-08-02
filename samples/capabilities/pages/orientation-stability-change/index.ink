<script type="application/json" def>
{
  "navigationBarTitleText": "Orientation Stability"
}
</script>

<script setup>
const MAX_LOGS = 10;

function formatTimestamp(value) {
  if (typeof value !== 'number' || !Number.isFinite(value)) {
    return 'N/A';
  }
  return `${Math.round(value)} ms`;
}

function makeInitialData() {
  return {
    available: false,
    sensorManaged: 'this.orientationSensor',
    currentStableText: 'false',
    changeCount: 0,
    lastTimestampText: 'N/A',
    activated: false,
    hasReading: false,
    statusChip: 'UNAVAILABLE',
    statusText: 'World awareness is disabled until this page enables it.',
    lastError: '',
    logs: [],
  };
}

function createLogEntry(kind, primaryText, secondaryText) {
  return {
    id: `${kind}-${Date.now()}-${Math.random().toString(16).slice(2, 8)}`,
    kind,
    primaryText,
    secondaryText,
  };
}

export default {
  data: makeInitialData(),

  onLoad() {
    this.orientation = null;
    this.orientationActivateListener = () => {
      this.captureOrientationState();
      this.appendLog(
        createLogEntry(
          'activate',
          'Page orientation sensor activated',
          `activated=${this.data.activated}, hasReading=${this.data.hasReading}`
        )
      );
      this.refreshStatus();
    };
    this.orientationReadingListener = () => {
      this.captureOrientationState();
      this.refreshStatus();
    };

    this.setData(makeInitialData());
    this.enablePageWorldAwareness();
    this.bindOrientationListeners();
  },

  onUnload() {
    this.unbindOrientationListeners();
  },

  setError(message) {
    this.setData({
      lastError: message,
      statusText: message,
    });
  },

  clearError() {
    if (this.data.lastError) {
      this.setData({ lastError: '' });
    }
  },

  onOrientationStabilityChange(event) {
    this.handleStabilityChange(event);
  },

  enablePageWorldAwareness() {
    try {
      if (typeof this.enableWorldAwareness !== 'function') {
        this.setError('enableWorldAwareness is unavailable on this page instance.');
        return;
      }
      this.enableWorldAwareness();
    } catch (error) {
      this.setError(String(error));
    }
  },

  getPageOrientationSensor() {
    return this.orientationSensor || null;
  },

  bindOrientationListeners() {
    const orientation = this.getPageOrientationSensor();
    this.orientation = orientation;

    if (!orientation || typeof orientation.addEventListener !== 'function') {
      this.setData({
        available: false,
        statusChip: 'UNAVAILABLE',
        statusText: 'Page world awareness did not expose an orientationSensor.',
      });
      return;
    }

    try {
      orientation.addEventListener('activate', this.orientationActivateListener);
      orientation.addEventListener('reading', this.orientationReadingListener);
      this.clearError();
      this.setData({
        available: true,
        statusChip: 'IDLE',
        statusText: 'Observing the page world awareness orientation stability pipeline.',
      });
      this.captureOrientationState();
      this.refreshStatus();
    } catch (error) {
      this.setError(String(error));
    }
  },

  unbindOrientationListeners() {
    if (!this.orientation || typeof this.orientation.removeEventListener !== 'function') {
      this.orientation = null;
      return;
    }

    try {
      this.orientation.removeEventListener('activate', this.orientationActivateListener);
      this.orientation.removeEventListener('reading', this.orientationReadingListener);
    } catch (_) {}

    this.orientation = null;
  },

  captureOrientationState() {
    const orientation = this.orientation;
    const stable =
      orientation && typeof orientation.stable === 'boolean' ? orientation.stable : false;
    this.setData({
      activated: !!(orientation && orientation.activated),
      hasReading: !!(orientation && orientation.hasReading),
      currentStableText: stable ? 'true' : 'false',
    });
  },

  refreshStatus() {
    if (!this.data.available) {
      this.setData({
        statusChip: 'UNAVAILABLE',
        statusText: 'Page world awareness did not expose an orientationSensor.',
      });
      return;
    }

    if (this.data.currentStableText === 'true') {
      this.setData({
        statusChip: 'STABLE',
        statusText: 'Page world awareness currently reports a stable head pose.',
      });
      return;
    }

    if (this.data.currentStableText === 'false') {
      this.setData({
        statusChip: 'UNSTABLE',
        statusText: 'Page world awareness currently reports an unstable head pose.',
      });
      return;
    }

    this.setData({
      statusChip: 'IDLE',
      statusText: this.data.activated
        ? 'Page orientation sensor is active and waiting for the first stability transition.'
        : 'Waiting for the page orientation sensor to activate.',
    });
  },

  appendLog(entry) {
    const logs = [entry, ...(this.data.logs || [])].slice(0, MAX_LOGS);
    this.setData({ logs });
  },

  handleStabilityChange(event) {
    const stable = !!(event && event.stable);
    const timestamp =
      event && typeof event.timeStamp === 'number' && Number.isFinite(event.timeStamp)
        ? event.timeStamp
        : null;
    const changeCount = (this.data.changeCount || 0) + 1;

    this.captureOrientationState();
    this.clearError();
    this.setData({
      available: true,
      currentStableText: stable ? 'true' : 'false',
      changeCount,
      lastTimestampText: formatTimestamp(timestamp),
    });
    this.appendLog(
      createLogEntry(
        'orientationstabilitychange',
        `stable=${stable}`,
        `timeStamp=${formatTimestamp(timestamp)}`
      )
    );
    this.refreshStatus();
  },

  clearLogs() {
    this.setData({ logs: [] });
  },

  resetSnapshot() {
    this.captureOrientationState();
    this.setData({
      currentStableText: 'false',
      changeCount: 0,
      lastTimestampText: 'N/A',
      statusChip: this.data.available ? 'UNSTABLE' : 'UNAVAILABLE',
      statusText: this.data.available
        ? 'Snapshot cleared. Page world awareness defaults to unstable until a stable window is detected.'
        : 'Page world awareness did not expose an orientationSensor.',
    });
  },
};
</script>

<page>
  <view class="container">
    <view class="hero-card">
      <text class="page-kicker">World Awareness Regression Panel</text>
      <view class="hero-header">
        <text class="page-title">Orientation Stability</text>
        <text class="hero-chip">{{statusChip}}</text>
      </view>
      <text class="subtitle">
        Validate <text class="inline-code">orientationstabilitychange</text> after this page enables <text class="inline-code">world awareness</text>, using the page-private <text class="inline-code">orientationSensor</text> field.
      </text>
      <text class="status-text">{{statusText}}</text>
      <text class="meta-line">Path: {{sensorManaged}}</text>
      <text class="error-text" ink:if="{{lastError}}">{{lastError}}</text>
    </view>

    <scroll-view class="metrics-scroll" scroll-x="true" scroll-direction="horizontal">
      <view class="metrics-grid">
        <view class="metric-card">
          <text class="metric-label">Stable</text>
          <text class="metric-value">{{currentStableText}}</text>
        </view>
        <view class="metric-card">
          <text class="metric-label">Change Count</text>
          <text class="metric-value">{{changeCount}}</text>
        </view>
        <view class="metric-card">
          <text class="metric-label">Last Timestamp</text>
          <text class="metric-value metric-value-small">{{lastTimestampText}}</text>
        </view>
        <view class="metric-card">
          <text class="metric-label">Activated</text>
          <text class="metric-value">{{activated}}</text>
        </view>
        <view class="metric-card">
          <text class="metric-label">Has Reading</text>
          <text class="metric-value">{{hasReading}}</text>
        </view>
      </view>
    </scroll-view>

    <view class="action-card">
      <text class="section-title">Local Actions</text>
      <view class="button-row" role="navigation">
        <button class="btn" bindtap="clearLogs">Clear Logs</button>
        <button class="btn btn-secondary" bindtap="resetSnapshot">Reset Snapshot</button>
      </view>
    </view>

    <view class="log-card">
      <view class="log-header">
        <text class="section-title">Recent Events</text>
        <text class="section-meta">Focused on stability transitions from the managed sensor.</text>
      </view>
      <view ink:if="{{logs.length}}">
        <view class="log-item" ink:for="{{logs}}" ink:key="id">
          <view class="log-topline">
            <text class="log-title">{{item.kind}}</text>
            <text class="log-chip">{{sensorManaged}}</text>
          </view>
          <text class="log-meta">{{item.primaryText}}</text>
          <text class="log-meta">{{item.secondaryText}}</text>
        </view>
      </view>
      <text class="empty-text" ink:else>No orientation stability events captured yet.</text>
    </view>
  </view>
</page>

<style>
.container {
  --page-background: var(--color-background);
  --surface-background: var(--color-surface);
  --surface-muted-background: var(--color-surface-highlight);
  --text-color: var(--color-text-primary);
  --muted-text-color: var(--color-text-secondary);
  --border-color: var(--border-color-default, #e5e7eb);
  --primary-background: var(--color-primary);
  --primary-text: #ffffff;
  display: flex;
  flex-direction: column;
  gap: 18px;
  padding: var(--spacing-lg, 20px);
  background-color: var(--page-background);
}

.hero-card,
.metric-card,
.action-card,
.log-card {
  display: flex;
  flex-direction: column;
  gap: 12px;
  padding: 18px;
  border-radius: 16px;
  border: var(--border-width-thin, 1px) solid var(--border-color);
  background-color: var(--surface-background);
  box-sizing: border-box;
}

.page-kicker {
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 1px;
  color: var(--muted-text-color);
}

.hero-header {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  gap: 12px;
}

.page-title {
  font-size: 30px;
  font-weight: 700;
  color: var(--text-color);
}

.hero-chip,
.log-chip {
  padding: 6px 10px;
  border-radius: 999px;
  font-size: 11px;
  font-weight: 700;
  color: var(--primary-text);
  background-color: var(--primary-background);
}

.subtitle,
.status-text,
.meta-line,
.section-meta,
.log-meta,
.empty-text,
.error-text {
  font-size: 14px;
  line-height: 20px;
  color: var(--muted-text-color);
}

.inline-code {
  font-weight: 700;
}

.error-text {
  color: #d14343;
}

.metrics-scroll {
  width: 100%;
}

.metrics-grid {
  display: flex;
  flex-direction: row;
  gap: 12px;
  width: max-content;
  min-width: 100%;
}

.metric-card {
  flex: 0 0 auto;
  min-width: 150px;
  background-color: var(--surface-muted-background);
}

.metric-label,
.section-title {
  font-size: 13px;
  font-weight: 700;
  color: var(--muted-text-color);
}

.metric-value {
  font-size: 28px;
  font-weight: 700;
  color: var(--text-color);
}

.metric-value-small {
  font-size: 18px;
}

.button-row {
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
  gap: 12px;
}

.btn {
  min-width: 148px;
  padding: 12px 18px;
  border-radius: 999px;
  color: var(--primary-text);
  background-color: var(--primary-background);
}

.btn-secondary {
  color: var(--text-color);
  background-color: var(--surface-muted-background);
}

.log-header,
.log-topline {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  gap: 12px;
}

.log-card {
  gap: 14px;
}

.log-item {
  display: flex;
  flex-direction: column;
  gap: 8px;
  padding: 14px;
  border-radius: 12px;
  background-color: var(--surface-muted-background);
  margin-bottom: 10px;
}

.log-title {
  font-size: 16px;
  font-weight: 700;
  color: var(--text-color);
}
</style>
