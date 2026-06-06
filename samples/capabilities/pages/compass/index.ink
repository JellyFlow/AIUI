<script type="application/json" def>
{
  "navigationBarTitleText": "Route Heading"
}
</script>

<script setup>
import wx from 'wx';

const DEFAULT_FREQUENCY = 60;
const EPSILON = 1e-6;
const FIR_WINDOW_SIZE = 5;
const CANVAS_SIZE = 320;
const CENTER = CANVAS_SIZE / 2;
const OUTER_RADIUS = 132;
const INNER_RADIUS = 106;

function formatHeading(value) {
  if (typeof value !== 'number' || !Number.isFinite(value)) {
    return '--';
  }
  return `${value.toFixed(1)} deg`;
}

function directionFromHeading(heading) {
  if (typeof heading !== 'number' || !Number.isFinite(heading)) {
    return '--';
  }
  const directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
  return directions[Math.round(heading / 45) % directions.length];
}

function makeEmptySensorState() {
  return {
    available: false,
    activated: false,
    hasReading: false,
    x: null,
    y: null,
    z: null,
    timestamp: null,
  };
}

function normalizeVector(vector) {
  const magnitude = Math.sqrt(vector.x * vector.x + vector.y * vector.y + vector.z * vector.z);
  if (!Number.isFinite(magnitude) || magnitude <= EPSILON) {
    return null;
  }
  return {
    x: vector.x / magnitude,
    y: vector.y / magnitude,
    z: vector.z / magnitude,
  };
}

function cross(a, b) {
  return {
    x: a.y * b.z - a.z * b.y,
    y: a.z * b.x - a.x * b.z,
    z: a.x * b.y - a.y * b.x,
  };
}

function computeHeadingDegrees(accelerometerState, magnetometerState) {
  const accValues = [accelerometerState.x, accelerometerState.y, accelerometerState.z];
  const magValues = [magnetometerState.x, magnetometerState.y, magnetometerState.z];
  if (![...accValues, ...magValues].every((value) => typeof value === 'number' && Number.isFinite(value))) {
    return null;
  }

  const gravity = normalizeVector({
    x: accelerometerState.x,
    y: accelerometerState.y,
    z: accelerometerState.z,
  });
  const magnetic = normalizeVector({
    x: magnetometerState.x,
    y: magnetometerState.y,
    z: magnetometerState.z,
  });
  if (!gravity || !magnetic) {
    return null;
  }

  const east = normalizeVector(cross(magnetic, gravity));
  if (!east) {
    return null;
  }

  const north = normalizeVector(cross(gravity, east));
  if (!north) {
    return null;
  }

  let heading = (Math.atan2(-north.x, north.y) * 180) / Math.PI;
  if (!Number.isFinite(heading)) {
    return null;
  }
  if (heading < 0) {
    heading += 360;
  }
  if (heading >= 360) {
    heading -= 360;
  }
  return heading;
}

function wrapHeadingDegrees(value) {
  if (typeof value !== 'number' || !Number.isFinite(value)) {
    return null;
  }
  let wrapped = value % 360;
  if (wrapped < 0) {
    wrapped += 360;
  }
  return wrapped;
}

function unwrapHeadingDegrees(previousUnwrappedHeading, nextHeading) {
  if (typeof nextHeading !== 'number' || !Number.isFinite(nextHeading)) {
    return null;
  }
  if (typeof previousUnwrappedHeading !== 'number' || !Number.isFinite(previousUnwrappedHeading)) {
    return nextHeading;
  }

  let delta = nextHeading - wrapHeadingDegrees(previousUnwrappedHeading);
  if (delta > 180) {
    delta -= 360;
  } else if (delta < -180) {
    delta += 360;
  }
  return previousUnwrappedHeading + delta;
}

function pointOnCircle(radius, degrees) {
  const radians = ((degrees - 90) * Math.PI) / 180;
  return {
    x: CENTER + Math.cos(radians) * radius,
    y: CENTER + Math.sin(radians) * radius,
  };
}

