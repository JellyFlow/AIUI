<script type="application/json" def>
{
  "navigationBarTitleText": "TypeScript Modules"
}
</script>

<script setup lang="ts">
import type { ModuleCase } from './cases';
import { moduleCases, summarizeCases } from './cases';

interface PageState {
  pageTitle: string;
  cards: ModuleCase[];
  summary: string;
  selectedDetail: string;
}

interface TapEvent {
  currentTarget?: {
    attributes?: Record<string, string>;
  };
}

const cards = moduleCases.map((item: ModuleCase): ModuleCase => ({
  ...item,
  detail: item.detail as string,
}));

const initialState: PageState = {
  pageTitle: 'TypeScript Module Imports',
  cards,
  summary: summarizeCases(cards),
  selectedDetail: cards[0]!.detail,
};

export default {
  data: initialState,

  inspectCase(e: TapEvent): void {
    const detail = e.currentTarget?.attributes?.['data-detail'] || initialState.selectedDetail;
    this.setData({
      selectedDetail: detail,
      summary: `Imported module detail: ${detail}`,
    });
  },
};
</script>

<page>
  <view class="container">
    <view class="page-title">{{pageTitle}}</view>
    <text class="page-subtitle">
      This page imports TypeScript helpers with an extensionless module specifier and keeps type-only imports out of runtime code.
    </text>

    <view class="module-list">
      <view class="module-card module-{{item.tone}}" ink:for="{{cards}}" ink:key="title">
        <button class="module-button" bindtap="inspectCase" data-detail="{{item.detail}}">
          <text class="module-title">{{item.title}}</text>
          <text class="module-detail">{{item.detail}}</text>
        </button>
      </view>
    </view>

    <view class="summary-card">
      <text class="summary-title">Loader Result</text>
      <text class="summary-text">{{summary}}</text>
      <text class="summary-text">{{selectedDetail}}</text>
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

  .module-list {
    display: flex;
    flex-direction: column;
    gap: 12px;
    margin-bottom: var(--spacing-lg, 20px);
  }

  .module-card {
    border: var(--border-width-thin, 1px) solid var(--border-color-default, #d1d1d6);
    border-radius: var(--radius-md, 12px);
    background-color: var(--color-surface);
  }

  .module-pass {
    border-color: var(--border-color-success, #34c759);
  }

  .module-info {
    border-color: var(--border-color-accent, #1989fa);
  }

  .module-button {
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

  .module-title,
  .summary-title {
    font-size: 15px;
    font-weight: 700;
  }

  .module-detail,
  .summary-text {
    font-size: 13px;
    line-height: 18px;
    color: var(--color-text-secondary);
  }

  .summary-card {
    display: flex;
    flex-direction: column;
    gap: 6px;
    padding: var(--spacing-md, 16px);
    border-radius: var(--radius-md, 12px);
    background-color: var(--color-surface-highlight);
  }
</style>
