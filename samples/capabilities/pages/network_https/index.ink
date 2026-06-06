<script type="application/json" def>
{
  "navigationBarTitleText": "Remote Briefing"
}
</script>

<script setup>
import wx from 'wx';

const REQUEST_URL = 'https://httpbin.org/get?source=ink-remote-briefing';
const PREVIEW_LIMIT = 220;

function clipText(value, limit = PREVIEW_LIMIT) {
  const text = typeof value === 'string' ? value : String(value);
  return text.length <= limit ? text : `${text.slice(0, limit)}...`;
}

export default {
  data: {
    requestUrl: REQUEST_URL,
    status: 'idle',
    statusCode: 'N/A',
    elapsedTime: 'N/A',
    sourceLabel: 'Remote source not loaded yet',
    headline: '点击下方按钮拉取远端内容卡片',
    body: '页面会通过 HTTPS 拉取远端摘要，并把结果放进一张可阅读的内容卡中。',
    footer: '适合演示内容加载、状态切换和失败提示。',
    lastError: '',
  },

  loadBriefing() {
    if (this.data.status === 'loading') {
      return;
    }

    const startedAt = Date.now();
    this.setData({
      status: 'loading',
      statusCode: 'N/A',
      elapsedTime: 'N/A',
      sourceLabel: 'Loading remote source...',
      headline: '正在加载远端简报',
      body: '请稍候，正在通过 HTTPS 请求更新内容。',
      footer: '连接建立后会显示来源、耗时和内容摘要。',
      lastError: '',
    });

    wx.request({
      url: REQUEST_URL,
      method: 'GET',
      dataType: 'json',
      success: (res) => {
        const elapsedMs = Date.now() - startedAt;
        const data = res.data || {};
        const args = data.args || {};
        const headers = data.headers || {};
        this.setData({
          status: 'success',
          statusCode: String(res.statusCode ?? 'N/A'),
          elapsedTime: `${elapsedMs} ms`,
          sourceLabel: data.origin || 'Remote source ready',
          headline: '远端简报已更新',
          body: clipText(
            `来源地址：${data.url || REQUEST_URL}。请求来源标签：${args.source || 'unknown'}。User-Agent：${headers['User-Agent'] || 'unknown'}.`
          ),
          footer: '这张卡已经通过 HTTPS 请求完成刷新。',
          lastError: '',
        });
      },
      fail: (error) => {
        const elapsedMs = Date.now() - startedAt;
        const message = error && error.errMsg ? error.errMsg : String(error);
        this.setData({
          status: 'fail',
          statusCode: 'N/A',
          elapsedTime: `${elapsedMs} ms`,
          sourceLabel: 'Remote source unavailable',
          headline: '远端简报加载失败',
          body: '当前无法获取最新内容，请检查网络环境后再试。',
          footer: '失败状态仍会保留在卡片上，方便用户理解当前情况。',
          lastError: message,
        });
      },
    });
  },
};
</script>

<page>
  <view class="container">
    <view class="hero-card">
      <text class="page-kicker">Network &amp; Integration</text>
      <text class="page-title">Remote Briefing Loader</text>
      <text class="page-description">
        用 HTTPS 拉取一张真实可读的远端简报卡片，而不是单独展示请求调用本身。
      </text>
    </view>

    <view class="card briefing-card briefing-{{status}}">
      <text class="section-title">{{headline}}</text>
      <text class="briefing-body">{{body}}</text>
      <text class="meta-line">Status: {{status}} · Code: {{statusCode}} · Elapsed: {{elapsedTime}}</text>
      <text class="meta-line">Source: {{sourceLabel}}</text>
      <text class="meta-line" ink:if="{{lastError}}">Error: {{lastError}}</text>
      <text class="briefing-footer">{{footer}}</text>
    </view>

    <card class="card action-card">
      <view class="button-row" role="navigation">
        <button class="btn" bindtap="loadBriefing">Load Briefing</button>
      </view>
    </card>
  </view>
</page>

<style>
  .container {
    display: flex;
    flex-direction: column;
    padding: var(--theme-padding, 20px);
    gap: 16px;
    background-color: var(--color-background);
  }

  .hero-card,
  .card {
    display: flex;
    flex-direction: column;
    gap: 10px;
    padding: var(--spacing-md, 16px);
    border-radius: var(--radius-md, 12px);
    background-color: var(--color-surface);
    border: var(--border-width-thin, 1px) solid var(--border-color-default, #d1d1d6);
  }

  .page-kicker,
  .briefing-footer {
    font-size: 12px;
    color: var(--color-text-secondary);
  }

  .page-title {
    font-size: 28px;
    font-weight: bold;
    color: var(--color-text-primary);
  }

  .page-description,
  .meta-line,
  .briefing-body {
    font-size: 14px;
    line-height: 20px;
    color: var(--color-text-secondary);
  }

  .section-title {
    font-size: 16px;
    font-weight: bold;
    color: var(--color-text-primary);
  }

  .briefing-card {
    background-color: var(--color-surface-highlight, #f2f2f7);
  }

  .briefing-success {
    border-color: var(--border-color-success, #34c759);
  }

  .briefing-fail {
    border-color: var(--border-color-danger, #ff3b30);
  }

  .briefing-loading {
    border-color: var(--border-color-warning, #ff9f0a);
  }

  .button-row {
    display: flex;
    flex-direction: row;
    gap: 12px;
  }

  .btn {
    flex: 1;
    font-size: 15px;
  }
</style>
