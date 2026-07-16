# Router (router)

Provides APIs related to page routing and navigation. These APIs are used to move between pages, replace the current page, return to previous pages, and manage the page stack.

## Method Overview

- `wx.redirectTo(Object object)`: Closes the current page and navigates to a specified page within the app. Navigation to a tabBar page is not allowed.
- `wx.navigateTo(Object object)`: Keeps the current page open and navigates to a specified page within the app. Navigation to a tabBar page is not allowed.
- `wx.navigateBack(Object object)`: Closes the current page and returns to the previous page or multiple previous pages.

## Method Details

### `wx.redirectTo(Object object)`

Closes the current page and navigates to another page within the app. It is commonly used when you want to replace the current page in a flow rather than keep it in the navigation history.

- **Use cases**: Replacing a step page, moving from a form page to a result page after submission, or chaining guide pages without preserving the previous page.
- **Parameters**: `object.url` specifies the target page path.
- **Page stack behavior**: The current page is popped from the stack and the target page is pushed, so the overall stack depth usually stays the same.
- **Notes**: Cannot navigate to a tabBar page.

Example:

```javascript
wx.redirectTo({
  url: '/pages/result/index?status=success'
});
```

### `wx.navigateTo(Object object)`

Keeps the current page and navigates to a new page. This is the most common forward navigation method, suitable for flows such as moving from a list to a detail page or from a home page to a feature page.

- **Use cases**: Entering a lower-level page from the current page while allowing the user to return later.
- **Parameters**: `object.url` specifies the target page path.
- **Page stack behavior**: The current page remains in the stack, and the target page is pushed onto the top of the stack.
- **Callbacks**: May trigger `success()` when the call succeeds, and `complete()` when the call finishes.
- **Notes**: Cannot navigate to a tabBar page.

Example:

```javascript
wx.navigateTo({
  url: '/pages/detail/index?id=1'
});
```

### `wx.navigateBack(Object object)`

Closes the current page and returns to the previous page. It can also return across multiple levels in the page stack.

- **Use cases**: Returning from a detail page to a list page, stepping back in a flow, or leaving a child page and returning to its source page.
- **Parameters**: `object.delta` indicates how many levels to go back. If omitted, the default value is `1`.
- **Page stack behavior**: The current page and any intermediate pages being skipped are removed from the stack.
- **Callbacks**: May trigger `success()` when the call succeeds, and `complete()` when the call finishes.
- **Notes**: If the specified back level is greater than the current page stack depth, the actual result depends on the runtime behavior. It is recommended to pass a value that matches the real stack depth.

Example:

```javascript
wx.navigateBack({
  delta: 1
});
```

## How To Choose

- Use `wx.navigateTo` to move to a lower-level regular page.
- Use `wx.redirectTo` to replace the current page with a new one.
- Use `wx.navigateBack` to return to the previous page or multiple previous pages.
