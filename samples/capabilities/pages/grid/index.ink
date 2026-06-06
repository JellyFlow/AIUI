<script setup>
  export default {};
</script>

<page>
  <view class="container">
    <view class="page-title">Grid Layouts</view>
    <view class="page-subtitle">
      Real-world page sections built with grid instead of isolated syntax demos.
    </view>

    <view class="card section">
      <view class="title">Dashboard Overview</view>
      <view class="section-note">A compact stats area using a two-column summary grid.</view>
      <view class="dashboard-grid">
        <view class="stat-card">
          <view class="stat-label">Active Users</view>
          <view class="stat-value">1,284</view>
          <view class="stat-meta">Today</view>
        </view>
        <view class="stat-card">
          <view class="stat-label">Avg Session</view>
          <view class="stat-value">18 min</view>
          <view class="stat-meta">Last 24h</view>
        </view>
        <view class="stat-card">
          <view class="stat-label">Conversion</view>
          <view class="stat-value">6.4%</view>
          <view class="stat-meta">Weekly</view>
        </view>
        <view class="stat-card">
          <view class="stat-label">Tickets</view>
          <view class="stat-value">23</view>
          <view class="stat-meta">Open</view>
        </view>
      </view>
    </view>

    <view class="card section">
      <view class="title">Sidebar + Main Workspace</view>
      <view class="section-note">A classic application shell with a narrow sidebar and a flexible main area.</view>
      <view class="workspace-grid">
        <view class="workspace-sidebar">
          <view class="sidebar-item">Home</view>
          <view class="sidebar-item">Queue</view>
          <view class="sidebar-item">Reports</view>
          <view class="sidebar-item">Settings</view>
        </view>
        <view class="workspace-main">
          <view class="workspace-hero">
            <view class="hero-title">Project Overview</view>
            <view class="hero-copy">Use grid to reserve a fixed navigation area while the content region grows naturally.</view>
          </view>
          <view class="workspace-summary-grid">
            <view class="mini-panel">
              <view class="mini-label">Pending</view>
              <view class="mini-value">12</view>
            </view>
            <view class="mini-panel">
              <view class="mini-label">Done</view>
              <view class="mini-value">48</view>
            </view>
          </view>
        </view>
      </view>
    </view>

    <view class="card section">
      <view class="title">Media Gallery</view>
      <view class="section-note">A responsive gallery where each card keeps a consistent thumbnail area.</view>
      <view class="gallery-grid">
        <view class="gallery-card">
          <view class="gallery-thumb">Cover</view>
          <view class="gallery-title">Morning Brief</view>
          <view class="gallery-meta">Podcast</view>
        </view>
        <view class="gallery-card">
          <view class="gallery-thumb">Cover</view>
          <view class="gallery-title">Design Review</view>
          <view class="gallery-meta">Video</view>
        </view>
        <view class="gallery-card">
          <view class="gallery-thumb">Cover</view>
          <view class="gallery-title">Sprint Notes</view>
          <view class="gallery-meta">Article</view>
        </view>
        <view class="gallery-card">
          <view class="gallery-thumb">Cover</view>
          <view class="gallery-title">Roadmap</view>
          <view class="gallery-meta">Deck</view>
        </view>
        <view class="gallery-card">
          <view class="gallery-thumb">Cover</view>
          <view class="gallery-title">Field Report</view>
          <view class="gallery-meta">Audio</view>
        </view>
        <view class="gallery-card">
          <view class="gallery-thumb">Cover</view>
          <view class="gallery-title">Weekly Sync</view>
          <view class="gallery-meta">Meeting</view>
        </view>
      </view>
    </view>

    <view class="card section">
      <view class="title">Article Card Feed</view>
      <view class="section-note">A content feed where cards share structure but adapt well to a two-column layout.</view>
      <view class="article-grid">
        <view class="article-card">
          <view class="article-kicker">Insight</view>
          <view class="article-title">Using grid to organize dense content blocks</view>
          <view class="article-copy">Cards stay readable because title, summary, and metadata live in a vertical stack.</view>
          <view class="article-meta-row">
            <view class="article-meta">6 min</view>
            <view class="article-meta">Layout</view>
          </view>
        </view>
        <view class="article-card">
          <view class="article-kicker">Guide</view>
          <view class="article-title">Practical section layouts for dashboards and detail pages</view>
          <view class="article-copy">A simple repeating grid is often enough for feeds, summaries, and recommendation surfaces.</view>
          <view class="article-meta-row">
            <view class="article-meta">8 min</view>
            <view class="article-meta">Patterns</view>
          </view>
        </view>
        <view class="article-card">
          <view class="article-kicker">Update</view>
          <view class="article-title">Shipping a new overview page with reusable panels</view>
          <view class="article-copy">Grid gives consistent outer rhythm while each card uses a flexible inner column.</view>
          <view class="article-meta-row">
            <view class="article-meta">4 min</view>
            <view class="article-meta">Product</view>
          </view>
        </view>
        <view class="article-card">
          <view class="article-kicker">Case Study</view>
          <view class="article-title">Combining card feeds with summary rows</view>
          <view class="article-copy">Real pages often mix repeated grid cards with inner flex and column-based composition.</view>
          <view class="article-meta-row">
            <view class="article-meta">10 min</view>
            <view class="article-meta">UX</view>
          </view>
        </view>
      </view>
    </view>

    <view class="card section">
      <view class="title">Settings Overview</view>
      <view class="section-note">A summary screen made of grouped entry cards instead of isolated grid mechanics.</view>
      <view class="settings-grid">
        <view class="setting-card">
          <view class="setting-title">Profile</view>
          <view class="setting-copy">Account photo, name, and visibility settings.</view>
        </view>
        <view class="setting-card">
          <view class="setting-title">Notifications</view>
          <view class="setting-copy">Delivery channels, digest frequency, and mute states.</view>
        </view>
        <view class="setting-card">
          <view class="setting-title">Storage</view>
          <view class="setting-copy">Offline assets, cache usage, and cleanup actions.</view>
        </view>
        <view class="setting-card">
          <view class="setting-title">Security</view>
          <view class="setting-copy">Session protection, passcode, and connected devices.</view>
        </view>
      </view>
    </view>
  </view>
