<script setup>
  const tileUrl = 'https://demotiles.maplibre.org/tiles-omt/{z}/{x}/{y}.pbf';

  export default {
    data: {
      tileUrl
    },
    onLoad() {
      console.log('Map MVT page loaded');
    }
  };
</script>

<page>
  <view class="container">
    <view class="page-header">
      <text class="page-kicker">Mapbox Vector Tiles</text>
      <text class="title">MVT 地图渲染</text>
      <text class="subtitle">
        使用公开 MapLibre demo 矢量瓦片源，验证 map 组件的瓦片请求、MVT 解码和基础面线点渲染。
      </text>
    </view>

    <view class="panel">
      <view class="panel-heading">
        <text class="section-kicker">City Overview</text>
        <text class="section-title">Innsbruck 视图</text>
        <text class="section-note">zoom 12 会同时覆盖水体、道路、建筑和行政边界等常见 MVT 图层。</text>
      </view>
      <map
        class="map-surface map-surface-large"
        tile-url="{{ tileUrl }}"
        longitude="11.4041"
        latitude="47.2692"
        zoom="12"
      />
    </view>

    <view class="panel">
      <view class="panel-heading">
        <text class="section-kicker">Local Detail</text>
        <text class="section-title">同一瓦片源的更高缩放级别</text>
        <text class="section-note">第二张地图使用不同配色和 zoom 14，方便观察缓存、重绘和线宽变化。</text>
      </view>
      <map
        class="map-surface map-surface-small"
        tile-url="{{ tileUrl }}"
        longitude="11.4041"
        latitude="47.2692"
        zoom="14"
      />
    </view>
  </view>
</page>

<style>
  .container {
    display: flex;
    flex-direction: column;
    width: 100%;
    padding: var(--spacing-lg, 20px);
    gap: var(--spacing-lg, 20px);
    box-sizing: border-box;
    background-color: var(--color-background);
  }

  .page-header {
    display: flex;
    flex-direction: column;
    gap: 6px;
  }

  .page-kicker,
  .section-kicker {
    font-size: 12px;
    color: var(--color-text-secondary);
  }

  .title {
    font-size: 28px;
    font-weight: bold;
    color: var(--color-text-primary);
  }

  .subtitle,
  .section-note {
    font-size: 14px;
    color: var(--color-text-secondary);
    line-height: 20px;
  }

  .panel {
    display: flex;
    flex-direction: column;
    gap: 12px;
    padding: var(--spacing-md, 16px);
    border-radius: var(--radius-sm, 8px);
    border: var(--border-width-thin, 1px) solid var(--border-color-default, #d5dadd);
    background-color: var(--color-surface);
  }

  .panel-heading {
    display: flex;
    flex-direction: column;
    gap: 5px;
  }

  .section-title {
    font-size: 18px;
    font-weight: 600;
    color: var(--color-text-primary);
  }

  .map-surface {
    width: 100%;
    border-radius: var(--radius-sm, 8px);
    overflow: hidden;
    background-color: var(--map-background, #eff4f1);
    border: var(--border-width-thin, 1px) solid var(--border-color-default, #d5dadd);
  }

  .map-surface-large {
    height: 320px;
  }

  .map-surface-small {
    height: 220px;
  }
</style>
