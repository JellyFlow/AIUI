<script setup>
  export default {
    data: {
      active: false,
      revealFillMode: false,
      startDelayedDemo: false,
    },
    onLoad() {
      setTimeout(() => {
        this.setData({
          active: true,
        });
      }, 600);

      setTimeout(() => {
        this.setData({
          revealFillMode: true,
        });
      }, 1000);

      setTimeout(() => {
        this.setData({
          startDelayedDemo: true,
        });
      }, 1400);
    },
  };
</script>

<page>
  <view class="container">
    <text class="page-title">CSS Transition and Animation</text>
    <text class="page-subtitle">
      Product-style interactions for entry motion, hover states, status chips, and expanding panels.
    </text>

    <card class="card">
      <text class="section-title">Notification Entry</text>
      <text class="section-copy">
        A newly arrived card fades in, shifts position, and changes emphasis after the page loads.
      </text>
      <view class="transition-box {{ active ? 'transition-box-active' : '' }}">
        <text class="box-label">Build Completed</text>
      </view>
      <text class="hint">Expected: the incoming notification starts quiet, then settles into a highlighted state.</text>
    </card>

    <card class="card">
      <text class="section-title">Quick Actions</text>
      <text class="section-copy">
        These tiles behave like hoverable action shortcuts inside a workspace or dashboard.
      </text>
      <view class="hover-grid">
        <view class="hover-tile hover-lift">
          <text class="hover-title">Open Queue</text>
          <text class="hover-copy">Lifts to signal focus</text>
        </view>
        <view class="hover-tile hover-glow">
          <text class="hover-title">Assign Owner</text>
          <text class="hover-copy">Glows when active</text>
        </view>
      </view>
      <text class="hint">Expected: each action tile animates only while hovered.</text>
    </card>

    <card class="card">
      <text class="section-title">Status Chips</text>
      <text class="section-copy">
        Short looping motion works well for lightweight activity and attention states.
      </text>
      <view class="autoplay-row">
        <view class="pulse-chip">Syncing</view>
        <view class="wave-chip">New Reply</view>
      </view>
      <text class="hint">Expected: chip motion starts immediately without user interaction.</text>
    </card>

    <card class="card">
      <text class="section-title">Panel State Variants</text>
      <text class="section-copy">
        This group compares delayed reveal, a settled final state, and a repeating motion used for side cues.
      </text>
      <view class="variant-grid">
        <view class="variant-card delayed-demo {{ startDelayedDemo ? 'delayed-demo-ready' : '' }}">
          <text class="variant-title">Drawer</text>
          <text class="variant-copy">Appears after a short delay.</text>
        </view>
        <view
          class="variant-card fill-demo {{ revealFillMode ? 'fill-demo-ready' : '' }}"
        >
          <text class="variant-title">Expanded</text>
          <text class="variant-copy">Keeps the final open state.</text>
        </view>
        <view class="variant-card direction-demo">
          <text class="variant-title">Beacon</text>
          <text class="variant-copy">Moves repeatedly to attract attention.</text>
        </view>
      </view>
      <text class="hint">
        Expected: delayed reveal waits first, expanded stays settled, beacon keeps oscillating.
      </text>
    </card>
  </view>
</page>

