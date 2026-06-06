<script type="application/json" def>
{
  "navigationBarTitleText": "Barcode Detector"
}
</script>

<script setup>
import { BarcodeDetector } from 'barcode';
import code128PngAsset from '../../assets/barcode-code128-ink-demo.png';
import code128WebpAsset from '../../assets/barcode-code128-ink-demo.webp';
import ean13PngAsset from '../../assets/barcode-ean13-5901234123457.png';
import ean13WebpAsset from '../../assets/barcode-ean13-5901234123457.webp';
import qrPngAsset from '../../assets/barcode-qr-ink-demo.png';
import qrSvgAsset from '../../assets/barcode-qr-ink-demo.svg';
import qrWebpAsset from '../../assets/barcode-qr-ink-demo.webp';

const SAMPLE_ASSETS = [
  {
    id: 'qr-png',
    label: 'QR PNG',
    previewPath: '../../assets/barcode-qr-ink-demo.png',
    source: qrPngAsset,
    mimeType: 'image/png',
    expectedFormat: 'qr_code',
    expectedRawValue: 'INK-QR-DEMO',
  },
  {
    id: 'qr-svg',
    label: 'QR SVG',
    previewPath: '../../assets/barcode-qr-ink-demo.svg',
    source: qrSvgAsset,
    mimeType: 'image/svg+xml',
    expectedFormat: 'qr_code',
    expectedRawValue: 'INK-QR-DEMO',
  },
  {
    id: 'qr-webp',
    label: 'QR WebP',
    previewPath: '../../assets/barcode-qr-ink-demo.webp',
    source: qrWebpAsset,
    mimeType: 'image/webp',
    expectedFormat: 'qr_code',
    expectedRawValue: 'INK-QR-DEMO',
  },
  {
    id: 'code128-png',
    label: 'Code128 PNG',
    previewPath: '../../assets/barcode-code128-ink-demo.png',
    source: code128PngAsset,
    mimeType: 'image/png',
    expectedFormat: 'code128',
    expectedRawValue: 'INK-CODE128-12345',
  },
  {
    id: 'code128-webp',
    label: 'Code128 WebP',
    previewPath: '../../assets/barcode-code128-ink-demo.webp',
    source: code128WebpAsset,
    mimeType: 'image/webp',
    expectedFormat: 'code128',
    expectedRawValue: 'INK-CODE128-12345',
  },
  {
    id: 'ean13-png',
    label: 'EAN13 PNG',
    previewPath: '../../assets/barcode-ean13-5901234123457.png',
    source: ean13PngAsset,
    mimeType: 'image/png',
    expectedFormat: 'ean_13',
    expectedRawValue: '5901234123457',
  },
  {
    id: 'ean13-webp',
    label: 'EAN13 WebP',
    previewPath: '../../assets/barcode-ean13-5901234123457.webp',
    source: ean13WebpAsset,
    mimeType: 'image/webp',
    expectedFormat: 'ean_13',
    expectedRawValue: '5901234123457',
  },
];

function formatResults(results) {
  if (!Array.isArray(results) || results.length === 0) {
    return ['No detections'];
  }
  return results.map((item, index) => `${index + 1}. ${item.format}: ${item.rawValue}`);
}

function getSampleById(id) {
  return SAMPLE_ASSETS.find((item) => item.id === id) || SAMPLE_ASSETS[0];
}

function buildSampleCards() {
  return SAMPLE_ASSETS.map((item) => ({
    id: item.id,
    label: item.label,
    previewPath: item.previewPath,
    mimeType: item.mimeType,
    expectedFormat: item.expectedFormat,
    expectedRawValue: item.expectedRawValue,
    status: 'Ready',
    showResult: false,
    testStatus: '',
    resultLines: [],
  }));
}

function isSamplePassed(sample, results) {
  if (!Array.isArray(results) || results.length === 0) {
    return false;
  }
  return results.some((item) => (
    item
    && item.format === sample.expectedFormat
    && item.rawValue === sample.expectedRawValue
  ));
}

