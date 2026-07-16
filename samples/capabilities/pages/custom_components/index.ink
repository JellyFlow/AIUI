<script def>
{
  "navigationBarTitleText": "Custom Components",
  "usingComponents": {
    "demo-card": "components/demo-card"
  }
}
</script>

<page>
  <view class="page">
    <text class="title">Custom Component Fixture</text>
    <text class="line">covers: properties, setData, triggerEvent, lifecycle, nested component</text>
    <text class="line">page title: {{title}}</text>
    <text class="line">last event: {{lastEvent}}</text>
    <text class="line">for list-driven nesting and remount behavior, open Custom Components Complex</text>
    <button class="action" bindtap="toggleTitle">Toggle Title</button>
    <demo-card title="{{title}}" bindchange="onCardChange" />
  </view>
</page>

<style>
.page {
  display: flex;
  flex-direction: column;
  gap: 12px;
  padding: 16px;
}

.title {
  font-size: 24px;
  font-weight: bold;
}

.line {
  font-size: 14px;
}

.action {
  width: 100%;
}
</style>
<script setup>
export default {
  data: {
    title: 'Alpha',
    lastEvent: 'none',
  },

  toggleTitle() {
    this.setData({
      title: this.data.title === 'Alpha' ? 'Beta' : 'Alpha',
    });
  },

  onCardChange(event) {
    this.setData({
      lastEvent: event.detail.value,
    });
  },
};
</script>
