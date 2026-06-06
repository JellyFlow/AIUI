<script setup>
import wx from 'wx';

export default {
  onLoad() {
    this.drawBundledFonts();
  },

  onShow() {
    this.drawBundledFonts();
  },

  drawBundledFonts() {
    const ctx = wx.createCanvasContext('bundledFontCanvas');
    if (!ctx) {
      return;
    }

    ctx.clearRect(0, 0, 360, 200);
    ctx.fillStyle = '#1f2937';

    ctx.font = '700 26px "Bundled Serif"';
    ctx.fillText('Northern Journal', 12, 40);

    ctx.font = 'italic 600 18px "Bundled Serif"';
    ctx.fillText('Editorial preview with bundled typography', 12, 72);

    ctx.font = '16px "Bundled Serif"';
    ctx.fillText('Bundled serif remains readable beside 中文与 English copy.', 12, 112);

    ctx.font = '700 14px "Bundled Serif"';
    ctx.fillText('Member Note', 12, 152);

    ctx.font = '16px "Bundled Serif"';
    ctx.fillText('Profile cards and article decks share the same bundled font.', 12, 180);
  },
};
</script>

<page>
  <view class="container">
    <view class="page-title">Bundled Fonts</view>
    <view class="page-subtitle">
      Real reading and profile surfaces that use the bundled serif family instead of isolated font rows.
    </view>

    <view class="card">
      <text class="section-title">Brand Hero</text>
      <text class="hero-kicker">Seasonal Issue</text>
      <text class="hero-title">Northern Journal</text>
      <text class="hero-deck">
        Bundled type gives a brand page a more editorial voice without depending on a platform font.
      </text>
    </view>

    <view class="card">
      <text class="section-title">Reading Card</text>
      <text class="article-title">A serif body makes short reading surfaces feel calmer.</text>
      <text class="article-copy">
        This example keeps the layout simple and shows the bundled font in a realistic intro, body, and
        bilingual fallback sentence with 中文 text.
      </text>
      <text class="article-copy fallback">
        Bundled fonts still need sensible fallback behavior so mixed-language content stays readable.
      </text>
    </view>

    <view class="card">
      <text class="section-title">Profile Summary</text>
      <text class="profile-role">Member Feature</text>
      <text class="profile-name">Mina Rivera</text>
      <text class="profile-meta">Field Editor</text>
      <text class="profile-copy">
        Names, editorial roles, and short summaries benefit from a bundled family when the page wants a
        recognizable voice.
      </text>
    </view>

    <view class="card canvas-card">
      <text class="section-title">Canvas Preview</text>
      <canvas id="bundledFontCanvas" width="360" height="200" class="canvas"></canvas>
    </view>
  </view>
</page>

<style>
  .container {
    display: flex;
    flex-direction: column;
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
    margin-top: var(--spacing-sm, 8px);
    margin-bottom: var(--spacing-lg, 20px);
  }

  .card {
    display: flex;
    flex-direction: column;
    gap: var(--spacing-sm, 8px);
    background-color: var(--color-surface-highlight);
    border: var(--border-width-thin, 1px) solid var(--border-color-default, #ccc);
    border-radius: var(--radius-md, 12px);
    padding: var(--spacing-md, 16px);
    margin-bottom: var(--spacing-md, 16px);
  }

  .section-title {
    display: block;
    font-size: 14px;
    font-weight: 700;
    color: var(--color-text-secondary);
  }

  .hero-kicker,
  .profile-role {
    font-family: 'Bundled Serif', serif;
    font-size: 12px;
    font-weight: 700;
    color: var(--color-text-secondary);
    font-variant: small-caps;
    letter-spacing: 0.6px;
  }

  .hero-title,
  .article-title,
  .profile-name {
    display: block;
    font-family: 'Bundled Serif', serif;
    color: var(--color-text-primary);
  }

  .hero-title {
    font-size: 28px;
    line-height: 34px;
    font-weight: 700;
  }

  .hero-deck,
  .article-copy,
  .profile-copy {
    font-family: 'Bundled Serif', serif;
    font-size: 16px;
    line-height: 24px;
    color: var(--color-text-primary);
  }

  .hero-deck {
    font-style: italic;
  }

  .article-title {
    font-size: 20px;
    line-height: 28px;
    font-weight: 700;
  }

  .profile-name {
    font-size: 22px;
    font-weight: 700;
  }

  .profile-meta {
    font-family: 'Bundled Serif', serif;
    font-size: 14px;
    color: var(--color-text-secondary);
  }

  .canvas-card {
    align-items: center;
  }

  .canvas {
    width: 360px;
    height: 200px;
    border: var(--border-width-thin, 1px) solid var(--border-color-contrast, #111);
    border-radius: var(--radius-md, 12px);
  }
</style>
