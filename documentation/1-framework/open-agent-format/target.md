# Target

`target` 用于描述页面当前被宿主承载到哪一种展示容器中。对于同一个页面来说，`target` 主要影响其展示形态、可用空间和交互层级。

## Target 有哪些

当前公开文档主要介绍两种常见 `target`：

- `_current`：保持在当前上下文中承载，例如对话流中的卡片容器或其他内联展示位
- `_blank`：切换到独立承载空间，例如全屏页面或更完整的沉浸式展示容器

## 不同设备中的 target 映射

不同宿主设备会基于各自的容器模型来承载页面。因此，`target` 的语义是稳定的，但它在具体设备上会落到哪一种宿主容器，取决于设备和宿主实现。当前公开文档先以 Rokid Glasses 为例说明：

### Rokid Glasses

- `_current`：对应对话流内的卡片容器。页面会以内联卡片的形式出现在当前对话上下文中，不离开消息流。
- `_blank`：对应从对话流中双击进入的全屏容器。页面会从卡片态切换到独立的全屏承载空间，以支持更完整的展示和交互。

## 如何使用 CSS 配置不同 target 的样式

如果同一个页面会在不同承载位复用，可以直接基于 `target` 做响应式样式分支：

```css
.panel {
  padding: 16rpx;
}

@media (target: _current) {
  .panel {
    max-height: 320rpx;
  }
}

@media (target: _blank) {
  .panel {
    max-width: 100%;
    padding: 24rpx;
  }
}
```

推荐把 `target` 主要用于处理：

- 信息密度差异
- 布局尺寸差异
- 是否展示辅助操作区
- 卡片态与展开态之间的样式切换

## 如何在 App 和 Page 监听 target 变化的事件

如果你希望在逻辑层根据承载位切换布局或数据策略，可以在 `App` 和 `Page` 上实现 `onTargetChanged(target, previousTarget)`。

```javascript
export default {
  onTargetChanged(target, previousTarget) {
    console.log('app target changed:', previousTarget, '->', target);
  }
}
```

```javascript
export default {
  data: {
    hostTarget: '_current'
  },
  onTargetChanged(target, previousTarget) {
    console.log('page target changed:', previousTarget, '->', target);
    this.setData({ hostTarget: target });
  }
}
```

常见用法包括：

- 在 `_current` 中只展示摘要内容
- 切到 `_blank` 后展开完整操作流

## 设计边界

`target` 主要表达的是“承载位置语义”，不建议把它当作以下概念的替代品：

- 当前视口的精确尺寸
- 当前是否处于某个具体业务状态

更合适的方式是：

- 用 `target` 描述页面被放在哪里
- 用页面数据描述业务流程的具体阶段

## 推荐阅读

- [页面概览](/AIUI/guide/open-agent-format-page)
- [事件](/AIUI/guide/open-agent-format-page-events)
- [焦点系统](/AIUI/framework/open-agent-format-page-focus)
