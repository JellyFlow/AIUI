import wx from 'wx';
import elephantAsset, { mimeType as elephantMimeType } from '../../assets/elephant.png';

const CANVAS_WIDTH = 400;
const CANVAS_HEIGHT = 520;
const FRAME_INTERVAL_MS = 16;
const DEFAULT_DRAW_COUNT = 900;
const SPRITE_SIZE = 28;
const SPRITE_SOURCE_SIZE = 96;
const STATUS_SAMPLE_SIZE = 20;

function nowMs() {
  return Date.now();
}

function stringToArrayBuffer(value) {
  const bytes = new Uint8Array(value.length);
  for (let i = 0; i < value.length; i += 1) {
    bytes[i] = value.charCodeAt(i) & 0xff;
  }
  return bytes.buffer;
}

function dataUrlToArrayBuffer(dataUrl) {
  const commaIndex = dataUrl.indexOf(',');
  if (commaIndex < 0) {
    throw new Error('Invalid data URL');
  }

  const header = dataUrl.slice(0, commaIndex);
  const body = dataUrl.slice(commaIndex + 1);
  if (header.includes(';base64')) {
    return stringToArrayBuffer(atob(body));
  }
  return stringToArrayBuffer(decodeURIComponent(body));
}

async function assetToBlob(asset, mimeType) {
  if (asset instanceof Blob) {
    return asset;
  }

  if (asset instanceof ArrayBuffer) {
    return new Blob([asset], { type: mimeType });
  }

  if (ArrayBuffer.isView(asset)) {
    const buffer = asset.buffer.slice(asset.byteOffset, asset.byteOffset + asset.byteLength);
    return new Blob([buffer], { type: mimeType });
  }

  if (typeof asset === 'string') {
    if (asset.startsWith('data:')) {
      return new Blob([dataUrlToArrayBuffer(asset)], { type: mimeType });
    }

    const response = await fetch(asset);
    const buffer = await response.arrayBuffer();
    return new Blob([buffer], { type: mimeType });
  }

  throw new Error(`Unsupported asset type: ${typeof asset}`);
}

function formatMs(value) {
  return Number.isFinite(value) ? value.toFixed(1) : '0.0';
}

function formatFps(value) {
  return Number.isFinite(value) ? value.toFixed(1) : '0.0';
}

