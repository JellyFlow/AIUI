# 焦点系统

AIUI 页面除了有承载位语义，还存在一套与交互激活相关的焦点模型。理解焦点，有助于你正确设计键盘导航、卡片激活、元素选中和页面级事件处理。

## 两层焦点的设计

在 AIUI 里，通常需要区分两层焦点：

- **宿主焦点（Host Focus）**：当前页面实例是否处于宿主的活跃交互状态
- **元素焦点（Element Focus）**：当前页面树中，具体哪个节点被选中或正在接收焦点语义

这两个概念彼此关联，但并不等价：

- 宿主焦点决定当前页面是否可以接管方向键、确认键等交互，以及是否进入可导航的活跃状态
- 元素焦点决定页面内部哪个节点会展示焦点样式、接收 `focus` / `blur` 相关事件，或成为当前可激活对象

可以简单理解为：宿主焦点解决“这个页面现在能不能交互”，元素焦点解决“页面里当前交互到哪里了”。

## 如何使用 CSS 配置焦点相关状态的样式

在 CSS 层，当前支持的焦点相关伪类是 `:host-focus`，用于表达页面整体是否处于宿主焦点状态。

```css
.agent-shell {
  opacity: 0.72;
  transform: scale(0.98);
  transition: opacity 0.2s, transform 0.2s;
}

.agent-shell:host-focus {
  opacity: 1;
  transform: scale(1);
}
```

推荐用这个状态表达当前页面是否已经回到前台的活跃交互上下文。

## 如何监听焦点相关的 App 和 Page 事件

如果你需要在逻辑层感知宿主焦点变化，可以在 `App` 或 `Page` 上监听以下回调：

- `onHostFocus()`：页面重新获得宿主焦点时触发
- `onHostBlur()`：页面失去宿主焦点时触发

`App` 适合处理全局层的状态同步，比如暂停全局快捷键、恢复音效或重建全局交互状态：

```javascript
export default {
  onHostFocus() {
    console.log('app host focus restored');
  },
  onHostBlur() {
    console.log('app host blurred');
  }
}
```

`Page` 适合处理当前页面的样式、文案和交互反馈：

```javascript
export default {
  data: {
    hostFocused: false
  },
  onHostFocus() {
    this.setData({ hostFocused: true });
  },
  onHostBlur() {
    this.setData({ hostFocused: false });
  }
}
```

## 元素级焦点

除了宿主焦点，页面内部也会维护元素级焦点。你可以通过元素事件和状态来实现“当前选中项”的 UI 反馈。

```xml
<view
  class="action-item {{focused ? 'action-item--focused' : ''}}"
  bindfocus="onItemFocus"
  bindblur="onItemBlur"
>
  打开详情
</view>
```

```javascript
export default {
  data: {
    focused: false
  },
  onItemFocus() {
    this.setData({ focused: true });
  },
  onItemBlur() {
    this.setData({ focused: false });
  }
}
```

这类元素级焦点通常用于：

- 列表项高亮
- 按钮组切换
- 表单输入框聚焦
- 当前导航位置提示

## Navigation 交互模式

在支持方向键或设备按键的宿主里，页面通常会进入一套基于焦点的 Navigation 交互模式。它的核心目标是让用户在不依赖触摸的情况下完成选择、移动和激活。

你可以按下面的方式理解这套模式：

- `Enter`：进入导航模式，或激活当前目标
- `ArrowUp` / `ArrowDown`：在当前导航路径内移动，或在没有页面接管时触发根视图滚动
- `Backspace`：退出当前层级、返回上一级，或请求关闭页面

如果页面需要自己接管这些行为，可以在对应事件里调用 `event.preventDefault()`，然后自己维护焦点迁移、滚动和激活逻辑。相关默认按键行为可继续参考 [事件](/AIUI/guide/open-agent-format-page-events)。

## 非焦点下哪些能力会受限

当页面不处于宿主焦点状态时，通常会优先影响“交互接管”而不是“页面渲染”：

- 方向键导航、确认键激活等依赖当前活跃页的交互通常会受限
- 页面对默认按键行为的接管能力通常会受限
- 依赖当前页面成为活跃交互上下文的焦点迁移、选择和确认流程通常会受限

但纯展示类能力通常不受影响，例如：

- 页面继续渲染已有内容
- 异步数据更新和 `setData`
- 不依赖当前活跃焦点的普通样式和状态变化

具体边界仍然取决于宿主实现，因此建议把“是否处于宿主焦点”作为交互设计中的显式状态来处理。

## 推荐阅读

- [页面概览](/AIUI/guide/open-agent-format-page)
- [事件](/AIUI/guide/open-agent-format-page-events)
- [Target](/AIUI/framework/open-agent-format-page-target)
