<script setup>
import wx from 'wx';

export default {
  onLoad() {
    console.log('Box Shadow test page loaded');
  },
};
</script>

<page>
  <view class="container">
    <view class="title">Box Shadow</view>

    <view class="card section">
      <text class="label">单个阴影</text>
      <view class="demo-box single-shadow"></view>
    </view>

    <view class="card section">
      <text class="label">多重阴影</text>
      <view class="demo-box multi-shadow"></view>
    </view>

    <view class="card section">
      <text class="label">圆角 + 阴影</text>
      <view class="demo-box rounded-shadow"></view>
    </view>

    <view class="card section">
      <text class="label">边框 + 背景 + 阴影</text>
      <view class="demo-box border-shadow"></view>
    </view>

    <view class="card section">
      <text class="label">卡片抬升效果</text>
      <view class="elevated-card">
        <text class="card-title">Shadow Card</text>
        <text class="card-copy">用于人工验收背景、圆角与外阴影的组合效果。</text>
      </view>
    </view>
  </view>
</page>

<style>
  .container {
    --box-shadow-page-background: var(--color-background);
    --box-shadow-surface-background: var(--color-surface);
    --box-shadow-surface-highlight-background: var(--color-surface-highlight);
    --box-shadow-text-color: var(--color-text-primary);
    --box-shadow-muted-text-color: var(--color-text-secondary);
    display: flex;
    flex-direction: column;
    padding: 20px;
    background-color: var(--box-shadow-page-background);
  }

  .title {
    font-size: 24px;
    font-weight: bold;
    margin-bottom: 20px;
    display: block;
    color: var(--box-shadow-text-color);
  }

  .section {
    flex-direction: column;
    margin-bottom: 32px;
  }

  .label {
    color: var(--box-shadow-text-color);
    font-size: 16px;
    margin-bottom: 12px;
    display: block;
  }

  .demo-box {
    width: 96px;
    height: 96px;
    background-color: var(--box-shadow-surface-background);
    border-radius: 12px;
  }

  .single-shadow {
    box-shadow: 0 8px 18px rgba(0, 0, 0, 0.18);
  }

  .multi-shadow {
    box-shadow:
      0 2px 4px rgba(0, 0, 0, 0.12),
      0 12px 24px rgba(52, 152, 219, 0.2);
  }

  .rounded-shadow {
    border-radius: 24px;
    background-color: var(--box-shadow-surface-highlight-background);
    box-shadow: 0 10px 24px rgba(41, 128, 185, 0.28);
  }

  .border-shadow {
    border: var(--border-width-default, 2px) solid var(--border-color-contrast, #2c3e50);
    background-color: var(--box-shadow-surface-highlight-background);
    box-shadow: 6px 8px 16px rgba(44, 62, 80, 0.22);
  }

  .elevated-card {
    width: 220px;
    padding: 16px;
    background-color: var(--box-shadow-surface-background);
    border-radius: 18px;
    box-shadow:
      0 1px 2px rgba(15, 23, 42, 0.08),
      0 12px 32px rgba(15, 23, 42, 0.14);
    box-sizing: border-box;
  }

  .card-title {
    display: block;
    font-size: 18px;
    font-weight: bold;
    color: var(--box-shadow-text-color);
    margin-bottom: 8px;
  }

  .card-copy {
    display: block;
    font-size: 14px;
    line-height: 20px;
    color: var(--box-shadow-muted-text-color);
  }
</style>
