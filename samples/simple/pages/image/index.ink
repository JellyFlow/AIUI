<script setup>
  export default {
    data: {
      avatarSrc: '../../assets/avatar.jpg',
      elephantSrc: '../../assets/elephant.png',
      svgSrc: '../../assets/clear-day.svg'
    },
    onLoad() {
      console.log('Image test page loaded');
    }
  };
</script>

<page>
  <view class="container">
    <view class="title">Image Test</view>
    
    <view class="section">
      <view class="section-title">JPG Image</view>
      <view class="image-container">
        <image class="test-image" src="{{ avatarSrc }}" mode="aspectFill" />
      </view>
    </view>

    <view class="section">
      <view class="section-title">PNG Image</view>
      <view class="image-container">
        <image class="test-image" src="{{ elephantSrc }}" mode="aspectFit" />
      </view>
    </view>

    <view class="section">
      <view class="section-title">SVG Image</view>
      <view class="image-container">
        <image class="test-image" src="{{ svgSrc }}" mode="aspectFit" />
      </view>
    </view>
    
    <view class="section">
      <view class="section-title">Broken Image</view>
      <view class="image-container">
        <image class="test-image" src="../../assets/does-not-exist.png" mode="aspectFit" />
      </view>
    </view>
    
  </view>
</page>

<style>
  .container {
    --image-page-background: var(--color-background);
    --image-surface-background: var(--color-surface);
    --image-surface-highlight-background: var(--color-surface-highlight);
    --image-text-color: var(--color-text-primary);
    --image-muted-text-color: var(--color-text-primary);
    display: flex;
    flex-direction: column;
    width: 100%;
    background-color: var(--image-page-background);
    padding: 20px;
    box-sizing: border-box;
  }

  .title {
    font-size: 28px;
    font-weight: bold;
    color: var(--image-text-color);
    margin-bottom: 24px;
    text-align: center;
  }

  .section {
    display: flex;
    flex-direction: column;
    align-items: center;
    background-color: var(--image-surface-background);
    border-radius: 12px;
    padding: 16px;
    margin-bottom: 20px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.05);
  }

  .section-title {
    font-size: 18px;
    font-weight: 600;
    color: var(--image-muted-text-color);
    margin-bottom: 12px;
  }

  .image-container {
    width: 240px;
    height: 240px;
    background-color: var(--image-surface-highlight-background);
    border-radius: 8px;
    overflow: hidden;
    display: flex;
    justify-content: center;
    align-items: center;
  }

  .test-image {
    width: 100%;
    height: 100%;
  }
</style>
