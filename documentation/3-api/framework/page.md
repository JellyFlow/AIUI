# Page

`Page` 用于注册智能体中的一个页面。每个页面的逻辑通过 `export default` 导出一个配置对象。

## 示例代码

```javascript
export default {
  data: {
    text: "This is page data.",
    user: {
      name: 'Rokid'
    }
  },
  onLoad(options) {
    // 页面加载
  },
  handleUpdate() {
    // 更新数据
    this.setData({
      text: 'Updated Text',
      'user.name': 'New Name' // 支持路径式更新
    }, () => {
      console.log('Data updated');
    });
  },
  handleComplete() {
    // 完成当前页面任务
    this.finish();
  },
}
```

## 实例方法

在页面逻辑中，可以通过 `this` 访问页面实例，并调用以下方法：

### `this.setData(Object data, Function? callback)`
用于将数据从逻辑层发送到视图层（异步），同时改变对应的 `this.data` 的值。
- **参数**:
    - `data`: 包含需要更新的数据键值对。支持以数据路径的形式给出（例如 `'a.b.c': 1`）。
    - `callback`: 可选。数据更新完成后的回调函数。

## 环境感知

`World Awareness` 是页面级的环境感知能力，用来让当前页面直接接入空间朝向、稳定性变化和头部手势等环境感知信息。

启用后，运行时会把感知能力限制在当前页面内部。这意味着：

- 页面可以拥有私有的 `orientationSensor`
- 页面可以接收 `headgesture` 事件
- 页面可以接收 `orientationstabilitychange` 事件
- 页面卸载时，运行时会自动关闭这一组能力

当前运行时行为：

- `enableWorldAwareness()` 会创建或复用页面私有的 `orientationSensor`
- 原生页面逻辑会启动页面级 `AbsoluteOrientationSensor`
- `disableWorldAwareness()` 会停止当前页面级传感器会话并关闭相关回调
- 运行时会在 `onUnload()` 完成前自动调用 `disableWorldAwareness()`

如果你需要页面感知空间姿态或环境变化，通常应先启用 world awareness，再通过页面回调或 `this.orientationSensor` 读取相关信息。

### `this.enableWorldAwareness()`
将当前页面切换到页面级环境感知模式，用于启用环境感知相关能力。
- 当前运行时会创建或复用页面私有的 `orientationSensor`。
- 运行时会从原生页面逻辑中启动页面级 `AbsoluteOrientationSensor`。
- 启用后，页面可接收 `headgesture` 和 `orientationstabilitychange` 的回调投递。
- 传感器实例保持为当前页面私有，而不是挂载到 `navigator` 上。

### `this.disableWorldAwareness()`
停止当前页面级传感器会话，并关闭相关页面回调。
- 运行时会在 `onUnload()` 完成前自动调用它，因此页面通常不需要在卸载清理里手动关闭 world awareness。

### `this.orientationSensor`
当 world awareness 启用后，页面实例会通过 `this.orientationSensor` 暴露当前页面私有的 `AbsoluteOrientationSensor` 实例。
- 在 `enableWorldAwareness()` 执行前，它的值是 `undefined`。
- 可用于读取 `quaternion`、`timestamp`、`stable` 和 `stabilityThreshold`。
- 页面通常通过 `onOrientationStabilityChange(event)` 接收稳定性变化；如果需要，也可以直接给该传感器实例注册事件监听器。

### `this.finish()`
通知系统当前页面任务已完成。
- 对于 **Cut (快切)** 智能体，调用此方法将主动交回焦点并退出当前展示状态。
- 对于 **Scene (场景)** 智能体，通常用于结束当前特定交互流程。

## 生命周期回调

| 回调函数 | 说明 | 触发时机 |
| :--- | :--- | :--- |
| `onLoad` | 监听页面加载 | 页面加载时触发（全局只触发一次） |
| `onShow` | 监听页面显示 | 页面显示/切入前台时触发 |
| `onReady` | 监听页面初次渲染完成 | 页面初次渲染完成时触发（全局只触发一次） |
| `onHide` | 监听页面隐藏 | 页面隐藏/切入后台时触发 |
| `onUnload` | 监听页面卸载 | 页面卸载时触发。运行时会在该阶段结束前自动关闭 world awareness。 |
| `onHeadGesture` | 监听页面级头部手势 | 启用 `enableWorldAwareness()` 后，在页面收到 `headgesture` 时触发 |
| `onOrientationStabilityChange` | 监听页面级方向稳定性变化 | 启用 `enableWorldAwareness()` 后，在页面收到 `orientationstabilitychange` 时触发 |
