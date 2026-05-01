<script setup>
  export default {
    onLoad() {
      console.log('Card component test page loaded');
    },
  };
</script>

<page>
  <view class="container">
    <view class="page-title">Card Component</view>

    <view class="section">
      <text class="section-title">Basic Card (No Props)</text>
      <card class="card">
        <text class="body-text">This is a minimal card using only CSS for styling.</text>
      </card>
    </view>

    <view class="section">
      <text class="section-title">Card with Title</text>
      <card class="card" title="Card Title">
        <text class="body-text">Card body content sits below the built-in title.</text>
      </card>
    </view>

    <view class="section">
      <text class="section-title">Card with Title and Footer</text>
      <card class="card" title="Meeting Summary" footer="Last updated: just now">
        <text class="body-text">Today's standup covered sprint goals, blockers, and upcoming deadlines.</text>
      </card>
    </view>

    <view class="section">
      <text class="section-title">Card with Cover Image</text>
      <card
        class="card card--no-padding"
        cover="https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=640&q=80"
        title="Mountain Landscape"
        footer="Photo by Unsplash"
      >
        <text class="body-text body-text--padded">Breathtaking views from the summit reveal valleys and distant peaks.</text>
      </card>
    </view>

    <view class="section">
      <text class="section-title">Card with Multiple Children</text>
      <card class="card" title="Team Members">
        <view class="member-row">
          <text class="member-name">Alice Chen</text>
          <text class="member-role">Engineer</text>
        </view>
        <view class="member-row">
          <text class="member-name">Bob Kim</text>
          <text class="member-role">Designer</text>
        </view>
        <view class="member-row">
          <text class="member-name">Carol Wu</text>
          <text class="member-role">PM</text>
        </view>
      </card>
    </view>
  </view>
</page>

<style>
  .container {
    flex-direction: column;
    padding: var(--spacing-lg, 24px);
  }

  .page-title {
    font-size: 28px;
    font-weight: bold;
    margin-bottom: var(--spacing-lg, 24px);
  }

  .section {
    flex-direction: column;
    margin-bottom: var(--spacing-lg, 24px);
  }

  .section-title {
    font-size: 13px;
    font-weight: bold;
    text-transform: uppercase;
    margin-bottom: 10px;
  }

  .card {
    flex-direction: column;
    border-radius: var(--radius-md, 12px);
    border: var(--card-border-width, var(--border-width-default, 2px)) solid var(--card-border-color, var(--border-color-default, #e5e5ea));
    overflow: hidden;
    padding: var(--card-padding, 16px);
  }

  .card--no-padding {
    padding: 0;
  }

  .body-text {
    font-size: 15px;
    line-height: 1.2;
  }

  .body-text--padded {
    padding: var(--spacing-md, 12px) var(--card-padding, 16px);
  }

  .member-row {
    flex-direction: row;
    justify-content: space-between;
    align-items: center;
    padding: 10px 0;
    border-bottom: var(--card-divider-width, var(--border-width-thin, 1px)) solid var(--card-divider-color, var(--border-color-muted, #f2f2f7));
  }

  .member-name {
    font-size: 15px;
    font-weight: 500;
  }

  .member-role {
    font-size: 13px;
  }
</style>
