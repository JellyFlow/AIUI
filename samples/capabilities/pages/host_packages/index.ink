<script def>
{
  "navigationBarTitleText": "Host Packages",
  "usingComponents": {
    "host-card": "@rokid/ui/host-card"
  }
}
</script>

<script setup>
import { buildHostSummary, packageFlavor, packageName } from '@rokid/ui';
import { source as sharedSource } from '@rokid/shared';

const helperSummary = buildHostSummary(
  'Helper import',
  'JavaScript module loaded from fixtures/packages',
);

export default {
  data: {
    pageTitle: 'Host Packages',
    intro:
      'This page verifies host-injected packages through ink-open. Launch it with --host-packages-dir fixtures/packages.',
    helperSummary,
    helperPackageName: packageName,
    helperPackageFlavor: packageFlavor,
    sharedSource,
    expectedOverride: sharedSource === 'app-local' ? 'PASS' : 'FAIL',
    overrideMessage:
      sharedSource === 'app-local'
        ? 'App-local node_modules overrides the host package with the same name.'
        : 'Unexpected source resolution result.',
  },
};
</script>

<page>
  <view class="container">
    <view class="page-title">{{pageTitle}}</view>
    <text class="page-subtitle">{{intro}}</text>

    <view class="card">
      <text class="section-title">Host JavaScript Import</text>
      <text class="detail-line">{{helperSummary}}</text>
      <text class="detail-line">package: {{helperPackageName}}</text>
      <text class="detail-line">source: {{helperPackageFlavor}}</text>
    </view>

    <view class="card">
      <text class="section-title">Host Component</text>
      <host-card
        eyebrow="Host Package Component"
        title="Host Card From @rokid/ui"
        subtitle="Rendered through usingComponents with explicit ink.components mapping"
        detail="Resolved through usingComponents: @rokid/ui/host-card"
        tone="success"
        statusText="ONLINE"
        metaPackage="@rokid/ui"
        metaSource="host package registry"
        metaComponent="@rokid/ui/host-card"
        note="This component lives in fixtures/packages and is mounted by the host, but it still consumes page-level theme variables."
      />
    </view>

    <view class="card">
      <text class="section-title">App Package Override</text>
      <text class="status-chip status-{{expectedOverride === 'PASS' ? 'pass' : 'fail'}}">
        {{expectedOverride}}
      </text>
      <text class="detail-line">resolved @rokid/shared source: {{sharedSource}}</text>
      <text class="detail-line">{{overrideMessage}}</text>
    </view>
  </view>
</page>

<style>
  .container {
    display: flex;
    flex-direction: column;
    gap: 16px;
    padding: var(--spacing-lg, 20px);
    background-color: var(--color-background);
  }

  .page-title {
    font-size: 28px;
    font-weight: 700;
    color: var(--color-text-primary);
  }

  .page-subtitle {
    font-size: 14px;
    line-height: 20px;
    color: var(--color-text-secondary);
  }

  .card {
    display: flex;
    flex-direction: column;
    gap: 10px;
    padding: var(--spacing-md, 16px);
    border-radius: var(--radius-md, 12px);
    background-color: var(--color-surface);
    border: var(--border-width-thin, 1px) solid var(--border-color-default, #d1d1d6);
  }

  .section-title {
    font-size: 17px;
    font-weight: 700;
    color: var(--color-text-primary);
  }

  .detail-line {
    font-size: 13px;
    line-height: 18px;
    color: var(--color-text-secondary);
  }

  .status-chip {
    align-self: flex-start;
    padding: 4px 10px;
    border-radius: 999px;
    font-size: 12px;
    font-weight: 700;
  }

  .status-pass {
    background-color: rgba(52, 199, 89, 0.16);
    color: var(--border-color-success, #34c759);
  }

  .status-fail {
    background-color: rgba(255, 59, 48, 0.14);
    color: var(--border-color-danger, #ff3b30);
  }
</style>
