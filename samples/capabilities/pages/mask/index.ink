<script setup>
export default {
  onLoad() {
    console.log('Mask test page loaded');
  },
};
</script>

<page>
  <view class="container">
    <view class="page-header">
      <text class="page-kicker">CSS Masking</text>
      <text class="page-title">Mask Image</text>
      <text class="page-subtitle">
        This page validates `white-space: nowrap`, `mask-image`, and `mask-mode` on text and element content.
      </text>
    </view>

    <view class="section-card dark-section">
      <text class="section-kicker">Text Fade</text>
      <text class="section-title light-title">Single Line Text With Right Fade</text>
      <view class="glass-sample">
        <text class="numeric">01</text>
        <text class="pill">休</text>
        <text class="masked-text">劳动节啊啊啊啊啊啊</text>
      </view>
    </view>

    <view class="section-card">
      <text class="section-kicker">Comparison</text>
      <text class="section-title">Masked And Unmasked Text</text>
      <view class="comparison-row">
        <view class="comparison-box">
          <text class="comparison-label">Masked</text>
          <text class="sample-line masked-line">Long notification text fades at the right edge</text>
        </view>
        <view class="comparison-box">
          <text class="comparison-label">Clipped</text>
          <text class="sample-line clipped-line">Long notification text cuts at the right edge</text>
        </view>
      </view>
    </view>

    <view class="section-card">
      <text class="section-kicker">Element Mask</text>
      <text class="section-title">Gradient Mask Applies To Children</text>
      <view class="masked-panel">
        <view class="panel-stripe stripe-a"></view>
        <view class="panel-stripe stripe-b"></view>
        <view class="panel-content">
          <text class="panel-title">Layered Content</text>
          <text class="panel-copy">Background and text should both fade through the same mask.</text>
        </view>
      </view>
    </view>
  </view>
</page>

<style>
  .container {
    --mask-page-background: var(--color-background);
    --mask-surface-background: var(--color-surface);
    --mask-surface-highlight-background: var(--color-surface-highlight);
    --mask-text-color: var(--color-text-primary);
    --mask-muted-text-color: var(--color-text-secondary);
    --mask-border-color: var(--border-color-default, rgba(15, 23, 42, 0.12));
    --mask-green: #19ff5c;
    --mask-blue: #2979ff;
    --mask-pink: #ff4f8b;
    display: flex;
    flex-direction: column;
    gap: 18px;
    min-height: 100vh;
    padding: 18px;
    background-color: var(--mask-page-background);
    box-sizing: border-box;
  }

  .page-header {
    display: flex;
    flex-direction: column;
    gap: 8px;
  }

  .page-kicker,
  .section-kicker,
  .comparison-label {
    font-size: 12px;
    font-weight: 700;
    color: var(--mask-muted-text-color);
    letter-spacing: 0.8px;
    text-transform: uppercase;
  }

  .page-title {
    font-size: 30px;
    font-weight: 700;
    color: var(--mask-text-color);
  }

  .page-subtitle {
    font-size: 14px;
    line-height: 20px;
    color: var(--mask-muted-text-color);
  }

  .section-card {
    display: flex;
    flex-direction: column;
    gap: 12px;
    padding: 16px;
    border-radius: 8px;
    border: 1px solid var(--mask-border-color);
    background-color: var(--mask-surface-background);
    box-sizing: border-box;
  }

  .dark-section {
    background-color: #000000;
    border-color: rgba(25, 255, 92, 0.28);
  }

  .section-title {
    font-size: 20px;
    font-weight: 700;
    color: var(--mask-text-color);
  }

  .light-title {
    color: #ffffff;
  }

  .glass-sample {
    position: relative;
    width: 140px;
    height: 140px;
    background-color: #000000;
  }

  .numeric {
    position: absolute;
    left: 34px;
    top: 28px;
    font-size: 36px;
    font-weight: 700;
    line-height: 40px;
    color: var(--mask-green);
  }

  .pill {
    position: absolute;
    right: 24px;
    top: 16px;
    width: 28px;
    height: 28px;
    border-radius: 4px;
    background-color: var(--mask-green);
    color: #000000;
    font-size: 18px;
    font-weight: 700;
    text-align: center;
    line-height: 28px;
  }

  .masked-text {
    position: absolute;
    left: 16px;
    top: 88px;
    width: 92px;
    height: 30px;
    color: var(--mask-green);
    font-size: 22px;
    font-weight: 600;
    line-height: 30px;
    white-space: nowrap;
    overflow: clip;
    mask-image: linear-gradient(to right, white 0%, white 58%, transparent 100%);
    mask-mode: alpha;
  }

  .comparison-row {
    display: flex;
    gap: 12px;
    flex-wrap: wrap;
  }

  .comparison-box {
    display: flex;
    flex-direction: column;
    gap: 8px;
    width: 220px;
    padding: 12px;
    border-radius: 8px;
    background-color: var(--mask-surface-highlight-background);
    box-sizing: border-box;
  }

  .sample-line {
    width: 180px;
    height: 28px;
    font-size: 16px;
    line-height: 28px;
    color: var(--mask-text-color);
    white-space: nowrap;
    overflow: clip;
  }

  .masked-line {
    mask-image: linear-gradient(to right, white 0%, white 68%, transparent 100%);
    mask-mode: alpha;
  }

  .clipped-line {
    border-right: 2px solid var(--mask-border-color);
  }

  .masked-panel {
    position: relative;
    width: 260px;
    height: 120px;
    overflow: clip;
    border-radius: 8px;
    background-color: #111827;
    mask-image: linear-gradient(to right, white 0%, white 62%, transparent 100%);
    mask-mode: alpha;
  }

  .panel-stripe {
    position: absolute;
    top: 0;
    bottom: 0;
    width: 130px;
  }

  .stripe-a {
    left: 0;
    background-image: linear-gradient(135deg, var(--mask-blue), var(--mask-green));
  }

  .stripe-b {
    right: 0;
    background-image: linear-gradient(135deg, var(--mask-pink), var(--mask-blue));
  }

  .panel-content {
    position: absolute;
    left: 16px;
    top: 18px;
    width: 210px;
    display: flex;
    flex-direction: column;
    gap: 8px;
  }

  .panel-title {
    font-size: 18px;
    font-weight: 700;
    color: #ffffff;
  }

  .panel-copy {
    font-size: 13px;
    line-height: 18px;
    color: rgba(255, 255, 255, 0.86);
  }
</style>
