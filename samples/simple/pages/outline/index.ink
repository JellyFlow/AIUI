<script setup>
import wx from 'wx';

export default {
  onLoad() {
    console.log('Outline test page loaded');
  },
};
</script>

<page>
  <view class="container">
    <view class="page-title">Outline</view>

    <view class="card section">
      <text class="label">outline: 2px solid blue</text>
      <view class="box solid-outline"></view>
    </view>

    <view class="card section">
      <text class="label">outline: 2px dashed red</text>
      <view class="box dashed-outline"></view>
    </view>

    <view class="card section">
      <text class="label">outline: 2px dotted green</text>
      <view class="box dotted-outline"></view>
    </view>

    <view class="card section">
      <text class="label">outline-offset: 4px</text>
      <view class="box offset-outline"></view>
    </view>

    <view class="card section">
      <text class="label">outline + border-radius</text>
      <view class="box rounded-outline"></view>
    </view>

    <view class="card section">
      <text class="label">outline + border</text>
      <view class="box border-and-outline"></view>
    </view>
  </view>
</page>

<style>
  .container {
    --outline-page-background: var(--color-background);
    --outline-text-color: var(--color-text-primary);
    --outline-box-background: var(--color-surface-highlight);
    display: flex;
    flex-direction: column;
    padding: 20px;
    background-color: var(--outline-page-background);
  }

  .page-title,
  .title {
    font-size: 24px;
    font-weight: bold;
    margin-bottom: 20px;
    display: block;
    color: var(--outline-text-color);
  }

  .section {
    flex-direction: column;
    margin-bottom: 40px;
  }

  .label {
    color: var(--outline-text-color);
    font-size: 16px;
    margin-bottom: 12px;
    display: block;
  }

  .box {
    width: 80px;
    height: 80px;
    background-color: var(--outline-box-background);
  }

  .solid-outline {
    outline: 2px solid blue;
  }

  .dashed-outline {
    outline: 2px dashed red;
  }

  .dotted-outline {
    outline: 2px dotted green;
  }

  .offset-outline {
    outline-width: 2px;
    outline-style: solid;
    outline-color: #ff6600;
    outline-offset: 4px;
  }

  .rounded-outline {
    border-radius: 12px;
    outline: 3px solid #9b59b6;
    outline-offset: 2px;
  }

  .border-and-outline {
    border: var(--border-width-default, 2px) solid var(--border-color-contrast, #333);
    outline: 3px solid #e74c3c;
    outline-offset: 3px;
  }
</style>
