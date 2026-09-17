# 页面定义

AIUI 页面由**页面配置**、**页面逻辑**、**页面结构**和**页面样式**组成。推荐使用 `.ink` 单文件形式：`<script def>` 声明页面配置，`<script setup>` 导出页面逻辑，`<page>` 描述界面结构，`<style>` 定义页面样式。

需要特别区分：`<script def>` 中是 JSON，不是可执行 JavaScript；生命周期、事件处理函数和初始状态应写在 `<script setup>` 的 `export default` 对象中。

## 完整页面示例

```html
<script type="application/json" def>
{
  "navigationBarTitleText": "天气",
  "description": "根据城市展示天气信息。",
  "schema": {
    "data": {
      "type": "object",
      "properties": {
        "city": {
          "type": "string",
          "description": "要查询的城市名称。"
        }
      },
      "required": ["city"]
    }
  },
  "usingComponents": {
    "weather-card": "components/weather-card"
  },
  "disableScroll": true
}
</script>

<script setup>
export default {
  data: {
    city: '',
    status: '等待查询'
  },
  onLoad(query) {
    this.setData({
      city: query.city || '',
      status: query.city ? '查询完成' : '请选择城市'
    });
  },
  handleComplete() {
    this.finish();
  }
}
</script>

<page>
  <weather-card city="{{city}}" status="{{status}}" />
  <button bindtap="handleComplete">完成</button>
</page>

<style>
page {
  padding: 16px;
}
</style>
```

同一个页面也可以拆成同名的 `.json`、`.js`、`.wxml` 和 `.wxss` 四个文件。此时 `.json` 等价于 `<script def>`，`.js` 等价于 `<script setup>` 中的默认导出。不要为同一路由混用两种结构。

## `<script def>` 页面配置

`<script def>` 必须包含一个合法的 JSON 对象，不能包含注释、函数、变量或尾随逗号。建议保留 `type="application/json"`，用来明确内容类型。

### 常用字段

| 字段 | 类型 | 必填 | 用途 |
| :--- | :--- | :--- | :--- |
| `navigationBarTitleText` | string | 否 | 设置页面标题；是否显示由宿主的导航栏呈现方式决定 |
| `description` | string | 对话式页面建议填写 | 向模型说明页面能完成什么任务以及何时使用该页面；应描述可观察的能力，而不是泛化标题 |
| `schema` | Object | 否 | 描述宿主或模型打开页面时可以提供的数据契约；页面输入写在 `schema.data` 中 |
| `usingComponents` | Object | 否 | 注册当前页面使用的自定义组件；键是模板标签名，值是组件路径或包导出名 |
| `disableScroll` | boolean | 否 | 是否关闭页面根节点的默认滚动；默认值为 `false` |

`description` 和 `schema.data` 共同把页面描述为可调用的 UI 工具。沉浸式智能体通常直接进入 `app.json` 注册的入口页面，因此页面不一定需要声明为独立工具；对话式卡片页面则应准确填写这两个字段。

### `schema.data`

`schema.data` 使用 JSON Schema 描述传入页面的数据。常用字段如下：

| 字段 | 类型 | 用途 |
| :--- | :--- | :--- |
| `type` | string | 数据根类型，页面输入通常使用 `object` |
| `properties` | Object | 定义每个输入字段及其类型、说明和约束 |
| `required` | string[] | 列出必须提供的字段名；未列出的字段均为可选 |
| `properties.<name>.type` | string | 字段类型，如 `string`、`number`、`integer`、`boolean`、`object` 或 `array` |
| `properties.<name>.description` | string | 告诉模型该字段的语义、格式、单位和取值要求 |
| `properties.<name>.enum` | any[] | 将字段限制为一组离散值 |
| `properties.<name>.items` | Object | 当字段为 `array` 时描述数组元素 |
| `properties.<name>.default` | any | 描述建议的默认值；页面逻辑仍应自行处理字段缺失的情况 |

`schema.data` 描述的是**打开页面时的输入**，不等同于页面逻辑对象里的 `data`。前者供模型和宿主构造调用参数，后者是页面首次渲染使用的本地状态。传入参数可在 `onLoad(query)` 中读取，再通过 `setData()` 写入页面状态。

```json
{
  "description": "展示指定城市和日期的天气。",
  "schema": {
    "data": {
      "type": "object",
      "properties": {
        "city": {
          "type": "string",
          "minLength": 1,
          "description": "城市名称，例如“杭州”。"
        },
        "date": {
          "type": "string",
          "description": "查询日期，格式为 YYYY-MM-DD。"
        },
        "unit": {
          "type": "string",
          "enum": ["celsius", "fahrenheit"],
          "default": "celsius",
          "description": "温度单位。"
        }
      },
      "required": ["city"]
    }
  }
}
```

