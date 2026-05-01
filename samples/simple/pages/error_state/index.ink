<script setup>
  export default {
    onLoad() {
      console.log('Error State test page loaded');
    },
  };
</script>

<page>
  <view class="container">
    <view class="page-title">Error State</view>

    <view class="section">
      <text class="section-title">Default Error State</text>
      <error-state
        class="error-box"
        text="Something went wrong."
      />
    </view>

    <view class="section">
      <text class="section-title">Error State with Icon</text>
      <error-state
        class="error-box error-box--warning"
        icon="https://cdn.jsdelivr.net/npm/@material-design-icons/svg@0.14.13/filled/warning.svg"
        text="The request could not be completed. Please try again later."
      />
    </view>

    <view class="section">
      <text class="section-title">Critical Error State</text>
      <error-state
        class="error-box error-box--critical"
        icon="https://cdn.jsdelivr.net/npm/@material-design-icons/svg@0.14.13/filled/error.svg"
        text="An unexpected critical error has occurred."
      />
    </view>
  </view>
</page>

<style>
  .container {
    padding: var(--spacing-lg, 18px);
    flex-direction: column;
  }

  .page-title {
    font-size: 28px;
    font-weight: bold;
    margin-bottom: var(--spacing-lg, 18px);
  }

  .section {
    flex-direction: column;
    margin-bottom: var(--spacing-lg, 18px);
    padding: var(--theme-padding, 12px);
    border-radius: var(--theme-radius, 12px);
    border: var(--theme-border);
  }

  .section-title {
    font-size: 14px;
    font-weight: bold;
    margin-bottom: 12px;
  }

  .error-box {
    flex-direction: row;
    align-items: center;
    padding: var(--theme-padding, 12px);
    border-radius: var(--radius-sm, 8px);
    border: var(--error-state-border-width, var(--border-width-thin, 1px)) solid var(--error-state-border-color, var(--border-color-muted, #f5c6cb));
  }

  .error-box--warning {
    border: var(--border-width-thin, 1px) solid var(--border-color-warning, var(--color-primary-40, #ffe082));
  }

  .error-box--critical {
    border: var(--border-width-thin, 1px) solid var(--border-color-danger, var(--color-primary-60, #f48fb1));
  }
</style>
