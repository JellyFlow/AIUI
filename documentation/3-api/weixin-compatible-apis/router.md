# 路由 (router)

提供页面路由导航相关的接口，用于在不同页面之间完成跳转、替换、返回和页面栈管理。

## 方法概览

- `wx.redirectTo(Object object)`: 关闭当前页面，跳转到应用内的某个页面，但是不允许跳转到 tabBar 页面。
- `wx.navigateTo(Object object)`: 保留当前页面，跳转到应用内的某个页面，但是不能跳到 tabBar 页面。
- `wx.navigateBack(Object object)`: 关闭当前页面，返回上一页面或多级页面。

## 方法详解

### `wx.redirectTo(Object object)`

关闭当前页面，并跳转到应用内的另一个页面。它常用于流程中的“替换当前页”，例如从列表页进入一个新的中间页，且不希望用户返回到旧页面。

- **适用场景**：步骤页替换、表单提交后切换到结果页、引导页串联跳转。
- **参数**：`object.url` 为目标页面路径。
- **页面栈行为**：当前页出栈，目标页入栈，页面总层级通常保持不变。
- **注意事项**：不能跳转到 tabBar 页面。

示例：

```javascript
wx.redirectTo({
  url: '/pages/result/index?status=success'
});
```

### `wx.navigateTo(Object object)`

保留当前页面，并跳转到新的页面。它是最常见的页面前进方式，适合从列表进入详情、从首页进入功能页等场景。

- **适用场景**：从一个页面进入下一级页面，并希望用户稍后可以返回。
- **参数**：`object.url` 为目标页面路径。
- **页面栈行为**：当前页保留在栈中，目标页压入页面栈顶部。
- **回调**：调用成功时可触发 `success()`，结束时可触发 `complete()`。
- **注意事项**：不能跳转到 tabBar 页面。

示例：

```javascript
wx.navigateTo({
  url: '/pages/detail/index?id=1'
});
```

### `wx.navigateBack(Object object)`

关闭当前页面并返回上一个页面，也可以一次返回多级页面。

- **适用场景**：详情页返回列表页、流程页回退、结束当前子页面后返回来源页。
- **参数**：`object.delta` 表示返回的层级数；省略时默认值为 `1`。
- **页面栈行为**：当前页以及需要回退的中间页面会被依次移出页面栈。
- **回调**：调用成功时可触发 `success()`，结束时可触发 `complete()`。
- **注意事项**：如果指定的返回层级大于当前页面栈深度，实际表现应以运行时处理结果为准，文档中建议按实际页面层级传入。

示例：

```javascript
wx.navigateBack({
  delta: 1
});
```

## 如何选择

- 进入下一级普通页面，用 `wx.navigateTo`。
- 用新页面替换当前页面，用 `wx.redirectTo`。
- 返回上一个页面或多级页面，用 `wx.navigateBack`。
