# Logic Development

In AIUI, the logic layer is the part that turns user intent into executable behavior. It adopts a modular development model similar to modern frontend frameworks: you register an agent or page by exporting a configuration object with `export default`, and organize lifecycle, state, and event handlers around how intent should be processed.

## Register an Agent (App)

Every agent project must have an `app.js` or `app.ink` in the root directory (in SFC mode). In a `.js` file, the agent instance is registered by exporting it with `export default`. In a `.ink` file, as the SFC entry, module export is not supported directly. Instead, agent logic must be defined inside script blocks and other ESM modules can be imported as needed. The agent instance is used to handle global lifecycle hooks, coordinate agent-level intent flow, and store global shared data.

### Example Code

```javascript
// app.js
export default {
  // 智能体初始化时触发
  onLaunch(options) {
    console.log('Agent Launch', options);
  },
  // 智能体启动或从后台进入前台时触发
  onShow(options) {
    console.log('Agent Show');
  },
  // 智能体从前台进入后台时触发
  onHide() {
    console.log('Agent Hide');
  },
  // 全局共享数据
  globalData: {
    userInfo: null
  }
}
```

### Lifecycle Callbacks

| Callback | Description | Trigger Timing |
| :--- | :--- | :--- |
| `onLaunch` | Listen for agent initialization | Triggered when agent initialization completes (only once globally) |
| `onShow` | Listen for the agent being shown | Triggered when the agent starts, or returns from background to foreground |
| `onHide` | Listen for the agent being hidden | Triggered when the agent moves from foreground to background |
| `onError` | Error listener | Triggered when the agent encounters a script error or an API call fails |

## Register a Page (Page)

Each page is defined by a page configuration object in its logic file (`.js` or `.ink`). In a `.js` file, the page is registered through `export default`; in a `.ink` file, the logic is defined directly inside `<script setup>` and required modules are imported there. This object defines the page's initial data, lifecycle callbacks, event handlers, and more. In practice, page logic is where user intent is translated into state transitions and UI updates.

### Example Code

```javascript
// pages/index/index.js
export default {
  // 页面的初始数据
  data: {
    title: 'Hello AIUI',
    count: 0
  },
  // 页面加载时触发
  onLoad(query) {
    console.log('Page Load', query);
  },
  // 页面显示时触发
  onShow() {
    console.log('Page Show');
  },
  // 页面初次渲染完成时触发
  onReady() {
    console.log('Page Ready');
  },
  // 页面隐藏时触发
  onHide() {
    console.log('Page Hide');
  },
  // 页面卸载时触发
  onUnload() {
    console.log('Page Unload');
  },
  // 事件处理函数
  handleIncrement() {
    this.setData({
      count: this.data.count + 1
    });
  }
}
```

### Lifecycle Callbacks

| Callback | Description | Trigger Timing |
| :--- | :--- | :--- |
| `onLoad` | Listen for page loading | Triggered when the page loads (only once globally) |
| `onShow` | Listen for the page being shown | Triggered when the page is shown or enters the foreground |
| `onReady` | Listen for the page's first render completion | Triggered when the page finishes its first render (only once globally) |
| `onHide` | Listen for the page being hidden | Triggered when the page is hidden or enters the background |
| `onUnload` | Listen for page unload | Triggered when the page is unloaded |

## Page Instance Methods

In page logic, you can access the page instance via `this` and call the following common methods. These APIs are the basic tools for turning intent changes into visible interface updates:

- **`this.setData(Object data, Function callback)`**: Sends data from the logic layer to the view layer asynchronously, while also updating the corresponding values in `this.data`.
- **`this.data`**: Gets the current page data.
- **`this.route`**: Not supported yet.
