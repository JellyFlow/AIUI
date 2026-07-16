<script type="application/json" def>
{
  "navigationBarTitleText": "WebAssembly"
}
</script>

<script setup>
import wasmBlob from './math.wasm';

function formatResult(passed, label, actual, expected) {
  return {
    label,
    actual: String(actual),
    expected: String(expected),
    tone: passed ? 'pass' : 'fail',
    status: passed ? 'Pass' : 'Fail',
  };
}

export default {
  data: {
    title: 'WebAssembly Runtime',
    status: 'idle',
    statusText: 'Ready to instantiate math.wasm',
    moduleSize: `${wasmBlob.size} bytes`,
    mimeType: wasmBlob.type || 'application/wasm',
    validateResult: 'Not run',
    summary: 'Tap Run Wasm to compile and execute exported functions.',
    results: [],
    error: '',
  },

  async runWasm() {
    if (this.data.status === 'running') {
      return;
    }

    this.setData({
      status: 'running',
      statusText: 'Compiling and instantiating math.wasm...',
      validateResult: 'Checking...',
      summary: 'Running WebAssembly exports.',
      results: [],
      error: '',
    });

    try {
      const isValid = WebAssembly.validate(wasmBlob);
      const { instance } = await WebAssembly.instantiate(wasmBlob);
      const addValue = instance.exports.add(13, 29);
      const mulValue = instance.exports.mul(7, 6);
      const scoreValue = instance.exports.score(5);
      const rows = [
        formatResult(addValue === 42, 'add(13, 29)', addValue, 42),
        formatResult(mulValue === 42, 'mul(7, 6)', mulValue, 42),
        formatResult(scoreValue === 46, 'score(5)', scoreValue, 46),
      ];
      const passed = isValid && rows.every((row) => row.tone === 'pass');

      this.setData({
        status: passed ? 'pass' : 'fail',
        statusText: passed ? 'Wasm execution passed' : 'Wasm execution mismatch',
        validateResult: isValid ? 'Valid module' : 'Invalid module',
        summary: passed
          ? 'math.wasm compiled, instantiated, and returned expected values.'
          : 'One or more WebAssembly exports returned an unexpected value.',
        results: rows,
        error: '',
      });
    } catch (error) {
      this.setData({
        status: 'fail',
        statusText: 'Wasm execution failed',
        validateResult: 'Failed',
        summary: 'The runtime raised an error while executing math.wasm.',
        results: [],
        error: error && error.message ? error.message : String(error),
      });
    }
  },
};
</script>

<page>
  <view class="container">
    <view class="hero">
      <text class="kicker">Runtime Capability</text>
      <text class="title">{{title}}</text>
      <text class="description">
        Imports a compiled .wasm asset, validates it, instantiates it, and calls numeric exports.
      </text>
    </view>

    <view class="status-card status-{{status}}">
      <text class="section-title">{{statusText}}</text>
      <text class="meta">Module: math.wasm · {{moduleSize}} · {{mimeType}}</text>
      <text class="meta">Validate: {{validateResult}}</text>
      <text class="summary">{{summary}}</text>
      <text class="error" ink:if="{{error}}">{{error}}</text>
    </view>

    <view class="result-list">
      <view class="result-row result-{{item.tone}}" ink:for="{{results}}" ink:key="label">
        <text class="result-label">{{item.label}}</text>
        <text class="result-value">Actual {{item.actual}} · Expected {{item.expected}}</text>
        <text class="result-status">{{item.status}}</text>
      </view>
    </view>

    <view class="action-card">
      <button class="run-button" bindtap="runWasm">Run Wasm</button>
    </view>
  </view>
</page>

<style>
  .container {
    display: flex;
    flex-direction: column;
    gap: 14px;
    padding: var(--theme-padding, 20px);
    background-color: var(--color-background);
  }

  .hero,
  .status-card,
  .action-card,
  .result-row {
    display: flex;
    flex-direction: column;
    gap: 8px;
    padding: var(--spacing-md, 16px);
    border-radius: var(--radius-md, 12px);
    border: var(--border-width-thin, 1px) solid var(--border-color-default, #d1d1d6);
    background-color: var(--color-surface);
  }

  .kicker,
  .meta,
  .result-value {
    font-size: 12px;
    line-height: 18px;
    color: var(--color-text-secondary);
  }

  .title {
    font-size: 28px;
    font-weight: 700;
    color: var(--color-text-primary);
  }

  .description,
  .summary,
  .error {
    font-size: 14px;
    line-height: 20px;
    color: var(--color-text-secondary);
  }

  .section-title,
  .result-label,
  .result-status {
    font-size: 15px;
    font-weight: 700;
    color: var(--color-text-primary);
  }

  .status-pass,
  .result-pass {
    border-color: var(--border-color-success, #34c759);
  }

  .status-fail,
  .result-fail {
    border-color: var(--border-color-danger, #ff3b30);
  }

  .status-running {
    border-color: var(--border-color-warning, #ff9f0a);
  }

  .result-list {
    display: flex;
    flex-direction: column;
    gap: 10px;
  }

  .error {
    color: var(--color-danger, #ff3b30);
  }

  .run-button {
    width: 100%;
    min-height: 48px;
    font-size: 15px;
  }
</style>
