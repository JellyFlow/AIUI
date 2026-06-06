<script type="application/json" def>
{
  "schema": {
    "data": {}
  }
}
</script>

<script setup>
import wx from 'wx';

const CANVAS_API_FRAME_INTERVAL_MS = 22;
const CANVAS_API_MOTION_STEP_MS = 90;

export default {
  onShow() {
    try {
      this.startAnimation();
    } catch (err) {
      console.error('failed to draw', err.message || err);
      console.error(err.stack);
    }
  },

  onHide() {
    this.stopAnimation();
  },

  onUnload() {
    this.stopAnimation();
  },

  startAnimation() {
    this.stopAnimation();
    this.elapsedMs = 0;
    this.drawFrame();
    this.timer = setInterval(() => {
      this.elapsedMs += CANVAS_API_FRAME_INTERVAL_MS;
      this.drawFrame();
    }, CANVAS_API_FRAME_INTERVAL_MS);
  },

  stopAnimation() {
    if (this.timer) {
      clearInterval(this.timer);
      this.timer = null;
    }
  },

  drawFrame() {
    const ctx = wx.createCanvasContext('apiCanvas');
    if (!ctx) return;

    const frame = (this.elapsedMs || 0) / CANVAS_API_MOTION_STEP_MS;

    ctx.clearRect(0, 0, 400, 760);
    ctx.fillStyle = '#f8fafc';
    ctx.fillRect(0, 0, 400, 760);

    this.drawPanel(ctx, 20, 20, 360, 200);
    this.drawPanel(ctx, 20, 240, 360, 220);
    this.drawPanel(ctx, 20, 480, 360, 240);

    this.drawWeatherCard(ctx, frame);
    this.drawRouteCard(ctx, frame);
    this.drawSpotlightCard(ctx, frame);

    ctx.flush();
  },

  drawPanel(ctx, x, y, width, height) {
    ctx.fillStyle = '#ffffff';
    ctx.fillRect(x, y, width, height);
    ctx.strokeStyle = '#d7dde5';
    ctx.lineWidth = 1;
    ctx.strokeRect(x, y, width, height);
  },

  drawWeatherCard(ctx, frame) {
    const panelX = 20;
    const panelY = 20;
    const cloudShift = (frame * 3) % 420;
    const sunX = 82 + Math.sin(frame / 18) * 14;
    const moonX = 292 + Math.cos(frame / 22) * 12;

    ctx.fillStyle = '#64748b';
    ctx.font = '14px Arial';
    ctx.fillText('Weather Card', panelX + 16, panelY + 26);

    ctx.fillStyle = '#dbeafe';
    ctx.fillRect(panelX + 16, panelY + 40, 328, 144);

    ctx.beginPath();
    ctx.fillStyle = '#f59e0b';
    ctx.arc(sunX, panelY + 84, 20, 0, Math.PI * 2);
    ctx.fill();

    ctx.beginPath();
    ctx.fillStyle = '#1e293b';
    ctx.arc(moonX, panelY + 82, 16, 0, Math.PI * 2);
    ctx.fill();

    ctx.beginPath();
    ctx.fillStyle = '#f8fafc';
    ctx.arc(moonX + 7, panelY + 77, 14, 0, Math.PI * 2);
    ctx.fill();

    this.drawCloud(ctx, panelX + 70 + (cloudShift % 60), panelY + 92, 1);
    this.drawCloud(ctx, panelX + 210 - ((cloudShift / 2) % 90), panelY + 118, 0.8);

    ctx.fillStyle = '#0f172a';
    ctx.font = '700 24px Arial';
    ctx.fillText('18°', panelX + 28, panelY + 144);
    ctx.font = '14px Arial';
    ctx.fillStyle = '#475569';
    ctx.fillText('Calm sky over the city', panelX + 28, panelY + 166);
  },

  drawCloud(ctx, x, y, scale) {
    ctx.save();
    ctx.setTransform(new DOMMatrix(scale, 0, 0, scale, x, y));
    ctx.fillStyle = '#ffffff';
    ctx.beginPath();
    ctx.moveTo(0, 16);
    ctx.quadraticCurveTo(8, 0, 20, 8);
    ctx.quadraticCurveTo(26, -10, 42, 0);
    ctx.quadraticCurveTo(54, -2, 58, 12);
    ctx.quadraticCurveTo(48, 24, 34, 22);
    ctx.lineTo(14, 22);
    ctx.quadraticCurveTo(2, 22, 0, 16);
    ctx.fill();
    ctx.restore();
  },

  drawRouteCard(ctx, frame) {
    const panelX = 20;
    const panelY = 240;
    const routeTop = panelY + 46;
    const beaconT = ((frame % 60) / 60);

    ctx.fillStyle = '#64748b';
    ctx.font = '14px Arial';
    ctx.fillText('Route Tracking', panelX + 16, panelY + 26);

    const routePath = new Path2D();
    routePath.moveTo(panelX + 40, routeTop + 124);
    routePath.bezierCurveTo(
      panelX + 110, routeTop + 24,
      panelX + 220, routeTop + 160,
      panelX + 308, routeTop + 48
    );

    ctx.strokeStyle = '#cbd5e1';
    ctx.lineWidth = 12;
    ctx.lineCap = 'round';
    ctx.stroke(routePath);

    ctx.strokeStyle = '#2563eb';
    ctx.lineWidth = 4;
    ctx.stroke(routePath);

    const markerPath = new Path2D('M0 -12 L10 10 L-10 10 Z');
    const startMatrix = new DOMMatrix(1, 0, 0, 1, panelX + 40, routeTop + 124);
    const endMatrix = new DOMMatrix(1, 0, 0, 1, panelX + 308, routeTop + 48);
    const markers = new Path2D();
    markers.addPath(markerPath, startMatrix);
    markers.addPath(markerPath, endMatrix);
    ctx.fillStyle = '#0f172a';
    ctx.fill(markers);

    const point = this.getBezierPoint(
      beaconT,
      [panelX + 40, routeTop + 124],
      [panelX + 110, routeTop + 24],
      [panelX + 220, routeTop + 160],
      [panelX + 308, routeTop + 48]
    );

    ctx.beginPath();
    ctx.fillStyle = '#f97316';
    ctx.arc(point.x, point.y, 8, 0, Math.PI * 2);
    ctx.fill();

    const beaconGlow = new Path2D();
    beaconGlow.arc(point.x, point.y, 16, 0, Math.PI * 2);
    ctx.fillStyle = 'rgba(249, 115, 22, 0.18)';
    ctx.fill(beaconGlow);

    ctx.fillStyle = '#0f172a';
    ctx.font = '700 18px Arial';
    ctx.fillText('Delivery in progress', panelX + 16, panelY + 190);
    ctx.font = '13px Arial';
    ctx.fillStyle = '#475569';
    ctx.fillText('The beacon moves along a path instead of showing raw curve primitives.', panelX + 16, panelY + 212);
  },

  drawSpotlightCard(ctx, frame) {
    const panelX = 20;
    const panelY = 480;
    const clipPath = new Path2D();
    clipPath.roundRect(panelX + 16, panelY + 42, 328, 166, 16);

    ctx.fillStyle = '#64748b';
    ctx.font = '14px Arial';
    ctx.fillText('Masked Spotlight', panelX + 16, panelY + 26);

    ctx.save();
    ctx.clip(clipPath);
    ctx.fillStyle = '#e0f2fe';
    ctx.fillRect(panelX + 16, panelY + 42, 328, 166);

    for (let i = 0; i < 8; i++) {
      const offset = ((frame * 6) + i * 48) % 420;
      ctx.beginPath();
      ctx.strokeStyle = '#93c5fd';
      ctx.lineWidth = 12;
      ctx.moveTo(panelX - 40 + offset, panelY + 208);
      ctx.lineTo(panelX + 80 + offset, panelY + 42);
      ctx.stroke();
    }

    const saved = ctx.getTransform();
    const pulseScale = 1 + Math.sin(frame / 8) * 0.08;
    ctx.setTransform(new DOMMatrix(pulseScale, 0, 0, pulseScale, panelX + 170, panelY + 118));
    ctx.fillStyle = '#0f172a';
    ctx.fillRect(-44, -28, 88, 56);
    ctx.setTransform(saved);

    ctx.fillStyle = '#ffffff';
    ctx.font = '700 16px Arial';
    ctx.fillText('Focus Mode', panelX + 138, panelY + 118);
    ctx.font = '13px Arial';
    ctx.fillText('Scanning active', panelX + 138, panelY + 140);
    ctx.restore();

    ctx.strokeStyle = '#bfdbfe';
    ctx.lineWidth = 1;
    ctx.strokeRect(panelX + 16, panelY + 42, 328, 166);

    ctx.fillStyle = '#475569';
    ctx.font = '13px Arial';
    ctx.fillText('Clip and transform make the spotlight panel feel like a real animated feature card.', panelX + 16, panelY + 228);
  },

  getBezierPoint(t, p0, p1, p2, p3) {
    const mt = 1 - t;
    return {
      x:
        mt * mt * mt * p0[0] +
        3 * mt * mt * t * p1[0] +
        3 * mt * t * t * p2[0] +
        t * t * t * p3[0],
      y:
        mt * mt * mt * p0[1] +
        3 * mt * mt * t * p1[1] +
        3 * mt * t * t * p2[1] +
        t * t * t * p3[1],
    };
  },
};
</script>

