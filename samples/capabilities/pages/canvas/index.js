import wx from 'wx';

const CANVAS_FRAME_INTERVAL_MS = 22;
const CANVAS_MOTION_STEP_MS = 80;

export default {
  data: {},

  onShow() {
    try {
      this.startAnimation();
    } catch (err) {
      console.error('failed to draw', err.message || err);
      console.error(err.stack);
    }
  },

  onLoad(query) {
    console.info('load page', query);
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
    this.drawDashboardFrame();
    this.timer = setInterval(() => {
      this.elapsedMs += CANVAS_FRAME_INTERVAL_MS;
      this.drawDashboardFrame();
    }, CANVAS_FRAME_INTERVAL_MS);
  },

  stopAnimation() {
    if (this.timer) {
      clearInterval(this.timer);
      this.timer = null;
    }
  },

  drawDashboardFrame() {
    const ctx = wx.createCanvasContext('myCanvas');
    if (!ctx) return;

    const frame = (this.elapsedMs || 0) / CANVAS_MOTION_STEP_MS;
    const progress = 0.72 + Math.sin(frame / 10) * 0.08;
    const pulse = (Math.sin(frame / 4) + 1) / 2;
    const dotActive = Math.floor(frame) % 18;

    ctx.clearRect(0, 0, 400, 420);
    ctx.fillStyle = '#f8fafc';
    ctx.fillRect(0, 0, 400, 420);

    this.drawPanel(ctx, 20, 20, 160, 160);
    this.drawPanel(ctx, 200, 20, 180, 160);
    this.drawPanel(ctx, 20, 200, 360, 96);
    this.drawPanel(ctx, 20, 316, 360, 84);

    this.drawProgressRing(ctx, progress, pulse);
    this.drawTrendPanel(ctx, frame);
    this.drawMessageRow(ctx, frame, dotActive);
    this.drawFooterSummary(ctx, progress);

    ctx.flush();
  },

  drawPanel(ctx, x, y, width, height) {
    ctx.fillStyle = '#ffffff';
    ctx.fillRect(x, y, width, height);
    ctx.strokeStyle = '#d7dde5';
    ctx.lineWidth = 1;
    ctx.strokeRect(x, y, width, height);
  },

  drawProgressRing(ctx, progress, pulse) {
    const centerX = 100;
    const centerY = 96;
    const radius = 34;
    const startAngle = -Math.PI / 2;
    const endAngle = startAngle + Math.PI * 2 * progress;

    ctx.font = '14px Arial';
    ctx.fillStyle = '#64748b';
    ctx.fillText('Sync Health', 34, 44);

    ctx.beginPath();
    ctx.strokeStyle = '#e2e8f0';
    ctx.lineWidth = 9;
    ctx.arc(centerX, centerY, radius, 0, Math.PI * 2);
    ctx.stroke();

    ctx.beginPath();
    ctx.strokeStyle = '#2563eb';
    ctx.lineWidth = 9;
    ctx.arc(centerX, centerY, radius, startAngle, endAngle);
    ctx.stroke();

    ctx.beginPath();
    ctx.fillStyle = `rgba(37, 99, 235, ${0.12 + pulse * 0.2})`;
    ctx.arc(centerX, centerY, 18 + pulse * 4, 0, Math.PI * 2);
    ctx.fill();

    ctx.font = '700 24px Arial';
    ctx.fillStyle = '#0f172a';
    ctx.fillText(`${Math.round(progress * 100)}%`, 71, 104);

    ctx.font = '13px Arial';
    ctx.fillStyle = '#64748b';
    ctx.fillText('Live update', 57, 146);
  },

  drawTrendPanel(ctx, frame) {
    const originX = 214;
    const originY = 150;
    const width = 150;
    const height = 92;

    ctx.font = '14px Arial';
    ctx.fillStyle = '#64748b';
    ctx.fillText('Activity Stream', originX, 48);

    ctx.strokeStyle = '#e2e8f0';
    ctx.lineWidth = 1;
    for (let i = 0; i < 4; i++) {
      const y = originY - i * 24;
      ctx.beginPath();
      ctx.moveTo(originX, y);
      ctx.lineTo(originX + width, y);
      ctx.stroke();
    }

    ctx.beginPath();
    ctx.strokeStyle = '#16a34a';
    ctx.lineWidth = 3;
    for (let i = 0; i <= 24; i++) {
      const x = originX + (i / 24) * width;
      const y =
        originY - 30 - Math.sin(frame / 6 + i * 0.45) * 18 - Math.cos(frame / 10 + i * 0.2) * 8;
      if (i === 0) {
        ctx.moveTo(x, y);
      } else {
        ctx.lineTo(x, y);
      }
    }
    ctx.stroke();

    const cursorX = originX + ((frame % 25) / 24) * width;
    const cursorY =
      originY -
      30 -
      Math.sin(frame / 6 + (frame % 25) * 0.45) * 18 -
      Math.cos(frame / 10 + (frame % 25) * 0.2) * 8;
    ctx.beginPath();
    ctx.fillStyle = '#16a34a';
    ctx.arc(cursorX, cursorY, 5, 0, Math.PI * 2);
    ctx.fill();
  },

  drawMessageRow(ctx, frame, dotActive) {
    ctx.font = '14px Arial';
    ctx.fillStyle = '#64748b';
    ctx.fillText('Message Rhythm', 34, 228);

    for (let i = 0; i < 6; i++) {
      const active = dotActive % 6 === i || (dotActive + 1) % 6 === i;
      const x = 52 + i * 54;
      const y = 264 + Math.sin(frame / 5 + i * 0.8) * (active ? 8 : 3);
      ctx.beginPath();
      ctx.fillStyle = active ? '#f97316' : '#cbd5e1';
      ctx.arc(x, y, active ? 10 : 7, 0, Math.PI * 2);
      ctx.fill();
    }

    ctx.font = '13px Arial';
    ctx.fillStyle = '#64748b';
    ctx.fillText('Inbound', 32, 286);
    ctx.fillText('Delivery', 304, 286);
  },

  drawFooterSummary(ctx, progress) {
    ctx.font = '14px Arial';
    ctx.fillStyle = '#64748b';
    ctx.fillText('Queue Summary', 34, 344);

    const cards = [
      { x: 34, title: 'Pending', value: '12' },
      { x: 146, title: 'Alerts', value: '3' },
      { x: 258, title: 'Latency', value: `${Math.round(170 - progress * 40)}ms` },
    ];

    cards.forEach((card) => {
      ctx.fillStyle = '#eff6ff';
      ctx.fillRect(card.x, 356, 90, 30);
      ctx.strokeStyle = '#bfdbfe';
      ctx.strokeRect(card.x, 356, 90, 30);
      ctx.font = '12px Arial';
      ctx.fillStyle = '#64748b';
      ctx.fillText(card.title, card.x + 8, 370);
      ctx.font = '700 14px Arial';
      ctx.fillStyle = '#0f172a';
      ctx.fillText(card.value, card.x + 8, 384);
    });
  },
};
