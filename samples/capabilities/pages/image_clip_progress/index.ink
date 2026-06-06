<script setup>
  export default {
    data: {
      elephantSrc: '../../assets/elephant.png',
      avatarSrc: '../../assets/avatar.jpg',
      dotSrc: '../../assets/dot_pattern.png',
      progress: 0,
    },
    onLoad() {
      console.log('Image Clip & Progress page loaded');

      let p = 0;
      const timer = setInterval(() => {
        p += 1;
        if (p >= 100) {
          p = 100;
          clearInterval(timer);
        }
        this.setData({ progress: p });
      }, 50);
    },
  };
</script>

<page>
  <view class="container">
    <view class="title">Image Clip &amp; Progress Bar</view>
    <view class="subtitle">
      Verifies overflow: clip with border-radius on parent containers,
      aspectFill image mode, and image-background bar clipping at different widths.
    </view>

    <view class="section">
      <view class="section-title">Overflow Clip + AspectFill</view>
      <view class="section-desc">
        The image below should be clipped to the rounded container bounds.
        No sharp corners should appear outside the border-radius.
      </view>
      <view class="clip-card">
        <image class="clip-image" src="{{ elephantSrc }}" mode="aspectFill" />
      </view>
    </view>

    <view class="section">
      <view class="section-title">Image-Background Bars (Static Widths)</view>
      <view class="section-desc">
        Each bar has the same image background but a different container width.
        The image is clipped via overflow: clip to the container bounds.
      </view>

      <view class="bar-row">
        <view class="bar-container" style="width: 100%;">
          <image class="bar-bg" src="{{ avatarSrc }}" mode="aspectFill" />
        </view>
        <text class="bar-label-right">100%</text>
      </view>

      <view class="bar-row">
        <view class="bar-container" style="width: 80%;">
          <image class="bar-bg" src="{{ avatarSrc }}" mode="aspectFill" />
        </view>
        <text class="bar-label-right">80%</text>
      </view>

      <view class="bar-row">
        <view class="bar-container" style="width: 60%;">
          <image class="bar-bg" src="{{ avatarSrc }}" mode="aspectFill" />
        </view>
        <text class="bar-label-right">60%</text>
      </view>

      <view class="bar-row">
        <view class="bar-container" style="width: 40%;">
          <image class="bar-bg" src="{{ avatarSrc }}" mode="aspectFill" />
        </view>
        <text class="bar-label-right">40%</text>
      </view>

      <view class="bar-row">
        <view class="bar-container" style="width: 20%;">
          <image class="bar-bg" src="{{ avatarSrc }}" mode="aspectFill" />
        </view>
        <text class="bar-label-right">20%</text>
      </view>
    </view>

    <view class="section">
      <view class="section-title">Image-Background Bars (Second Image)</view>
      <view class="section-desc">
        Same pattern with a different image to verify clip works across various
        aspect ratios and image content.
      </view>

      <view class="bar-row">
        <view class="bar-container" style="width: 100%;">
          <image class="bar-bg" src="{{ elephantSrc }}" mode="aspectFill" />
        </view>
        <text class="bar-label-right">100%</text>
      </view>

      <view class="bar-row">
        <view class="bar-container" style="width: 70%;">
          <image class="bar-bg" src="{{ elephantSrc }}" mode="aspectFill" />
        </view>
        <text class="bar-label-right">70%</text>
      </view>

      <view class="bar-row">
        <view class="bar-container" style="width: 40%;">
          <image class="bar-bg" src="{{ elephantSrc }}" mode="aspectFill" />
        </view>
        <text class="bar-label-right">40%</text>
      </view>

      <view class="bar-row">
        <view class="bar-container" style="width: 10%;">
          <image class="bar-bg" src="{{ elephantSrc }}" mode="aspectFill" />
        </view>
        <text class="bar-label-right">10%</text>
      </view>
    </view>

    <view class="section">
      <view class="section-title">Dot-Pattern Bars</view>
      <view class="section-desc">
        A dot-matrix pattern image used as background for clipped bars.
        Each bar shows a different segment of the same dot grid.
      </view>

      <view class="bar-row">
        <view class="bar-container" style="width: 100%;">
          <image class="bar-bg" src="{{ dotSrc }}" mode="aspectFill" />
        </view>
        <text class="bar-label-right">100%</text>
      </view>

      <view class="bar-row">
        <view class="bar-container" style="width: 65%;">
          <image class="bar-bg" src="{{ dotSrc }}" mode="aspectFill" />
        </view>
        <text class="bar-label-right">65%</text>
      </view>

      <view class="bar-row">
        <view class="bar-container" style="width: 45%;">
          <image class="bar-bg" src="{{ dotSrc }}" mode="aspectFill" />
        </view>
        <text class="bar-label-right">45%</text>
      </view>

      <view class="bar-row">
        <view class="bar-container" style="width: 25%;">
          <image class="bar-bg" src="{{ dotSrc }}" mode="aspectFill" />
        </view>
        <text class="bar-label-right">25%</text>
      </view>

      <view class="bar-row">
        <view class="bar-container" style="width: 5%;">
          <image class="bar-bg" src="{{ dotSrc }}" mode="aspectFill" />
        </view>
        <text class="bar-label-right">5%</text>
      </view>
    </view>

    <view class="section">
      <view class="section-title">Animated Progress Bar</view>
      <view class="section-desc">
        A download-style progress bar where the image background is clipped
        by an animating width container. The fill advances via CSS keyframes
        while the percentage counter increments in JS.
      </view>
      <view class="progress-card">
        <image class="progress-bg" src="{{ avatarSrc }}" mode="aspectFill" />
        <view class="progress-overlay" />
        <view class="progress-fill" />
        <view class="progress-label">
          <text class="progress-text">{{ progress }}%</text>
        </view>
      </view>
    </view>

    <view class="hint-section">
      <view class="hint-title">Expected Behavior</view>
      <view class="hint-item">1. Cards and bars have rounded corners — images never bleed outside border-radius.</view>
      <view class="hint-item">2. Each bar shows the same background image clipped at a different width.</view>
      <view class="hint-item">3. The animated progress bar fill stays within the rounded clip area.</view>
      <view class="hint-item">4. The percentage counter increments from 0 to 100.</view>
    </view>
  </view>
