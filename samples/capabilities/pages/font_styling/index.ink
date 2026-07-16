<script setup>
export default {
  onLoad() {
    console.log('Font Styling page loaded');
  },
};
</script>

<page>
  <view class="container">
    <text class="page-title">Font Styling</text>
    <text class="page-subtitle">
      Typography in realistic reading, notes, and profile contexts.
    </text>

    <card class="section-card" role="group">
      <text class="section-title">Host Fonts</text>
      <text class="host-note">
        This block uses host-managed fonts from hostFontsDir with explicit fallback stacks.
      </text>
      <text class="host-serif-label">Host Serif</text>
      <text class="host-serif-title">Noto Serif keeps long-form UI copy calm and readable.</text>
      <text class="host-serif-copy">
        If the host serif is unavailable, the stack falls back to Georgia, Times New Roman, and then
        generic serif rendering.
      </text>
      <text class="host-emoji-label">Host Emoji</text>
      <text class="host-emoji-copy">
        Emoji fallback stays usable across hosts: 🙂 🚀 🎧 🌤️ 🧭
      </text>
      <text class="host-emoji-note">
        Stack: Noto Emoji, Apple Color Emoji, Segoe UI Emoji, Noto Color Emoji, sans-serif.
      </text>
    </card>

    <card class="section-card" role="group">
      <text class="section-title">Editorial Intro</text>
      <text class="eyebrow">Weekly Brief</text>
      <text class="editorial-title">A calmer reading rhythm starts with better text styling.</text>
      <text class="editorial-deck">
        Serif copy helps this section read like an article intro, while the italic deck creates a softer
        editorial tone.
      </text>
      <text class="editorial-body">
        This content block reads more like a product brief or magazine intro because the title, deck, and
        body each carry a slightly different tone.
      </text>
    </card>

    <card class="section-card" role="group">
      <text class="section-title">Quote And Annotation</text>
      <text class="quote-mark">“</text>
      <text class="quote-copy">
        Good typography makes structure visible before the user starts reading line by line.
      </text>
      <text class="quote-source">Product Writing Notes</text>
      <text class="annotation-label">Editor Note</text>
      <text class="annotation-copy">
        An oblique annotation feels distinct from the main quotation without needing extra decoration.
      </text>
    </card>

    <card class="section-card" role="group">
      <text class="section-title">Developer Snippet</text>
      <text class="snippet-label">Terminal Output</text>
      <text class="snippet-line">$ ink build --page font_styling</text>
      <text class="snippet-line">Compiled 4 typography sections successfully.</text>
      <text class="snippet-line">Preview uses monospace to match code and logs.</text>
    </card>

    <card class="section-card" role="group">
      <text class="section-title">Profile Summary</text>
      <text class="profile-role">Design Systems</text>
      <text class="profile-name">Avery Chen</text>
      <text class="profile-meta">Content Strategist</text>
      <text class="profile-copy">
        Small-caps and family changes are more convincing when they appear in labels, titles, and short
        descriptive copy inside a realistic profile card.
      </text>
    </card>
  </view>
</page>

<style>
  .container {
    display: flex;
    flex-direction: column;
    padding: var(--spacing-lg, 20px);
    background-color: var(--color-background);
  }

  .page-title {
    font-size: 24px;
    font-weight: bold;
    color: var(--color-text-primary);
  }

  .page-subtitle {
    font-size: 14px;
    line-height: 20px;
    color: var(--color-text-secondary);
    margin-top: var(--spacing-sm, 8px);
    margin-bottom: var(--spacing-lg, 20px);
  }

  .section-card {
    display: flex;
    flex-direction: column;
    margin-bottom: var(--spacing-lg, 20px);
    gap: var(--spacing-sm, 8px);
  }

  .host-note,
  .host-serif-copy,
  .host-emoji-note {
    font-size: 14px;
    line-height: 20px;
    color: var(--color-text-secondary);
  }

  .host-serif-label,
  .host-emoji-label {
    font-size: 12px;
    font-weight: 600;
    color: var(--color-text-secondary);
    font-variant: small-caps;
    letter-spacing: 0.6px;
    margin-top: var(--spacing-sm, 6px);
  }

  .host-serif-title {
    font-family: 'Noto Serif', Georgia, 'Times New Roman', serif;
    font-size: 22px;
    line-height: 30px;
    font-weight: 700;
    color: var(--color-text-primary);
  }

  .host-serif-copy {
    font-family: 'Noto Serif', Georgia, 'Times New Roman', serif;
    color: var(--color-text-primary);
  }

  .host-emoji-copy {
    font-family: 'Noto Emoji', 'Apple Color Emoji', 'Segoe UI Emoji', 'Noto Color Emoji', sans-serif;
    font-size: 24px;
    line-height: 32px;
    color: var(--color-text-primary);
  }

  .section-title {
    font-size: 14px;
    font-weight: bold;
    color: var(--color-text-secondary);
    margin-bottom: var(--spacing-sm, 10px);
  }

  .eyebrow,
  .annotation-label,
  .snippet-label,
  .profile-role {
    font-size: 12px;
    font-weight: 600;
    color: var(--color-text-secondary);
    font-variant: small-caps;
    letter-spacing: 0.6px;
  }

  .editorial-title {
    font-family: Georgia, serif;
    font-size: 24px;
    line-height: 32px;
    font-weight: 700;
    color: var(--color-text-primary);
  }

  .editorial-deck {
    font-family: Georgia, serif;
    font-style: italic;
    font-size: 16px;
    line-height: 24px;
    color: var(--color-text-primary);
  }

  .editorial-body {
    font-family: Georgia, serif;
    font-size: 16px;
    line-height: 24px;
    color: var(--color-text-primary);
  }

  .quote-mark {
    font-family: Georgia, serif;
    font-size: 32px;
    line-height: 32px;
  }

  .quote-copy {
    font-family: Georgia, serif;
    font-style: italic;
    font-size: 18px;
    line-height: 26px;
    color: var(--color-text-primary);
  }

  .quote-source {
    font-size: 13px;
    font-weight: 600;
    color: var(--color-text-secondary);
  }

  .annotation-copy {
    font-style: oblique;
    font-size: 14px;
    line-height: 20px;
    color: var(--color-text-primary);
  }

  .snippet-line {
    font-family: 'Courier New', monospace;
    font-size: 14px;
    line-height: 20px;
    color: var(--color-text-primary);
  }

  .profile-name {
    font-size: 20px;
    font-weight: 700;
    color: var(--color-text-primary);
  }

  .profile-meta {
    font-size: 14px;
    color: var(--color-text-secondary);
  }

  .profile-copy {
    font-size: 14px;
    line-height: 20px;
    color: var(--color-text-primary);
  }
</style>
