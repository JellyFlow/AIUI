<script setup>
  export default {
    onLoad() {
      console.log('Background image test page loaded');
    },
  };
</script>

<page>
  <view class="container">
    <view class="page-header">
      <text class="page-kicker">Background Painting</text>
      <text class="page-title">Background Image</text>
      <text class="page-subtitle">
        This page validates the CSS `background-image` pipeline with image, linear-gradient, radial-gradient, `background-size`, `background-repeat`, and `background-position` samples.
      </text>
    </view>

    <view class="section-card">
      <text class="section-kicker">URL Image</text>
      <text class="section-title">Basic Image Background And Rounded Clipping</text>
      <text class="section-note">
        This card uses `url(...)` directly as a background image to verify image loading, rounded clipping, and text overlay composition together.
      </text>
      <view class="sample-card sample-hero">
        <view class="overlay-panel">
          <text class="sample-label">Hero Card</text>
          <text class="sample-title">Elephant Story Cover</text>
          <text class="sample-copy">The background comes from a local asset while the content stays readable above the image layer.</text>
        </view>
      </view>
    </view>

    <view class="section-card">
      <text class="section-kicker">Gradients</text>
      <text class="section-title">Linear And Radial Gradient Variations</text>
      <text class="section-note">
        These cards focus on pure gradient backgrounds without any image assets so gradient parsing and rendering are easy to inspect.
      </text>
      <view class="gradient-grid">
        <view class="sample-card gradient-card gradient-linear">
          <text class="sample-label">Linear Gradient</text>
          <text class="sample-title">Sunrise Banner</text>
          <text class="sample-copy">`linear-gradient(135deg, ...)` is useful for banners and marketing surfaces.</text>
        </view>
        <view class="sample-card gradient-card gradient-radial">
          <text class="sample-label">Radial Gradient</text>
          <text class="sample-title">Spotlight Panel</text>
          <text class="sample-copy">`radial-gradient(circle at center, ...)` creates a centered spotlight effect.</text>
        </view>
        <view class="sample-card gradient-card gradient-linear-stops">
          <text class="sample-label">Linear Stops</text>
          <text class="sample-title">Explicit Color Stops</text>
          <text class="sample-copy">This case checks ordered stops with sharp and soft transitions across the same axis.</text>
        </view>
        <view class="sample-card gradient-card gradient-radial-corner">
          <text class="sample-label">Radial Position</text>
          <text class="sample-title">Corner Glow</text>
          <text class="sample-copy">This case places the radial center near the corner to verify non-centered positioning.</text>
        </view>
      </view>
    </view>

    <view class="section-card">
      <text class="section-kicker">Background Size</text>
      <text class="section-title">Cover, Contain, And Fixed Size</text>
      <text class="section-note">
        The same asset is rendered with `cover`, `contain`, and a fixed size so scaling behavior is easy to compare.
      </text>
      <view class="compare-grid">
        <view class="compare-card">
          <text class="compare-title">Cover</text>
          <view class="size-sample size-cover"></view>
          <text class="compare-copy">Fills the container first.</text>
        </view>
        <view class="compare-card">
          <text class="compare-title">Contain</text>
          <view class="size-sample size-contain"></view>
          <text class="compare-copy">Keeps the full image visible.</text>
        </view>
        <view class="compare-card">
          <text class="compare-title">72px 72px</text>
          <view class="size-sample size-fixed"></view>
          <text class="compare-copy">Checks explicit background dimensions.</text>
        </view>
      </view>
    </view>

    <view class="section-card">
      <text class="section-kicker">Background Repeat</text>
      <text class="section-title">Repeat, Repeat-X, Repeat-Y, And No-Repeat</text>
      <text class="section-note">
        A small texture asset makes repeat direction easy to verify visually.
      </text>
      <view class="compare-grid">
        <view class="compare-card">
          <text class="compare-title">repeat</text>
          <view class="repeat-sample repeat-both"></view>
          <text class="compare-copy">Tiles in both directions.</text>
        </view>
        <view class="compare-card">
          <text class="compare-title">repeat-x</text>
          <view class="repeat-sample repeat-x"></view>
          <text class="compare-copy">Repeats only horizontally.</text>
        </view>
        <view class="compare-card">
          <text class="compare-title">repeat-y</text>
          <view class="repeat-sample repeat-y"></view>
          <text class="compare-copy">Repeats only vertically.</text>
        </view>
        <view class="compare-card">
          <text class="compare-title">no-repeat</text>
          <view class="repeat-sample repeat-none"></view>
          <text class="compare-copy">Draws the background only once.</text>
        </view>
      </view>
    </view>

    <view class="section-card">
      <text class="section-kicker">Background Position</text>
      <text class="section-title">Center, Left Top, And Percentage Positioning</text>
      <text class="section-note">
        These cases disable repeating and use a fixed image size so the alignment point is obvious.
      </text>
      <view class="compare-grid">
        <view class="compare-card">
          <text class="compare-title">center center</text>
          <view class="position-sample position-center"></view>
          <text class="compare-copy">Aligns the background to the element center.</text>
        </view>
        <view class="compare-card">
          <text class="compare-title">left top</text>
          <view class="position-sample position-top-left"></view>
          <text class="compare-copy">Pins the background to the top-left corner.</text>
        </view>
        <view class="compare-card">
          <text class="compare-title">25% 75%</text>
          <view class="position-sample position-percent"></view>
          <text class="compare-copy">Checks percentage-based position parsing.</text>
        </view>
      </view>
    </view>
  </view>
