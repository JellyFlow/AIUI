<script type="application/json" def>
{
  "navigationBarTitleText": "TypeScript SFC"
}
</script>

<script setup lang="ts">
type SignalTone = 'pass' | 'info';

interface Signal {
  title: string;
  value: string;
  tone: SignalTone;
}

interface PageData {
  pageTitle: string;
  signals: Signal[];
  activeSignal: string;
  compileNote: string;
}

interface TapEvent {
  currentTarget?: {
    attributes?: Record<string, string>;
  };
}

const typedSignals: Signal[] = [
  {
    title: 'lang="ts"',
    value: 'SFC script language metadata reached the SWC pipeline.',
    tone: 'pass',
  },
  {
    title: 'typed setup',
    value: 'Interfaces, aliases, and annotated constants were erased.',
    tone: 'pass',
  },
  {
    title: 'template binding',
    value: 'Typed data is available to the page template after compilation.',
    tone: 'info',
  },
];

const pageData: PageData = {
  pageTitle: 'TypeScript SFC Setup',
  signals: typedSignals,
  activeSignal: typedSignals[0]!.title,
  compileNote: `${typedSignals.length} SFC TypeScript signals rendered.`,
};

export default {
  data: pageData,

  focusSignal(e: TapEvent): void {
    const title = e.currentTarget?.attributes?.['data-title'] || pageData.activeSignal;
    this.setData({
      activeSignal: title,
      compileNote: `Focused ${title} from a typed event handler.`,
    });
  },
};
</script>

<page>
  <view class="container">
    <view class="page-title">{{pageTitle}}</view>
    <text class="page-subtitle">
      This single-file component keeps the template and style in .ink while compiling the setup script as TypeScript.
    </text>

    <view class="signal-grid">
      <view class="signal-card signal-{{item.tone}}" ink:for="{{signals}}" ink:key="title">
        <button class="signal-button" bindtap="focusSignal" data-title="{{item.title}}">
          <text class="signal-title">{{item.title}}</text>
          <text class="signal-value">{{item.value}}</text>
        </button>
      </view>
    </view>

    <view class="result-panel">
      <text class="result-title">Active Signal</text>
      <text class="result-text">{{activeSignal}}</text>
      <text class="result-text">{{compileNote}}</text>
    </view>
  </view>
</page>

<style>
  .container {
    display: flex;
    flex-direction: column;
    padding: var(--spacing-lg, 20px);
    color: var(--color-text-primary);
  }

  .page-title {
    font-size: 24px;
    font-weight: 700;
  }

  .page-subtitle {
    font-size: 14px;
    line-height: 20px;
    color: var(--color-text-secondary);
    margin-top: var(--spacing-sm, 8px);
    margin-bottom: var(--spacing-lg, 20px);
  }

  .signal-grid {
    display: flex;
    flex-direction: column;
    gap: 12px;
    margin-bottom: var(--spacing-lg, 20px);
  }

  .signal-card {
    border: var(--border-width-thin, 1px) solid var(--border-color-default, #d1d1d6);
    border-radius: var(--radius-md, 12px);
    background-color: var(--color-surface);
  }

  .signal-pass {
    border-color: var(--border-color-success, #34c759);
  }

  .signal-info {
    border-color: var(--border-color-accent, #1989fa);
  }

  .signal-button {
    width: 100%;
    min-height: 84px;
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    justify-content: center;
    gap: 6px;
    padding: 14px;
    text-align: left;
  }

  .signal-title,
  .result-title {
    font-size: 15px;
    font-weight: 700;
  }

  .signal-value,
  .result-text {
    font-size: 13px;
    line-height: 18px;
    color: var(--color-text-secondary);
  }

  .result-panel {
    display: flex;
    flex-direction: column;
    gap: 6px;
    padding: var(--spacing-md, 16px);
    border-radius: var(--radius-md, 12px);
    background-color: var(--color-surface-highlight);
  }
</style>
