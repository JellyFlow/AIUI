# 组件

组件用于封装可复用的状态、视图结构和事件逻辑，适合把复杂页面拆分为独立模块，提升复用性与可维护性。

当前 AIUI 已支持组件局部 `data`、`properties`、`setData()`、`triggerEvent()`、生命周期、嵌套组件以及组件样式隔离等能力。

## 注册与使用

页面或组件可以通过 `usingComponents` 引入组件。常见写法是在 AIUI 的 `.ink` 文件中通过 `<script def>` 声明：

```html
<script def>
{
  "usingComponents": {
    "demo-card": "components/demo-card"
  }
}
</script>
```

如果当前文件本身也是一个组件，则需要同时声明 `"component": true`：

```html
<script def>
{
  "component": true,
  "usingComponents": {
    "demo-badge": "components/demo-badge"
  }
}
</script>
```

注册后即可像内置标签一样使用：

```xml
<demo-card title="{{title}}" bindchange="onCardChange" />
```

## 推荐写法

AIUI 推荐使用 `.ink` 单文件组件，将组件声明、模板、样式和逻辑放在同一个文件中：

```html
<script def>
{
  "component": true
}
</script>

<template>
  <view class="card">
    <text>{{title}}</text>
  </view>
</template>

<style>
.card {
  display: flex;
  padding: 12px;
}
</style>

<script setup>
export default {
  properties: {
    title: {
      type: String,
      value: 'Untitled'
    }
  }
}
</script>
```

其中：

- `<script def>` 用于声明组件元信息，例如 `"component": true` 和 `usingComponents`
- `<template>` 用于定义组件结构
- `<style>` 用于定义组件内部样式
- `<script setup>` 用于导出组件逻辑

## 组件实例能力

组件实例目前支持以下核心能力：

- `properties`：父级传入的只读属性
- `data`：组件内部状态
- `methods`：组件方法，调用时直接使用 `this.xxx()`
- `this.setData(patch)`：更新组件内部状态
- `this.triggerEvent(name, detail)`：向父级派发自定义事件

示例：

```javascript
export default {
  data: {
    count: 0
  },
  properties: {
    title: {
      type: String,
      value: 'Untitled'
    }
  },
  methods: {
    emitChange() {
      const nextCount = this.data.count + 1;
      this.setData({ count: nextCount });
      this.triggerEvent('change', {
        value: `${this.properties.title}:${nextCount}`
      });
    }
  }
}
```

## 生命周期

当前支持的组件生命周期包括：

- `created`
- `attached`
- `ready`
- `detached`

可以在 `lifetimes` 中声明：

```javascript
export default {
  lifetimes: {
    created() {},
    attached() {},
    ready() {},
    detached() {}
  }
}
```

## 补充说明

- 组件可以继续引用其他组件，适合构建嵌套组件树
- 组件样式默认只作用于组件内部，不会泄漏到页面其他区域
- 组件内部可以通过事件转发，将子组件事件继续向外层传递