function getEventSampleId(event) {
  const currentTarget = event && event.currentTarget ? event.currentTarget : null;
  if (!currentTarget) {
    return null;
  }

  const dataset = currentTarget.dataset;
  if (dataset && typeof dataset.sampleId === 'string' && dataset.sampleId) {
    return dataset.sampleId;
  }

  const attributes = currentTarget.attributes;
  if (attributes && typeof attributes['data-sample-id'] === 'string') {
    return attributes['data-sample-id'];
  }

  return null;
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

async function loadImportedAsset(sample) {
  const source = sample.source;

  if (source instanceof Blob) {
    return source.arrayBuffer();
  }

  if (source instanceof ArrayBuffer) {
    return source;
  }

  if (ArrayBuffer.isView(source)) {
    return source.buffer.slice(source.byteOffset, source.byteOffset + source.byteLength);
  }

  if (typeof source === 'string') {
    if (source.startsWith('data:')) {
      return dataUrlToArrayBuffer(source);
    }
    if (source.trim().startsWith('<svg')) {
      return stringToArrayBuffer(source);
    }
    throw new Error(`Imported asset resolved to URL string: ${source}`);
  }

  throw new Error(`Unsupported imported asset type: ${typeof source}`);
}

export default {
  data: {
    supportedFormatsPreview: 'Loading...',
    sampleCards: buildSampleCards(),
  },

  async onLoad() {
    this.detector = new BarcodeDetector();
    await this.loadSupportedFormats();
  },

  setCardState(sampleId, patch) {
    const sampleCards = (this.data.sampleCards || []).map((item) => (
      item.id === sampleId ? { ...item, ...patch } : item
    ));
    this.setData({ sampleCards });
  },

  async loadSupportedFormats() {
    try {
      const formats = await BarcodeDetector.getSupportedFormats();
      this.setData({
        supportedFormatsPreview: Array.isArray(formats) && formats.length > 0
          ? formats.join(', ')
          : 'No formats reported',
      });
    } catch (error) {
      this.setData({ supportedFormatsPreview: 'Failed to load' });
    }
  },

  async detectSample(event) {
    const sampleId = getEventSampleId(event);
    const sample = getSampleById(sampleId);

    this.setCardState(sample.id, {
      status: 'Detecting...',
      showResult: true,
      testStatus: 'Running...',
      resultLines: ['Running BarcodeDetector.detect(blob)...'],
    });

    try {
      const arrayBuffer = await loadImportedAsset(sample);
      const blob = new Blob([arrayBuffer], {
        type: sample.mimeType || 'application/octet-stream',
      });
      const results = await this.detector.detect(blob);
      const passed = isSamplePassed(sample, results);
      this.setCardState(sample.id, {
        status: `Done (${results.length})`,
        showResult: true,
        testStatus: passed ? 'Pass' : 'Fail',
        resultLines: formatResults(results),
      });
    } catch (error) {
      this.setCardState(sample.id, {
        status: 'Error',
        showResult: true,
        testStatus: 'Fail',
        resultLines: [String(error)],
      });
    }
  },
};
</script>

<page>
  <view class="container">
    <view class="page-title">Barcode Detector Test</view>
    <view class="subtitle">
      Simple barcode sample page. Each image uses Blob input and shows the recognition result below.
    </view>

    <view class="card">
      <text class="section-title">Summary</text>
      <text class="meta-line">Supported Formats: {{supportedFormatsPreview}}</text>
    </view>

    <view class="sample-list">
      <view class="card sample-card" ink:for="{{sampleCards}}">
        <text class="section-title">{{item.label}}</text>
        <text class="meta-line">Expected Format: {{item.expectedFormat}}</text>
        <text class="meta-line">Expected Raw Value: {{item.expectedRawValue}}</text>
        <text class="meta-line">MIME Type: {{item.mimeType}}</text>
        <view class="preview-frame">
          <image class="preview-image" src="{{item.previewPath}}" mode="aspectFit" />
        </view>
        <view class="button-row" role="navigation">
          <button
            class="btn"
            data-sample-id="{{item.id}}"
            bindtap="detectSample"
          >
            Detect
          </button>
        </view>
        <text class="meta-line">Status: {{item.status}}</text>
        <view class="result-list" ink:if="{{item.showResult}}">
          <view class="result-item">
            <text class="result-text">Test: {{item.testStatus}}</text>
          </view>
          <view class="result-item" ink:for="{{item.resultLines}}">
            <text class="result-text">{{item}}</text>
          </view>
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
    --primary-background: var(--color-primary);
    --primary-text: #ffffff;
    --secondary-background: var(--surface-muted-background, #edf2f7);
    --secondary-text: var(--text-color);
    display: flex;
    flex-direction: column;
    padding: 24px;
    gap: 16px;
    background-color: var(--page-background);
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

  .sample-list {
    display: flex;
    flex-direction: column;
    gap: 16px;
  }

  .card {
    display: flex;
    flex-direction: column;
    gap: 8px;
    padding: var(--spacing-md, 16px);
    border-radius: var(--radius-md, 12px);
    background-color: var(--surface-background);
    border: var(--border-width-thin, 1px) solid var(--border-color-default, #e5e7eb);
  }

  .section-title {
    font-size: 18px;
    font-weight: bold;
    color: var(--text-color);
    margin-bottom: 4px;
  }

  .meta-line {
    font-size: 14px;
    color: var(--text-color);
    font-family: monospace;
  }

  .button-row {
    display: flex;
    flex-direction: row;
    gap: 12px;
    margin-top: 8px;
  }

  .btn {
    min-width: 160px;
    font-size: 14px;
    font-weight: 600;
    padding: 12px 14px;
  }

  .sample-card {
    gap: var(--spacing-sm, 10px);
  }

  .result-list {
    display: flex;
    flex-direction: column;
    gap: 8px;
    margin-top: 4px;
  }

  .result-item,
  .log-item {
    padding: 10px 12px;
    border-radius: var(--radius-sm, 8px);
    background-color: var(--surface-muted-background);
  }

  .result-text,
  .log-text {
    font-size: 13px;
    color: var(--text-color);
    font-family: monospace;
  }

  .preview-frame {
    width: 100%;
    min-height: 240px;
    display: flex;
    justify-content: center;
    align-items: center;
    background-color: var(--surface-muted-background);
    border-radius: var(--radius-md, 12px);
    padding: var(--spacing-md, 16px);
    box-sizing: border-box;
  }

  .preview-image {
    width: 100%;
    max-width: 480px;
    height: 220px;
  }
</style>
