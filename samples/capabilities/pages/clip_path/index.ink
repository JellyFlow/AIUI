<script setup>
import wx from 'wx';

export default {
  onLoad() {
    console.log('Clip path test page loaded');
  },
};
</script>

<page>
  <view class='container'>
    <view class='page-title'>Clip Path</view>
    <view class='page-subtitle'>
      Visual regression page covering inset, circle, ellipse, polygon, and compound hole clip-path shapes on realistic cards.
    </view>

    <view class='card section'>
      <text class='label'>Inset With Rounded Corners</text>
      <view class='swatch-frame inset-demo'>
        <view class='shape-fill layered-fill'></view>
        <text class='shape-copy'>inset(10px 18px round 12px)</text>
      </view>
    </view>

    <view class='card section'>
      <text class='label'>Circle Intersecting Content</text>
      <view class='swatch-frame circle-demo'>
        <view class='shape-fill layered-fill'></view>
        <text class='shape-copy'>circle(50% at center)</text>
      </view>
    </view>

    <view class='card section'>
      <text class='label'>Ellipse Spotlight</text>
      <view class='swatch-frame ellipse-demo'>
        <view class='shape-fill layered-fill'></view>
        <text class='shape-copy'>ellipse(40% 60% at 50% 50%)</text>
      </view>
    </view>

    <view class='card section'>
      <text class='label'>Pixel Border Card</text>
      <view class='pixel-card-shell pixel-step-shape'>
        <view class='pixel-card-core pixel-step-shape'>
          <text class='pixel-eyebrow'>RETRO UI</text>
          <text class='pixel-title'>Pixel Shield</text>
          <text class='pixel-copy'>
            The border is built with two layered polygon clips. The outer shell paints the frame,
            and the inner panel creates the inset content area.
          </text>
        </view>
      </view>
      <text class='shape-copy'>outer + inner: polygon(0 12%, 6% 12%, 6% 6%, 12% 6%, 12% 0, 88% 0, 88% 6%, 94% 6%, 94% 12%, 100% 12%, 100% 88%, 94% 88%, 94% 94%, 88% 94%, 88% 100%, 12% 100%, 12% 94%, 6% 94%, 6% 88%, 0 88%)</text>
      <text class='note'>This is a page-level demo built purely with layered `clip-path: polygon(...)` shapes. It creates a pixel-art border look without changing the engine&apos;s normal border renderer.</text>
    </view>

    <view class='card section'>
      <text class='label'>Checklist</text>
      <text class='note'>Supported: inset(), circle(), ellipse(), polygon(), and polygon(evenodd, ... / ...) for compound hole clips.</text>
      <text class='note'>Still unsupported: path(...) and url(...). Unsupported values should degrade without applying an extra clip.</text>
    </view>
  </view>
</page>

<style>
  .container {
    --clip-surface: var(--color-surface-highlight);
    --clip-text: var(--color-text-primary);
    display: flex;
    flex-direction: column;
    padding: var(--spacing-lg, 20px);
    background-color: var(--color-background);
  }

  .page-title {
    font-size: 24px;
    font-weight: bold;
    color: var(--clip-text);
  }

  .page-subtitle {
    margin-top: 8px;
    margin-bottom: 20px;
    font-size: 14px;
    line-height: 20px;
    color: var(--color-text-secondary);
  }

  .section {
    flex-direction: column;
    gap: 12px;
    margin-bottom: 20px;
    padding: 16px;
  }

  .label {
    font-size: 16px;
    font-weight: 700;
    color: var(--clip-text);
  }

  .swatch-frame {
    display: flex;
    flex-direction: column;
    justify-content: flex-end;
    width: 220px;
    height: 120px;
    padding: 14px;
    box-sizing: border-box;
    background-color: var(--clip-surface);
    border: 2px solid rgba(255, 255, 255, 0.08);
  }

  .shape-fill {
    width: 100%;
    height: 100%;
    border-radius: 12px;
  }

  .layered-fill {
    background:
      linear-gradient(135deg, #ff7a59, transparent),
      linear-gradient(45deg, #6c5ce7, transparent),
      linear-gradient(180deg, #00b894, transparent),
      #1f2937;
  }

  .shape-copy {
    margin-top: 10px;
    font-size: 12px;
    line-height: 16px;
    color: #ffffff;
  }

  .note {
    font-size: 13px;
    line-height: 18px;
    color: var(--color-text-secondary);
  }

  .pixel-card-shell {
    width: 244px;
    padding: 8px;
    box-sizing: border-box;
    background-color: #7c3aed;
    box-shadow: 0 10px 18px rgba(17, 24, 39, 0.24);
  }

  .pixel-card-core {
    min-height: 132px;
    padding: 16px;
    box-sizing: border-box;
    background:
      linear-gradient(180deg, rgba(255, 255, 255, 0.08), transparent),
      linear-gradient(135deg, #ff7a59, transparent 48%),
      #111827;
    display: flex;
    flex-direction: column;
    justify-content: center;
    gap: 8px;
  }

  .pixel-step-shape {
    clip-path: polygon(
      0 12%,
      6% 12%,
      6% 6%,
      12% 6%,
      12% 0,
      88% 0,
      88% 6%,
      94% 6%,
      94% 12%,
      100% 12%,
      100% 88%,
      94% 88%,
      94% 94%,
      88% 94%,
      88% 100%,
      12% 100%,
      12% 94%,
      6% 94%,
      6% 88%,
      0 88%
    );
  }

  .pixel-eyebrow {
    font-size: 11px;
    line-height: 14px;
    font-weight: 700;
    color: #f59e0b;
    letter-spacing: 1px;
  }

  .pixel-title {
    font-size: 20px;
    line-height: 22px;
    font-weight: 700;
    color: #ffffff;
  }

  .pixel-copy {
    font-size: 13px;
    line-height: 18px;
    color: rgba(255, 255, 255, 0.78);
  }

  .hollow-demo-surface {
    position: relative;
    width: 320px;
    height: 92px;
    padding: 10px 12px;
    box-sizing: border-box;
    background-color: transparent;
  }

  .hollow-demo-backdrop {
    width: 100%;
    height: 100%;
    box-sizing: border-box;
    background-color: transparent;
  }

  .compound-hole-frame {
    position: absolute;
    inset: 10px 12px;
    background-color: #45f882;
  }

  .inset-demo {
    clip-path: inset(10px 18px round 12px);
  }

  .circle-demo {
    clip-path: circle(50% at center);
  }

  .ellipse-demo {
    clip-path: ellipse(40% 60% at 50% 50%);
  }

  .compound-hole-shape {
    clip-path: polygon(
      evenodd,
      0 20px,
      8px 20px,
      8px 10px,
      16px 10px,
      16px 4px,
      280px 4px,
      280px 10px,
      288px 10px,
      288px 20px,
      296px 20px,
      296px 52px,
      288px 52px,
      288px 62px,
      280px 62px,
      280px 68px,
      16px 68px,
      16px 62px,
      8px 62px,
      8px 52px,
      0 52px /
      3px 23px,
      11px 23px,
      11px 13px,
      19px 13px,
      19px 7px,
      277px 7px,
      277px 13px,
      285px 13px,
      285px 23px,
      293px 23px,
      293px 49px,
      285px 49px,
      285px 59px,
      277px 59px,
      277px 65px,
      19px 65px,
      19px 59px,
      11px 59px,
      11px 49px,
      3px 49px
    );
  }

</style>
