<script setup>
import { createOpenAPI } from 'open';

export default {
  data: {
    status: 'idle',
    result: '',
    error: '',
  },

  async onLoad() {
    console.log('Open module test page loaded');
    try {
      this.api = await createOpenAPI('dev');
      console.info('api is ready', this.api);
    } catch (err) {
      console.info('failed to create open api', err);
      this.setData({ status: 'error', error: String(err) });
    }
  },

  async callHello() {
    if (!this.api || !this.api.dummy) {
      this.setData({ status: 'error', error: 'API not initialized' });
      return;
    }
    
    this.setData({ status: 'loading', result: '', error: '' });
    try {
      const res = await this.api.dummy.hello();
      console.info(res);
      const text = typeof res === 'string' ? res : JSON.stringify(res, null, 2);
      this.setData({ status: 'success', result: text });
    } catch (err) {
      console.error('failed to call', err);
      this.setData({ status: 'error', error: String(err) });
    }
  },
};
</script>

<page>
  <view class="container">
    <view class="page-title">Open Module Test</view>

    <view class="info-card">
      <text class="label">Method: dummy.hello()</text>
      <text class="label">URL: https://example.com/hello</text>
    </view>

    <view class="status-row">
      <text class="status-label">Status:</text>
      <text class="status-value status-{{status}}">{{status}}</text>
    </view>

    <view class="result-box" ink:if="{{status === 'success'}}">
      <text class="result-title">Response</text>
      <text class="result-text">{{result}}</text>
    </view>

    <view class="error-box" ink:if="{{status === 'error'}}">
      <text class="error-title">Error</text>
      <text class="error-text">{{error}}</text>
    </view>

    <button class="btn" bindtap="callHello">Call dummy.hello()</button>
  </view>
</page>

<style>
  .container {
    --open-page-background: var(--color-background);
    --open-surface-background: var(--color-surface);
    --open-surface-muted-background: var(--color-surface-highlight);
    --open-text-color: var(--color-text-primary);
    --open-muted-text-color: var(--color-text-secondary);
    --open-status-idle-color: var(--color-text-secondary);
    --open-status-loading-color: var(--border-color-warning, #ff9f0a);
    --open-status-success-color: var(--border-color-success, #34c759);
    --open-status-error-color: var(--border-color-danger, #ff3b30);
    --open-result-background: var(--open-surface-muted-background, #f0fff4);
    --open-error-background: var(--open-surface-muted-background, #fff5f5);
    --open-button-background: var(--color-primary);
    --open-button-text-color: var(--open-contrast-text-color, #ffffff);
    display: flex;
    flex-direction: column;
    padding: 40px;
    background-color: var(--open-page-background);
  }

  .page-title,
  .title {
    font-size: 28px;
    font-weight: bold;
    color: var(--open-text-color);
    margin-bottom: 24px;
  }

  .info-card {
    background-color: var(--open-surface-background);
    border-radius: 10px;
    padding: 16px;
    margin-bottom: 20px;
    border: var(--border-width-thin, 1px) solid var(--border-color-default, #e5e5ea);
    flex-direction: column;
  }

  .label {
    font-size: 14px;
    color: var(--open-muted-text-color);
    margin-bottom: 4px;
    font-family: monospace;
  }

  .status-row {
    flex-direction: row;
    align-items: center;
    margin-bottom: 20px;
  }

  .status-label {
    font-size: 16px;
    color: var(--open-text-color);
    margin-right: 8px;
  }

  .status-value {
    font-size: 16px;
    font-weight: bold;
  }

  .status-idle {
    color: var(--open-status-idle-color);
  }

  .status-loading {
    color: var(--open-status-loading-color);
  }

  .status-success {
    color: var(--open-status-success-color);
  }

  .status-error {
    color: var(--open-status-error-color);
  }

  .result-box {
    background-color: var(--open-result-background);
    border-radius: 10px;
    padding: 16px;
    margin-bottom: 20px;
    border: var(--border-width-thin, 1px) solid var(--border-color-success, #34c759);
    flex-direction: column;
  }

  .result-title {
    font-size: 14px;
    font-weight: bold;
    color: var(--open-status-success-color);
    margin-bottom: 8px;
  }

  .result-text {
    font-size: 13px;
    color: var(--open-text-color);
    font-family: monospace;
  }

  .error-box {
    background-color: var(--open-error-background);
    border-radius: 10px;
    padding: 16px;
    margin-bottom: 20px;
    border: var(--border-width-thin, 1px) solid var(--border-color-danger, #ff3b30);
    flex-direction: column;
  }

  .error-title {
    font-size: 14px;
    font-weight: bold;
    color: var(--open-status-error-color);
    margin-bottom: 8px;
  }

  .error-text {
    font-size: 13px;
    color: var(--open-text-color);
    font-family: monospace;
  }

  .btn {
    background-color: var(--open-button-background);
    color: var(--open-button-text-color);
    font-size: 16px;
    font-weight: bold;
    border-radius: 8px;
    padding: 12px 20px;
    text-align: center;
  }
</style>