export default {
  data: {
    frequency: DEFAULT_FREQUENCY,
    heroChip: 'WAITING',
    summaryText: 'Route heading panel powered by Magnetometer and Accelerometer',
    headingText: '--',
    directionLabel: '--',
    readinessText: 'Waiting for heading lock',
    statusText: 'Waiting for both sensors to produce valid readings',
    lastError: '',
  },

  onLoad() {
    this.magnetometer = null;
    this.accelerometer = null;
    this.magnetometerState = makeEmptySensorState();
    this.accelerometerState = makeEmptySensorState();
    this.currentHeading = null;
    this.resetHeadingFilter();
    this.createSensors(true);
  },

  onShow() {
    this.drawCompass();
  },

  onUnload() {
    this.disposeSensors();
  },

  setError(message) {
    this.setData({ lastError: message });
  },

  clearError() {
    if (this.data.lastError) {
      this.setData({ lastError: '' });
    }
  },

  resetSensorState(kind, available = false) {
    const nextState = makeEmptySensorState();
    nextState.available = available;
    if (kind === 'magnetometer') {
      this.magnetometerState = nextState;
    } else {
      this.accelerometerState = nextState;
    }
  },

  clearSensorReadings(kind) {
    const state = kind === 'magnetometer' ? this.magnetometerState : this.accelerometerState;
    state.activated = false;
    state.hasReading = false;
    state.x = null;
    state.y = null;
    state.z = null;
    state.timestamp = null;
  },

  captureSensorSnapshot(kind) {
    const sensor = kind === 'magnetometer' ? this.magnetometer : this.accelerometer;
    const state = kind === 'magnetometer' ? this.magnetometerState : this.accelerometerState;
    state.activated = !!(sensor && sensor.activated);
    state.hasReading = !!(sensor && sensor.hasReading);
    state.x = sensor ? sensor.x : null;
    state.y = sensor ? sensor.y : null;
    state.z = sensor ? sensor.z : null;
    state.timestamp = sensor ? sensor.timestamp : null;
  },

  resetHeadingFilter() {
    this.headingFirSamples = [];
    this.lastUnwrappedHeading = null;
  },

  pushHeadingSample(heading) {
    const unwrappedHeading = unwrapHeadingDegrees(this.lastUnwrappedHeading, heading);
    if (typeof unwrappedHeading !== 'number' || !Number.isFinite(unwrappedHeading)) {
      return null;
    }

    this.lastUnwrappedHeading = unwrappedHeading;
    this.headingFirSamples.push(unwrappedHeading);
    if (this.headingFirSamples.length > FIR_WINDOW_SIZE) {
      this.headingFirSamples.shift();
    }

    const average =
      this.headingFirSamples.reduce((sum, sample) => sum + sample, 0) / this.headingFirSamples.length;
    return wrapHeadingDegrees(average);
  },

  updateUiState() {
    const sensorsAvailable = this.magnetometerState.available && this.accelerometerState.available;
    const rawHeading = computeHeadingDegrees(this.accelerometerState, this.magnetometerState);
    const filteredHeading =
      typeof rawHeading === 'number' && Number.isFinite(rawHeading) ? this.pushHeadingSample(rawHeading) : null;
    const headingReady = typeof filteredHeading === 'number' && Number.isFinite(filteredHeading);

    let heroChip = 'WAITING';
    let statusText = 'Waiting for both sensors to produce valid readings';
    let readinessText = 'Waiting for heading lock';
    if (!sensorsAvailable) {
      heroChip = 'UNAVAILABLE';
      statusText = 'Route heading needs both Magnetometer and Accelerometer support';
      readinessText = 'Sensors unavailable';
    } else if (this.data.lastError) {
      heroChip = 'ERROR';
      statusText = this.data.lastError;
      readinessText = 'Heading error';
    } else if (headingReady) {
      heroChip = 'HEADING READY';
      statusText = 'Route heading is updating from live fused sensor data';
      readinessText = 'Heading locked';
    }

    this.currentHeading = headingReady ? filteredHeading : null;
    this.setData({
      heroChip,
      statusText,
      readinessText,
      headingText: formatHeading(filteredHeading),
      directionLabel: headingReady ? directionFromHeading(filteredHeading) : '--',
    });
    this.drawCompass();
  },

  drawCompass() {
    const ctx = wx.createCanvasContext('compassCanvas');
    if (!ctx) {
      return;
    }

    ctx.clearRect(0, 0, CANVAS_SIZE, CANVAS_SIZE);
    ctx.fillStyle = '#f7f8fb';
    ctx.fillRect(0, 0, CANVAS_SIZE, CANVAS_SIZE);

    ctx.beginPath();
    ctx.fillStyle = '#ffffff';
    ctx.arc(CENTER, CENTER, OUTER_RADIUS, 0, Math.PI * 2);
    ctx.fill();
    ctx.strokeStyle = '#d7dbe7';
    ctx.lineWidth = 2;
    ctx.stroke();

    ctx.beginPath();
    ctx.arc(CENTER, CENTER, INNER_RADIUS, 0, Math.PI * 2);
    ctx.strokeStyle = '#e8ebf3';
    ctx.lineWidth = 1;
    ctx.stroke();

    for (let degree = 0; degree < 360; degree += 10) {
      const major = degree % 90 === 0;
      const start = pointOnCircle(major ? OUTER_RADIUS - 20 : OUTER_RADIUS - 12, degree);
      const end = pointOnCircle(OUTER_RADIUS - 2, degree);
      ctx.beginPath();
      ctx.moveTo(start.x, start.y);
      ctx.lineTo(end.x, end.y);
      ctx.strokeStyle = major ? '#364152' : '#9aa4b2';
      ctx.lineWidth = major ? 3 : 1.5;
      ctx.stroke();
    }

    const labels = [
      { text: 'N', degree: 0, color: '#ff5e57' },
      { text: 'E', degree: 90, color: '#364152' },
      { text: 'S', degree: 180, color: '#364152' },
      { text: 'W', degree: 270, color: '#364152' },
    ];
    labels.forEach((label) => {
      const point = pointOnCircle(OUTER_RADIUS - 34, label.degree);
      ctx.fillStyle = label.color;
      ctx.font = label.text === 'N' ? 'bold 24px Arial' : 'bold 18px Arial';
      ctx.textAlign = 'center';
      ctx.textBaseline = 'middle';
      ctx.fillText(label.text, point.x, point.y);
    });

    if (this.currentHeading !== null) {
      const tip = pointOnCircle(OUTER_RADIUS - 24, this.currentHeading);
      const tail = pointOnCircle(54, this.currentHeading + 180);
      const left = pointOnCircle(18, this.currentHeading + 90);
      const right = pointOnCircle(18, this.currentHeading - 90);

      ctx.beginPath();
      ctx.moveTo(tip.x, tip.y);
      ctx.lineTo(left.x, left.y);
      ctx.lineTo(tail.x, tail.y);
      ctx.lineTo(right.x, right.y);
      ctx.closePath();
      ctx.fillStyle = '#ff5e57';
      ctx.fill();

      ctx.beginPath();
      ctx.arc(CENTER, CENTER, 8, 0, Math.PI * 2);
      ctx.fillStyle = '#1f2937';
      ctx.fill();
    } else {
      const north = pointOnCircle(OUTER_RADIUS - 26, 0);
      const south = pointOnCircle(46, 180);
      ctx.beginPath();
      ctx.moveTo(north.x, north.y);
      ctx.lineTo(CENTER, CENTER - 18);
      ctx.lineTo(south.x, south.y);
      ctx.strokeStyle = '#c6ccd7';
      ctx.lineWidth = 4;
      ctx.stroke();
    }

    ctx.beginPath();
    ctx.arc(CENTER, CENTER, 40, 0, Math.PI * 2);
    ctx.fillStyle = 'rgba(255, 255, 255, 0.92)';
    ctx.fill();
    ctx.strokeStyle = '#e5e7eb';
    ctx.lineWidth = 1;
    ctx.stroke();

    ctx.fillStyle = '#111827';
    ctx.font = 'bold 22px Arial';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.fillText(this.data.directionLabel, CENTER, CENTER - 12);

    ctx.fillStyle = '#6b7280';
    ctx.font = '14px Arial';
    ctx.fillText(this.data.headingText, CENTER, CENTER + 16);
  },

  bindMagnetometer(sensor) {
    sensor.addEventListener('activate', () => {
      this.captureSensorSnapshot('magnetometer');
      this.updateUiState();
    });

    sensor.addEventListener('reading', () => {
      this.captureSensorSnapshot('magnetometer');
      this.updateUiState();
    });

    sensor.addEventListener('error', (event) => {
      this.captureSensorSnapshot('magnetometer');
      const message =
        event && event.message ? `${event.error || 'error'}: ${event.message}` : 'Unknown magnetometer error';
      this.setError(`Magnetometer ${message}`);
      this.updateUiState();
    });
  },

  bindAccelerometer(sensor) {
    sensor.addEventListener('activate', () => {
      this.captureSensorSnapshot('accelerometer');
      this.updateUiState();
    });

    sensor.addEventListener('reading', () => {
      this.captureSensorSnapshot('accelerometer');
      this.updateUiState();
    });

    sensor.addEventListener('error', (event) => {
      this.captureSensorSnapshot('accelerometer');
      const message =
        event && event.message ? `${event.error || 'error'}: ${event.message}` : 'Unknown accelerometer error';
      this.setError(`Accelerometer ${message}`);
      this.updateUiState();
    });
  },

  createSensors(initial = false) {
    this.disposeSensors();
    this.clearError();
    this.resetHeadingFilter();

    if (typeof Magnetometer === 'undefined') {
      this.resetSensorState('magnetometer', false);
      this.setError('Magnetometer is not available in this runtime');
    } else {
      try {
        this.resetSensorState('magnetometer', true);
        this.magnetometer = new Magnetometer({ frequency: this.data.frequency });
        this.bindMagnetometer(this.magnetometer);
      } catch (error) {
        this.magnetometer = null;
        this.resetSensorState('magnetometer', false);
        this.setError(`Magnetometer ${String(error)}`);
      }
    }

    if (typeof Accelerometer === 'undefined') {
      this.resetSensorState('accelerometer', false);
      this.setError(this.data.lastError || 'Accelerometer is not available in this runtime');
    } else {
      try {
        this.resetSensorState('accelerometer', true);
        this.accelerometer = new Accelerometer({ frequency: this.data.frequency });
        this.bindAccelerometer(this.accelerometer);
      } catch (error) {
        this.accelerometer = null;
        this.resetSensorState('accelerometer', false);
        this.setError(`Accelerometer ${String(error)}`);
      }
    }

    this.setData({
      summaryText: initial
        ? 'Live heading panel powered by Magnetometer and Accelerometer'
        : 'Created fresh route-heading sensor instances',
    });
    this.updateUiState();
  },

  disposeSensors() {
    if (this.magnetometer) {
      try {
        this.magnetometer.stop();
      } catch (_) {}
      this.magnetometer = null;
    }
    if (this.accelerometer) {
      try {
        this.accelerometer.stop();
      } catch (_) {}
      this.accelerometer = null;
    }
  },

  startSensors() {
    if (!this.magnetometer || !this.accelerometer) {
      this.setError('Compass requires both Magnetometer and Accelerometer instances');
      this.updateUiState();
      return;
    }

    try {
      this.clearError();
      this.resetHeadingFilter();
      this.clearSensorReadings('magnetometer');
      this.clearSensorReadings('accelerometer');
      this.currentHeading = null;
      this.setData({
        heroChip: 'WAITING',
        headingText: '--',
        directionLabel: '--',
        readinessText: 'Waiting for heading lock',
        statusText: 'Waiting for both sensors to produce valid readings',
      });
      this.drawCompass();
      this.magnetometer.start();
      this.accelerometer.start();
      this.updateUiState();
    } catch (error) {
      this.setError(String(error));
      this.updateUiState();
    }
  },

  stopSensors() {
    try {
      if (this.magnetometer) {
        this.magnetometer.stop();
      }
      if (this.accelerometer) {
        this.accelerometer.stop();
      }
      this.captureSensorSnapshot('magnetometer');
      this.captureSensorSnapshot('accelerometer');
      this.updateUiState();
    } catch (error) {
      this.setError(String(error));
      this.updateUiState();
    }
  },

  recreateSensors() {
    this.createSensors(false);
  },
};
</script>