<page>
  <view class="container">
    <view class="page-title">Canvas API</view>
    <view class="page-subtitle">
      Animated visual cards that use path, clip, transform, and richer drawing APIs in realistic scenes.
    </view>
    <view class="card">
      <view class="section-title">Animated Visual Cards</view>
      <canvas id="apiCanvas" width="400" height="760" class="canvas"></canvas>
    </view>
  </view>
</page>

<style>
.container {
  display: flex;
  flex-direction: column;
  padding: var(--spacing-lg, 20px);
  background-color: var(--color-background);
}

.page-title,
.title {
  font-size: 24px;
  font-weight: bold;
  color: var(--color-text-primary);
}

.page-subtitle {
  font-size: 14px;
  line-height: 20px;
  color: var(--color-text-secondary);
  margin-top: var(--spacing-sm, 8px);
  margin-bottom: var(--spacing-lg, 20px);
}

.card {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-sm, 10px);
  padding: var(--spacing-md, 16px);
  background-color: var(--color-surface-highlight);
  border: var(--border-width-thin, 1px) solid var(--border-color-default, #ccc);
  border-radius: var(--radius-md, 12px);
}

.section-title {
  font-size: 14px;
  font-weight: 700;
  color: var(--color-text-secondary);
}

.canvas {
  width: 400px;
  height: 760px;
  border: var(--border-width-thin, 1px) solid var(--border-color-default, #ccc);
  background-color: var(--color-surface);
  border-radius: var(--radius-md, 12px);
}
</style>
