<script type="application/json" def>
{
  "navigationBarTitleText": "Motion Monitor"
}
</script>

<script setup>
const LOG_LIMIT = 40;
const DEFAULT_FREQUENCY = 60;

function nowLabel() {
  return new Date().toISOString().slice(11, 19);
}

function formatAxis(value) {
  if (typeof value !== 'number' || !Number.isFinite(value)) {
    return '--';
  }
  return value.toFixed(3);
}

function formatTimestamp(value) {
  if (typeof value !== 'number' || !Number.isFinite(value)) {
    return 'N/A';
  }
  return `${Math.round(value)} ms`;
}

function formatMagnitude(x, y, z) {
  if (![x, y, z].every((value) => typeof value === 'number' && Number.isFinite(value))) {
    return '--';
  }
  return Math.sqrt(x * x + y * y + z * z).toFixed(3);
}

function classifyMotion(magnitude) {
  if (typeof magnitude !== 'number' || !Number.isFinite(magnitude)) {
    return {
      motionState: 'Waiting for motion',
      impactHint: 'Start sampling to detect walking, shock, and idle states.',
    };
  }

  if (magnitude >= 11.5) {
    return {
      motionState: 'Impact spike',
      impactHint: 'A stronger acceleration pulse is present, similar to a step hit or sudden movement.',
    };
  }

  if (magnitude >= 10.2) {
    return {
      motionState: 'Active motion',
      impactHint: 'Body movement is visible and the wearable is no longer in a steady state.',
    };
  }

  return {
    motionState: 'Steady hold',
    impactHint: 'Current acceleration looks calm and close to a stable idle posture.',
  };
}

