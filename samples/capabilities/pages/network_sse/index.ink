<script type="application/json" def>
{
  "navigationBarTitleText": "Live Inbox"
}
</script>

<script setup>
import wx from 'wx';

const SSE_URL = 'https://sse.dev/test';
const PREVIEW_LIMIT = 120;
const INBOX_LIMIT = 3;

function clipText(value, limit = PREVIEW_LIMIT) {
  const text = typeof value === 'string' ? value : String(value);
  return text.length <= limit ? text : `${text.slice(0, limit)}...`;
}

export default {
  data: {
    endpointUrl: SSE_URL,
    status: 'idle',
    messageCount: 0,
    lastEventId: 'N/A',
    lastError: '',
    inboxItems: [],
    latestUpdate: 'N/A',
  },

  onLoad() {
    this.eventSourceTask = null;
  },

  onUnload() {
    this.closeStream(true);
  },

  connectStream() {
    if (this.eventSourceTask) {
      return;
    }

    this.setData({
      status: 'connecting',
      messageCount: 0,
      lastEventId: 'N/A',
      lastError: '',
      inboxItems: [],
      latestUpdate: 'Connecting...',
    });

    const task = wx.createEventSource({
      url: SSE_URL,
      method: 'GET',
    });

    task.onOpen(() => {
      this.setData({
        status: 'open',
        lastError: '',
        latestUpdate: new Date().toISOString().slice(11, 19),
      });
    });

    task.onMessage((event) => {
      const nextCount = (this.data.messageCount || 0) + 1;
      const item = {
        id: `${Date.now()}-${nextCount}`,
        title: event && event.event ? event.event : `Update ${nextCount}`,
        body: clipText(event && event.data ? event.data : 'Empty message'),
      };
      const inboxItems = [item, ...(this.data.inboxItems || [])].slice(0, INBOX_LIMIT);
      this.setData({
        status: 'open',
        messageCount: nextCount,
        lastEventId: event && event.id ? event.id : 'N/A',
        lastError: '',
        inboxItems,
        latestUpdate: new Date().toISOString().slice(11, 19),
      });
    });

    task.onError((error) => {
      const message = error && error.errMsg ? error.errMsg : String(error);
      this.setData({
        status: 'error',
        lastError: message,
      });
    });

    this.eventSourceTask = task;
  },

  closeStream(silent = false) {
    if (!this.eventSourceTask) {
      if (!silent) {
        this.setData({
          status: this.data.status === 'idle' ? 'idle' : 'closed',
        });
      }
      return;
    }

    try {
      this.eventSourceTask.close();
    } catch (_) {}

    this.eventSourceTask = null;
    this.setData({
      status: 'closed',
    });
  },
};
</script>

<page>
  <view class="container">
    <view class="hero-card">
      <text class="page-kicker">Network &amp; Integration</text>
      <text class="page-title">Live Notification Inbox</text>
      <text class="page-description">
        用 SSE 打开一个持续更新的通知收件箱，页面重点是通知接收体验，而不是事件流调试过程。
      </text>
    </view>

    <view class="card">
      <text class="section-title">Inbox</text>
      <text class="meta-line">Status: {{status}} · Messages: {{messageCount}} · Updated: {{latestUpdate}}</text>
      <text class="meta-line">Source: {{endpointUrl}}</text>
      <text class="meta-line" ink:if="{{lastError}}">Error: {{lastError}}</text>
      <view ink:if="{{inboxItems.length}}">
        <view class="message-card" ink:for="{{inboxItems}}" ink:key="id">
          <text class="message-title">{{item.title}}</text>
          <text class="message-body">{{item.body}}</text>
        </view>
      </view>
      <text class="empty-text" ink:else>连接后这里会显示最新的实时通知。</text>
    </view>

    <card class="card">
      <view class="button-row" role="navigation">
        <button class="btn" bindtap="connectStream">Connect Inbox</button>
        <button class="btn" bindtap="closeStream">Disconnect</button>
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

  .page-kicker {
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
  .empty-text,
  .message-body {
    font-size: 14px;
    line-height: 20px;
    color: var(--color-text-secondary);
  }

  .section-title,
  .message-title {
    font-size: 16px;
    font-weight: bold;
    color: var(--color-text-primary);
  }

  .message-card {
    display: flex;
    flex-direction: column;
    gap: 6px;
    padding: 12px;
    border-radius: var(--radius-md, 10px);
    background-color: var(--color-surface-highlight, #f2f2f7);
    margin-top: 8px;
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
