<script setup>
export default {};
</script>

<page>
  <view class="container">
    <view class="title">Size Constraints Test</view>
    <view class="subtitle">
      Verify width/height together with min-width, min-height, max-width, and max-height.
    </view>

    <view class="section">
      <view class="section-title">1. Fixed Width and Height</view>
      <view class="section-desc">Baseline box with explicit width and height.</view>
      <view class="stage">
        <view class="sample fixed-box">
          <text class="sample-text">160 x 90</text>
        </view>
      </view>
    </view>

    <view class="section">
      <view class="section-title">2. Max Constraints Clamp Size</view>
      <view class="section-desc">
        Width and height are larger than max constraints, so final size should clamp to 140 x 80.
      </view>
      <view class="stage">
        <view class="sample max-box">
          <text class="sample-text">width: 220</text>
          <text class="sample-text">max-width: 140</text>
          <text class="sample-text">height: 120</text>
          <text class="sample-text">max-height: 80</text>
        </view>
      </view>
    </view>

    <view class="section">
      <view class="section-title">3. Min Constraints Lift Size</view>
      <view class="section-desc">
        Small content should still be lifted to at least 140 x 80 by min constraints.
      </view>
      <view class="stage">
        <view class="sample min-box">
          <text class="sample-text">tiny</text>
        </view>
      </view>
    </view>

    <view class="section">
      <view class="section-title">4. Width/Height Within Min and Max</view>
      <view class="section-desc">
        Explicit width and height stay unchanged when they already fall inside the min/max range.
      </view>
      <view class="stage">
        <view class="sample ranged-box">
          <text class="sample-text">180 x 100</text>
        </view>
      </view>
    </view>

    <view class="section">
      <view class="section-title">5. Only Min and Max Without Fixed Size</view>
      <view class="section-desc">
        Auto-sized box should still stay inside the declared range and wrap its content.
      </view>
      <view class="stage">
        <view class="sample auto-range-box">
          <text class="sample-text">
            This box relies on content sizing, but min and max constraints should still apply.
          </text>
        </view>
      </view>
    </view>
  </view>
</page>

<style>
.container {
  display: flex;
  flex-direction: column;
  width: 100%;
  padding: var(--spacing-lg, 20px);
  box-sizing: border-box;
  gap: 18px;
}

.title {
  font-size: 28px;
  font-weight: bold;
  text-align: center;
}

.subtitle {
  font-size: 14px;
  line-height: 20px;
  text-align: center;
  margin-bottom: 6px;
}

.section {
  display: flex;
  flex-direction: column;
  border-radius: var(--radius-md, 12px);
  padding: var(--spacing-md, 16px);
  box-sizing: border-box;
  gap: var(--spacing-sm, 10px);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.section-title {
  font-size: 18px;
  font-weight: 600;
}

.section-desc {
  font-size: 13px;
  line-height: 18px;
}

.stage {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  min-height: 130px;
  padding: var(--spacing-md, 12px);
  box-sizing: border-box;
  border-radius: var(--radius-md, 10px);
}

.sample {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  padding: 10px 12px;
  box-sizing: border-box;
  border-radius: var(--radius-md, 10px);
  border-width: var(--border-width-default, 2px);
  border-style: dashed;
  text-align: center;
}

.sample-text {
  font-size: 12px;
  line-height: 16px;
}

.fixed-box {
  width: 160px;
  height: 90px;
  border-color: var(--border-color-accent, #60a5fa);
}

.max-box {
  width: 220px;
  height: 120px;
  max-width: 140px;
  max-height: 80px;
  border-color: var(--border-color-danger, #f87171);
}

.min-box {
  width: 60px;
  height: 30px;
  min-width: 140px;
  min-height: 80px;
  border-color: var(--border-color-success, #4ade80);
}

.ranged-box {
  width: 180px;
  height: 100px;
  min-width: 120px;
  max-width: 220px;
  min-height: 70px;
  max-height: 130px;
  border-color: var(--border-color-highlight, #a78bfa);
}

.auto-range-box {
  min-width: 120px;
  max-width: 220px;
  min-height: 70px;
  max-height: 120px;
  border-color: var(--border-color-warning, #fbbf24);
}
</style>
