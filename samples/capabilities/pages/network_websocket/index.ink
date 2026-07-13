<script type="application/json" def>
{
  "navigationBarTitleText": "Session Channel"
}
</script>

<script setup>
import wx from 'wx';

const SOCKET_URL = 'wss://echo.websocket.org/.ws';
const WS_CANVAS_MOTION_STEP_MS = 90;
const PREVIEW_LIMIT = 120;
const MAX_FRAME_DELTA_MS = 50;

function clipText(value, limit = PREVIEW_LIMIT) {
  const text = typeof value === 'string' ? value : String(value);
  return text.length <= limit ? text : `${text.slice(0, limit)}...`;
}

function formatIncomingMessage(message) {
  if (typeof message === 'string') {
    return clipText(message);
  }
  if (message instanceof ArrayBuffer) {
    return `ArrayBuffer(${message.byteLength} bytes)`;
  }
  if (message && message.data !== undefined) {
    return formatIncomingMessage(message.data);
  }
  return clipText(String(message));
}

export default {
  data: {
    endpointUrl: SOCKET_URL,
    status: 'idle',
    sentCount: 0,
    receivedCount: 0,
    latestResponse: 'No response yet',
    sessionNote: 'Open the channel, then send a heartbeat to confirm round-trip updates.',
    lastError: '',
  },

  onShow() {
    this.startRenderLoop();
  },

  onLoad() {
    this.socketTask = null;
    this.rafId = null;
    this.lastFrameTimeMs = 0;
    this.elapsedMs = 0;
    this.renderLoopActive = false;
    this.lastHeartbeatPulseMs = -1000;
    this.lastReceivePulseMs = -1000;
  },

  onUnload() {
    this.stopRenderLoop();
    this.closeSocket(true);
  },

  onHide() {
    this.stopRenderLoop();
  },

  startRenderLoop() {
    this.stopRenderLoop();
    this.lastFrameTimeMs = 0;
    this.renderLoopActive = true;
    this.scheduleRenderFrame();
  },

  stopRenderLoop() {
    this.renderLoopActive = false;
    if (this.rafId !== null) {
      cancelAnimationFrame(this.rafId);
      this.rafId = null;
    }
  },

  scheduleRenderFrame() {
    if (!this.renderLoopActive || this.rafId !== null) {
      return;
    }
    this.rafId = requestAnimationFrame((timestamp) => {
      this.rafId = null;
      this.renderFrame(timestamp);
      this.scheduleRenderFrame();
    });
  },

  renderFrame(timestamp) {
    if (!this.renderLoopActive) {
      return;
    }
    if (this.lastFrameTimeMs) {
      const deltaMs = Math.max(0, Math.min(MAX_FRAME_DELTA_MS, timestamp - this.lastFrameTimeMs));
      this.elapsedMs += deltaMs;
    }
    this.lastFrameTimeMs = timestamp;
    this.drawStatusFrame();
  },

  drawStatusFrame() {
    const ctx = wx.createCanvasContext('websocketStatusCanvas');
    if (!ctx) return;

    const frame = (this.elapsedMs || 0) / WS_CANVAS_MOTION_STEP_MS;
    const status = this.data.status;
    const heartbeatAge = Math.max(0, (this.elapsedMs || 0) - (this.lastHeartbeatPulseMs || -1000));
    const receiveAge = Math.max(0, (this.elapsedMs || 0) - (this.lastReceivePulseMs || -1000));
    const heartbeatPulse = Math.max(0, 1 - heartbeatAge / 520);
    const receivePulse = Math.max(0, 1 - receiveAge / 520);
    const breath = (Math.sin(frame / 4) + 1) / 2;

    const primaryColor = '#22c55e';
    const lineColor = '#14532d';
    const textColor = '#86efac';
    const softTextColor = '#4ade80';

    ctx.clearRect(0, 0, 360, 200);
    ctx.fillStyle = '#020617';
    ctx.fillRect(0, 0, 360, 200);

    ctx.strokeStyle = '#15803d';
    ctx.lineWidth = 1;
    ctx.strokeRect(8, 8, 344, 184);

    ctx.fillStyle = softTextColor;
    ctx.font = '14px Arial';
    ctx.fillText('Connection Pulse', 18, 26);

    const centerX = 84;
    const centerY = 98;
    const radius = 34;
    const startAngle = -Math.PI / 2;
    const ringSweep = status === 'connecting'
      ? Math.PI * 1.4
      : Math.PI * 2 * (0.3 + breath * 0.45);
    const ringStart = status === 'connecting'
      ? startAngle + frame / 5
      : startAngle;

    ctx.beginPath();
    ctx.strokeStyle = lineColor;
    ctx.lineWidth = 7;
    ctx.arc(centerX, centerY, radius, 0, Math.PI * 2);
    ctx.stroke();

    ctx.beginPath();
    ctx.strokeStyle = primaryColor;
    ctx.lineWidth = 7;
    ctx.arc(centerX, centerY, radius, ringStart, ringStart + ringSweep);
    ctx.stroke();

    const coreRadius = 12 + breath * 4 + heartbeatPulse * 5;
    ctx.beginPath();
    ctx.fillStyle = `rgba(34, 197, 94, ${0.12 + breath * 0.16})`;
    ctx.arc(centerX, centerY, coreRadius, 0, Math.PI * 2);
    ctx.fill();

    ctx.font = '700 16px Arial';
    ctx.fillStyle = textColor;
    ctx.fillText(status.toUpperCase(), 50, 106);

    ctx.font = '13px Arial';
    ctx.fillStyle = softTextColor;
    ctx.fillText(`Sent ${this.data.sentCount}`, 32, 144);
    ctx.fillText(`Recv ${this.data.receivedCount}`, 96, 144);

    const trackX = 176;
    const trackY = 88;
    const trackWidth = 152;

    ctx.font = '14px Arial';
    ctx.fillStyle = softTextColor;
    ctx.fillText('Heartbeat Rhythm', trackX, 26);

    ctx.strokeStyle = lineColor;
    ctx.lineWidth = 1;
    for (let i = 0; i < 3; i++) {
      const y = trackY + i * 24;
      ctx.beginPath();
      ctx.moveTo(trackX, y);
      ctx.lineTo(trackX + trackWidth, y);
      ctx.stroke();
    }

    ctx.beginPath();
    ctx.strokeStyle = primaryColor;
    ctx.lineWidth = 2;
    ctx.moveTo(trackX, trackY + 24);
    for (let i = 0; i <= 24; i++) {
      const x = trackX + (i / 24) * trackWidth;
      const wave = Math.sin(frame / 5 + i * 0.55) * (3 + heartbeatPulse * 10 + receivePulse * 8);
      const receiveLift = Math.cos(frame / 6 + i * 0.35) * receivePulse * 5;
      const y = trackY + 24 - wave - receiveLift;
      ctx.lineTo(x, y);
    }
    ctx.stroke();

    const heartbeatX = trackX + 28 + ((frame * 4) % 96);
    const receiveX = trackX + 54 + ((frame * 3) % 82);
    ctx.beginPath();
    ctx.fillStyle = '#22c55e';
    ctx.arc(heartbeatX, trackY + 24 - heartbeatPulse * 16, 5 + heartbeatPulse * 4, 0, Math.PI * 2);
    ctx.fill();

    ctx.beginPath();
    ctx.fillStyle = '#86efac';
    ctx.arc(receiveX, trackY + 24 - receivePulse * 18, 5 + receivePulse * 4, 0, Math.PI * 2);
    ctx.fill();

    ctx.font = '12px Arial';
    ctx.fillStyle = softTextColor;
    ctx.fillText('send', trackX, 146);
    ctx.fillText('recv', trackX + 84, 146);

    ctx.flush();
  },

  connectSocket() {
    if (this.socketTask) {
      return;
    }

    this.setData({
      status: 'connecting',
      sentCount: 0,
      receivedCount: 0,
      latestResponse: 'Waiting for session open...',
      sessionNote: 'Connecting to the realtime session channel.',
      lastError: '',
    });

    const socket = wx.connectSocket({
      url: SOCKET_URL,
    });

    socket.onOpen(() => {
      this.setData({
        status: 'open',
        sessionNote: 'Channel is open. You can send a heartbeat now.',
        lastError: '',
      });
      this.lastReceivePulseMs = this.elapsedMs || 0;
    });

    socket.onMessage((message) => {
      const preview = formatIncomingMessage(message);
      const nextReceived = (this.data.receivedCount || 0) + 1;
      this.setData({
        status: 'open',
        receivedCount: nextReceived,
        latestResponse: preview,
        sessionNote: 'Latest response received from the channel.',
        lastError: '',
      });
      this.lastReceivePulseMs = this.elapsedMs || 0;
    });

    socket.onError((error) => {
      const text = error && error.errMsg ? error.errMsg : String(error);
      this.setData({
        status: 'error',
        sessionNote: 'The session channel reported an error.',
        lastError: text,
      });
    });

    socket.onClose(() => {
      this.socketTask = null;
      this.setData({
        status: 'closed',
        sessionNote: 'The realtime session has been closed.',
      });
    });

    this.socketTask = socket;
  },

  sendHeartbeat() {
    if (!this.socketTask || this.data.status !== 'open') {
      this.setData({
        status: 'error',
        sessionNote: 'Open the channel before sending a heartbeat.',
        lastError: 'Channel is not open.',
      });
      return;
    }

    const payload = `heartbeat:${Date.now()}`;
    try {
      this.socketTask.send(payload);
      const nextSent = (this.data.sentCount || 0) + 1;
      this.setData({
        sentCount: nextSent,
        sessionNote: 'Heartbeat sent. Waiting for round-trip response.',
        lastError: '',
      });
      this.lastHeartbeatPulseMs = this.elapsedMs || 0;
    } catch (error) {
      const text = String(error);
      this.setData({
        status: 'error',
        sessionNote: 'Sending the heartbeat failed.',
        lastError: text,
      });
    }
  },

  closeSocket(silent = false) {
    if (!this.socketTask) {
      if (!silent) {
        this.setData({
          status: this.data.status === 'idle' ? 'idle' : 'closed',
          sessionNote: 'No active session to close.',
        });
      }
      return;
    }

    try {
      this.socketTask.close();
    } catch (_) {
      this.socketTask = null;
      this.setData({
        status: 'closed',
        sessionNote: 'The session was closed locally.',
      });
    }
  },
};
</script>

