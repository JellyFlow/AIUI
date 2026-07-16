<script def>
{
  "component": true
}
</script>
<template>
  <view class="badge">
    <text class="label">nested label: {{label}}</text>
  </view>
</template>
<style>
.badge {
  display: flex;
  padding: 8px;
}

.label {
  font-size: 12px;
}
</style>
<script setup>
export default {
  properties: {
    label: {
      type: String,
      value: 'badge',
    },
  },
};
</script>
