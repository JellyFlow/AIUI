<script setup>
  import wx from 'wx';

  const CLOSE_DELAY_MS = 80;

  export default {
    data: {
      status: 'Ready to leave this session.',
      pendingMethod: '',
    },

    requestClose(method, action) {
      this.setData({
        status: `Leaving via ${method}...`,
        pendingMethod: method,
      });

      setTimeout(() => {
        action();
      }, CLOSE_DELAY_MS);
    },

    closeWithWindow() {
      this.requestClose('window.close()', () => {
        window.close();
      });
    },

    closeWithWx() {
      this.requestClose('wx.exitMiniProgram()', () => {
        wx.exitMiniProgram();
      });
    },
  };
</script>

<page>
  <view class="container">
    <view class="page-title">Leave Session</view>
    <text class="page-description">
      这是一个真实的退出确认页，用来结束当前会话或关闭当前视图，而不是展示底层生命周期说明。
    </text>

    <card class="card section">
      <text class="section-title">Leave Now</text>
      <text class="status-text">{{status}}</text>
      <text class="hint" ink:if="{{pendingMethod}}">
        如果页面仍然可见，说明宿主尚未接手 `{{pendingMethod}}` 这次退出请求。
      </text>
      <view class="button-row" role="navigation">
        <button class="btn btn-primary" bindtap="closeWithWindow">window.close()</button>
        <button class="btn btn-secondary" bindtap="closeWithWx">wx.exitMiniProgram()</button>
      </view>
    </card>
  </view>
</page>

<style>
  .container {
    display: flex;
    flex-direction: column;
    padding: var(--theme-padding, 20px);
  }

  .page-title {
    font-size: 28px;
    font-weight: bold;
    margin-bottom: var(--spacing-md, 12px);
  }

  .page-description {
    font-size: 14px;
    line-height: 20px;
    color: var(--color-text-secondary, #666666);
    margin-bottom: var(--spacing-lg, 20px);
  }

  .card {
    background-color: var(--color-surface, #ffffff);
    border: var(--border-width-thin, 1px) solid var(--border-color-default, #e5e5ea);
    border-radius: var(--radius-md, 12px);
    padding: var(--spacing-md, 16px);
  }

  .section {
    display: flex;
    flex-direction: column;
    margin-bottom: var(--spacing-md, 16px);
  }

  .section-title {
    font-size: 16px;
    font-weight: bold;
    margin-bottom: var(--spacing-sm, 10px);
  }

  .btn {
    font-size: 16px;
    font-weight: bold;
    padding: 12px 20px;
    text-align: center;
  }

  .button-row {
    display: flex;
    flex-direction: row;
    gap: 12px;
    margin-top: 6px;
  }

  .status-text {
    font-size: 14px;
    font-family: monospace;
    margin-bottom: var(--spacing-sm, 10px);
  }

  .hint {
    font-size: 12px;
    line-height: 18px;
    color: var(--color-text-secondary, #666666);
  }
</style>
