<script type="application/json" def>
{
  "navigationBarTitleText": "Image Workbench"
}
</script>

<script setup>
import wx from 'wx';

const LOG_LIMIT = 80;
const SAMPLE_SVG = `
<svg xmlns="http://www.w3.org/2000/svg" width="120" height="80" viewBox="0 0 120 80">
  <rect width="120" height="80" rx="16" fill="#0f172a" />
  <rect x="8" y="8" width="104" height="64" rx="12" fill="#1d4ed8" />
  <circle cx="34" cy="40" r="16" fill="#f8fafc" />
  <rect x="58" y="24" width="34" height="10" rx="5" fill="#bfdbfe" />
  <rect x="58" y="42" width="42" height="10" rx="5" fill="#dbeafe" />
</svg>
`.trim();

function nowLabel() {
  return new Date().toISOString().slice(11, 19);
}

function formatBytes(value) {
  if (typeof value !== 'number' || !Number.isFinite(value)) {
    return '0 B';
  }
  if (value < 1024) {
    return `${value} B`;
  }
  if (value < 1024 * 1024) {
    return `${(value / 1024).toFixed(2)} KB`;
  }
  return `${(value / (1024 * 1024)).toFixed(2)} MB`;
}

function previewPixels(view) {
  if (!view || typeof view.length !== 'number') {
    return 'N/A';
  }
  return Array.from(view.slice(0, 12)).join(', ');
}

export default {
  data: {
    cameraAvailable: false,
    cameraStatusText: 'Checking camera...',
    sampleStage: 'Ready to inspect',
    sampleBlobType: '',
    sampleBlobSize: '0 B',
    sampleBitmapSize: '0 x 0',
    sampleImageDataSize: '0 B',
    samplePixelsPreview: 'N/A',
    photoStage: 'Waiting for capture',
    photoMimeType: '',
    photoByteLength: '0 B',
    photoBlobType: '',
    photoBlobSize: '0 B',
    photoBitmapSize: '0 x 0',
    photoImageDataSize: '0 B',
    photoPixelsPreview: 'N/A',
    lastError: '',
    logs: ['Image APIs page ready'],
  },

  onLoad() {
    this.cameraContext = null;
    this.sampleBlob = null;
    this.sampleBitmap = null;
    this.sampleImageData = null;
    this.photoPayload = null;
    this.photoBlob = null;
    this.photoBitmap = null;
    this.photoImageData = null;
    this.initCameraContext();
  },

  log(message) {
    const logs = [`${nowLabel()} ${message}`, ...(this.data.logs || [])].slice(0, LOG_LIMIT);
    this.setData({ logs });
  },

  clearError() {
    if (this.data.lastError) {
      this.setData({ lastError: '' });
    }
  },

  setError(error) {
    const message = String(error);
    this.setData({ lastError: message });
    this.log(`Error: ${message}`);
  },

  ensureCameraContext(options = {}) {
    const { silent = false } = options;
    if (this.cameraContext && typeof this.cameraContext.takePhoto === 'function') {
      this.setData({
        cameraAvailable: true,
        cameraStatusText: 'Camera is ready for capture',
      });
      return true;
    }

    try {
      if (wx.media && typeof wx.media.createCameraContext === 'function') {
        this.cameraContext = wx.media.createCameraContext();
      } else {
        this.cameraContext = null;
      }
      const available = !!this.cameraContext;
      this.setData({
        cameraAvailable: available,
        cameraStatusText: available ? 'Camera is ready for capture' : 'Camera is unavailable',
      });
      if (available) {
        this.log('CameraContext acquired');
        return true;
      }

      const reason =
        wx.media && typeof wx.media.createCameraContext === 'function'
          ? 'wx.media.createCameraContext() returned undefined'
          : 'wx.media.createCameraContext() is not available';
      this.log(`CameraContext unavailable: ${reason}`);
      if (!silent) {
        this.setError(reason);
      }
      return false;
    } catch (error) {
      this.setData({
        cameraAvailable: false,
        cameraStatusText: 'Camera failed to initialize',
      });
      if (!silent) {
        this.setError(error);
      } else {
        this.log(`CameraContext initialization deferred: ${String(error)}`);
      }
      return false;
    }
  },

  initCameraContext() {
    this.ensureCameraContext({ silent: true });
  },

  async runSamplePipeline() {
    try {
      this.clearError();
      this.setData({ sampleStage: 'Running sample asset pipeline' });
      this.sampleBlob = new Blob([SAMPLE_SVG], { type: 'image/svg+xml' });
      const sampleArrayBuffer = await this.sampleBlob.arrayBuffer();
      this.sampleBitmap = await createImageBitmap(this.sampleBlob);

      const canvas = new Canvas(this.sampleBitmap.width, this.sampleBitmap.height);
      const ctx = canvas.getContext('2d');
      ctx.drawImage(this.sampleBitmap, 0, 0);
      this.sampleImageData = ctx.getImageData(0, 0, this.sampleBitmap.width, this.sampleBitmap.height);

      this.setData({
        sampleStage: 'Sample asset decoded and inspected',
        sampleBlobType: this.sampleBlob.type || 'unknown',
        sampleBlobSize: formatBytes(sampleArrayBuffer.byteLength),
        sampleBitmapSize: `${this.sampleBitmap.width} x ${this.sampleBitmap.height}`,
        sampleImageDataSize: formatBytes(this.sampleImageData.data.length),
        samplePixelsPreview: previewPixels(this.sampleImageData.data),
      });
      this.log('Sample SVG pipeline completed');
    } catch (error) {
      this.setError(error);
    }
  },

  async capturePhoto() {
    if (!this.ensureCameraContext()) {
      this.setError('CameraContext is unavailable');
      return;
    }

    try {
      this.clearError();
      this.log('takePhoto requested');
      this.photoPayload = await this.cameraContext.takePhoto({ quality: 'high' });
      this.photoBlob = null;
      this.photoBitmap = null;
      this.photoImageData = null;
      this.setData({
        photoStage: 'Capture complete, ready for processing',
        photoMimeType: this.photoPayload.mimeType || 'unknown',
        photoByteLength: formatBytes(this.photoPayload.data.byteLength || 0),
        photoBlobType: '',
        photoBlobSize: '0 B',
        photoBitmapSize: '0 x 0',
        photoImageDataSize: '0 B',
        photoPixelsPreview: 'N/A',
      });
      this.log(`Photo captured (${this.photoPayload.mimeType || 'unknown'})`);
    } catch (error) {
      this.setError(error);
    }
  },

  async runPhotoPipeline() {
    if (!this.photoPayload) {
      this.setError('Capture a photo first');
      return;
    }

    try {
      this.clearError();
      this.setData({ photoStage: 'Running capture processing pipeline' });
      this.photoBlob = new Blob([this.photoPayload.data], {
        type: this.photoPayload.mimeType || 'application/octet-stream',
      });
      const photoArrayBuffer = await this.photoBlob.arrayBuffer();
      this.photoBitmap = await createImageBitmap(this.photoBlob);

      const canvas = new Canvas(this.photoBitmap.width, this.photoBitmap.height);
      const ctx = canvas.getContext('2d');
      ctx.drawImage(this.photoBitmap, 0, 0);
      this.photoImageData = ctx.getImageData(0, 0, this.photoBitmap.width, this.photoBitmap.height);

      this.setData({
        photoStage: 'Capture decoded and inspected',
        photoBlobType: this.photoBlob.type || 'unknown',
        photoBlobSize: formatBytes(photoArrayBuffer.byteLength),
        photoBitmapSize: `${this.photoBitmap.width} x ${this.photoBitmap.height}`,
        photoImageDataSize: formatBytes(this.photoImageData.data.length),
        photoPixelsPreview: previewPixels(this.photoImageData.data),
      });
      this.log('Photo pipeline completed');
    } catch (error) {
      this.setError(error);
    }
  },
};
</script>

