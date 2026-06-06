<script setup>
import wx from 'wx';

export default {
  onLoad() {
    console.log('Filter test page loaded');
  },
};
</script>

<page>
  <view class="container">
    <view class="title">Filter</view>
    <view class="page-subtitle">
      Media and thumbnail treatments that use filter as part of realistic preview states.
    </view>

    <view class="card section">
      <text class="label">Featured Cover</text>
      <view class="media-card drop-shadow">
        <view class="mock-artwork">
          <view class="color-band bg-red"></view>
          <view class="color-band bg-green"></view>
          <view class="color-band bg-blue"></view>
        </view>
        <text class="media-title">Morning Brief</text>
        <text class="media-copy">Drop shadow helps the cover float over the page surface.</text>
      </view>
    </view>

    <view class="card section">
      <text class="label">Blurred Background Preview</text>
      <view class="media-card">
        <view class="hero-strip blur"></view>
        <text class="media-copy">Blur is often used behind overlays or on de-emphasized artwork.</text>
      </view>
    </view>

    <view class="card section">
      <text class="label">Archived Gallery Item</text>
      <view class="gallery-row">
        <view class="thumb grayscale"></view>
        <view class="thumb contrast-brightness"></view>
        <view class="thumb combined"></view>
      </view>
      <text class="media-copy">Gallery items can signal archive, boosted visibility, or stylized preview states.</text>
    </view>

    <view class="card section">
      <text class="label">System Mode Previews</text>
      <view class="gallery-row">
        <view class="thumb invert"></view>
        <view class="thumb opacity"></view>
    </view>
      <text class="media-copy">Invert and filter opacity are useful when previews need alternate display modes.</text>
  </view>
</page>

<style>
  .container {
    --filter-page-background: var(--color-background);
    --filter-page-background: var(--color-background);
    --filter-text-color: var(--color-text-primary);
    --filter-green-box-background: #2ecc71;
    --filter-blue-box-background: #2980b9;
    display: flex;
    display: flex;
    flex-direction: column;
    padding: var(--spacing-lg, 20px);
    background-color: var(--filter-page-background);
  }

  .title {
    font-size: 24px;
    font-weight: bold;
    margin-bottom: var(--spacing-lg, 20px);
    display: block;
    color: var(--filter-text-color);
  }

  .page-subtitle {
    font-size: 14px;
    line-height: 20px;
    color: var(--color-text-secondary);
    margin-bottom: var(--spacing-lg, 20px);
  }

  .section {
    flex-direction: column;
    gap: 12px;
    margin-bottom: var(--spacing-lg, 20px);
    padding: var(--spacing-md, 16px);
  }

  .label {
    color: var(--filter-text-color);
    font-size: 16px;
    font-weight: 700;
    display: block;
  }

  .media-card {
    display: flex;
    flex-direction: column;
    gap: 10px;
  }

  .mock-artwork,
  .hero-strip,
  .thumb {
    background-color: var(--color-surface-highlight);
    border-radius: var(--radius-sm, 8px);
  }

  .mock-artwork {
    display: flex;
    width: 180px;
    height: 112px;
    padding: 12px;
    box-sizing: border-box;
    gap: 8px;
    align-items: center;
  }

  .color-band {
    flex: 1;
    height: 88px;
    border-radius: 10px;
  }

  .hero-strip {
    width: 100%;
    height: 96px;
    background:
      linear-gradient(135deg, var(--filter-red-box-background), transparent),
      linear-gradient(45deg, var(--filter-green-box-background), transparent),
      linear-gradient(180deg, var(--filter-blue-box-background), transparent);
  }

  .gallery-row {
    display: flex;
    gap: 12px;
    flex-wrap: wrap;
  }

  .thumb {
    width: 92px;
    height: 92px;
    background:
      linear-gradient(135deg, var(--filter-red-box-background), transparent),
      linear-gradient(45deg, var(--filter-blue-box-background), transparent),
      linear-gradient(180deg, var(--filter-green-box-background), transparent);
  }

  .media-title {
    font-size: 18px;
    font-weight: 700;
    color: var(--color-text-primary);
  }

  .media-copy {
    font-size: 14px;
    line-height: 20px;
    color: var(--color-text-secondary);
  }

  .bg-red { background-color: var(--filter-red-box-background); }
  .bg-green { background-color: var(--filter-green-box-background); }
  .bg-blue { background-color: var(--filter-blue-box-background); }

  .drop-shadow {
    filter: drop-shadow(5px 5px 10px rgba(0, 0, 0, 0.5));
  }

  .blur {
    filter: blur(5px);
  }

  .grayscale {
    filter: grayscale(100%);
  }

  .invert {
    filter: invert(100%);
  }

  .opacity {
    filter: opacity(50%);
  }

  .contrast-brightness {
    filter: contrast(200%) brightness(150%);
  }

  .combined {
    filter: drop-shadow(4px 4px 5px rgba(0, 0, 0, 0.4)) blur(2px) grayscale(50%);
  }
</style>
