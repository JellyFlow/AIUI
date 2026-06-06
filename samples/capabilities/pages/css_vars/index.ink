<script setup>
  export default {
    onLoad() {
      console.log('CSS Variables Page Loaded');
    },
  };
</script>

<page>
  <view class="container">
    <text class="page-title">CSS Variables</text>
    <text class="page-subtitle">
      Token-driven cards that feel like real theme surfaces instead of variable override boxes.
    </text>

    <view class="demo-card">
      <text class="section-label">Default Theme</text>
      <text class="demo-title">Team Workspace</text>
      <text class="demo-desc">This surface inherits shared spacing, border, and radius tokens directly.</text>
    </view>

    <view class="demo-card secondary">
      <text class="section-label">Local Override</text>
      <text class="demo-title">Campaign Panel</text>
      <text class="demo-desc">A scoped override changes the panel tone without rewriting the whole component.</text>
    </view>

    <view class="demo-card fallback">
      <text class="section-label">Fallback Chain</text>
      <text class="demo-title">Recovery Banner</text>
      <text class="demo-desc">Fallback values keep the card usable even when a token is missing upstream.</text>
    </view>

    <view class="token-grid">
      <view class="demo-card compact">
        <text class="section-label">Shared Surface</text>
        <text class="demo-title">Profile</text>
      </view>
      <view class="demo-card compact secondary-soft">
        <text class="section-label">Accent Variant</text>
        <text class="demo-title">Highlights</text>
      </view>
    </view>
  </view>
</page>

<style>
  .container {
    display: flex;
    flex-direction: column;
    gap: var(--spacing-md, 16px);
    padding: var(--spacing-lg, 20px);
  }

  .page-title {
    font-size: 24px;
    font-weight: 700;
    color: var(--color-text-primary);
  }

  .page-subtitle {
    font-size: 14px;
    line-height: 20px;
    color: var(--color-text-secondary);
  }

  .demo-card {
    display: flex;
    flex-direction: column;
    gap: var(--spacing-sm, 8px);
    padding: var(--theme-padding);
    border: var(--theme-border);
    border-radius: var(--theme-radius);
    background-color: var(--theme-bg, var(--color-surface-highlight));
  }

  .section-label {
    font-size: 12px;
    font-weight: 700;
    color: var(--color-text-secondary);
    font-variant: small-caps;
    letter-spacing: 0.6px;
  }

  .demo-title {
    font-size: 18px;
    font-weight: bold;
    color: var(--color-text-primary);
  }

  .demo-desc {
    font-size: 14px;
    line-height: 20px;
    color: var(--color-text-secondary);
  }

  .token-grid {
    display: flex;
    gap: var(--spacing-md, 16px);
  }

  .compact {
    flex: 1;
  }

  .secondary {
    /* Override global variables for this scope */
    --theme-color: #e74c3c;
    --theme-bg: #fadbd8;
    --theme-border: var(--border-width-default, 2px) dashed var(--border-color-danger, #e74c3c);
  }

  .secondary-soft {
    --theme-bg: var(--color-surface);
  }

  .fallback {
    /* Use a fallback value because --undefined-color doesn't exist */
    border: var(--border-width-default, 2px) solid var(--undefined-color, var(--border-color-fallback, #2ecc71));
  }
</style>
