<script setup>
  import wx from 'wx';

  const SAMPLE_KEY = 'storage-demo.sample';
  const SAMPLE_VALUE = 'Ink storage sample value';
  const MAX_LOGS = 8;

  export default {
    data: {
      key: 'storage-demo.key',
      value: 'Hello Storage',
      sampleKey: SAMPLE_KEY,
      sampleValue: SAMPLE_VALUE,
      result: 'Use the buttons below to test wx.storage APIs.',
      resultType: 'info',
      logs: [],
    },

    onLoad() {
      console.log('Storage test page loaded');
    },

    onKeyInput(e) {
      this.setData({ key: e.currentTarget.value });
    },

    onValueInput(e) {
      this.setData({ value: e.currentTarget.value });
    },

    formatValue(value) {
      if (typeof value === 'string') {
        return value.length ? `"${value}"` : '""';
      }
      if (value === undefined) {
        return 'undefined';
      }
      try {
        return JSON.stringify(value);
      } catch (_error) {
        return String(value);
      }
    },

    pushLog(kind, message) {
      const timestamp = new Date().toISOString().slice(11, 19);
      const nextLogs = [
        { id: `${Date.now()}-${Math.random()}`, kind, message: `[${timestamp}] ${message}` },
        ...this.data.logs,
      ].slice(0, MAX_LOGS);
      this.setData({ logs: nextLogs });
    },

    setResult(resultType, result) {
      this.setData({ resultType, result });
      this.pushLog(resultType, result);
    },

    requireKey(actionName) {
      if (this.data.key) {
        return true;
      }
      this.setResult('error', `${actionName} failed: key is required.`);
      return false;
    },

    onSetStorage() {
      if (!this.requireKey('Set')) {
        return;
      }
      try {
        wx.setStorageSync(this.data.key, this.data.value);
        this.setResult('success', `Set "${this.data.key}" => ${this.formatValue(this.data.value)}`);
      } catch (error) {
        this.setResult('error', `Set failed: ${String(error)}`);
      }
    },

    onGetStorage() {
      if (!this.requireKey('Get')) {
        return;
      }
      try {
        const value = wx.getStorageSync(this.data.key);
        this.setResult('success', `Get "${this.data.key}" => ${this.formatValue(value)}`);
      } catch (error) {
        this.setResult('error', `Get failed: ${String(error)}`);
      }
    },

    onRemoveStorage() {
      if (!this.requireKey('Remove')) {
        return;
      }
      try {
        wx.removeStorageSync(this.data.key);
        this.setResult('success', `Removed "${this.data.key}".`);
      } catch (error) {
        this.setResult('error', `Remove failed: ${String(error)}`);
      }
    },

    onClearStorage() {
      try {
        wx.clearStorageSync();
        this.setResult('success', 'Cleared all storage entries.');
      } catch (error) {
        this.setResult('error', `Clear failed: ${String(error)}`);
      }
    },

    onWriteSample() {
      try {
        wx.setStorageSync(this.data.sampleKey, this.data.sampleValue);
        this.setData({
          key: this.data.sampleKey,
          value: this.data.sampleValue,
        });
        this.setResult(
          'success',
          `Write Sample stored "${this.data.sampleKey}" => ${this.formatValue(this.data.sampleValue)}`
        );
      } catch (error) {
        this.setResult('error', `Write Sample failed: ${String(error)}`);
      }
    },

    onReadSample() {
      try {
        const value = wx.getStorageSync(this.data.sampleKey);
        this.setData({
          key: this.data.sampleKey,
          value: typeof value === 'string' ? value : this.data.value,
        });
        this.setResult(
          'success',
          `Read Sample got "${this.data.sampleKey}" => ${this.formatValue(value)}`
        );
      } catch (error) {
        this.setResult('error', `Read Sample failed: ${String(error)}`);
      }
    },
  };
</script>

