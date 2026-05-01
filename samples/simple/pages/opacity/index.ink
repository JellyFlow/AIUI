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
    <view class="title">CSS Opacity</view>

    <view class="section">
      <text class="label">opacity: 1.0 (Default)</text>
      <view class="box opacity-100">
        <text class="inner-text">1.0</text>
      </view>
    </view>

    <view class="section">
      <text class="label">opacity: 0.8</text>
      <view class="box opacity-80">
        <text class="inner-text">0.8</text>
      </view>
    </view>

    <view class="section">
      <text class="label">opacity: 0.5</text>
      <view class="box opacity-50">
        <text class="inner-text">0.5</text>
      </view>
    </view>

    <view class="section">
      <text class="label">opacity: 0.2</text>
      <view class="box opacity-20">
        <text class="inner-text">0.2</text>
      </view>
    </view>

    <view class="section">
      <text class="label">opacity: 0.0</text>
      <view class="box opacity-0">
        <text class="inner-text">0.0</text>
      </view>
    </view>

    <view class="section">
      <text class="label">Nested Opacity (0.5 * 0.5)</text>
      <view class="box opacity-50">
        <view class="inner-box opacity-50">
          <text class="inner-text">0.25</text>
        </view>
      </view>
    </view>

    <view class="section">
      <text class="label">With Background and Border</text>
      <view class="complex-box opacity-60">
        <text class="inner-text">Text</text>
        <image class="test-img" src="/assets/elephant.png" />
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
    padding: 20px;
    box-sizing: border-box;
    background-color: var(--opacity-page-background);
    width: 100vw;
  }

  .title {
    font-size: 24px;
    font-weight: bold;
    margin-bottom: 20px;
    color: var(--opacity-text-color);
  }

  .section {
    display: flex;
    flex-direction: column;
    margin-bottom: 24px;
    background-color: var(--opacity-surface-background);
    padding: 16px;
    border-radius: 8px;
    box-shadow: var(--opacity-section-shadow);
  }

  .label {
    font-size: 16px;
    color: var(--opacity-muted-text-color);
    margin-bottom: 12px;
  }

  .box {
    width: 120px;
    height: 60px;
    background-color: var(--opacity-box-background);
    display: flex;
    justify-content: center;
    align-items: center;
    border-radius: 8px;
  }

  .inner-box {
    width: 60px;
    height: 40px;
    background-color: var(--opacity-inner-box-background);
    display: flex;
    justify-content: center;
    align-items: center;
    border-radius: 4px;
  }

  .complex-box {
    width: 200px;
    height: 120px;
    background-color: var(--opacity-complex-box-background);
    border: var(--border-width-strong, 4px) solid var(--border-color-success, #27ae60);
    border-radius: 12px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: space-around;
  }

  .inner-text {
    color: var(--opacity-contrast-text-color);
    font-weight: bold;
    font-size: 16px;
  }

  .test-img {
    width: 60px;
    height: 60px;
    border-radius: 30px;
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
