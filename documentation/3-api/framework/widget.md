# Widget

Widget 是 AIUI 中面向小尺寸常驻界面的运行时入口。Widget 文件的默认导出必须是对象，运行时会把其中的可枚举属性复制到 Widget 实例上，并提供响应式状态、宿主尺寸与生命周期能力。

## 定义 Widget 状态与交互

```javascript
export default {
  data: {
    label: 'Ready',
    count: 0,
  },

  onAttach() {
    this.setData({ label: 'Now playing' });
  },

  increment() {
    this.setData({ count: this.data.count + 1 });
  },
};
```

Widget 模板使用 `<widget>` 作为根节点。模板事件会调用默认导出对象上的同名方法：

```xml
<widget>
  <view bindtap="increment">
    <text>{{label}}: {{count}}</text>
  </view>
</widget>
```

## 根据宿主信息调整界面

宿主元数据是运行时提供的只读快照，可用于按 Widget 规格或当前尺寸调整内容：

```javascript
export default {
  onAttach() {
    console.log(this.widgetId, this.family);
    console.log(this.hostWidth, this.hostHeight, this.interactive);
  },
};
```

## 生命周期与当前行为

- Widget 支持 `onCreate()`、`onAttach()`、`onDetach()` 与 `onDestroy()` 生命周期。
- `setData()` 支持顶层字段和点路径更新；回调会在原生状态同步后执行。
- `onKeyDown(event)` 等输入处理函数以及 `bindtap` 等模板事件，只会在宿主允许交互时分发。
- `family` 当前为 `'1x1'` 或 `'1x2'`，`target` 固定为 `'_widget'`。

## API Reference

### 实例成员

| 成员 | 类型 | 说明 |
| --- | --- | --- |
| `this.data` | `Record<string, any>` | 当前响应式状态，默认是 `{}`。 |
| `this.setData(patch, callback?)` | `Function` | 合并状态并同步 Widget 界面。 |
| `this.widgetId` | `string` | 当前 Widget 实例的稳定运行时标识。 |
| `this.family` | `'1x1' \| '1x2'` | Manifest 与 Widget 文件声明的规格。 |
| `this.target` | `'_widget'` | Widget 展示目标。 |
| `this.isAttached` | `boolean` | 当前是否已挂载到宿主。 |
| `this.interactive` | `boolean` | 宿主当前是否允许输入。 |
| `this.hostWidth` | `number` | 当前宿主逻辑宽度。 |
| `this.hostHeight` | `number` | 当前宿主逻辑高度。 |

### `this.setData(patch, callback?)`

`patch` 必须是对象。顶层键会替换对应值，点路径会按需创建中间对象。可选的 `callback` 在状态同步完成后执行。

### 生命周期回调

| 回调 | 触发时机 |
| --- | --- |
| `onCreate()` | Widget 加载并完成宿主状态初始化后。 |
| `onAttach()` | Widget 在宿主界面中激活时。 |
| `onDetach()` | Widget 停用或准备销毁时。 |
| `onDestroy()` | Widget 最终销毁期间。 |