<style>
  .container {
    --transition-demo-page-background: var(--color-background);
    --transition-demo-card-background: var(--color-surface);
    --transition-demo-surface-highlight: var(--color-surface-highlight);
    --transition-demo-text-color: var(--color-text-primary);
    --transition-demo-muted-text-color: var(--color-text-secondary);
    --transition-demo-accent-color: var(--color-primary);
    --transition-demo-accent-soft-color: var(--color-primary-40, rgba(64, 255, 94, 0.4));
    --transition-demo-accent-muted-color: var(--color-primary-60, rgba(64, 255, 94, 0.6));
    --transition-demo-contrast-text-color: #ffffff;
    --transition-demo-card-shadow: 0 8px 24px rgba(15, 23, 42, 0.08);
    --transition-demo-hover-shadow: 0 4px 12px rgba(15, 23, 42, 0.08);
    --transition-demo-hover-lift-shadow: 0 16px 28px rgba(37, 99, 235, 0.22);
    --transition-demo-success-background: #22c55e;
    --transition-demo-warning-background: #f59e0b;
    --transition-demo-danger-background: #ef4444;
    --transition-demo-secondary-background: #8b5cf6;
    --transition-demo-secondary-soft-background: #c4b5fd;
    display: flex;
    flex-direction: column;
    padding: var(--spacing-lg, 20px);
    background-color: var(--transition-demo-page-background);
  }

  .page-title {
    font-size: 24px;
    font-weight: bold;
    color: var(--transition-demo-text-color);
    margin-bottom: var(--spacing-sm, 10px);
  }

  .page-subtitle {
    font-size: 14px;
    line-height: 20px;
    color: var(--transition-demo-muted-text-color);
    margin-bottom: var(--spacing-lg, 20px);
  }

  .card {
    display: flex;
    flex-direction: column;
    background-color: var(--transition-demo-card-background);
    border-radius: 16px;
    padding: var(--spacing-md, 16px);
    margin-bottom: var(--spacing-lg, 20px);
    box-shadow: var(--transition-demo-card-shadow);
  }

  .section-title {
    font-size: 18px;
    font-weight: bold;
    color: var(--transition-demo-text-color);
    margin-bottom: 8px;
  }

  .section-copy {
    font-size: 14px;
    line-height: 20px;
    color: var(--transition-demo-muted-text-color);
    margin-bottom: 14px;
  }

  .transition-box {
    width: 200px;
    height: 76px;
    border-radius: 14px;
    background-color: var(--transition-demo-surface-highlight);
    opacity: 0.25;
    color: var(--transition-demo-muted-text-color);
    transform: translateX(0px);
    transition:
      opacity 700ms ease-out,
      background-color 700ms ease-in-out,
      color 700ms ease-in-out,
      transform 700ms ease-out;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .transition-box-active {
    background-color: var(--transition-demo-accent-color);
    color: var(--transition-demo-contrast-text-color);
    opacity: 1;
    transform: translateX(28px);
  }

  .box-label {
    color: inherit;
    font-size: 14px;
    font-weight: bold;
  }

  .hover-grid {
    display: flex;
    flex-direction: row;
    gap: 12px;
  }

  .hover-tile {
    width: 150px;
    min-height: 96px;
    padding: 14px;
    border-radius: 14px;
    box-sizing: border-box;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    background-color: var(--transition-demo-surface-highlight);
    color: var(--transition-demo-text-color);
    opacity: 0.92;
    transform: translateY(0px);
    box-shadow: var(--transition-demo-hover-shadow);
  }

  .hover-lift {
    transition:
      transform 220ms ease-out,
      background-color 220ms ease-out;
  }

  .hover-lift:hover {
    background-color: var(--transition-demo-accent-soft-color);
    transform: translateY(-8px);
    box-shadow: var(--transition-demo-hover-lift-shadow);
  }

  .hover-glow {
    transition:
      opacity 220ms ease-out,
      background-color 220ms ease-in-out,
      color 220ms ease-in-out,
      transform 220ms ease-out;
  }

  .hover-glow:hover {
    background-color: var(--transition-demo-accent-color);
    color: var(--transition-demo-contrast-text-color);
    opacity: 1;
    transform: translateY(-4px);
  }

  .hover-title {
    font-size: 16px;
    font-weight: bold;
    color: inherit;
  }

  .hover-copy {
    font-size: 13px;
    line-height: 18px;
    color: inherit;
  }

  .autoplay-row {
    display: flex;
    flex-direction: row;
    gap: 12px;
  }

  .pulse-chip,
  .wave-chip {
    width: 180px;
    height: 52px;
    border-radius: 26px;
    color: var(--transition-demo-contrast-text-color);
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .pulse-chip {
    background-color: var(--transition-demo-accent-color);
    animation: pulse-in 1200ms ease-in-out infinite alternate both;
  }

  .wave-chip {
    background-color: var(--transition-demo-secondary-background);
    animation: wave-once 900ms ease-out 1 both;
  }

  .variant-grid {
    display: flex;
    flex-direction: row;
    gap: 12px;
  }

  .variant-card {
    width: 132px;
    min-height: 110px;
    padding: 14px;
    border-radius: 14px;
    box-sizing: border-box;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    color: var(--transition-demo-contrast-text-color);
  }

  .variant-title {
    font-size: 15px;
    font-weight: bold;
    color: inherit;
  }

  .variant-copy {
    font-size: 12px;
    line-height: 17px;
    color: inherit;
  }

  .delayed-demo {
    background-color: var(--transition-demo-muted-text-color);
    opacity: 0.28;
    transform: translateX(0px);
    transition:
      opacity 800ms ease-out 400ms,
      transform 800ms ease-out 400ms,
      background-color 800ms ease-in-out 400ms;
  }

  .delayed-demo-ready {
    background-color: var(--transition-demo-success-background);
    opacity: 1;
    transform: translateX(18px);
  }

  .fill-demo {
    background-color: var(--transition-demo-warning-background);
    opacity: 0.35;
    transform: translateY(0px);
    transition:
      opacity 850ms ease-out,
      transform 850ms ease-out,
      background-color 850ms ease-in-out;
  }

  .fill-demo-ready {
    background-color: var(--transition-demo-danger-background);
    opacity: 1;
    transform: translateY(-10px);
  }

  .direction-demo {
    background-color: var(--transition-demo-secondary-background);
    animation: drift-sideways 1100ms ease-in-out infinite alternate both;
  }

  .hint {
    margin-top: 12px;
    font-size: 13px;
    line-height: 18px;
    color: var(--transition-demo-muted-text-color);
  }

  @keyframes pulse-in {
    from {
      opacity: 0.35;
      background-color: var(--transition-demo-surface-highlight);
      transform: translateX(0px);
    }

    to {
      opacity: 1;
      background-color: var(--transition-demo-accent-color);
      transform: translateX(20px);
    }
  }

  @keyframes wave-once {
    from {
      opacity: 0.2;
      background-color: var(--transition-demo-secondary-soft-background);
      transform: translateY(10px);
    }

    to {
      opacity: 1;
      background-color: var(--transition-demo-secondary-background);
      transform: translateY(0px);
    }
  }

  @keyframes drift-sideways {
    from {
      opacity: 0.45;
      transform: translateX(0px);
    }

    to {
      opacity: 1;
      transform: translateX(14px);
    }
  }
</style>