<page>
  <view class="container">
    <view class="hero-card">
      <text class="page-kicker">Network &amp; Integration</text>
      <text class="page-title">Realtime Session Channel</text>
      <text class="page-description">
        用 WebSocket 打开一个可用的双向会话通道，并把回执结果作为真实的会话状态展示出来。
      </text>
    </view>

    <view class="card status-card">
      <canvas id="websocketStatusCanvas" width="360" height="200" class="status-canvas"></canvas>
    </view>

    <card class="card action-card">
      <view class="button-row" role="navigation">
        <button class="btn" bindtap="connectSocket">Open</button>
        <button class="btn" bindtap="sendHeartbeat">Heartbeat</button>
        <button class="btn" bindtap="closeSocket">Close</button>
      </view>
    </card>
  </view>
</page>

<style>
  .container {
    display: flex;
    flex-direction: column;
    padding: var(--theme-padding, 20px);
    gap: 16px;
    background-color: var(--color-background);
  }

  .hero-card,
  .card {
    display: flex;
    flex-direction: column;
    gap: 10px;
    padding: var(--spacing-md, 16px);
    border-radius: var(--radius-md, 12px);
    background-color: var(--color-surface);
    border: var(--border-width-thin, 1px) solid var(--border-color-default, #d1d1d6);
  }

  .status-card,
  .action-card {
    border: none;
  }

  .page-kicker {
    font-size: 12px;
    color: var(--color-text-secondary);
  }

  .page-title {
    font-size: 28px;
    font-weight: bold;
    color: var(--color-text-primary);
  }

  .page-description,
  .meta-line,
  .response-text {
    font-size: 14px;
    line-height: 20px;
    color: var(--color-text-secondary);
  }

  .section-title {
    font-size: 16px;
    font-weight: bold;
    color: var(--color-text-primary);
  }

  .button-row {
    display: flex;
    flex-direction: row;
    gap: 12px;
  }

  .status-canvas {
    width: 100%;
    height: 200px;
    border-radius: var(--radius-md, 10px);
    overflow: hidden;
  }

  .btn {
    flex: 1;
    font-size: 15px;
  }
</style>