<page>
  <view class="container">
    <view class="page-header">
      <text class="page-kicker">Image Workbench</text>
      <text class="page-title">采集、解码与像素检查</text>
      <text class="subtitle">
        用一个真实的图像工作台来承载样片导入、拍照采集、Bitmap 解码和 ImageData 检查，而不是单独展示 API 名称。
      </text>
    </view>

    <view class="card">
      <text class="section-kicker">Workbench Summary</text>
      <text class="section-title">设备与流程概览</text>
      <text class="section-note">先看设备状态和最近一次异常，再决定是跑内置样片还是现场采集。</text>
      <view class="summary-row">
        <view class="summary-item summary-item-left">
          <text class="summary-label">Camera</text>
          <text class="summary-value">{{cameraStatusText}}</text>
        </view>
        <view class="summary-item">
          <text class="summary-label">Last Error</text>
          <text class="summary-value">{{lastError || 'None'}}</text>
        </view>
      </view>
    </view>

    <view class="card">
      <text class="section-kicker">Sample Asset</text>
      <text class="section-title">内置样片处理流程</text>
      <text class="section-note">
        使用内置 SVG 跑一遍导入、Blob、Bitmap 和像素读取流程，适合在没有相机输入时快速检查图像能力。
      </text>
      <text class="stage-line">Stage: {{sampleStage}}</text>
      <view class="metric-list">
        <text class="meta-line">Blob Package: {{sampleBlobType || 'N/A'}} / {{sampleBlobSize}}</text>
        <text class="meta-line">Decoded Bitmap: {{sampleBitmapSize}}</text>
        <text class="meta-line">Pixel Buffer: {{sampleImageDataSize}}</text>
        <text class="meta-line">Pixel Preview: {{samplePixelsPreview}}</text>
      </view>
      <view class="button-grid" role="navigation">
        <button class="btn" bindtap="runSamplePipeline">运行样片流程</button>
      </view>
    </view>

    <view class="card">
      <text class="section-kicker">Capture Pipeline</text>
      <text class="section-title">现场拍照与处理检查</text>
      <text class="section-note">
        先采集照片 payload，再把它送进 Blob、Bitmap 和 ImageData 链路，确认真实输入也能稳定被解码与检查。
      </text>
      <text class="stage-line">Stage: {{photoStage}}</text>
      <view class="metric-list">
        <text class="meta-line">Capture MIME: {{photoMimeType || 'N/A'}}</text>
        <text class="meta-line">Capture Bytes: {{photoByteLength}}</text>
        <text class="meta-line">Blob Package: {{photoBlobType || 'N/A'}} / {{photoBlobSize}}</text>
        <text class="meta-line">Decoded Bitmap: {{photoBitmapSize}}</text>
        <text class="meta-line">Pixel Buffer: {{photoImageDataSize}}</text>
        <text class="meta-line">Pixel Preview: {{photoPixelsPreview}}</text>
      </view>
      <view class="button-grid" role="navigation">
        <button class="btn" bindtap="capturePhoto">拍照采集</button>
        <button class="btn" bindtap="runPhotoPipeline">运行处理流程</button>
      </view>
    </view>

    <view class="card log-card">
      <text class="section-kicker">Processing History</text>
      <text class="section-title">处理记录</text>
      <text class="section-note">保留最近一次导入、拍照、解码和异常事件，方便值班或调试时回看处理路径。</text>
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
    --page-background: var(--color-background);
    --surface-background: var(--color-surface);
    --surface-muted-background: var(--color-surface-highlight);
    --text-color: var(--color-text-primary);
    --muted-text-color: var(--color-text-secondary);
    display: flex;
    flex-direction: column;
    padding: 24px;
    gap: 16px;
    background-color: var(--page-background);
  }

  .page-header {
    display: flex;
    flex-direction: column;
    gap: 6px;
  }

  .page-kicker {
    font-size: 12px;
    color: var(--muted-text-color);
  }

  .page-title {
    font-size: 28px;
    font-weight: bold;
    color: var(--text-color);
  }

  .subtitle {
    font-size: 14px;
    color: var(--muted-text-color);
    margin-bottom: 4px;
  }

  .card {
    display: flex;
    flex-direction: column;
    gap: 10px;
    padding: var(--spacing-md, 16px);
    border-radius: var(--radius-md, 12px);
    background-color: var(--surface-background);
    border: var(--border-width-thin, 1px) solid var(--border-color-default, #e5e7eb);
  }

  .section-kicker {
    font-size: 12px;
    color: var(--muted-text-color);
  }

  .section-title {
    font-size: 18px;
    font-weight: bold;
    color: var(--text-color);
  }

  .section-note {
    font-size: 13px;
    color: var(--muted-text-color);
  }

  .summary-row {
    display: flex;
    flex-direction: row;
    gap: 12px;
  }

  .summary-item {
    display: flex;
    flex-direction: column;
    gap: 4px;
    flex: 1;
    padding: 12px;
    border-radius: var(--radius-sm, 8px);
    background-color: var(--surface-muted-background);
  }

  .summary-item-left {
    margin-right: 2px;
  }

  .summary-label {
    font-size: 12px;
    color: var(--muted-text-color);
  }

  .summary-value {
    font-size: 14px;
    color: var(--text-color);
  }

  .stage-line {
    font-size: 13px;
    color: var(--text-color);
  }

  .metric-list {
    display: flex;
    flex-direction: column;
    gap: 6px;
  }

  .meta-line {
    font-size: 14px;
    color: var(--text-color);
    font-family: monospace;
  }

  .button-grid {
    display: flex;
    flex-direction: row;
    flex-wrap: wrap;
    gap: 12px;
    margin-top: 8px;
  }

  .btn {
    min-width: 160px;
    font-size: 14px;
    font-weight: 600;
    padding: 12px 14px;
  }

  .log-card {
    min-height: 220px;
  }

  .log-list {
    display: flex;
    flex-direction: column;
    gap: 8px;
  }

  .log-item {
    padding: 10px 12px;
    border-radius: var(--radius-sm, 8px);
    background-color: var(--surface-muted-background);
  }

  .log-text {
    font-size: 13px;
    color: var(--text-color);
    font-family: monospace;
  }
</style>
