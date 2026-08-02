<script type="application/json" def>
{
  "navigationBarTitleText": "Remote Briefing"
}
</script>

<script setup>
import wx from 'wx';

const REQUEST_URL = 'https://js.rokid.com/api/v1/testing/http/echo?source=ink-remote-briefing';
const STREAM_URL =
  'https://js.rokid.com/api/v1/testing/http/stream?count=5&interval=300&prefix=ink-stream-preview';
const PREVIEW_LIMIT = 220;

function clipText(value, limit = PREVIEW_LIMIT) {
  const text = typeof value === 'string' ? value : String(value);
  return text.length <= limit ? text : `${text.slice(0, limit)}...`;
}

function createBriefingState() {
  return {
    briefingStatus: 'idle',
    briefingStatusCode: 'N/A',
    briefingElapsedTime: 'N/A',
    briefingSourceLabel: 'Remote source not loaded yet',
    briefingHeadline: '点击下方按钮拉取远端内容卡片',
    briefingBody: '页面会通过 HTTPS 拉取远端摘要，并把结果放进一张可阅读的内容卡中。',
    briefingFooter: '适合演示内容加载、状态切换和失败提示。',
    briefingError: '',
  };
}

function createStreamState() {
  return {
    streamStatus: 'idle',
    streamElapsedTime: 'N/A',
    streamSourceLabel: 'Stream preview not started yet',
    streamHeadline: '点击按钮体验流式 HTTPS 内容拼接',
    streamBody: '页面会通过 fetch 读取 response.body，并用 TextDecoder(stream:true) 逐段拼接文本。',
    streamLines: [],
    streamFooter: '适合演示流式 body、reader 和分段解码。',
    streamError: '',
  };
}

function createChecksState() {
  return {
    checksStatus: 'idle',
    checksSummary: '点击按钮运行兼容性检查。',
    checksItems: [],
    checksError: '',
  };
}

function formatCheck(label, pass, detail) {
  return {
    id: `${label}-${pass ? 'pass' : 'fail'}`,
    label,
    pass,
    badge: pass ? 'PASS' : 'FAIL',
    detail,
  };
}