export default {
  data: {
    available: false,
    frequency: DEFAULT_FREQUENCY,
    activated: false,
    hasReading: false,
    readingCount: 0,
    x: null,
    y: null,
    z: null,
    timestamp: null,
    xText: '--',
    yText: '--',
    zText: '--',
    timestampText: 'N/A',
    magnitude: '--',
    motionState: 'Waiting for motion',
    impactHint: 'Start sampling to detect walking, shock, and idle states.',
    lastError: '',
    logCount: 1,
    logs: ['Motion monitor ready'],
  },

  onLoad() {
    this.sensor = null;
    this.createSensor(true);
  },

  onUnload() {
    this.disposeSensor();
  },

  log(message) {
    const nextLogs = [`${nowLabel()} ${message}`, ...(this.data.logs || [])].slice(0, LOG_LIMIT);
    this.setData({
      logs: nextLogs,
      logCount: nextLogs.length,
    });
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

  updateReadingSnapshot() {
    const sensor = this.sensor;
    const x = sensor ? sensor.x : null;
    const y = sensor ? sensor.y : null;
    const z = sensor ? sensor.z : null;
    const timestamp = sensor ? sensor.timestamp : null;
    const magnitudeValue =
      [x, y, z].every((value) => typeof value === 'number' && Number.isFinite(value))
        ? Math.sqrt(x * x + y * y + z * z)
        : null;
    const motion = classifyMotion(magnitudeValue);
    this.setData({
      activated: !!(sensor && sensor.activated),
      hasReading: !!(sensor && sensor.hasReading),
      x,
      y,
      z,
      timestamp,
      xText: formatAxis(x),
      yText: formatAxis(y),
      zText: formatAxis(z),
      timestampText: formatTimestamp(timestamp),
      magnitude: formatMagnitude(x, y, z),
      motionState: motion.motionState,
      impactHint: motion.impactHint,
    });
  },

  bindSensor(sensor) {
    sensor.addEventListener('activate', () => {
      this.updateReadingSnapshot();
      this.log('Accelerometer activated');
    });

    sensor.addEventListener('reading', () => {
      const nextCount = this.data.readingCount + 1;
      this.setData({
        readingCount: nextCount,
      });
      this.updateReadingSnapshot();
      if (nextCount <= 5 || nextCount % 10 === 0) {
        this.log(
          `Reading #${nextCount}: x=${formatAxis(sensor.x)} y=${formatAxis(sensor.y)} z=${formatAxis(sensor.z)}`
        );
      }
    });

    sensor.addEventListener('error', (event) => {
      this.updateReadingSnapshot();
      const message =
        event && event.message ? `${event.error || 'error'}: ${event.message}` : 'Unknown accelerometer error';
      this.setError(message);
    });
  },

  createSensor(initial = false) {
    this.disposeSensor();

    if (typeof Accelerometer === 'undefined') {
      this.sensor = null;
      this.setData({
        available: false,
        activated: false,
        hasReading: false,
        readingCount: 0,
        x: null,
        y: null,
        z: null,
        timestamp: null,
        xText: '--',
        yText: '--',
        zText: '--',
        timestampText: 'N/A',
        magnitude: '--',
      });
      this.log('Accelerometer is not available in this runtime');
      return;
    }

    try {
      const sensor = new Accelerometer({ frequency: this.data.frequency });
      this.sensor = sensor;
      this.bindSensor(sensor);
      this.setData({
        available: true,
        activated: false,
        hasReading: false,
        readingCount: 0,
        x: null,
        y: null,
        z: null,
        timestamp: null,
        xText: '--',
        yText: '--',
        zText: '--',
        timestampText: 'N/A',
        magnitude: '--',
      });
      this.clearError();
      this.log(initial ? 'Motion monitor instance ready' : 'Created a fresh motion monitor instance');
    } catch (error) {
      this.sensor = null;
      this.setData({ available: false });
      this.setError(String(error));
    }
  },

  disposeSensor() {
    if (!this.sensor) {
      return;
    }
    try {
      this.sensor.stop();
    } catch (_) {}
    this.sensor = null;
  },

  startSensor() {
    if (!this.sensor) {
      this.setError('Accelerometer is unavailable');
      return;
    }
    try {
      this.clearError();
      this.log(`Calling sensor.start() with frequency=${this.data.frequency}`);
      this.sensor.start();
    } catch (error) {
      this.setError(String(error));
    }
  },

  stopSensor() {
    if (!this.sensor) {
      return;
    }
    try {
      this.log('Calling sensor.stop()');
      this.sensor.stop();
      this.updateReadingSnapshot();
    } catch (error) {
      this.setError(String(error));
    }
  },

  recreateSensor() {
    this.createSensor(false);
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
        <text class="page-title">Motion &amp; Impact Monitor</text>
        <text class="hero-chip">{{available ? 'READY' : 'UNAVAILABLE'}}</text>
      </view>
      <text class="subtitle">
        用加速度实时判断佩戴设备当前是在静止、走动还是出现冲击脉冲，更像现场动作监测页而不是原始传感器测试页。
      </text>
    </view>

    <view class="status-grid">
      <view class="status-card">
        <text class="status-label">Sensor Ready</text>
        <text class="status-value">{{available}}</text>
      </view>
      <view class="status-card">
        <text class="status-label">Live Session</text>
        <text class="status-value">{{activated}}</text>
      </view>
      <view class="status-card">
        <text class="status-label">Signal</text>
        <text class="status-value">{{hasReading}}</text>
      </view>
      <view class="status-card">
        <text class="status-label">Samples</text>
        <text class="status-value">{{readingCount}}</text>
      </view>
    </view>

    <view class="data-card">
      <view class="section-header">
        <text class="section-title">Motion Snapshot</text>
        <text class="section-meta">{{frequency}} Hz live stream</text>
      </view>

      <view class="axis-grid">
        <view class="axis-card axis-x">
          <text class="axis-label">X</text>
          <text class="axis-value">{{xText}}</text>
          <text class="axis-unit">m/s^2</text>
        </view>
        <view class="axis-card axis-y">
          <text class="axis-label">Y</text>
          <text class="axis-value">{{yText}}</text>
          <text class="axis-unit">m/s^2</text>
        </view>
        <view class="axis-card axis-z">
          <text class="axis-label">Z</text>
          <text class="axis-value">{{zText}}</text>
          <text class="axis-unit">m/s^2</text>
        </view>
      </view>

      <view class="reading-meta">
        <text class="meta-line">Current Motion: {{motionState}}</text>
        <text class="meta-line">Impact Hint: {{impactHint}}</text>
        <text class="meta-line">Acceleration Magnitude: {{magnitude}} m/s^2</text>
        <text class="meta-line">Updated: {{timestampText}}</text>
        <text class="meta-line">Last Error: {{lastError || 'None'}}</text>
      </view>
    </view>

    <view class="control-card">
      <text class="section-title">Session Controls</text>
      <view class="button-grid" role="navigation">
        <button class="btn" bindtap="startSensor">Start Monitor</button>
        <button class="btn btn-secondary" bindtap="stopSensor">Pause Session</button>
        <button class="btn btn-secondary" bindtap="recreateSensor">Reset Sensor</button>
        <button class="btn btn-secondary" bindtap="clearLogs">Clear Record</button>
      </view>
    </view>

    <view class="log-card">
      <view class="section-header">
        <text class="section-title">Session Record</text>
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
  --imu-page-background: var(--color-background);
  --imu-surface-background: var(--color-surface);
  --imu-surface-muted-background: var(--color-surface-highlight);
  --imu-text-color: var(--color-text-primary);
  --imu-muted-text-color: var(--color-text-secondary);
  --imu-primary-background: var(--color-primary);
  --imu-primary-text: #ffffff;
  --imu-secondary-background: var(--imu-surface-muted-background, #edf2f7);
  --imu-secondary-text: var(--imu-text-color);
  --imu-border-color: var(--border-color-default, #e5e7eb);
  --imu-glow-x: rgba(255, 94, 87, 0.12);
  --imu-glow-y: rgba(52, 199, 89, 0.12);
  --imu-glow-z: rgba(10, 132, 255, 0.12);
  display: flex;
  flex-direction: column;
  gap: 16px;
  padding: 24px;
  background-color: var(--imu-page-background);
}

.hero-card,
.data-card,
.control-card,
.log-card,
.status-card {
  border-radius: 16px;
  border: var(--border-width-thin, 1px) solid var(--imu-border-color);
  background-color: var(--imu-surface-background);
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
  color: var(--imu-muted-text-color);
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
  color: var(--imu-text-color);
}

.hero-chip {
  padding: 8px 12px;
  border-radius: 999px;
  background-color: var(--imu-secondary-background);
  color: var(--imu-text-color);
  font-size: 12px;
  font-weight: 700;
}

.subtitle {
  font-size: 14px;
  line-height: 20px;
  color: var(--imu-muted-text-color);
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
  color: var(--imu-muted-text-color);
  text-transform: uppercase;
}

.status-value {
  font-size: 20px;
  font-weight: 700;
  color: var(--imu-text-color);
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
  color: var(--imu-text-color);
}

.section-meta {
  font-size: 12px;
  color: var(--imu-muted-text-color);
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
  border: var(--border-width-thin, 1px) solid var(--imu-border-color);
}

.axis-x {
  background-color: var(--imu-glow-x);
}

.axis-y {
  background-color: var(--imu-glow-y);
}

.axis-z {
  background-color: var(--imu-glow-z);
}

.axis-label {
  font-size: 12px;
  color: var(--imu-muted-text-color);
  text-transform: uppercase;
}

.axis-value {
  font-size: 26px;
  font-weight: 700;
  color: var(--imu-text-color);
}

.axis-unit {
  font-size: 12px;
  color: var(--imu-muted-text-color);
}

.reading-meta {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.meta-line {
  font-size: 14px;
  color: var(--imu-text-color);
}

.button-grid {
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
  gap: 12px;
}

.btn {
  min-width: 140px;
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
  background-color: var(--imu-secondary-background);
}

.log-text {
  font-size: 12px;
  line-height: 18px;
  color: var(--imu-text-color);
}
</style>