</page>

<style>
  .container {
    --clip-page-background: var(--color-background);
    --clip-surface-background: var(--color-surface);
    --clip-surface-highlight-background: var(--color-surface-highlight);
    --clip-text-color: var(--color-text-primary);
    --clip-muted-text-color: var(--color-text-secondary);
    --clip-accent-color: var(--color-primary);
    --clip-contrast-text-color: #ffffff;
    display: flex;
    flex-direction: column;
    width: 100%;
    background-color: var(--clip-page-background);
    padding: var(--spacing-lg, 20px);
    box-sizing: border-box;
  }

  .title {
    font-size: 24px;
    font-weight: bold;
    color: var(--clip-text-color);
    margin-bottom: 8px;
  }

  .subtitle {
    font-size: 14px;
    line-height: 20px;
    color: var(--clip-muted-text-color);
    margin-bottom: 24px;
  }

  .section {
    display: flex;
    flex-direction: column;
    background-color: var(--clip-surface-background);
    border-radius: var(--radius-md, 12px);
    padding: var(--spacing-md, 16px);
    margin-bottom: var(--spacing-lg, 20px);
  }

  .section-title {
    font-size: 18px;
    font-weight: 600;
    color: var(--clip-text-color);
    margin-bottom: 8px;
  }

  .section-desc {
    font-size: 13px;
    line-height: 18px;
    color: var(--clip-muted-text-color);
    margin-bottom: var(--spacing-md, 16px);
  }

  .clip-card {
    width: 240px;
    height: 160px;
    border-radius: 20px;
    overflow: clip;
    background-color: var(--clip-surface-highlight-background);
    align-self: center;
  }

  .clip-image {
    width: 100%;
    height: 100%;
  }

  .bar-row {
    display: flex;
    flex-direction: row;
    align-items: center;
    margin-bottom: var(--spacing-md, 12px);
  }

  .bar-container {
    height: 40px;
    border-radius: var(--radius-md, 10px);
    overflow: clip;
    position: relative;
  }

  .bar-bg {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
  }

  .bar-label-right {
    font-size: 14px;
    font-weight: 600;
    color: var(--clip-muted-text-color);
    margin-left: 12px;
  }

  .progress-card {
    width: 300px;
    height: 180px;
    border-radius: 16px;
    overflow: clip;
    position: relative;
    align-self: center;
  }

  .progress-bg {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
  }

  .progress-overlay {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.45);
  }

  .progress-fill {
    position: absolute;
    bottom: 0;
    left: 0;
    height: 6px;
    background-color: var(--clip-accent-color);
    border-radius: 3px;
    animation: fill-bar 5000ms ease-in-out 1 forwards;
  }

  .progress-label {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
  }

  .progress-text {
    font-size: 28px;
    font-weight: bold;
    color: var(--clip-contrast-text-color);
  }

  @keyframes fill-bar {
    from {
      width: 0%;
    }
    to {
      width: 100%;
    }
  }

  .hint-section {
    display: flex;
    flex-direction: column;
    background-color: var(--clip-surface-highlight-background);
    border-radius: var(--radius-md, 12px);
    padding: var(--spacing-md, 16px);
  }

  .hint-title {
    font-size: 15px;
    font-weight: 600;
    color: var(--clip-text-color);
    margin-bottom: var(--spacing-sm, 10px);
  }

  .hint-item {
    font-size: 13px;
    line-height: 20px;
    color: var(--clip-muted-text-color);
    margin-bottom: 4px;
  }
</style>