function formatStreamLine(value, index) {
  const normalized = clipText(value.replace(/\r/g, '').replace(/"/g, "'").trim());
  return {
    id: `stream-line-${index}`,
    text: normalized,
  };
}

export default {
  data: {
    requestUrl: REQUEST_URL,
    streamUrl: STREAM_URL,
    ...createBriefingState(),
    ...createStreamState(),
    ...createChecksState(),
  },

  loadBriefing() {
    if (this.data.briefingStatus === 'loading') {
      return;
    }

    const startedAt = Date.now();
    this.setData({
      briefingStatus: 'loading',
      briefingStatusCode: 'N/A',
      briefingElapsedTime: 'N/A',
      briefingSourceLabel: 'Loading remote source...',
      briefingHeadline: '正在加载远端简报',
      briefingBody: '请稍候，正在通过 HTTPS 请求更新内容。',
      briefingFooter: '连接建立后会显示来源、耗时和内容摘要。',
      briefingError: '',
    });

    wx.request({
      url: REQUEST_URL,
      method: 'GET',
      dataType: 'json',
      success: (res) => {
        const elapsedMs = Date.now() - startedAt;
        const data = res.data || {};
        const query = data.query || {};
        const headers = data.headers || {};
        const userAgent = headers['user-agent'] || headers['User-Agent'] || 'unknown';
        const sourcePath = data.path || '/api/v1/testing/http/echo';
        this.setData({
          briefingStatus: 'success',
          briefingStatusCode: String(res.statusCode ?? 'N/A'),
          briefingElapsedTime: `${elapsedMs} ms`,
          briefingSourceLabel: data.timestamp || 'Testing source ready',
          briefingHeadline: '远端简报已更新',
          briefingBody: clipText(
            `来源路径：${sourcePath}。请求来源标签：${query.source || 'unknown'}。User-Agent：${userAgent}。`
          ),
          briefingFooter: '这张卡已经通过 Rokid testing infrastructure 的 HTTPS 请求完成刷新。',
          briefingError: '',
        });
      },
      fail: (error) => {
        const elapsedMs = Date.now() - startedAt;
        const message = error && error.errMsg ? error.errMsg : String(error);
        this.setData({
          briefingStatus: 'fail',
          briefingStatusCode: 'N/A',
          briefingElapsedTime: `${elapsedMs} ms`,
          briefingSourceLabel: 'Remote source unavailable',
          briefingHeadline: '远端简报加载失败',
          briefingBody: '当前无法获取最新内容，请检查网络环境后再试。',
          briefingFooter: '失败状态仍会保留在卡片上，方便用户理解当前情况。',
          briefingError: message,
        });
      },
    });
  },

  async loadStreamPreview() {
    if (this.data.streamStatus === 'loading') {
      return;
    }

    const startedAt = Date.now();
    this.setData({
      streamStatus: 'loading',
      streamElapsedTime: 'N/A',
      streamSourceLabel: 'Opening streamed HTTPS preview...',
      streamHeadline: '正在拼接流式内容预览',
      streamBody: '请稍候，页面正在按 chunk 读取远端内容。',
      streamLines: [],
      streamFooter: 'reader 已建立，正在等待完整预览。',
      streamError: '',
    });

    try {
      const response = await fetch(STREAM_URL);
      const reader = response.body.getReader();
      const decoder = new TextDecoder();
      let buffer = '';
      const streamLines = [];
      let lineIndex = 0;
      const sourceLabel = response.url || STREAM_URL;

      this.setData({
        streamSourceLabel: sourceLabel,
        streamHeadline: '正在接收流式内容',
        streamFooter: '每解析出一行内容，页面都会立即追加显示。',
      });

      while (true) {
        const { value, done } = await reader.read();
        if (done) {
          break;
        }

        buffer += decoder.decode(value, { stream: true });
        let newlineIndex = buffer.indexOf('\n');
        let appended = false;
        while (newlineIndex !== -1) {
          const line = buffer.slice(0, newlineIndex);
          buffer = buffer.slice(newlineIndex + 1);
          const normalized = line.trim();
          if (normalized) {
            streamLines.push(formatStreamLine(normalized, lineIndex));
            lineIndex += 1;
            appended = true;
          }
          newlineIndex = buffer.indexOf('\n');
        }

        if (appended) {
          this.setData({
            streamStatus: 'loading',
            streamElapsedTime: `${Date.now() - startedAt} ms`,
            streamSourceLabel: sourceLabel,
            streamHeadline: `正在接收第 ${streamLines.length} 行流式内容`,
            streamBody: '',
            streamLines: [...streamLines],
            streamFooter: '流式内容已到达，界面正在逐行刷新。',
            streamError: '',
          });
        }
      }

      buffer += decoder.decode();
      const trailingLine = buffer.trim();
      if (trailingLine) {
        streamLines.push(formatStreamLine(trailingLine, lineIndex));
        this.setData({
          streamStatus: 'loading',
          streamElapsedTime: `${Date.now() - startedAt} ms`,
          streamSourceLabel: sourceLabel,
          streamHeadline: `正在接收第 ${streamLines.length} 行流式内容`,
          streamBody: '',
          streamLines: [...streamLines],
          streamFooter: '流式内容已到达，界面正在逐行刷新。',
          streamError: '',
        });
      }
      const elapsedMs = Date.now() - startedAt;

      this.setData({
        streamStatus: 'success',
        streamElapsedTime: `${elapsedMs} ms`,
        streamSourceLabel: sourceLabel,
        streamHeadline: `流式预览已拆分为 ${streamLines.length} 行`,
        streamBody: streamLines.length ? '' : '收到空的流式内容。',
        streamLines,
        streamFooter: '这张卡通过 fetch body reader 解码文本，并按换行拆分逐行展示。',
        streamError: '',
      });
    } catch (error) {
      const elapsedMs = Date.now() - startedAt;
      const message = error && error.message ? error.message : String(error);
      this.setData({
        streamStatus: 'fail',
        streamElapsedTime: `${elapsedMs} ms`,
        streamSourceLabel: 'Stream preview unavailable',
        streamHeadline: '流式预览加载失败',
        streamBody: '当前无法完成流式 HTTPS 预览，请稍后再试。',
        streamLines: [],
        streamFooter: '失败状态会保留下来，便于观察 reader 或网络错误。',
        streamError: message,
      });
    }
  },

  async runCompatibilityChecks() {
    if (this.data.checksStatus === 'running') {
      return;
    }

    this.setData({
      checksStatus: 'running',
      checksSummary: '正在运行 fetch 兼容性检查...',
      checksItems: [],
      checksError: '',
    });

    const items = [];

    try {
      const headers = new Headers([
        ['X-Test', 'one'],
        ['x-test', 'two'],
      ]);
      const headerPass = headers.has('x-test') && headers.get('X-Test') === 'one, two';
      items.push(
        formatCheck(
          'Headers',
          headerPass,
          headerPass ? '大小写不敏感查询与重复值合并正常。' : 'Headers 合并结果与预期不一致。'
        )
      );

      const sourceResponse = new Response('clone-body', {
        headers: {
          'Content-Type': 'text/plain; charset=utf-8',
        },
      });
      const clonedResponse = sourceResponse.clone();
      const originalText = await sourceResponse.text();
      const clonedText = await clonedResponse.text();
      const clonePass =
        originalText === 'clone-body' &&
        clonedText === 'clone-body' &&
        sourceResponse.bodyUsed &&
        clonedResponse.bodyUsed;
      items.push(
        formatCheck(
          'Response.clone()',
          clonePass,
          clonePass ? '原始响应和克隆响应都能独立消费 body。' : 'clone 后的 body 消费结果不正确。'
        )
      );

      const lockedResponse = new Response('reader-lock', {
        headers: {
          'Content-Type': 'text/plain; charset=utf-8',
        },
      });
      const reader = lockedResponse.body.getReader();
      let lockRejected = false;
      try {
        await lockedResponse.text();
      } catch (_) {
        lockRejected = true;
      }
      if (reader.releaseLock) {
        reader.releaseLock();
      }
      items.push(
        formatCheck(
          'Body lock',
          lockRejected,
          lockRejected ? 'reader 锁定后，便利消费器会正确拒绝。' : 'reader 锁定时仍然允许 text()。'
        )
      );

      const passed = items.filter((item) => item.pass).length;
      this.setData({
        checksStatus: passed === items.length ? 'success' : 'partial',
        checksSummary:
          passed === items.length
            ? '兼容性检查全部通过。'
            : `兼容性检查通过 ${passed}/${items.length} 项。`,
        checksItems: items,
        checksError: '',
      });
    } catch (error) {
      const message = error && error.message ? error.message : String(error);
      this.setData({
        checksStatus: 'fail',
        checksSummary: '兼容性检查未能完成。',
        checksItems: items,
        checksError: message,
      });
    }
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

    <view class="card briefing-card briefing-{{briefingStatus}}">
      <text class="section-title">{{briefingHeadline}}</text>
      <text class="briefing-body">{{briefingBody}}</text>
      <text class="meta-line">
        Status: {{briefingStatus}} · Code: {{briefingStatusCode}} · Elapsed: {{briefingElapsedTime}}
      </text>
      <text class="meta-line">Source: {{briefingSourceLabel}}</text>
      <text class="meta-line" ink:if="{{briefingError}}">Error: {{briefingError}}</text>
      <text class="briefing-footer">{{briefingFooter}}</text>
    </view>

    <view class="card stream-card stream-{{streamStatus}}">
      <text class="section-title">{{streamHeadline}}</text>
      <view class="stream-lines" ink:if="{{streamLines.length}}">
        <view class="stream-line-item" ink:for="{{streamLines}}" ink:key="id">
          <text class="stream-line-text">{{item.text}}</text>
        </view>
      </view>
      <text class="briefing-body" ink:else>{{streamBody}}</text>
      <text class="meta-line">Status: {{streamStatus}} · Elapsed: {{streamElapsedTime}}</text>
      <text class="meta-line">Source: {{streamSourceLabel}}</text>
      <text class="meta-line" ink:if="{{streamError}}">Error: {{streamError}}</text>
      <text class="briefing-footer">{{streamFooter}}</text>
    </view>

    <view class="card checks-card checks-{{checksStatus}}">
      <text class="section-title">Compatibility Checks</text>
      <text class="briefing-body">{{checksSummary}}</text>
      <view ink:if="{{checksItems.length}}">
        <view class="check-item" ink:for="{{checksItems}}" ink:key="id">
          <text class="check-label">{{item.label}} · {{item.badge}}</text>
          <text class="meta-line">{{item.detail}}</text>
        </view>
      </view>
      <text class="meta-line" ink:if="{{checksError}}">Error: {{checksError}}</text>
    </view>

    <card class="card action-card">
      <view class="button-row" role="navigation">
        <button class="btn" bindtap="loadBriefing">Load Briefing</button>
        <button class="btn" bindtap="loadStreamPreview">Stream Preview</button>
        <button class="btn" bindtap="runCompatibilityChecks">Run Checks</button>
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

  .stream-card,
  .checks-card {
    background-color: var(--color-surface-highlight, #f8f8fb);
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

  .stream-success,
  .checks-success {
    border-color: var(--border-color-success, #34c759);
  }

  .stream-fail,
  .checks-fail {
    border-color: var(--border-color-danger, #ff3b30);
  }

  .stream-loading,
  .checks-running {
    border-color: var(--border-color-warning, #ff9f0a);
  }

  .checks-partial {
    border-color: var(--border-color-warning, #ff9f0a);
  }

  .check-item {
    display: flex;
    flex-direction: column;
    gap: 4px;
    padding: 10px 12px;
    border-radius: var(--radius-md, 10px);
    background-color: var(--color-surface, #ffffff);
  }

  .stream-lines {
    display: flex;
    flex-direction: column;
    gap: 8px;
  }

  .stream-line-item {
    display: flex;
    flex-direction: column;
    padding: 10px 12px;
    border-radius: var(--radius-md, 10px);
    background-color: var(--color-surface, #ffffff);
  }

  .stream-line-text {
    font-size: 14px;
    line-height: 20px;
    color: var(--color-text-secondary);
  }

  .check-label {
    font-size: 14px;
    font-weight: bold;
    color: var(--color-text-primary);
  }

  .button-row {
    display: flex;
    flex-direction: row;
    gap: 12px;
    flex-wrap: wrap;
  }

  .btn {
    flex: 1;
    min-width: 0;
    font-size: 15px;
  }
</style>