export default {
  data: {
    statusText: 'Loading',
    drawCount: DEFAULT_DRAW_COUNT,
    lastFrameMs: '0.0',
    fps: '0.0',
    toggleLabel: 'Stop',
  },

  onLoad() {
    this.bitmap = null;
    this.frameIndex = 0;
    this.running = true;
    this.frameTimes = [];
    this.drawCount = DEFAULT_DRAW_COUNT;
    this.loadBitmap();
  },

  onHide() {
    this.stopLoop();
  },

  onUnload() {
    this.stopLoop();
    if (this.bitmap && typeof this.bitmap.close === 'function') {
      this.bitmap.close();
    }
    this.bitmap = null;
  },

  async loadBitmap() {
    try {
      const blob = await assetToBlob(elephantAsset, elephantMimeType || 'image/png');
      this.bitmap = await createImageBitmap(blob);
      this.setData({
        statusText: 'Running',
        drawCount: this.drawCount,
        toggleLabel: 'Stop',
      });
      this.startLoop();
    } catch (error) {
      this.setData({
        statusText: `Load failed: ${error && error.message ? error.message : String(error)}`,
        toggleLabel: 'Start',
      });
      this.drawError(error);
    }
  },

  startLoop() {
    this.stopLoop();
    if (!this.bitmap) {
      return;
    }

    this.running = true;
    this.setData({ statusText: 'Running', toggleLabel: 'Stop' });
    this.timer = setInterval(() => {
      this.drawPerfFrame();
    }, FRAME_INTERVAL_MS);
    this.drawPerfFrame();
  },

  stopLoop() {
    if (this.timer) {
      clearInterval(this.timer);
      this.timer = null;
    }
    this.running = false;
    this.setData({ toggleLabel: 'Start' });
  },

  toggleRunning() {
    if (this.running) {
      this.stopLoop();
      this.setData({ statusText: 'Paused' });
      return;
    }
    this.startLoop();
  },

  runLowLoad() {
    this.setDrawCount(400);
  },

  runMediumLoad() {
    this.setDrawCount(900);
  },

  runHighLoad() {
    this.setDrawCount(1600);
  },

  setDrawCount(drawCount) {
    this.drawCount = drawCount;
    this.frameTimes = [];
    this.setData({
      drawCount,
      lastFrameMs: '0.0',
      fps: '0.0',
    });
    if (!this.running && this.bitmap) {
      this.drawPerfFrame();
    }
  },

  drawPerfFrame() {
    const ctx = wx.createCanvasContext('perfCanvas');
    if (!ctx || !this.bitmap) {
      return;
    }

    const startedAt = nowMs();
    const frame = this.frameIndex;
    const drawCount = this.drawCount || DEFAULT_DRAW_COUNT;
    const columns = Math.max(1, Math.floor(CANVAS_WIDTH / SPRITE_SIZE));
    const sourceWidth = Math.min(SPRITE_SOURCE_SIZE, this.bitmap.width || SPRITE_SOURCE_SIZE);
    const sourceHeight = Math.min(SPRITE_SOURCE_SIZE, this.bitmap.height || SPRITE_SOURCE_SIZE);
    const sourceX = Math.max(0, Math.floor(((this.bitmap.width || sourceWidth) - sourceWidth) / 2));
    const sourceY = Math.max(
      0,
      Math.floor(((this.bitmap.height || sourceHeight) - sourceHeight) / 2),
    );

    ctx.clearRect(0, 0, CANVAS_WIDTH, CANVAS_HEIGHT);
    ctx.fillStyle = '#0b1020';
    ctx.fillRect(0, 0, CANVAS_WIDTH, CANVAS_HEIGHT);

    for (let i = 0; i < drawCount; i += 1) {
      const col = i % columns;
      const row = Math.floor(i / columns);
      const jitterX = Math.sin((frame + i) * 0.071) * 4;
      const jitterY = Math.cos((frame + i) * 0.053) * 4;
      const x = col * SPRITE_SIZE + jitterX;
      const y = 56 + ((row * SPRITE_SIZE + jitterY) % (CANVAS_HEIGHT - 68));
      const size = 18 + ((i + frame) % 4) * 4;

      ctx.drawImage(this.bitmap, sourceX, sourceY, sourceWidth, sourceHeight, x, y, size, size);
    }

    const elapsedMs = nowMs() - startedAt;
    this.frameTimes.push(elapsedMs);
    if (this.frameTimes.length > STATUS_SAMPLE_SIZE) {
      this.frameTimes.shift();
    }
    const averageFrameMs =
      this.frameTimes.reduce((total, value) => total + value, 0) / this.frameTimes.length;
    const fps = averageFrameMs > 0 ? 1000 / averageFrameMs : 0;

    this.drawOverlay(ctx, drawCount, elapsedMs, fps);
    ctx.flush();

    this.frameIndex += 1;
    this.setData({
      lastFrameMs: formatMs(elapsedMs),
      fps: formatFps(fps),
      drawCount,
    });
  },

  drawOverlay(ctx, drawCount, elapsedMs, fps) {
    ctx.fillStyle = 'rgba(11, 16, 32, 0.82)';
    ctx.fillRect(0, 0, CANVAS_WIDTH, 48);
    ctx.font = '700 15px Arial';
    ctx.fillStyle = '#f8fafc';
    ctx.fillText(`drawImage x ${drawCount}`, 14, 20);
    ctx.font = '13px Arial';
    ctx.fillStyle = '#93c5fd';
    ctx.fillText(`frame ${formatMs(elapsedMs)}ms  avg ${formatFps(fps)} fps`, 14, 38);
  },

  drawError(error) {
    const ctx = wx.createCanvasContext('perfCanvas');
    if (!ctx) {
      return;
    }

    ctx.clearRect(0, 0, CANVAS_WIDTH, CANVAS_HEIGHT);
    ctx.fillStyle = '#111827';
    ctx.fillRect(0, 0, CANVAS_WIDTH, CANVAS_HEIGHT);
    ctx.font = '700 16px Arial';
    ctx.fillStyle = '#fecaca';
    ctx.fillText('drawImage perf asset failed', 20, 40);
    ctx.font = '13px Arial';
    ctx.fillStyle = '#fca5a5';
    ctx.fillText(String(error && error.message ? error.message : error).slice(0, 46), 20, 66);
    ctx.flush();
  },
};
