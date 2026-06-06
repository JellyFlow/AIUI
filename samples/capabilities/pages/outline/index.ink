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
    <view class="page-subtitle">
      Focus, selection, and key-navigation cues shown through realistic interactive cards.
    </view>

    <view class="card section">
      <text class="label">Focused Navigation Card</text>
      <view class="focus-card solid-outline" role="navigation">
        <text class="card-title">Continue Reading</text>
        <text class="card-copy">A solid outline makes the current focus target obvious.</text>
      </view>
    </view>

    <view class="card section">
      <text class="label">Draft Selection</text>
      <view class="focus-card dashed-outline">
        <text class="card-title">Draft Workspace</text>
        <text class="card-copy">Dashed outlines can signal editable or temporary selections.</text>
      </view>
    </view>

    <view class="card section">
      <text class="label">Suggestion Highlight</text>
      <view class="focus-card dotted-outline">
        <text class="card-title">Suggested Reply</text>
        <text class="card-copy">A dotted treatment helps secondary emphasis feel lighter than a primary focus ring.</text>
      </view>
    </view>

    <view class="card section">
      <text class="label">Offset Focus Ring</text>
      <view class="focus-card offset-outline">
        <text class="card-title">Keyboard Shortcut</text>
        <text class="card-copy">Offset keeps the ring outside the content so text and borders stay clean.</text>
      </view>
    </view>

    <view class="card section">
      <text class="label">Rounded Media Entry</text>
      <view class="focus-card rounded-outline">
        <text class="card-title">Playlist Card</text>
        <text class="card-copy">Outline can follow a rounded card silhouette without flattening the shape.</text>
      </view>
    </view>

    <view class="card section">
      <text class="label">Border + Outline State</text>
      <view class="focus-card border-and-outline">
        <text class="card-title">Security Review</text>
        <text class="card-copy">Some states need both an inner border and an outer outline to feel selected.</text>
      </view>
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
    padding: var(--spacing-lg, 20px);
    background-color: var(--outline-page-background);
  }

  .page-title,
  .title {
    font-size: 24px;
    font-weight: bold;
    display: block;
    color: var(--outline-text-color);
  }

  .page-subtitle {
    font-size: 14px;
    line-height: 20px;
    color: var(--color-text-secondary);
    margin-top: var(--spacing-sm, 8px);
    margin-bottom: var(--spacing-lg, 20px);
  }

  .section {
    flex-direction: column;
    gap: 12px;
    margin-bottom: var(--spacing-lg, 20px);
    padding: var(--spacing-md, 16px);
  }

  .label {
    color: var(--outline-text-color);
    font-size: 16px;
    font-weight: 700;
    display: block;
  }

  .focus-card {
    display: flex;
    flex-direction: column;
    gap: 8px;
    width: 220px;
    min-height: 108px;
    padding: 14px;
    box-sizing: border-box;
    background-color: var(--outline-box-background);
    border-radius: var(--radius-sm, 8px);
  }

  .card-title {
    font-size: 17px;
    font-weight: 700;
    color: var(--color-text-primary);
  }

  .card-copy {
    font-size: 13px;
    line-height: 18px;
    color: var(--color-text-secondary);
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
    border-radius: var(--radius-md, 12px);
    outline: 3px solid #9b59b6;
    outline-offset: 2px;
  }

  .border-and-outline {
    border: var(--border-width-default, 2px) solid var(--border-color-contrast, #333);
    outline: 3px solid #e74c3c;
    outline-offset: 3px;
  }
</style>
