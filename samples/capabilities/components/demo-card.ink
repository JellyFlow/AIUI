<script def>
{
  "component": true,
  "usingComponents": {
    "demo-badge": "components/demo-badge"
  }
}
</script>
<template>
  <view class="card">
    <text class="line">phase: {{phase}}</text>
    <text class="line">title: {{title}}</text>
    <text class="line">count: {{count}}</text>
    <demo-badge label="{{title}}" />
    <button class="action" bindtap="emitChange">Emit Change</button>
  </view>
</template>
<style>
.card {
  display: flex;
  flex-direction: column;
  gap: 8px;
  padding: 12px;
  border-width: 1px;
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
    count: 0,
    phase: 'created',
  },

  properties: {
    title: {
      type: String,
      value: 'Untitled',
    },
  },

  lifetimes: {
    created() {
      this.setData({
        phase: 'created',
      });
    },
    attached() {
      this.setData({
        phase: 'attached',
      });
    },
    ready() {
      this.setData({
        phase: 'ready',
      });
    },
    detached() {
      this.setData({
        phase: 'detached',
      });
    },
  },

  methods: {
    emitChange() {
      const nextCount = this.data.count + 1;
      this.setData({
        count: nextCount,
      });
      this.triggerEvent('change', {
        value: `${this.properties.title}:${nextCount}`,
      });
    },
  },
};
</script>
