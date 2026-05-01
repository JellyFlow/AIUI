<script setup>
export default {
  data: {
    singleValue: '',
    multiValue: '',
    searchQuery: '',
    disabledValue: 'Cannot edit this',
    maxValue: '',
    submittedText: '',
    submitted: false,
  },

  onLoad() {
    console.log('Input & Textarea test page loaded');
  },

  onSingleInput(e) {
    this.setData({ singleValue: e.currentTarget.value });
  },

  onMultiInput(e) {
    this.setData({ multiValue: e.currentTarget.value });
  },

  onSearchInput(e) {
    this.setData({ searchQuery: e.currentTarget.value });
  },

  onMaxInput(e) {
    this.setData({ maxValue: e.currentTarget.value });
  },

  onSubmit() {
    this.setData({
      submittedText: this.data.singleValue,
      submitted: true,
    });
  },

  onReset() {
    this.setData({
      singleValue: '',
      multiValue: '',
      searchQuery: '',
      maxValue: '',
      submittedText: '',
      submitted: false,
    });
  },
};
</script>

<page>
  <view class="container">
    <view class="page-title">Input &amp; Textarea</view>

    <!-- Single-line input -->
    <view class="card section">
      <view class="title">Single-line &lt;input&gt;</view>
      <input
        class="text-input"
        value="{{singleValue}}"
        placeholder="Type something…"
        bindinput="onSingleInput"
      />
      <text class="hint">Value: "{{singleValue}}"</text>
    </view>

    <!-- Textarea (multi-line) -->
    <view class="card section">
      <view class="title">Multi-line &lt;textarea&gt;</view>
      <textarea
        class="text-area"
        value="{{multiValue}}"
        placeholder="Write multiple lines…"
        bindinput="onMultiInput"
      />
      <text class="hint">Length: {{multiValue.length}} chars</text>
    </view>

    <!-- Search field -->
    <view class="card section">
      <view class="title">Search Input</view>
      <view class="search-row">
        <input
          class="search-input"
          value="{{searchQuery}}"
          placeholder="Search…"
          bindinput="onSearchInput"
        />
      </view>
      <text class="hint" ink:if="{{searchQuery}}">Searching for: "{{searchQuery}}"</text>
      <text class="hint muted" ink:else>Enter a search term above</text>
    </view>

    <!-- Disabled input -->
    <view class="card section">
      <view class="title">Disabled Input</view>
      <input
        class="text-input disabled-input"
        value="{{disabledValue}}"
        disabled
      />
      <text class="hint muted">This input is disabled</text>
    </view>

    <!-- maxLength input -->
    <view class="card section">
      <view class="title">maxLength = 10</view>
      <input
        class="text-input"
        value="{{maxValue}}"
        placeholder="Max 10 chars"
        maxLength="10"
        bindinput="onMaxInput"
      />
      <text class="hint">{{maxValue.length}} / 10</text>
    </view>

    <!-- Submit / reset -->
    <view class="card section">
      <view class="title">Submit Demo</view>
      <input
        class="text-input"
        value="{{singleValue}}"
        placeholder="Type a message and submit"
        bindinput="onSingleInput"
      />
      <view class="btn-row">
        <button class="btn btn-primary" bindtap="onSubmit">Submit</button>
        <button class="btn btn-secondary" bindtap="onReset">Reset</button>
      </view>
      <view ink:if="{{submitted}}" class="result-box">
        <text class="result-label">Submitted:</text>
        <text class="result-text">"{{submittedText}}"</text>
      </view>
    </view>
  </view>
</page>

<style>
  .container {
    display: flex;
    flex-direction: column;
    padding: var(--theme-padding, 20px);
  }

  .page-title {
    font-size: 24px;
    font-weight: bold;
    margin-bottom: var(--spacing-lg, 20px);
  }

  .card {
    border: var(--theme-border);
    border-radius: var(--theme-radius, 12px);
    padding: var(--card-padding, 16px);
    margin-bottom: var(--spacing-lg, 20px);
  }

  .section {
    flex-direction: column;
  }

  .title {
    font-size: 16px;
    font-weight: bold;
    margin-bottom: 12px;
    padding-bottom: 8px;
    border-bottom: var(--border-width-default, 2px) solid var(--border-color-accent, var(--theme-color, #1989fa));
  }

  .text-input {
    width: 100%;
    border: var(--input-border-width, var(--border-width-thin, 1px)) solid var(--input-border-color, var(--border-color-default, #d0d0d0));
    border-radius: var(--input-radius, 8px);
    box-sizing: border-box;
    padding: var(--input-padding-y, 10px) var(--input-padding-x, 14px);
    font-size: 15px;
    margin-bottom: 8px;
  }

  .text-area {
    width: 100%;
    border: var(--input-border-width, var(--border-width-thin, 1px)) solid var(--input-border-color, var(--border-color-default, #d0d0d0));
    border-radius: var(--input-radius, 8px);
    box-sizing: border-box;
    padding: var(--input-padding-y, 10px) var(--input-padding-x, 14px);
    font-size: 15px;
    margin-bottom: 8px;
    min-height: 80px;
  }

  .disabled-input {
    border-color: var(--border-color-muted, var(--color-primary-40, #e0e0e0));
  }

  .search-row {
    flex-direction: row;
    align-items: center;
    margin-bottom: 8px;
  }

  .search-input {
    flex-grow: 1;
    border: var(--input-border-width, var(--border-width-thin, 1px)) solid var(--input-border-color, var(--border-color-default, #d0d0d0));
    border-radius: 20px;
    box-sizing: border-box;
    padding: 8px var(--input-padding-x, 16px);
    font-size: 14px;
  }

  .hint {
    font-size: 13px;
    margin-top: 4px;
  }

  .muted {
  }

  .btn-row {
    flex-direction: row;
    margin-top: 12px;
    margin-bottom: 8px;
  }

  .btn {
    border-radius: var(--radius-sm, 8px);
    padding: 10px var(--spacing-lg, 20px);
    font-size: 14px;
    font-weight: bold;
    margin-right: 10px;
    text-align: center;
  }

  .btn-primary {
  }

  .btn-secondary {
  }

  .result-box {
    flex-direction: column;
    border: var(--border-width-thin, 1px) solid var(--border-color-success, var(--theme-color, #34c759));
    border-radius: var(--radius-sm, 8px);
    padding: var(--theme-padding, 12px);
    margin-top: 8px;
  }

  .result-label {
    font-size: 13px;
    font-weight: bold;
    margin-bottom: 4px;
  }

  .result-text {
    font-size: 14px;
  }
</style>