</page>

<style>
  .container {
    --bg-page-background: var(--color-background);
    --bg-surface-background: var(--color-surface);
    --bg-surface-highlight-background: var(--color-surface-highlight);
    --bg-text-color: var(--color-text-primary);
    --bg-muted-text-color: var(--color-text-secondary);
    --bg-border-color: var(--border-color-default, rgba(15, 23, 42, 0.12));
    display: flex;
    flex-direction: column;
    gap: 18px;
    padding: 18px;
    background-color: var(--bg-page-background);
    box-sizing: border-box;
  }

  .page-header {
    display: flex;
    flex-direction: column;
    gap: 8px;
  }

  .page-kicker {
    font-size: 12px;
    font-weight: 700;
    color: var(--bg-muted-text-color);
    letter-spacing: 0.8px;
    text-transform: uppercase;
  }

  .page-title {
    font-size: 30px;
    font-weight: 700;
    color: var(--bg-text-color);
  }

  .page-subtitle {
    font-size: 14px;
    line-height: 20px;
    color: var(--bg-muted-text-color);
  }

  .section-card {
    display: flex;
    flex-direction: column;
    gap: 10px;
    padding: 16px;
    border-radius: 18px;
    border: 1px solid var(--bg-border-color);
    background-color: var(--bg-surface-background);
    box-sizing: border-box;
  }

  .section-kicker {
    font-size: 12px;
    font-weight: 700;
    color: var(--bg-muted-text-color);
    letter-spacing: 0.8px;
    text-transform: uppercase;
  }

  .section-title {
    font-size: 20px;
    font-weight: 700;
    color: var(--bg-text-color);
  }

  .section-note {
    font-size: 13px;
    line-height: 19px;
    color: var(--bg-muted-text-color);
  }

  .sample-card,
  .size-sample,
  .repeat-sample,
  .position-sample {
    border-radius: 16px;
    overflow: hidden;
    box-sizing: border-box;
  }

  .sample-card {
    display: flex;
    flex-direction: column;
    justify-content: flex-end;
    min-height: 180px;
    padding: 16px;
  }

  .sample-hero {
    background-color: #10233a;
    background-image: url('../../assets/elephant.png');
    background-size: cover;
    background-position: center center;
    background-repeat: no-repeat;
  }

  .overlay-panel {
    display: flex;
    flex-direction: column;
    gap: 6px;
    padding: 14px;
    border-radius: 12px;
    background-color: rgba(15, 23, 42, 0.55);
  }

  .gradient-grid,
  .compare-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 12px;
  }

  .gradient-card {
    min-height: 148px;
  }

  .gradient-linear {
    background-color: #3b1d68;
    background-image: linear-gradient(135deg, rgba(255, 181, 71, 1) 0%, rgba(255, 107, 107, 0.95) 52%, rgba(111, 66, 193, 1) 100%);
  }

  .gradient-radial {
    background-color: #0f172a;
    background-image: radial-gradient(circle at center, rgba(255, 255, 255, 0.92) 0%, rgba(96, 165, 250, 0.88) 35%, rgba(15, 23, 42, 1) 100%);
  }

  .gradient-linear-stops {
    background-color: #1f2937;
    background-image: linear-gradient(90deg, rgba(34, 197, 94, 1) 0%, rgba(34, 197, 94, 1) 28%, rgba(250, 204, 21, 1) 58%, rgba(239, 68, 68, 1) 100%);
  }

  .gradient-radial-corner {
    background-color: #111827;
    background-image: radial-gradient(circle at 20% 20%, rgba(251, 191, 36, 0.95) 0%, rgba(245, 158, 11, 0.72) 24%, rgba(59, 130, 246, 0.4) 52%, rgba(17, 24, 39, 1) 100%);
  }

  .compare-card {
    display: flex;
    flex-direction: column;
    gap: 8px;
    padding: 14px;
    border-radius: 16px;
    border: 1px solid var(--bg-border-color);
    background-color: var(--bg-surface-highlight-background);
    box-sizing: border-box;
  }

  .compare-title,
  .sample-title {
    font-size: 18px;
    font-weight: 700;
    line-height: 24px;
    color: #ffffff;
  }

  .sample-label {
    font-size: 11px;
    font-weight: 700;
    color: rgba(255, 255, 255, 0.76);
    letter-spacing: 0.6px;
    text-transform: uppercase;
  }

  .sample-copy {
    font-size: 13px;
    line-height: 18px;
    color: rgba(255, 255, 255, 0.82);
  }

  .compare-title {
    color: var(--bg-text-color);
  }

  .compare-copy {
    font-size: 13px;
    line-height: 18px;
    color: var(--bg-muted-text-color);
  }

  .size-sample,
  .repeat-sample,
  .position-sample {
    width: 100%;
    height: 120px;
    background-color: #e2e8f0;
  }

  .size-cover,
  .size-contain,
  .size-fixed,
  .position-sample {
    background-image: url('../../assets/elephant.png');
    background-repeat: no-repeat;
  }

  .size-cover {
    background-size: cover;
    background-position: center center;
  }

  .size-contain {
    background-size: contain;
    background-position: center center;
  }

  .size-fixed {
    background-size: 72px 72px;
    background-position: center center;
  }

  .repeat-both,
  .repeat-x,
  .repeat-y,
  .repeat-none {
    background-image: url('../../assets/dot_pattern.png');
    background-size: 24px 24px;
    background-position: left top;
  }

  .repeat-both {
    background-repeat: repeat;
  }

  .repeat-x {
    background-repeat: repeat-x;
  }

  .repeat-y {
    background-repeat: repeat-y;
  }

  .repeat-none {
    background-repeat: no-repeat;
  }

  .position-center {
    background-size: 72px 72px;
    background-position: center center;
  }

  .position-top-left {
    background-size: 72px 72px;
    background-position: left top;
  }

  .position-percent {
    background-size: 72px 72px;
    background-position: 25% 75%;
  }

  @media (max-width: 480px) {
    .gradient-grid,
    .compare-grid {
      grid-template-columns: 1fr;
    }
  }
</style>