<page>
  <view class="container">
    <view class="page-title">Storage API</view>
    <text class="page-description">
      Test wx.storage sync APIs with manual inputs and quick sample actions.
    </text>

    <view class="card section">
      <view class="title">Inputs</view>
      <text class="label">Key</text>
      <input
        class="text-input"
        value="{{key}}"
        placeholder="Enter a storage key"
        bindinput="onKeyInput"
      />

      <text class="label">Value</text>
      <textarea
        class="text-area"
        value="{{value}}"
        placeholder="Enter a storage value"
        bindinput="onValueInput"
      />
    </view>

    <view class="card section">
      <view class="title">CRUD Actions</view>
      <view class="btn-row">
        <button class="btn btn-primary" bindtap="onSetStorage">Set</button>
        <button class="btn btn-secondary" bindtap="onGetStorage">Get</button>
      </view>
      <view class="btn-row">
        <button class="btn btn-secondary" bindtap="onRemoveStorage">Remove</button>
        <button class="btn btn-danger" bindtap="onClearStorage">Clear</button>
      </view>
    </view>

    <view class="card section">
      <view class="title">Quick Actions</view>
      <text class="hint">Sample key: {{sampleKey}}</text>
      <text class="hint">Sample value: {{sampleValue}}</text>
      <view class="btn-row">
        <button class="btn btn-primary" bindtap="onWriteSample">Write Sample</button>
        <button class="btn btn-secondary" bindtap="onReadSample">Read Sample</button>
      </view>
    </view>

    <view class="card section">
      <view class="title">Latest Result</view>
      <view class="result-box result-{{resultType}}">
        <text class="result-text">{{result}}</text>
      </view>
    </view>

    <view class="card section">
      <view class="title">Operation Log</view>
      <view ink:if="{{logs.length}}">
        <view class="log-item" ink:for="{{logs}}" ink:key="id">
          <text class="log-kind log-kind-{{item.kind}}">{{item.kind}}</text>
          <text class="log-message">{{item.message}}</text>
        </view>
      </view>
      <text class="hint" ink:else>No operations yet.</text>
    </view>
  </view>
</page>

<style>
  .container {
    display: flex;
    flex-direction: column;
    padding: var(--theme-padding, 20px);
  }

  .page-title {
    font-size: 24px;
    font-weight: bold;
    margin-bottom: 8px;
  }

  .page-description {
    font-size: 14px;
    margin-bottom: var(--spacing-lg, 20px);
  }

  .card {
    border: var(--theme-border);
    border-radius: var(--theme-radius, 12px);
    padding: var(--card-padding, 16px);
    margin-bottom: var(--spacing-lg, 20px);
  }

  .section {
    flex-direction: column;
  }

  .title {
    font-size: 16px;
    font-weight: bold;
    margin-bottom: 12px;
    padding-bottom: 8px;
    border-bottom: var(--border-width-default, 2px) solid var(--border-color-accent, var(--theme-color, #1989fa));
  }

  .label {
    font-size: 13px;
    font-weight: bold;
    margin-bottom: 6px;
  }

  .text-input {
    width: 100%;
    border: var(--input-border-width, var(--border-width-thin, 1px)) solid var(--input-border-color, var(--border-color-default, #d0d0d0));
    border-radius: var(--input-radius, 8px);
    box-sizing: border-box;
    padding: var(--input-padding-y, 10px) var(--input-padding-x, 14px);
    font-size: 15px;
    margin-bottom: 12px;
  }

  .text-area {
    width: 100%;
    min-height: 88px;
    border: var(--input-border-width, var(--border-width-thin, 1px)) solid var(--input-border-color, var(--border-color-default, #d0d0d0));
    border-radius: var(--input-radius, 8px);
    box-sizing: border-box;
    padding: var(--input-padding-y, 10px) var(--input-padding-x, 14px);
    font-size: 15px;
  }

  .btn-row {
    flex-direction: row;
    margin-top: 8px;
    margin-bottom: 4px;
  }

  .btn {
    border-radius: var(--radius-sm, 8px);
    padding: 10px var(--spacing-lg, 20px);
    font-size: 14px;
    font-weight: bold;
    margin-right: 10px;
    text-align: center;
  }

  .btn-primary {
  }

  .btn-secondary {
  }

  .btn-danger {
  }

  .hint {
    font-size: 13px;
    margin-bottom: 6px;
  }

  .result-box {
    border-radius: var(--radius-sm, 8px);
    padding: var(--theme-padding, 12px);
  }

  .result-info {
    border: var(--border-width-thin, 1px) solid var(--border-color-default, #d0d0d0);
  }

  .result-success {
    border: var(--border-width-thin, 1px) solid var(--border-color-success, var(--theme-color, #34c759));
  }

  .result-error {
    border: var(--border-width-thin, 1px) solid var(--border-color-danger, #ff3b30);
  }

  .result-text {
    font-size: 14px;
  }

  .log-item {
    flex-direction: column;
    border-bottom: var(--border-width-thin, 1px) solid var(--border-color-muted, #e8e8e8);
    padding-top: 8px;
    padding-bottom: 8px;
  }

  .log-kind {
    font-size: 12px;
    font-weight: bold;
    text-transform: uppercase;
    margin-bottom: 4px;
  }

  .log-kind-success {
  }

  .log-kind-error {
  }

  .log-kind-info {
  }

  .log-message {
    font-size: 13px;
  }
</style>
