<script setup>
  export default {
    data: {
      avatarSrc: '../../assets/avatar.jpg',
      coverSrc: '../../assets/elephant.png',
      badgeSrc: '../../assets/clear-day.svg'
    },
    onLoad() {
      console.log('Image presentation page loaded');
    }
  };
</script>

<page>
  <view class="container">
    <view class="page-header">
      <text class="page-kicker">Media Presentation</text>
      <text class="title">内容卡片与封面展示</text>
      <text class="subtitle">
        把头像、封面、不同 `mode` 的裁切行为和失败占位都放进真实内容场景里，而不是按图片格式逐个罗列。
      </text>
    </view>

    <view class="section hero-card">
      <image class="hero-image" src="{{ coverSrc }}" mode="aspectFill" />
      <view class="hero-copy">
        <text class="section-kicker">Featured Story</text>
        <text class="section-title">今日精选封面</text>
        <text class="section-note">
          大图区域使用 `aspectFill`，优先保证封面完整铺满卡片，适合故事、活动和内容发现页的首屏视觉。
        </text>
      </view>
    </view>

    <view class="section profile-card">
      <view class="profile-row">
        <view class="avatar-frame">
          <image class="avatar-image" src="{{ avatarSrc }}" mode="aspectFill" />
        </view>
        <view class="profile-copy">
          <text class="section-kicker">Creator Profile</text>
          <text class="section-title">人物头像与资料摘要</text>
          <text class="section-note">
            圆角头像更适合资料卡、消息列表和内容作者区域，裁切重点落在人像主体而不是保留原图边缘。
          </text>
        </view>
      </view>
      <view class="badge-row">
        <view class="badge-preview">
          <image class="badge-image" src="{{ badgeSrc }}" mode="aspectFit" />
        </view>
        <view class="badge-copy">
          <text class="mini-title">轻量状态徽标</text>
          <text class="mini-note">适合天气、状态和空页面提示等需要清晰边缘的图形资源。</text>
        </view>
      </view>
    </view>

    <view class="section">
      <text class="section-kicker">Preview Modes</text>
      <text class="section-title">同一素材在不同布局中的呈现</text>
      <text class="section-note">
        通过同一张素材展示 `aspectFill` 与 `aspectFit` 的差异，帮助理解内容卡片和预览框的取舍。
      </text>
      <view class="compare-row">
        <view class="compare-card compare-card-left">
          <text class="mini-title">Feed Cover</text>
          <view class="preview-frame">
            <image class="preview-image" src="{{ coverSrc }}" mode="aspectFill" />
          </view>
          <text class="mini-note">优先铺满，适合列表封面和推荐流缩略图。</text>
        </view>
        <view class="compare-card">
          <text class="mini-title">Asset Preview</text>
          <view class="preview-frame">
            <image class="preview-image" src="{{ coverSrc }}" mode="aspectFit" />
          </view>
          <text class="mini-note">完整保留素材，适合上传确认和素材检查。</text>
        </view>
      </view>
    </view>

    <view class="section">
      <text class="section-kicker">Fallback</text>
      <text class="section-title">资源缺失时的占位语义</text>
      <text class="section-note">
        不把失效图片单独作为“能力异常”展示，而是放进真实的内容占位卡里，保持结构可读性。
      </text>
      <view class="fallback-row">
        <view class="fallback-frame">
          <image class="fallback-image" src="../../assets/does-not-exist.png" mode="aspectFit" />
        </view>
        <view class="fallback-copy">
          <text class="mini-title">封面待同步</text>
          <text class="mini-note">
            当远端素材不可用时，页面仍保留标题、摘要和布局槽位，避免整个内容块塌掉。
          </text>
        </view>
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
    --image-muted-text-color: var(--color-text-secondary);
    --image-border-color: var(--border-color-default, transparent);
    display: flex;
    flex-direction: column;
    width: 100%;
    background-color: var(--image-page-background);
    padding: var(--spacing-lg, 20px);
    gap: var(--spacing-lg, 20px);
    box-sizing: border-box;
  }

  .page-header {
    display: flex;
    flex-direction: column;
    gap: 6px;
  }

  .page-kicker {
    font-size: 12px;
    color: var(--image-muted-text-color);
  }

  .title {
    font-size: 28px;
    font-weight: bold;
    color: var(--image-text-color);
  }

  .subtitle {
    font-size: 14px;
    color: var(--image-muted-text-color);
  }

  .section {
    display: flex;
    flex-direction: column;
    background-color: var(--image-surface-background);
    border-radius: var(--radius-md, 12px);
    border: var(--border-width-thin, 1px) solid var(--image-border-color);
    padding: var(--spacing-md, 16px);
    gap: 12px;
  }

  .hero-card {
    gap: 14px;
  }

  .hero-image {
    width: 100%;
    height: 180px;
    border-radius: var(--radius-sm, 8px);
  }

  .hero-copy {
    display: flex;
    flex-direction: column;
    gap: 6px;
  }

  .section-kicker {
    font-size: 12px;
    color: var(--image-muted-text-color);
  }

  .section-title {
    font-size: 18px;
    font-weight: 600;
    color: var(--image-text-color);
  }

  .section-note {
    font-size: 14px;
    color: var(--image-muted-text-color);
  }

  .profile-card {
    gap: 14px;
  }

  .profile-row {
    display: flex;
    flex-direction: row;
    align-items: center;
    gap: 14px;
  }

  .avatar-frame {
    width: 80px;
    height: 80px;
    border-radius: 999px;
    overflow: hidden;
    background-color: var(--image-surface-highlight-background);
    flex-shrink: 0;
  }

  .avatar-image {
    width: 100%;
    height: 100%;
  }

  .profile-copy {
    display: flex;
    flex-direction: column;
    gap: 6px;
    flex: 1;
  }

  .badge-row {
    display: flex;
    flex-direction: row;
    align-items: center;
    gap: 12px;
    padding: 12px;
    border-radius: var(--radius-sm, 8px);
    background-color: var(--image-surface-highlight-background);
  }

  .badge-preview {
    width: 56px;
    height: 56px;
    border-radius: var(--radius-sm, 8px);
    overflow: hidden;
    background-color: var(--image-surface-background);
    flex-shrink: 0;
  }

  .badge-image {
    width: 100%;
    height: 100%;
  }

  .badge-copy {
    display: flex;
    flex-direction: column;
    gap: 4px;
  }

  .compare-row {
    display: flex;
    flex-direction: row;
    gap: 12px;
  }

  .compare-card {
    display: flex;
    flex-direction: column;
    gap: 8px;
    flex: 1;
  }

  .compare-card-left {
    margin-right: 2px;
  }

  .preview-frame {
    width: 100%;
    height: 120px;
    border-radius: var(--radius-sm, 8px);
    overflow: hidden;
    background-color: var(--image-surface-highlight-background);
  }

  .preview-image {
    width: 100%;
    height: 100%;
  }

  .fallback-row {
    display: flex;
    flex-direction: row;
    align-items: center;
    gap: 14px;
    padding: 12px;
    border-radius: var(--radius-sm, 8px);
    background-color: var(--image-surface-highlight-background);
  }

  .fallback-frame {
    width: 96px;
    height: 72px;
    border-radius: var(--radius-sm, 8px);
    overflow: hidden;
    background-color: var(--image-surface-background);
    flex-shrink: 0;
  }

  .fallback-image {
    width: 100%;
    height: 100%;
  }

  .fallback-copy {
    display: flex;
    flex-direction: column;
    gap: 4px;
    flex: 1;
  }

  .mini-title {
    font-size: 15px;
    font-weight: 600;
    color: var(--image-text-color);
  }

  .mini-note {
    font-size: 13px;
    color: var(--image-muted-text-color);
  }
</style>
