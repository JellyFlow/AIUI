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
    <view class="page-subtitle">
      Real card elevation and layered surfaces instead of isolated shadow samples.
    </view>

    <view class="card section">
      <text class="label">Quick Action Card</text>
      <view class="elevated-card single-shadow">
        <text class="card-title">New Shortcut</text>
        <text class="card-copy">A light shadow separates a small action card from the background.</text>
      </view>
    </view>

    <view class="card section">
      <text class="label">Notification Stack</text>
      <view class="notification-stack">
        <view class="stack-card stack-back"></view>
        <view class="stack-card stack-middle"></view>
        <view class="stack-card stack-front multi-shadow">
          <text class="card-title">Sync Complete</text>
          <text class="card-copy">Multiple shadows make the foreground card feel layered.</text>
        </view>
      </view>
    </view>

    <view class="card section">
      <text class="label">Rounded Media Tile</text>
      <view class="media-tile rounded-shadow">
        <text class="card-title">Weekend Mix</text>
      </view>
    </view>

    <view class="card section">
      <text class="label">Bordered Summary Panel</text>
      <view class="summary-panel border-shadow">
        <text class="card-title">Summary</text>
        <text class="card-copy">Border and shadow can work together when a panel needs stronger separation.</text>
      </view>
    </view>

    <view class="card section">
      <text class="label">Floating Detail Sheet</text>
      <view class="elevated-card">
        <text class="card-title">Trip Plan</text>
        <text class="card-copy">A larger sheet uses a softer elevation recipe to suggest modal depth.</text>
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
    padding: var(--spacing-lg, 20px);
    background-color: var(--box-shadow-page-background);
  }

  .title {
    font-size: 24px;
    font-weight: bold;
    display: block;
    color: var(--box-shadow-text-color);
  }

  .page-subtitle {
    font-size: 14px;
    line-height: 20px;
    color: var(--box-shadow-muted-text-color);
    margin-top: var(--spacing-sm, 8px);
    margin-bottom: var(--spacing-lg, 20px);
  }

  .section {
    flex-direction: column;
    gap: 12px;
    margin-bottom: var(--spacing-lg, 20px);
    padding: var(--spacing-md, 16px);
  }

  .label {
    color: var(--box-shadow-text-color);
    font-size: 16px;
    font-weight: 700;
    display: block;
  }

  .elevated-card,
  .summary-panel,
  .media-tile,
  .stack-card {
    background-color: var(--box-shadow-surface-background);
    border-radius: var(--radius-md, 12px);
  }

  .single-shadow {
    box-shadow: 0 8px 18px rgba(0, 0, 0, 0.18);
  }

  .multi-shadow {
    box-shadow:
      0 2px 4px rgba(0, 0, 0, 0.12),
      0 12px 24px rgba(52, 152, 219, 0.2);
  }

  .notification-stack {
    position: relative;
    width: 240px;
    height: 148px;
  }

  .stack-card {
    position: absolute;
    left: 0;
    right: 0;
    height: 112px;
    padding: 14px;
    box-sizing: border-box;
  }

  .stack-back {
    top: 24px;
    opacity: 0.4;
  }

  .stack-middle {
    top: 12px;
    left: 8px;
    right: 8px;
    opacity: 0.7;
  }

  .stack-front {
    top: 0;
  }

  .rounded-shadow {
    width: 180px;
    height: 104px;
    padding: 16px;
    box-sizing: border-box;
    display: flex;
    align-items: flex-end;
    background-color: var(--box-shadow-surface-highlight-background);
    box-shadow: 0 10px 24px rgba(41, 128, 185, 0.28);
    border-radius: 24px;
  }

  .border-shadow {
    width: 220px;
    padding: var(--spacing-md, 16px);
    box-sizing: border-box;
    border: var(--border-width-default, 2px) solid var(--border-color-contrast, #2c3e50);
    background-color: var(--box-shadow-surface-highlight-background);
    box-shadow: 6px 8px 16px rgba(44, 62, 80, 0.22);
  }

  .elevated-card {
    width: 220px;
    padding: var(--spacing-md, 16px);
    background-color: var(--box-shadow-surface-background);
    border-radius: 18px;
    box-shadow:
      0 1px 2px rgba(15, 23, 42, 0.08),
      0 12px 32px rgba(15, 23, 42, 0.14);
    box-sizing: border-box;
  }

  .media-tile {
    display: flex;
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
