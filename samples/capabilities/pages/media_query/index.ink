<script setup>
export default {
}
</script>

<page>
  <view class="container">
    <view class="header">Media Query</view>
    <view class="page-subtitle">
      A responsive dashboard surface that rearranges content across viewport widths and orientation.
    </view>

    <view class="dashboard-card">
      <view class="section-title">Responsive Workspace</view>
      <view class="responsive-box">
        <text class="box-text">Overview panel resizes by breakpoint</text>
      </view>
      <view class="content-grid">
        <view class="content-card">Summary</view>
        <view class="content-card">Activity</view>
        <view class="content-card">Queue</view>
      </view>
    </view>

    <view class="info-panel">
      <view class="section-title">Active Breakpoint</view>
      <view class="info-item portrait-only">Orientation: Portrait</view>
      <view class="info-item landscape-only">Orientation: Landscape</view>

      <view class="info-item mobile-only">Screen: Mobile (&lt; 500px)</view>
      <view class="info-item tablet-only">Screen: Tablet (500px - 800px)</view>
      <view class="info-item desktop-only">Screen: Desktop (&gt; 800px)</view>
    </view>

    <view class="viewport-units-demo">
      <view class="section-title">Viewport Units</view>
      <view class="vw-box">Featured rail uses 50vw</view>
      <view class="vh-box">Preview area uses 20vh</view>
    </view>
  </view>
</page>

<style>
.container {
  --media-query-page-background: var(--color-background);
  --media-query-surface-background: var(--color-surface);
  --media-query-text-color: var(--color-text-primary);
  --media-query-muted-text-color: var(--color-text-secondary);
  --media-query-responsive-default-background: #4CAF50;
  --media-query-mobile-background: #F44336;
  --media-query-tablet-background: #2196F3;
  --media-query-orientation-background: #607D8B;
  --media-query-vw-background: #9C27B0;
  --media-query-vh-background: #FF9800;
  --media-query-contrast-text-color: #ffffff;
  display: flex;
  flex-direction: column;
  width: 100%;
  height: 100%;
  padding: var(--spacing-lg, 20px);
  box-sizing: border-box;
  background-color: var(--media-query-page-background);
  gap: var(--spacing-lg, 20px);
}

.header {
  font-size: 24px;
  font-weight: bold;
  color: var(--media-query-text-color);
}

.page-subtitle {
  font-size: 14px;
  line-height: 20px;
  color: var(--media-query-muted-text-color);
}

.dashboard-card,
.info-panel,
.viewport-units-demo {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-sm, 10px);
  padding: var(--spacing-lg, 20px);
  background-color: var(--media-query-surface-background);
  border-radius: var(--radius-sm, 8px);
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.section-title {
  font-size: 16px;
  font-weight: 700;
  color: var(--media-query-text-color);
}

.responsive-box {
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: var(--media-query-responsive-default-background);
  border-radius: var(--radius-sm, 8px);
  transition: all 0.3s ease;
  
  /* Default: Desktop size */
  width: 300px;
  height: 200px;
}

.content-grid {
  display: flex;
  gap: var(--spacing-sm, 10px);
}

.content-card {
  flex: 1;
  min-height: 76px;
  border-radius: var(--radius-sm, 8px);
  background-color: var(--media-query-surface-background);
  border: var(--border-width-thin, 1px) solid var(--border-color-muted, #d1d5db);
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
  color: var(--media-query-text-color);
}

.box-text {
  color: var(--media-query-contrast-text-color);
  font-size: 16px;
  font-weight: bold;
}

.info-panel {
  padding: var(--spacing-md, 15px);
}

.info-item {
  padding: 10px;
  border-radius: 4px;
  color: var(--media-query-contrast-text-color);
  font-weight: bold;
  text-align: center;
  display: none; /* Hidden by default */
}

.viewport-units-demo {
  padding: var(--spacing-md, 15px);
}

.vw-box {
  background-color: var(--media-query-vw-background);
  color: var(--media-query-contrast-text-color);
  height: 50px;
  width: 50vw;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 4px;
}

.vh-box {
  background-color: var(--media-query-vh-background);
  color: var(--media-query-contrast-text-color);
  width: 100%;
  height: 20vh;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 4px;
}

@media (orientation: portrait) {
  .portrait-only {
    display: flex;
    background-color: var(--media-query-orientation-background);
  }
}

@media (orientation: landscape) {
  .landscape-only {
    display: flex;
    background-color: var(--media-query-orientation-background);
  }
}

@media (max-width: 500px) {
  .responsive-box {
    width: 150px;
    height: 100px;
    background-color: var(--media-query-mobile-background);
  }
  
  .box-text {
    font-size: 12px;
  }

  .mobile-only {
    display: flex;
    background-color: var(--media-query-mobile-background);
  }

  .content-grid {
    flex-direction: column;
  }
}

@media (min-width: 500px) and (max-width: 800px) {
  .responsive-box {
    width: 200px;
    height: 150px;
    background-color: var(--media-query-tablet-background);
  }

  .tablet-only {
    display: flex;
    background-color: var(--media-query-tablet-background);
  }
}

@media (min-width: 800px) {
  .desktop-only {
    display: flex;
    background-color: var(--media-query-responsive-default-background);
  }
}

</style>
