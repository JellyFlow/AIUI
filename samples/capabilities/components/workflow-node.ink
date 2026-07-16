<template>
  <view class="node">
    <view class="node-header">
      <view class="node-copy">
        <text class="node-label">{{label}}</text>
        <text class="node-meta">{{owner}} · {{priority}}</text>
      </view>
      <view class="node-stats">
        <text class="node-state">{{state}}</text>
        <text class="node-count">tap {{tapCount}}</text>
      </view>
    </view>
    <view class="node-detail" wx:if="{{detailMode === 'expanded'}}">
      <text class="node-note">{{note}}</text>
    </view>
    <button class="node-action" bindtap="emitSelect">Send Child Event</button>
  </view>
</template>

<style>
.node {
  display: flex;
  flex-direction: column;
  gap: 8px;
  padding: 12px;
  border-width: 1px;
  border-radius: 10px;
}

.node-header {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: flex-start;
  gap: 12px;
}

.node-copy {
  display: flex;
  flex-direction: column;
  gap: 4px;
  flex: 1;
}

.node-label {
  font-size: 15px;
  font-weight: bold;
}

.node-meta,
.node-state,
.node-count,
.node-note {
  font-size: 12px;
}

.node-stats {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 4px;
}

.node-detail {
  display: flex;
}

.node-action {
  width: 100%;
}
</style>

<script setup>
export default {
  data: {
    phase: 'created',
    tapCount: 0,
  },

  properties: {
    itemId: {
      type: String,
      value: 'node-0',
    },
    label: {
      type: String,
      value: 'Untitled node',
    },
    owner: {
      type: String,
      value: 'Unknown owner',
    },
    priority: {
      type: String,
      value: 'normal',
    },
    state: {
      type: String,
      value: 'idle',
    },
    note: {
      type: String,
      value: 'No note',
    },
    detailMode: {
      type: String,
      value: 'expanded',
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
    emitSelect() {
      const nextTapCount = this.data.tapCount + 1;
      this.setData({
        tapCount: nextTapCount,
      });
      this.triggerEvent('select', {
        itemId: this.properties.itemId,
        label: this.properties.label,
        owner: this.properties.owner,
        priority: this.properties.priority,
        state: this.properties.state,
        note: this.properties.note,
        detailMode: this.properties.detailMode,
        tapCount: nextTapCount,
        phase: this.data.phase,
        source: 'workflow-node',
      });
    },
  },
};
</script>
