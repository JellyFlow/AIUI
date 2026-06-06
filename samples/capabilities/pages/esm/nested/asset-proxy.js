import nestedModule, { nestedMessage, nestedRecord } from './message.js';
import elephantAsset, {
  mimeType as elephantMimeType,
  path as elephantModulePath,
} from '../../../assets/elephant.png';
import avatarAsset, {
  mimeType as avatarMimeType,
  path as avatarModulePath,
} from '../../../assets/avatar.jpg';
import clearDayAsset, {
  mimeType as clearDayMimeType,
  path as clearDayModulePath,
} from '../../../assets/clear-day.svg';

function toAssetPreview(id, label, asset, previewPath, modulePath, mimeType) {
  return {
    id,
    label,
    previewPath,
    modulePath,
    mimeType,
    exportShape:
      typeof asset?.arrayBuffer === 'function' ? 'blob-like default export' : typeof asset,
  };
}

export const assetPreviews = [
  toAssetPreview(
    'png',
    'PNG via JS proxy',
    elephantAsset,
    '../../assets/elephant.png',
    elephantModulePath,
    elephantMimeType,
  ),
  toAssetPreview(
    'jpg',
    'JPG via JS proxy',
    avatarAsset,
    '../../assets/avatar.jpg',
    avatarModulePath,
    avatarMimeType,
  ),
  toAssetPreview(
    'svg',
    'SVG via JS proxy',
    clearDayAsset,
    '../../assets/clear-day.svg',
    clearDayModulePath,
    clearDayMimeType,
  ),
];

export const proxySummary = 'Proxy module extends the JS chain to imported assets.';
export const proxyRecord = {
  stage: 'page -> js -> js -> resource',
  nestedSummary: nestedModule.summary,
  assetCount: assetPreviews.length,
};

export {
  nestedMessage as reExportedNestedMessage,
  nestedRecord as reExportedNestedRecord,
} from './message.js';

const proxyModule = {
  moduleName: 'asset-proxy.js',
  assetCount: assetPreviews.length,
  summary: `${nestedMessage} and ${assetPreviews.length} indirect asset imports`,
};

export default proxyModule;
