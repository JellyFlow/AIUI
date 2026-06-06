<script type="application/json" def>
{
  "navigationBarTitleText": "ESM Import"
}
</script>

<script setup>
import directModule, {
  directBadge,
  directDetails,
  moduleName,
  pageTitle,
} from './constants.js';
import nestedModule, {
  nestedMessage,
  nestedRecord,
} from './nested/message.js';
import proxyModule, {
  assetPreviews,
  proxyRecord,
  proxySummary,
  reExportedNestedMessage,
  reExportedNestedRecord,
} from './nested/asset-proxy.js';

const directPassed = Boolean(
  pageTitle
  && moduleName
  && directBadge
  && directDetails?.owner
  && directModule?.description,
);
const nestedPassed = Boolean(
  nestedMessage
  && nestedRecord?.stage
  && nestedModule?.summary,
);
const reExportPassed = Boolean(
  reExportedNestedMessage === nestedMessage
  && reExportedNestedRecord?.inheritedOwner === directDetails.owner
  && proxyRecord?.assetCount === assetPreviews.length
  && proxyModule?.moduleName,
);
const assetPassed = assetPreviews.every((asset) => (
  asset.previewPath
  && asset.modulePath
  && asset.mimeType
  && asset.exportShape
));

const directCard = {
  title: 'Starter Brief Module',
  status: directPassed ? 'Ready' : 'Unavailable',
  statusTone: directPassed ? 'pass' : 'fail',
  details: [
    moduleName,
    directModule.description,
    `Badge: ${directBadge}`,
    `Owner: ${directDetails.owner}`,
  ],
};

const nestedCard = {
  title: 'Message Module',
  status: nestedPassed ? 'Ready' : 'Unavailable',
  statusTone: nestedPassed ? 'pass' : 'fail',
  details: [
    nestedMessage,
    nestedModule.summary,
    `Stage: ${nestedRecord.stage}`,
    `Inherited note: ${nestedRecord.inheritedDescription}`,
  ],
};

const reExportCard = {
  title: 'Shared Toolkit Module',
  status: reExportPassed ? 'Ready' : 'Unavailable',
  statusTone: reExportPassed ? 'pass' : 'fail',
  details: [
    reExportedNestedMessage,
    proxySummary,
    `Asset pack size: ${proxyRecord.assetCount}`,
    `Bundle: ${proxyModule.moduleName}`,
  ],
};

const assetCard = {
  title: 'Asset Gallery',
  status: assetPassed ? 'Ready' : 'Unavailable',
  statusTone: assetPassed ? 'pass' : 'fail',
  details: [
    proxySummary,
    '这些图片资源已经通过代理模块装配到页面里，可直接用于卡片与预览区。',
  ],
  assets: assetPreviews,
};

const moduleCards = [directCard, nestedCard, reExportCard];

export default {
  data: {
    pageTitle,
    moduleCards,
    assetCard,
  },
};
</script>

<page>
  <view class="container">
    <view class="page-title">{{pageTitle}}</view>
    <text class="page-description">
      把 ESM 导入能力改成一个功能模块画廊。每张卡都代表一个已经装配完成、可以直接使用的模块。
    </text>

    <view class="card">
      <view class="card-header">
        <text class="section-title">Modules</text>
        <text class="meta-line">Ready bundles: {{moduleCards.length}}</text>
      </view>
      <view class="detail-list">
        <view class="detail-item" ink:for="{{moduleCards}}" ink:key="title">
          <view class="card-header">
            <text class="detail-title">{{item.title}}</text>
            <text class="status-chip status-{{item.statusTone}}">{{item.status}}</text>
          </view>
          <text class="detail-text">{{item.details[0]}}</text>
          <text class="detail-text">{{item.details[1]}}</text>
        </view>
      </view>
    </view>

    <view class="card">
      <view class="card-header">
        <text class="section-title">{{assetCard.title}}</text>
        <text class="status-chip status-{{assetCard.statusTone}}">{{assetCard.status}}</text>
      </view>
      <view class="detail-list">
        <view class="detail-item" ink:for="{{assetCard.details}}">
          <text class="detail-text">{{item}}</text>
        </view>
      </view>
      <view class="asset-list">
        <view class="asset-item" ink:for="{{assetCard.assets}}">
          <text class="asset-title">{{item.label}}</text>
          <text class="meta-line">Format: {{item.mimeType}}</text>
          <text class="meta-line">Usage: imported preview asset</text>
          <view class="asset-preview">
            <image class="asset-image" src="{{item.previewPath}}" mode="aspectFit" />
          </view>
        </view>
      </view>
    </view>
  </view>
</page>

<style>
  .container {
    display: flex;
    flex-direction: column;
    padding: var(--spacing-lg, 20px);
    gap: 16px;
    background-color: var(--color-background);
  }

  .page-title {
    font-size: 28px;
    font-weight: bold;
    color: var(--color-text-primary);
  }

  .page-description {
    font-size: 14px;
    line-height: 20px;
    color: var(--color-text-secondary);
  }

  .card {
    display: flex;
    flex-direction: column;
    gap: var(--spacing-sm, 10px);
    padding: var(--spacing-md, 16px);
    border-radius: var(--radius-md, 12px);
    background-color: var(--color-surface);
    border: var(--border-width-thin, 1px) solid var(--border-color-default, #d1d1d6);
  }

  .card-header {
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    align-items: center;
    gap: 12px;
  }

  .section-title {
    font-size: 18px;
    font-weight: bold;
    color: var(--color-text-primary);
  }

  .status-chip {
    padding: 4px 10px;
    border-radius: 999px;
    font-size: 12px;
    font-weight: bold;
    font-family: monospace;
  }

  .status-pass {
    background-color: rgba(52, 199, 89, 0.16);
    color: var(--border-color-success, #34c759);
  }

  .status-fail {
    background-color: rgba(255, 59, 48, 0.14);
    color: var(--border-color-danger, #ff3b30);
  }

  .meta-line,
  .detail-text {
    font-size: 13px;
    line-height: 18px;
    color: var(--color-text-primary);
    font-family: monospace;
  }

  .summary-list,
  .detail-list,
  .asset-list {
    display: flex;
    flex-direction: column;
    gap: var(--spacing-sm, 10px);
  }

  .detail-item {
    padding: 10px 12px;
    border-radius: var(--radius-md, 10px);
    background-color: var(--color-surface-highlight, #f2f2f7);
  }

  .detail-title {
    font-size: 15px;
    font-weight: 600;
    color: var(--color-text-primary);
  }

  .asset-item {
    display: flex;
    flex-direction: column;
    gap: 8px;
    padding: 14px;
    border-radius: var(--radius-md, 12px);
    background-color: var(--color-surface-highlight, #f2f2f7);
  }

  .asset-title {
    font-size: 16px;
    font-weight: 600;
    color: var(--color-text-primary);
  }

  .asset-preview {
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 180px;
    padding: var(--spacing-md, 12px);
    border-radius: var(--radius-md, 10px);
    background-color: var(--color-surface);
  }

  .asset-image {
    width: 100%;
    max-width: 320px;
    height: 160px;
  }
</style>
