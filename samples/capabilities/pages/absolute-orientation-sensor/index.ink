<script type="application/json" def>
{
  "navigationBarTitleText": "Head Pose"
}
</script>

<script setup>
import wx from 'wx';

const DEFAULT_FREQUENCY = 60;
const CANVAS_SIZE = 320;
const CENTER = CANVAS_SIZE / 2;
const ATTITUDE_RADIUS = 110;
const YAW_BAR_WIDTH = 220;
const YAW_BAR_LEFT = (CANVAS_SIZE - YAW_BAR_WIDTH) / 2;
const YAW_BAR_TOP = 266;

function formatTimestamp(value) {
  if (typeof value !== 'number' || !Number.isFinite(value)) {
    return 'N/A';
  }
  return `${Math.round(value)} ms`;
}

function radiansToDegrees(value) {
  return (value * 180) / Math.PI;
}

function clamp(value, min, max) {
  return Math.min(Math.max(value, min), max);
}

function formatAngle(value) {
  if (typeof value !== 'number' || !Number.isFinite(value)) {
    return '--';
  }
  return `${value.toFixed(1)}deg`;
}

function clampPitchOffset(value) {
  return clamp(value, -45, 45) * 2;
}

function describePose(euler) {
  if (!euler) {
    return {
      poseState: 'Waiting for pose',
      poseHint: 'Start the sensor to inspect head pose and viewing posture.',
    };
  }

  const roll = Math.abs(euler.roll);
  const pitch = Math.abs(euler.pitch);

  if (roll < 8 && pitch < 8) {
    return {
      poseState: 'Stable view',
      poseHint: 'Headset posture looks centered and suitable for forward viewing.',
    };
  }

  if (pitch >= 18) {
    return {
      poseState: 'Pitch shift',
      poseHint: 'The wearer is looking noticeably up or down.',
    };
  }

  return {
    poseState: 'Tilted posture',
    poseHint: 'Roll indicates the headset is leaning left or right.',
  };
}

function quaternionToEulerDegrees(quaternion) {
  if (!Array.isArray(quaternion) || quaternion.length < 4) {
    return null;
  }

  const [x, y, z, w] = quaternion;
  if (![x, y, z, w].every((value) => typeof value === 'number' && Number.isFinite(value))) {
    return null;
  }

  const sinrCosp = 2 * (w * x + y * z);
  const cosrCosp = 1 - 2 * (x * x + y * y);
  const roll = radiansToDegrees(Math.atan2(sinrCosp, cosrCosp));

  const sinp = 2 * (w * y - z * x);
  const pitch = radiansToDegrees(Math.asin(clamp(sinp, -1, 1)));

  const sinyCosp = 2 * (w * z + x * y);
  const cosyCosp = 1 - 2 * (y * y + z * z);
  const yaw = radiansToDegrees(Math.atan2(sinyCosp, cosyCosp));

  return { roll, pitch, yaw };
}

