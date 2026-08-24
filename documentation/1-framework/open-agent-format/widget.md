# Widget 开发

Widget 用于构建小尺寸、可由宿主持久展示的界面。它与页面使用相同的 `.ink` 单文件格式和数据绑定能力，但拥有独立的声明入口、根节点、规格和生命周期。

## 创建 Widget 文件

在 `widgets/` 下创建 `.ink` 文件，并在 JSON 定义中声明 Widget 规格：

```xml
<script type="application/json" def>
{
  "widget": {
    "family": "1x1"
  }
}
</script>

<script setup>
export default {
  data: {
    count: 0,
  },

  increment() {
    this.setData({ count: this.data.count + 1 });
  },
};
</script>

<widget>
  <button class="counter" bindtap="increment">
    <text>{{count}}</text>
  </button>
</widget>

<style>
.counter {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
}
</style>
```

Widget 模板必须使用 `<widget>` 作为根节点。`family` 当前支持 `1x1` 和 `1x2`。

## 在 `app.json` 中注册 Widget

通过应用配置的 `widgets` 数组声明 Widget 路径和规格：

```json
{
  "pages": [
    "pages/index/index"
  ],
  "widgets": [
    {
      "path": "widgets/counter/index",
      "family": "1x1"
    }
  ]
}
```

`path` 不包含 `.ink` 扩展名。`app.json` 中的 `family` 必须与 Widget 文件 JSON 定义中的 `widget.family` 一致，否则运行时会拒绝以 Widget 方式加载该入口。

一个典型目录如下：

```text
agent-app/
  app.json
  pages/
    index/
      index.ink
  widgets/
    counter/
      index.ink
```

## 管理状态和交互

Widget 默认导出对象中的 `data` 是响应式状态。调用 `this.setData()` 后，模板中对应的数据绑定会更新：

```javascript
export default {
  data: {
    status: 'Ready',
  },

  activate() {
    this.setData({ status: 'Active' });
  },
};
```

模板事件与页面类似，会调用默认导出对象上的同名方法。只有宿主允许交互时，`bindtap` 等模板事件和输入处理函数才会分发；可以通过 `this.interactive` 读取当前状态。

## 响应 Widget 生命周期

```javascript
export default {
  onCreate() {
    console.log('created', this.widgetId, this.family);
  },

  onAttach() {
    this.setData({ status: 'Attached' });
  },

  onDetach() {
    console.log('detached');
  },

  onDestroy() {
    console.log('destroyed');
  },
};
```

- `onCreate()`：Widget 加载并完成宿主状态初始化后触发。
- `onAttach()`：Widget 在宿主界面中激活时触发。
- `onDetach()`：Widget 停用或准备销毁时触发。
- `onDestroy()`：Widget 最终销毁时触发。

Widget 可以通过 `this.hostWidth` 和 `this.hostHeight` 获取宿主逻辑尺寸，通过 `this.family` 获取当前规格。Widget 的展示目标固定为 `_widget`。

## 继续阅读

- [app.json](/AIUI/framework/open-agent-format-app-json)：配置页面和 Widget 入口。
- [Widget API](/AIUI/api/framework-widget)：查看实例成员、`setData()` 和生命周期的完整参考。
- [组件](/AIUI/framework/open-agent-format-custom-components)：将可复用界面封装成自定义组件。
