# Page

`Page` is used to register a page in an agent. The logic for each page is exported as a configuration object through `export default`.

## Example Code

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

## Instance Methods

In page logic, you can access the page instance through `this` and call the following methods:

### `this.setData(Object data, Function? callback)`
Used to send data from the logic layer to the view layer asynchronously, while also updating the corresponding values in `this.data`.
- **Parameters**:
    - `data`: Key-value pairs containing the data to update. Path-style updates are supported, for example `'a.b.c': 1`.
    - `callback`: Optional. A callback function that runs after the data update is complete.

## World Awareness

`World Awareness` is the page-scoped environment-awareness capability set. It allows the current page to receive spatial orientation, stability changes, and head-gesture signals directly.

After it is enabled, the runtime keeps these sensing capabilities private to the current page. In practice, this means:

- the page can own a private `orientationSensor`
- the page can receive `headgesture` events
- the page can receive `orientationstabilitychange` events
- the runtime automatically shuts this capability group down when the page unloads

Current runtime behavior:

- `enableWorldAwareness()` creates or reuses a page-private `orientationSensor`
- native page logic starts the page-scoped `AbsoluteOrientationSensor`
- `disableWorldAwareness()` stops the current page-scoped sensor session and disables related callbacks
- the runtime automatically calls `disableWorldAwareness()` before `onUnload()` completes

If your page needs spatial pose or environment-aware signals, the usual pattern is to enable world awareness first, then consume the related data through page callbacks or `this.orientationSensor`.

### `this.enableWorldAwareness()`
Switches the current page into a page-scoped sensing mode for environment-aware features.
- The runtime creates or reuses a page-private `orientationSensor`.
- The runtime starts the page-scoped `AbsoluteOrientationSensor` from native page logic.
- After enabling, the page can receive `headgesture` and `orientationstabilitychange` deliveries.
- The sensor remains private to the current page instead of being mounted on `navigator`.

### `this.disableWorldAwareness()`
Stops the page-scoped sensor session and disables related page callbacks.
- The runtime also calls it automatically before `onUnload()` completes, so pages usually do not need to stop world awareness manually during unload cleanup.

### `this.orientationSensor`
When world awareness is enabled, the page instance exposes `this.orientationSensor` as the page-private `AbsoluteOrientationSensor` instance used by the runtime.
- It is `undefined` before `enableWorldAwareness()` runs.
- It can be used to inspect `quaternion`, `timestamp`, `stable`, and `stabilityThreshold`.
- Pages typically receive stability changes through `onOrientationStabilityChange(event)`, while direct sensor listeners remain available when needed.

### `this.finish()`
Notifies the system that the current page task has been completed.
- For **Cut** agents, calling this method proactively returns focus and exits the current presentation state.
- For **Scene** agents, it is typically used to end the current specific interaction flow.

## Lifecycle Callbacks

| Callback | Description | Trigger Timing |
| :--- | :--- | :--- |
| `onLoad` | Listens for page loading | Triggered when the page loads, only once globally |
| `onShow` | Listens for the page being shown | Triggered when the page is shown or brought to the foreground |
| `onReady` | Listens for the initial page render to complete | Triggered when the initial render completes, only once globally |
| `onHide` | Listens for the page being hidden | Triggered when the page is hidden or moved to the background |
| `onUnload` | Listens for page unload | Triggered when the page is unloaded. The runtime automatically disables world awareness before this stage finishes. |
| `onHeadGesture` | Listens for page-scoped head gestures | Triggered after `enableWorldAwareness()` when the page receives `headgesture` |
| `onOrientationStabilityChange` | Listens for page-scoped orientation stability changes | Triggered after `enableWorldAwareness()` when the page receives `orientationstabilitychange` |