export default {
  data: {
    available: false,
    frequency: DEFAULT_FREQUENCY,
    started: false,
    activated: false,
    hasReading: false,
    heroChip: 'READY',
    statusText: 'Create a sensor instance and press Start to begin sampling.',
    poseState: 'Waiting for pose',
    poseHint: 'Start the sensor to inspect head pose and viewing posture.',
    rollText: '--',
    pitchText: '--',
    yawText: '--',
    timestampText: 'N/A',
    lastError: '',
  },

  onLoad() {
    this.sensor = null;
    this.currentEuler = null;
    this.createSensor(true);
  },

  onUnload() {
    this.disposeSensor();
  },

  setError(message) {
    this.setData({ lastError: message });
  },

  clearError() {
    if (this.data.lastError) {
      this.setData({ lastError: '' });
    }
  },

  updateHeroState() {
    let heroChip = 'READY';
    let statusText = 'Press Start to begin live head-pose tracking.';

    if (!this.data.available) {
      heroChip = 'UNAVAILABLE';
      statusText = 'Head-pose tracking is unavailable in this runtime.';
    } else if (this.data.lastError) {
      heroChip = 'ERROR';
      statusText = this.data.lastError;
    } else if (this.data.activated && this.data.hasReading) {
      heroChip = 'LIVE';
      statusText = 'Move the device to inspect live head pose, gaze angle, and facing direction.';
    } else if (this.data.started) {
      heroChip = 'WAITING';
      statusText = 'Waiting for the first valid head-pose reading.';
    }

    this.setData({
      heroChip,
      statusText,
    });
  },

  updateReadingSnapshot() {
    const sensor = this.sensor;
    const quaternion = sensor && sensor.quaternion ? Array.from(sensor.quaternion) : null;
    const euler = quaternionToEulerDegrees(quaternion);
    const timestamp = sensor ? sensor.timestamp : null;
    const pose = describePose(euler);
    this.currentEuler = euler;
    this.setData({
      activated: !!(sensor && sensor.activated),
      hasReading: !!(sensor && sensor.hasReading),
      poseState: pose.poseState,
      poseHint: pose.poseHint,
      rollText: formatAngle(euler && euler.roll),
      pitchText: formatAngle(euler && euler.pitch),
      yawText: formatAngle(euler && euler.yaw),
      timestampText: formatTimestamp(timestamp),
    });
    this.updateHeroState();
    this.drawDashboard();
  },

  bindSensor(sensor) {
    sensor.addEventListener('activate', () => {
      this.updateReadingSnapshot();
    });

    sensor.addEventListener('reading', () => {
      this.updateReadingSnapshot();
    });

    sensor.addEventListener('error', (event) => {
      this.setData({ started: false });
      this.updateReadingSnapshot();
      const message =
        event && event.message ? `${event.error || 'error'}: ${event.message}` : 'Unknown absoluteOrientationSensor error';
      this.setError(message);
      this.updateHeroState();
      this.drawDashboard();
    });
  },

  createSensor(initial = false) {
    this.disposeSensor();
    this.currentEuler = null;

    if (typeof AbsoluteOrientationSensor === 'undefined') {
      this.sensor = null;
      this.setData({
        available: false,
        started: false,
        activated: false,
        hasReading: false,
        heroChip: 'UNAVAILABLE',
        statusText: 'Head-pose tracking is unavailable in this runtime.',
        poseState: 'Unavailable',
        poseHint: 'AbsoluteOrientationSensor support is required for live pose tracking.',
        rollText: '--',
        pitchText: '--',
        yawText: '--',
        timestampText: 'N/A',
      });
      this.drawDashboard();
      return;
    }

    try {
      const sensor = new AbsoluteOrientationSensor({ frequency: this.data.frequency });
      this.sensor = sensor;
      this.bindSensor(sensor);
      this.setData({
        available: true,
        started: false,
        activated: false,
        hasReading: false,
        heroChip: initial ? 'READY' : 'RESET',
        statusText: initial
          ? 'Press Start to begin live head-pose tracking.'
          : 'Fresh pose sensor instance created. Press Start when you are ready.',
        poseState: 'Ready',
        poseHint: 'The panel is ready to track roll, pitch, and yaw.',
        rollText: '--',
        pitchText: '--',
        yawText: '--',
        timestampText: 'N/A',
      });
      this.clearError();
      this.drawDashboard();
    } catch (error) {
      this.sensor = null;
      this.currentEuler = null;
      this.setData({
        available: false,
        started: false,
      });
      this.setError(String(error));
      this.updateHeroState();
      this.drawDashboard();
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
      this.setError('AbsoluteOrientationSensor is unavailable');
      this.updateHeroState();
      this.drawDashboard();
      return;
    }
    try {
      this.clearError();
      this.currentEuler = null;
      this.setData({
        started: true,
        activated: false,
        hasReading: false,
        rollText: '--',
        pitchText: '--',
        yawText: '--',
        timestampText: 'N/A',
      });
      this.updateHeroState();
      this.drawDashboard();
      this.sensor.start();
    } catch (error) {
      this.setData({ started: false });
      this.setError(String(error));
      this.updateHeroState();
      this.drawDashboard();
    }
  },

  recreateSensor() {
    this.createSensor(false);
  },

  drawDashboard() {
    const ctx = wx.createCanvasContext('eulerCanvas');
    if (!ctx) {
      return;
    }

    ctx.clearRect(0, 0, CANVAS_SIZE, CANVAS_SIZE);
    ctx.fillStyle = '#f6f8fb';
    ctx.fillRect(0, 0, CANVAS_SIZE, CANVAS_SIZE);

    ctx.beginPath();
    ctx.arc(CENTER, CENTER, ATTITUDE_RADIUS + 18, 0, Math.PI * 2);
    ctx.fillStyle = '#ffffff';
    ctx.fill();

    ctx.save();
    ctx.beginPath();
    ctx.arc(CENTER, CENTER, ATTITUDE_RADIUS, 0, Math.PI * 2);
    ctx.clip();

    if (this.currentEuler) {
      const roll = (this.currentEuler.roll * Math.PI) / 180;
      const pitchOffset = clampPitchOffset(this.currentEuler.pitch);

      ctx.save();
      ctx.translate(CENTER, CENTER + pitchOffset);
      ctx.rotate(roll);

      ctx.fillStyle = '#dcebff';
      ctx.fillRect(-240, -260, 480, 260);
      ctx.fillStyle = '#f4e2cf';
      ctx.fillRect(-240, 0, 480, 260);

      ctx.strokeStyle = '#33506f';
      ctx.lineWidth = 3;
      ctx.beginPath();
      ctx.moveTo(-220, 0);
      ctx.lineTo(220, 0);
      ctx.stroke();

      for (let i = -2; i <= 2; i++) {
        if (i === 0) {
          continue;
        }
        const y = i * 24;
        const lineWidth = Math.abs(i) === 2 ? 42 : 64;
        ctx.strokeStyle = 'rgba(51, 80, 111, 0.28)';
        ctx.lineWidth = 2;
        ctx.beginPath();
        ctx.moveTo(-lineWidth, y);
        ctx.lineTo(lineWidth, y);
        ctx.stroke();
      }

      ctx.restore();
    } else {
      ctx.fillStyle = '#e7f0ff';
      ctx.fillRect(CENTER - 160, CENTER - 160, 320, 160);
      ctx.fillStyle = '#f3e4d6';
      ctx.fillRect(CENTER - 160, CENTER, 320, 160);
    }

    ctx.restore();

    ctx.beginPath();
    ctx.arc(CENTER, CENTER, ATTITUDE_RADIUS, 0, Math.PI * 2);
    ctx.strokeStyle = '#d9e1ea';
    ctx.lineWidth = 4;
    ctx.stroke();

    ctx.beginPath();
    ctx.arc(CENTER, CENTER, 6, 0, Math.PI * 2);
    ctx.fillStyle = '#35506d';
    ctx.fill();

    ctx.strokeStyle = '#35506d';
    ctx.lineWidth = 4;
    ctx.beginPath();
    ctx.moveTo(CENTER - 52, CENTER);
    ctx.lineTo(CENTER - 12, CENTER);
    ctx.moveTo(CENTER + 12, CENTER);
    ctx.lineTo(CENTER + 52, CENTER);
    ctx.stroke();

    ctx.strokeStyle = 'rgba(53, 80, 109, 0.45)';
    ctx.lineWidth = 3;
    ctx.beginPath();
    ctx.moveTo(CENTER, CENTER - ATTITUDE_RADIUS - 10);
    ctx.lineTo(CENTER, CENTER - ATTITUDE_RADIUS + 12);
    ctx.stroke();

    ctx.fillStyle = '#7c8da1';
    ctx.font = '12px Arial';
    ctx.textAlign = 'center';
    ctx.fillText('ROLL / PITCH', CENTER, 32);

    ctx.fillStyle = '#24384f';
    ctx.font = 'bold 26px Arial';
    ctx.fillText(this.data.yawText, CENTER, 246);

    ctx.fillStyle = '#7c8da1';
    ctx.font = '12px Arial';
    ctx.fillText('YAW', CENTER, 226);

    ctx.fillStyle = '#e6ebf1';
    ctx.fillRect(YAW_BAR_LEFT, YAW_BAR_TOP, YAW_BAR_WIDTH, 10);
    ctx.fillStyle = '#3b82f6';
    ctx.fillRect(YAW_BAR_LEFT, YAW_BAR_TOP, YAW_BAR_WIDTH, 10);
    ctx.fillStyle = '#24384f';

    const yaw = this.currentEuler ? this.currentEuler.yaw : 0;
    const markerX = YAW_BAR_LEFT + ((yaw + 180) / 360) * YAW_BAR_WIDTH;
    ctx.fillRect(markerX - 2, YAW_BAR_TOP - 8, 4, 26);

    ctx.font = '11px Arial';
    ctx.textAlign = 'left';
    ctx.fillText('-180', YAW_BAR_LEFT, YAW_BAR_TOP + 28);
    ctx.textAlign = 'center';
    ctx.fillText('0', CENTER, YAW_BAR_TOP + 28);
    ctx.textAlign = 'right';
    ctx.fillText('180', YAW_BAR_LEFT + YAW_BAR_WIDTH, YAW_BAR_TOP + 28);
  },
};
</script>