<page>
  <view class="container">
    <view class="hero-card">
      <text class="page-kicker">Field Toolkit</text>
      <view class="hero-header">
        <text class="page-title">Route Heading Panel</text>
        <text class="hero-chip">{{heroChip}}</text>
      </view>
      <text class="subtitle">{{summaryText}}</text>
    </view>

    <view class="compass-card">
      <canvas id="compassCanvas" width="320" height="320" class="compass-canvas"></canvas>
      <view class="compass-meta">
        <text class="heading-text">{{headingText}}</text>
        <text class="direction-text">{{directionLabel}}</text>
        <text class="status-text">{{readinessText}}</text>
      </view>
      <text class="status-text">{{statusText}}</text>
      <text class="error-text" wx:if="{{lastError}}">{{lastError}}</text>
    </view>

    <view class="control-card">
      <view class="button-grid" role="navigation">
        <button class="btn" bindtap="startSensors">Start Navigation</button>
        <button class="btn btn-secondary" bindtap="stopSensors">Pause Heading</button>
        <button class="btn btn-secondary" bindtap="recreateSensors">Reset Sensors</button>
      </view>
    </view>
  </view>
</page>

<style>
.container {
  --compass-page-background: var(--color-background);
  --compass-surface-background: var(--color-surface);
  --compass-muted-background: var(--color-surface-highlight);
  --compass-text-color: var(--color-text-primary);
  --compass-muted-text-color: var(--color-text-secondary);
  --compass-primary-background: var(--color-primary);
  --compass-primary-text: #ffffff;
  --compass-secondary-background: var(--compass-muted-background, #edf2f7);
  --compass-secondary-text: var(--compass-text-color);
  --compass-border-color: var(--border-color-default, #e5e7eb);
  display: flex;
  flex-direction: column;
  gap: 18px;
  padding: 24px;
  background-color: var(--compass-page-background);
}

.hero-card,
.compass-card,
.control-card {
  display: flex;
  flex-direction: column;
  gap: 12px;
  padding: var(--spacing-lg, 20px);
  border-radius: 18px;
  border: var(--border-width-thin, 1px) solid var(--compass-border-color);
  background-color: var(--compass-surface-background);
  box-sizing: border-box;
}

.page-kicker {
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 1px;
  color: var(--compass-muted-text-color);
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
  color: var(--compass-text-color);
}

.hero-chip {
  padding: 8px 12px;
  border-radius: 999px;
  background-color: var(--compass-secondary-background);
  color: var(--compass-text-color);
  font-size: 12px;
  font-weight: 700;
}

.subtitle,
.status-text,
.error-text {
  font-size: 14px;
  line-height: 20px;
}

.subtitle,
.status-text {
  color: var(--compass-muted-text-color);
}

.error-text {
  color: #d14343;
}

.compass-card {
  align-items: center;
  background: linear-gradient(180deg, var(--compass-surface-background) 0%, #f8faff 100%);
}

.compass-canvas {
  width: 320px;
  height: 320px;
  border-radius: 20px;
  background-color: #f7f8fb;
}

.compass-meta {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 6px;
}

.heading-text {
  font-size: 32px;
  font-weight: 700;
  color: var(--compass-text-color);
}

.direction-text {
  font-size: 20px;
  font-weight: 700;
  color: var(--compass-muted-text-color);
}

.control-card {
  align-items: stretch;
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
</style>
