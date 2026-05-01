<script setup>
  export default {};
</script>

<page>
  <view class="container">
    <view class="page-title">Grid</view>

    <view class="card section">
      <view class="title">Basic 3-column Grid</view>
      <view class="grid-3col">
        <view class="cell">1</view>
        <view class="cell">2</view>
        <view class="cell">3</view>
        <view class="cell">4</view>
        <view class="cell">5</view>
        <view class="cell">6</view>
      </view>
    </view>

    <view class="card section">
      <view class="title">Fixed + Fr columns</view>
      <view class="grid-fixed-fr">
        <view class="cell sidebar">Sidebar</view>
        <view class="cell main">Main</view>
      </view>
    </view>

    <view class="card section">
      <view class="title">Column + Row Gap</view>
      <view class="grid-gap">
        <view class="cell">A</view>
        <view class="cell">B</view>
        <view class="cell">C</view>
        <view class="cell">D</view>
      </view>
    </view>

    <view class="card section">
      <view class="title">Grid-column Span</view>
      <view class="grid-span">
        <view class="cell span2">Span 2</view>
        <view class="cell">3</view>
        <view class="cell">4</view>
        <view class="cell">5</view>
      </view>
    </view>

    <view class="card section">
      <view class="title">Explicit Placement</view>
      <view class="grid-place">
        <view class="cell place-a">A (col 2, row 1)</view>
        <view class="cell place-b">B (col 1, row 2)</view>
        <view class="cell place-c">C (col 3, row 2)</view>
      </view>
    </view>

    <view class="card section">
      <view class="title">Auto-fill with minmax</view>
      <view class="grid-autofill">
        <view class="cell">1</view>
        <view class="cell">2</view>
        <view class="cell">3</view>
        <view class="cell">4</view>
        <view class="cell">5</view>
      </view>
    </view>

    <view class="card section">
      <view class="title">align-items &amp; justify-items</view>
      <view class="grid-align">
        <view class="cell align-cell">Center</view>
        <view class="cell align-cell">Center</view>
        <view class="cell align-cell">Center</view>
      </view>
    </view>
  </view>
</page>

<style>
  .container {
    flex-direction: column;
    padding: 16px;
  }

  .page-title {
    font-size: 24px;
    font-weight: bold;
    margin-bottom: 16px;
  }

  .card {
    border-radius: 12px;
    border: var(--border-width-thin, 1px) solid var(--border-color-muted, #ebedf0);
  }

  .section {
    flex-direction: column;
    margin-bottom: 16px;
    padding: 16px;
  }

  .title {
    font-size: 16px;
    font-weight: 600;
    margin-bottom: 12px;
    padding-bottom: 8px;
    border-bottom: var(--border-width-thin, 1px) solid var(--border-color-muted, #ebedf0);
  }

  /* shared cell style */
  .cell {
    background-color: var(--grid-cell-background, var(--color-surface-highlight));
    font-size: 14px;
    font-weight: 600;
    display: flex;
    justify-content: center;
    align-items: center;
    border-radius: 6px;
    height: 48px;
  }

  /* ── Basic 3-column grid ── */
  .grid-3col {
    display: grid;
    grid-template-columns: 1fr 1fr 1fr;
    gap: 8px;
  }

  /* ── Fixed sidebar + flexible main ── */
  .grid-fixed-fr {
    display: grid;
    grid-template-columns: 80px 1fr;
    gap: 8px;
  }

  /* ── Column + row gap ── */
  .grid-gap {
    display: grid;
    grid-template-columns: 1fr 1fr;
    column-gap: 16px;
    row-gap: 8px;
  }

  /* ── Spanning cells ── */
  .grid-span {
    display: grid;
    grid-template-columns: 1fr 1fr 1fr;
    gap: 8px;
  }

  .span2 {
    grid-column: 1 / span 2;
  }

  /* ── Explicit placement ── */
  .grid-place {
    display: grid;
    grid-template-columns: 1fr 1fr 1fr;
    grid-template-rows: 48px 48px;
    gap: 8px;
  }

  .place-a {
    grid-column: 2;
    grid-row: 1;
  }

  .place-b {
    grid-column: 1;
    grid-row: 2;
  }

  .place-c {
    grid-column: 3;
    grid-row: 2;
  }

  /* ── Auto-fill with minmax ── */
  .grid-autofill {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(80px, 1fr));
    gap: 8px;
  }

  /* ── align-items / justify-items ── */
  .grid-align {
    display: grid;
    grid-template-columns: 1fr 1fr 1fr;
    align-items: center;
    justify-items: center;
    gap: 8px;
    height: 80px;
    background-color: var(--grid-align-background, var(--color-surface-highlight));
    border-radius: 8px;
    padding: 8px;
  }

  .align-cell {
    width: 60px;
    height: 40px;
  }
</style>