<page>
  <view class="container">
    <view class="hero-card">
      <text class="page-kicker">Field Toolkit</text>
      <view class="hero-header">
        <text class="page-title">Head Pose Panel</text>
        <text class="hero-chip">{{heroChip}}</text>
      </view>
      <text class="subtitle">
        把姿态传感器读数转成可读的头部姿态面板，用来观察佩戴姿态、视线倾斜和当前朝向，而不是直接暴露底层传感器名称。
      </text>
    </view>

    <view class="dashboard-card">
      <canvas id="eulerCanvas" width="320" height="320" class="dashboard-canvas"></canvas>
      <text class="status-text">{{statusText}}</text>
      <text class="status-text">{{poseState}}</text>
      <text class="meta-line">{{poseHint}}</text>
      <text class="meta-line">Updated: {{timestampText}}</text>
      <text class="error-text" wx:if="{{lastError}}">{{lastError}}</text>
    </view>

    <view class="euler-grid">
      <view class="euler-card">
        <text class="euler-label">Roll</text>
        <text class="euler-value">{{rollText}}</text>
        <text class="euler-hint">Left / right lean</text>
      </view>
      <view class="euler-card">
        <text class="euler-label">Pitch</text>
        <text class="euler-value">{{pitchText}}</text>
        <text class="euler-hint">Looking up / down</text>
      </view>
      <view class="euler-card euler-card-wide">
        <text class="euler-label">Yaw</text>
        <text class="euler-value">{{yawText}}</text>
        <text class="euler-hint">Facing direction</text>
      </view>
    </view>

    <view class="control-card">
      <view class="button-grid" role="navigation">
        <button class="btn" bindtap="startSensor">Start Tracking</button>
        <button class="btn btn-secondary" bindtap="recreateSensor">Reset Sensor</button>
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
  display: flex;
  flex-direction: column;
  gap: 18px;
  padding: var(--spacing-lg, 20px);
  background-color: var(--imu-page-background);
}

