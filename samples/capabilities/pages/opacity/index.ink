<script setup>
import wx from 'wx';

export default {
  onLoad() {
    console.log('Opacity test page loaded');
  },
};
</script>

<page>
  <view scroll-y="true" class="container">
    <view class="title">Opacity</view>
    <view class="page-subtitle">
      Real interface states where opacity controls emphasis, disabled actions, and layered overlays.
    </view>

    <view class="section">
      <text class="label">Primary And Secondary Metadata</text>
      <view class="info-card">
        <text class="card-title">Weekly Report</text>
        <text class="card-copy opacity-80">Ready for review by the product and design teams.</text>
        <text class="meta-line opacity-50">Updated 18 minutes ago</text>
      </view>
    </view>

    <view class="section">
      <text class="label">Muted Status Row</text>
      <view class="status-row">
        <view class="status-pill opacity-100"><text class="inner-text">Live</text></view>
        <view class="status-pill opacity-80"><text class="inner-text">Queued</text></view>
        <view class="status-pill opacity-50"><text class="inner-text">Draft</text></view>
        <view class="status-pill opacity-20"><text class="inner-text">Hidden</text></view>
      </view>
    </view>

    <view class="section">
      <text class="label">Disabled Action Area</text>
      <view class="action-row">
        <view class="action-button opacity-100"><text class="inner-text">Publish</text></view>
        <view class="action-button opacity-50"><text class="inner-text">Schedule</text></view>
        <view class="action-button opacity-20"><text class="inner-text">Archive</text></view>
      </view>
    </view>

    <view class="section">
      <text class="label">Layered Overlay</text>
      <view class="complex-box">
        <image class="test-img opacity-80" src="/assets/elephant.png" />
        <view class="overlay-panel opacity-60">
          <text class="inner-text">Preview Locked</text>
          <text class="overlay-copy opacity-80">Opacity helps the overlay sit above the artwork without fully hiding it.</text>
        </view>
      </view>
    </view>

  </view>
</page>

<style>
  .container {
    --opacity-page-background: var(--color-background);
    --opacity-surface-background: var(--color-surface);
    --opacity-text-color: var(--color-text-primary);
    --opacity-muted-text-color: var(--color-text-secondary);
    --opacity-section-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    --opacity-box-background: #3498db;
    --opacity-inner-box-background: #e74c3c;
    --opacity-complex-box-background: #2ecc71;
    --opacity-contrast-text-color: #ffffff;
    display: flex;
    flex-direction: column;
    padding: var(--spacing-lg, 20px);
    box-sizing: border-box;
    background-color: var(--opacity-page-background);
    width: 100vw;
  }

  .title {
    font-size: 24px;
    font-weight: bold;
    color: var(--opacity-text-color);
  }

  .page-subtitle {
    font-size: 14px;
    line-height: 20px;
    color: var(--opacity-muted-text-color);
    margin-top: var(--spacing-sm, 8px);
    margin-bottom: var(--spacing-lg, 20px);
  }

  .section {
    display: flex;
    flex-direction: column;
    gap: 12px;
    margin-bottom: 24px;
    background-color: var(--opacity-surface-background);
    padding: var(--spacing-md, 16px);
    border-radius: var(--radius-sm, 8px);
    box-shadow: var(--opacity-section-shadow);
  }

  .label {
    font-size: 16px;
    font-weight: 700;
    color: var(--opacity-text-color);
  }

  .info-card,
  .status-row,
  .action-row {
    background-color: var(--opacity-box-background);
    display: flex;
    border-radius: var(--radius-sm, 8px);
  }

  .info-card {
    flex-direction: column;
    gap: 8px;
    padding: 14px;
  }

  .card-title {
    font-size: 18px;
    font-weight: 700;
    color: var(--opacity-contrast-text-color);
  }

  .card-copy,
  .meta-line {
    font-size: 14px;
    line-height: 20px;
    color: var(--opacity-contrast-text-color);
  }

  .status-row,
  .action-row {
    gap: 12px;
    padding: 12px;
    flex-wrap: wrap;
  }

  .status-pill,
  .action-button {
    min-width: 88px;
    min-height: 44px;
    padding: 0 14px;
    display: flex;
    justify-content: center;
    align-items: center;
    border-radius: var(--radius-sm, 8px);
    background-color: var(--opacity-inner-box-background);
  }

  .complex-box {
    position: relative;
    width: 240px;
    height: 160px;
    background-color: var(--opacity-complex-box-background);
    border: var(--border-width-strong, 4px) solid var(--border-color-success, #27ae60);
    border-radius: var(--radius-md, 12px);
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: space-around;
  }

  .overlay-panel {
    position: absolute;
    left: 16px;
    right: 16px;
    bottom: 16px;
    padding: 12px;
    background-color: var(--opacity-inner-box-background);
    border-radius: var(--radius-sm, 8px);
  }

  .overlay-copy {
    margin-top: 8px;
    font-size: 12px;
    line-height: 18px;
    color: var(--opacity-contrast-text-color);
  }

  .inner-text {
    color: var(--opacity-contrast-text-color);
    font-weight: bold;
    font-size: 16px;
  }

  .test-img {
    width: 88px;
    height: 88px;
    border-radius: 44px;
  }

  .opacity-100 {
    opacity: 1.0;
  }

  .opacity-80 {
    opacity: 0.8;
  }

  .opacity-60 {
    opacity: 0.6;
  }

  .opacity-50 {
    opacity: 0.5;
  }

  .opacity-20 {
    opacity: 0.2;
  }

  .opacity-0 {
    opacity: 0.0;
  }
</style>
