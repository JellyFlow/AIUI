# ScrollView 滚动视图

`scroll-view` 组件是一个可滚动的视图容器，允许用户在内容超出可视区域时滚动查看。

## 使用方法

```xml
<scroll-view class="scroll-container" scroll-y="true">
  <view class="item">项目 1</view>
  <view class="item">项目 2</view>
  <view class="item">项目 3</view>
  <!-- 更多项目 -->
</scroll-view>
```

## 约束横向滚动区域

`scroll-x` 只启用横向溢出处理，不会替容器指定宽度。通常父级的默认拉伸布局会让 `scroll-view` 占满可用宽度；如果父级使用 `align-items: flex-start` 等非拉伸布局，宽度为 `auto` 的滚动容器可能随内容展开，因而没有可滚动的可视区域。

下面的完整 `.ink` 页面通过 `width: 100%` 将横向滚动区域限制在父级可用宽度内：

```html
<script setup>
const items = Array.from({ length: 8 }, (_, index) => ({
  id: index + 1,
  label: `项目 ${index + 1}`
}));

export default {
  data: { items }
};
</script>

<page>
  <view class="page">
    <scroll-view class="gallery" scroll-x="true">
      <view class="track">
        <view class="item" ink:for="{{ items }}" ink:key="id">
          {{ item.label }}
        </view>
      </view>
    </scroll-view>
  </view>
</page>

<style>
.page {
  flex-direction: column;
  align-items: flex-start;
  padding: 20px;
}

.gallery {
  width: 100%;
  height: 88px;
  overflow: hidden;
}

.track {
  display: flex;
  flex-direction: row;
  width: 1324px;
  height: 88px;
}

.item {
  width: 144px;
  height: 64px;
  margin-right: 12px;
  background-color: #60a5fa;
  flex-shrink: 0;
}
</style>
```

这里的关键不是必须写出某个固定像素宽度，而是让 `scroll-view` 获得一个小于内容宽度的确定可视宽度。父级已经能够约束并拉伸子项时，可以不重复声明 `width`。

## 属性

| 属性 | 类型 | 默认值 | 描述 |
| :--- | :--- | :--- | :--- |
| `scroll-x` | Boolean | `false` | 允许横向滚动。 |
| `scroll-y` | Boolean | `false` | 允许纵向滚动。 |
| `scroll-top` | Number | - | 设置竖向滚动条位置。 |
| `scroll-left` | Number | - | 设置横向滚动条位置。 |
| `scroll-into-view` | String | - | 滚动到该 ID 对应的元素位置。 |
| `auto-scroll` | Boolean | `false` | 启用自动滚动。 |
| `scroll-speed` | Number | `25.0` | 自动滚动的速度。 |
| `scroll-direction` | String | `vertical` | 自动滚动的方向 (`vertical` 或 `horizontal`)。 |

## 监听滚动

使用 `bindscroll` 监听滚动位置变化，使用 `bindscrollend` 监听一次滚动结束：

```xml
<scroll-view
  class="scroll-container"
  scroll-y="true"
  bindscroll="handleScroll"
  bindscrollend="handleScrollEnd"
>
  <!-- 列表内容 -->
</scroll-view>
```

```javascript
export default {
  handleScroll(event) {
    console.log('当前位置', event.detail.scrollTop);
  },

  handleScrollEnd(event) {
    console.log('最终位置', event.detail.scrollTop);
  }
};
```

无论滚动由用户操作还是代码触发，监听函数收到的事件类型和数据结构都相同，事件中不包含滚动来源。只有滚动位置实际发生变化时才会派发 `scroll`；当前滚动序列结束时会派发一次 `scrollend`。用户手势和平滑滚动可能连续派发多个 `scroll`，而代码触发的立即滚动会同步依次派发一次 `scroll` 和一次 `scrollend`。

`event.detail` 包含以下字段：

| 字段 | 类型 | 说明 |
| :--- | :--- | :--- |
| `scrollTop` / `scrollLeft` | Number | 事件派发时的纵向或横向滚动位置 |
| `scrollWidth` / `scrollHeight` | Number | 可滚动内容的宽度或高度 |
| `clientWidth` / `clientHeight` | Number | 当前可视区域的宽度或高度 |
| `scrollBottom` | Number | 距离内容底部的剩余距离 |
| `isAtBottom` | Boolean | 是否已经滚动到底部 |

## 功能特性

- 支持横向和纵向滚动。
- 支持触摸和鼠标拖拽手势。
- 支持鼠标滚轮滚动。
- 支持自定义速度和方向的自动滚动。