.hero-card,
.dashboard-card,
.euler-card,
.control-card {
  border-radius: 16px;
  border: var(--border-width-thin, 1px) solid var(--imu-border-color);
  background-color: var(--imu-surface-background);
  box-sizing: border-box;
}

.hero-card {
  display: flex;
  flex-direction: column;
  gap: 12px;
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
  flex-wrap: wrap;
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

.dashboard-card {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: var(--spacing-sm, 10px);
  padding: 18px;
}

.dashboard-canvas {
  width: 320px;
  height: 320px;
}

.meta-line {
  font-size: 13px;
  color: var(--imu-muted-text-color);
}

.status-text {
  font-size: 15px;
  line-height: 22px;
  text-align: center;
  color: var(--imu-text-color);
}

.error-text {
  font-size: 13px;
  line-height: 20px;
  text-align: center;
  color: #ff8f8f;
}

.euler-grid {
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
  gap: 14px;
}

.euler-card {
  flex: 1 1 calc(50% - 7px);
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 8px;
  padding: 18px;
  background-color: var(--imu-surface-muted-background);
}

.euler-card-wide {
  flex-basis: 100%;
}

.euler-label {
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 1px;
  color: var(--imu-muted-text-color);
  text-transform: uppercase;
}

.euler-value {
  font-size: 34px;
  font-weight: 700;
  color: var(--imu-text-color);
}

.euler-hint {
  font-size: 13px;
  color: var(--imu-muted-text-color);
}

.button-grid {
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
  gap: 12px;
}

.control-card {
  padding: var(--spacing-md, 16px);
}

.btn {
  flex: 1;
  min-width: 140px;
  padding: 12px 14px;
  font-size: 14px;
  font-weight: 600;
}

@media (max-width: 420px) {
  .container {
    padding: var(--spacing-md, 16px);
  }

  .page-title {
    font-size: 26px;
  }

  .dashboard-canvas {
    width: 280px;
    height: 280px;
  }

  .euler-card,
  .euler-card-wide {
    flex-basis: 100%;
  }

  .euler-value {
    font-size: 30px;
  }
}
</style>