</page>

<style>
  .container {
    display: flex;
    flex-direction: column;
    padding: var(--spacing-md, 16px);
  }

  .page-title {
    font-size: 24px;
    font-weight: bold;
    margin-bottom: var(--spacing-md, 16px);
  }

  .page-subtitle {
    font-size: 14px;
    line-height: 20px;
    color: var(--color-text-secondary);
    margin-bottom: var(--spacing-lg, 20px);
  }

  .card {
    border-radius: var(--radius-md, 12px);
    border: var(--border-width-thin, 1px) solid var(--border-color-muted, #ebedf0);
  }

  .section {
    flex-direction: column;
    margin-bottom: var(--spacing-md, 16px);
    padding: var(--spacing-md, 16px);
  }

  .title {
    font-size: 16px;
    font-weight: 600;
    margin-bottom: var(--spacing-md, 12px);
    padding-bottom: 8px;
    border-bottom: var(--border-width-thin, 1px) solid var(--border-color-muted, #ebedf0);
  }

  .section-note {
    font-size: 13px;
    line-height: 18px;
    color: var(--color-text-secondary);
    margin-bottom: var(--spacing-md, 12px);
  }

  .stat-card,
  .mini-panel,
  .gallery-card,
  .article-card,
  .setting-card,
  .workspace-sidebar,
  .workspace-hero,
  .media-card,
  .sidebar-item {
    background-color: var(--color-surface-highlight, #f2f2f7);
  }

  .stat-card,
  .mini-panel,
  .gallery-card,
  .article-card,
  .setting-card,
  .workspace-hero,
  .media-card,
  .sidebar-item {
    border-radius: var(--radius-md, 10px);
  }

  .dashboard-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 12px;
  }

  .stat-card {
    display: flex;
    flex-direction: column;
    padding: 14px;
    gap: 4px;
  }

  .stat-label,
  .mini-label,
  .gallery-meta,
  .article-kicker,
  .article-meta,
  .setting-copy {
    font-size: 12px;
    color: var(--color-text-secondary);
  }

  .stat-value,
  .mini-value {
    font-size: 22px;
    font-weight: 700;
  }

  .stat-meta {
    font-size: 12px;
    font-weight: 600;
  }

  .workspace-grid {
    display: grid;
    grid-template-columns: 96px 1fr;
    gap: 12px;
  }

  .workspace-sidebar {
    display: flex;
    flex-direction: column;
    gap: 8px;
    padding: 8px;
  }

  .sidebar-item {
    padding: 10px 12px;
    font-size: 13px;
    font-weight: 600;
  }

  .workspace-main {
    display: grid;
    grid-template-rows: auto auto;
    gap: 10px;
  }

  .workspace-hero {
    display: flex;
    flex-direction: column;
    gap: 6px;
    padding: 14px;
  }

  .hero-title,
  .gallery-title,
  .setting-title {
    font-size: 15px;
    font-weight: 700;
  }

  .hero-copy,
  .article-copy {
    font-size: 12px;
    line-height: 18px;
    color: var(--color-text-secondary);
  }

  .workspace-summary-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 10px;
  }

  .mini-panel {
    display: flex;
    flex-direction: column;
    gap: 4px;
    padding: 12px;
  }

  .gallery-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(104px, 1fr));
    gap: 12px;
  }

  .gallery-card {
    display: flex;
    flex-direction: column;
    gap: 8px;
    padding: 10px;
  }

  .gallery-thumb {
    height: 84px;
    border-radius: var(--radius-sm, 8px);
    background-color: var(--color-surface);
    display: flex;
    justify-content: center;
    align-items: center;
    font-size: 12px;
    font-weight: 600;
  }

  .article-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 12px;
  }

  .article-card {
    display: flex;
    flex-direction: column;
    gap: 8px;
    padding: 14px;
  }

  .article-title {
    font-size: 16px;
    font-weight: 700;
    line-height: 22px;
  }

  .article-meta-row {
    display: flex;
    gap: 10px;
    align-items: center;
  }

  .settings-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 12px;
  }

  .setting-card {
    display: flex;
    flex-direction: column;
    gap: 6px;
    padding: 14px;
  }

  @media (max-width: 480px) {
    .dashboard-grid,
    .workspace-summary-grid,
    .article-grid,
    .settings-grid {
      grid-template-columns: 1fr;
    }

    .workspace-grid {
      grid-template-columns: 1fr;
    }
  }
</style>