### 其他兼容字段

页面配置解析器还接受小程序风格的窗口、背景、渲染器和宿主扩展字段，例如 `navigationBarBackgroundColor`、`navigationBarTextStyle`、`navigationStyle`、`homeButton`、`backgroundColor`、`backgroundColorContent`、`backgroundTextStyle`、`backgroundColorTop`、`backgroundColorBottom`、`enablePullDownRefresh`、`onReachBottomDistance`、`pageOrientation`、`viewport`、`style`、`initialRenderingCache`、`singlePage`、`restartStrategy`、`handleWebviewPreload`、`visualEffectInBackground`、`enablePassiveEvent`、`renderer`、`rendererOptions` 和 `componentFramework`。

这些字段主要用于兼容不同宿主或保留未来能力，并不代表所有宿主都实现了对应视觉或交互效果。除非目标宿主明确提供相应契约，否则优先使用上面的常用字段，并通过 `<style>` 控制页面内容样式。

## `<script setup>` 页面逻辑

页面逻辑通过 `export default` 导出一个对象。该对象中的字段会成为页面实例的状态、生命周期和事件处理方法。

| 字段 | 类型 | 必填 | 用途 |
| :--- | :--- | :--- | :--- |
| `data` | Object | 否 | 页面的初始渲染状态；内容必须可 JSON 序列化 |
| `onLoad` | function | 否 | 页面加载时调用一次，并接收路由或工具调用参数 |
| `onShow` | function | 否 | 页面显示或重新进入前台时调用 |
| `onReady` | function | 否 | 页面首次渲染完成后调用一次 |
| `onHide` | function | 否 | 页面隐藏或切入后台时调用 |
| `onUnload` | function | 否 | 页面卸载时调用，适合释放计时器、监听器和其他资源 |
| `onKeyDown` | function | 否 | 按键按下时调用，通过 `event.code` 读取按键编码 |
| `onKeyUp` | function | 否 | 按键抬起时调用；可用 `event.preventDefault()` 拦截部分宿主默认行为 |
| `onVoiceWakeup` | function | 否 | 收到语音或触控唤醒事件时调用，通过 `event.keyword` 区分来源 |
| 自定义方法 | function | 否 | 响应模板事件或复用页面逻辑，可通过 `this` 访问页面实例 |
| 自定义字段 | any | 否 | 保存不参与模板渲染的页面成员；需要驱动界面更新的数据应放入 `data` |

页面配置中的 `options` 不应写入这里作为标准字段。打开页面时携带的参数由 `onLoad(query)` 接收；自定义组件的配置则通过 `<script def>` 的 `usingComponents` 声明。

## 页面实例

页面回调和自定义方法中的 `this` 指向当前页面实例。

### `this.data`

读取页面当前状态。不要只直接修改 `this.data` 来驱动界面；需要更新绑定内容时使用 `this.setData()`。

### `this.setData(Object patch, Function? callback)`

异步把数据更新发送到视图层，同时更新 `this.data`。`patch` 支持路径式键名，例如 `'user.name': 'Rokid'`；可选回调会在本次视图更新完成后执行。

```javascript
this.setData({
  status: 'ready',
  'user.name': 'Rokid'
}, () => {
  console.log('view updated');
});
```

### `this.finish()`

通知宿主当前页面任务已经完成。对于 Cut（快切）智能体，这通常会交回焦点并退出当前展示；对于 Scene（场景）智能体，通常表示结束当前交互流程。它不是普通的页面返回 API，应只在业务任务确实完成时调用。

## 生命周期与事件

首次打开页面时依次触发 `onLoad` → `onShow` → `onReady`。页面被覆盖时触发 `onHide`，重新显示时再次触发 `onShow`，销毁时触发 `onUnload`。

按键和唤醒事件的默认行为、事件字段及拦截方式，请参阅 [事件](/AIUI/framework/open-agent-format-page-events)。完整生命周期说明请参阅 [生命周期](/AIUI/framework/open-agent-format-page-lifecycle)。

## 推荐阅读

- [页面概览](/AIUI/framework/open-agent-format-page)
- [生命周期](/AIUI/framework/open-agent-format-page-lifecycle)
- [事件](/AIUI/framework/open-agent-format-page-events)
- [组件](/AIUI/framework/open-agent-format-custom-components)
