# Window（窗口）

`Window` 表示当前 AIUI 智能体的窗口。通过全局 `window` 对象，可以读取窗口尺寸、打开已配置的 Widget 或请求关闭当前智能体。

本文描述 Ink `v0.18.x` 中的窗口能力。

## 读取窗口尺寸

使用 `innerWidth` 和 `innerHeight` 获取当前窗口视口的像素尺寸：

```javascript
const viewport = {
  width: window.innerWidth,
  height: window.innerHeight,
};

console.log(viewport);
```

这两个属性由运行时维护，智能体应将它们视为只读信息。

## 打开 Widget

调用 `window.open()` 打开当前智能体在 `app.json` 的 `widgets` 列表中声明的 Widget。传入 Widget 路径时省略 `.ink` 扩展名，可以附带查询参数：

```javascript
window.open('widgets/weather/index?city=hangzhou');
```

`target` 可以省略，默认值为 `_widget`；也可以明确传入该值：

```javascript
window.open('widgets/weather/index?city=hangzhou', '_widget');
```

Ink `v0.18.x` 仅支持通过 `window.open()` 打开已声明的 Widget，不支持打开 Page、外部 URL 或任意未在 `app.json.widgets` 中配置的 Widget。调用会立即返回，不会返回 Widget 实例或打开结果。Widget 的声明方式请参阅 [Widget](/AIUI/framework/open-agent-format-widget)，完整路由说明请参阅[路由](/AIUI/api/route)。

## 关闭当前智能体

调用 `window.close()` 向宿主发送关闭当前智能体实例的请求：

```javascript
window.close();
```

该方法只发送关闭请求，实际关闭时机由宿主管理。

## 全局访问

在普通 AIUI 窗口中，`window`、`self`、`globalThis` 和 `global` 指向同一个全局对象：

```javascript
console.log(window === globalThis); // true
console.log(window === self); // true
console.log(window === global); // true
```

`v0.18.x` 会将部分 Web API 显式挂载到 `window`，但不要据此推断每个可直接使用的全局符号都存在对应的 `window.xxx` 属性。具体暴露方式与限制请查看对应的 API 页面。

Agent Worker 使用独立的全局作用域，不提供 `Window`。有关 Worker 全局对象和生命周期，请参阅 [AgentWorker](/AIUI/api/framework-agent-worker)。

## API Reference

### `window.innerWidth`

- **类型**：只读 `number`。
- **说明**：返回当前窗口视口的宽度，单位为像素。

### `window.innerHeight`

- **类型**：只读 `number`。
- **说明**：返回当前窗口视口的高度，单位为像素。

### `window.open(url, target?)`

请求宿主打开当前智能体中已声明的 Widget。

| 参数 | 类型 | 必填 | 说明 |
| --- | --- | --- | --- |
| `url` | `string` | 是 | `app.json.widgets` 中已声明的 Widget 路径，可附带查询参数；省略 `.ink` 扩展名。 |
| `target` | `'_widget'` | 否 | 打开目标，默认值为 `_widget`，也是当前唯一支持的值。 |

**返回值**：`undefined`。

`url` 为空时抛出 `TypeError`。不要传入 `_widget` 以外的 `target` 值；Ink `v0.18.x` 不支持通过该方法打开其他目标。

### `window.close()`

请求宿主关闭当前智能体实例。

**返回值**：`undefined`。

### `window.atob(encodedData)`

将 Base64 编码的字符串解码为二进制字符串。

- **参数**：`encodedData`，`string`，要解码的 Base64 字符串。
- **返回值**：解码后的 `string`。

### `window.btoa(stringToEncode)`

将二进制字符串编码为 Base64 字符串。

- **参数**：`stringToEncode`，`string`，要编码的二进制字符串。
- **返回值**：Base64 编码后的 `string`。
