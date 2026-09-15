# ScrollView

The `scroll-view` component is a scrollable view container that allows users to scroll when the content exceeds the visible area.

## Usage

```xml
<scroll-view class="scroll-container" scroll-y="true">
  <view class="item">项目 1</view>
  <view class="item">项目 2</view>
  <view class="item">项目 3</view>
  <!-- 更多项目 -->
</scroll-view>
```

## Properties

| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `scroll-x` | Boolean | `false` | Enables horizontal scrolling. |
| `scroll-y` | Boolean | `false` | Enables vertical scrolling. |
| `scroll-top` | Number | - | Sets the vertical scroll position. |
| `scroll-left` | Number | - | Sets the horizontal scroll position. |
| `scroll-into-view` | String | - | Scrolls to the position of the element with the corresponding ID. |
| `auto-scroll` | Boolean | `false` | Enables automatic scrolling. |
| `scroll-speed` | Number | `25.0` | The speed of automatic scrolling. |
| `scroll-direction` | String | `vertical` | The direction of automatic scrolling (`vertical` or `horizontal`). |

## Listen for Scrolling

Use `bindscroll` to observe scroll position changes and `bindscrollend` to observe the end of a scrolling sequence:

```xml
<scroll-view
  class="scroll-container"
  scroll-y="true"
  bindscroll="handleScroll"
  bindscrollend="handleScrollEnd"
>
  <!-- List content -->
</scroll-view>
```

```javascript
export default {
  handleScroll(event) {
    console.log('Current position', event.detail.scrollTop);
  },

  handleScrollEnd(event) {
    console.log('Final position', event.detail.scrollTop);
  }
};
```

Whether scrolling comes from user input or code, handlers receive the same event types and data shape, and the event does not identify its source. A `scroll` event is dispatched only when the scroll position actually changes, and one `scrollend` event is dispatched when the current scrolling sequence ends. User gestures and smooth scrolling can dispatch multiple `scroll` events, while an immediate code-triggered scroll synchronously dispatches one `scroll` event followed by one `scrollend` event.

`event.detail` contains these fields:

| Field | Type | Description |
| :--- | :--- | :--- |
| `scrollTop` / `scrollLeft` | Number | Vertical or horizontal scroll position when the event is dispatched |
| `scrollWidth` / `scrollHeight` | Number | Width or height of the scrollable content |
| `clientWidth` / `clientHeight` | Number | Width or height of the visible area |
| `scrollBottom` | Number | Remaining vertical distance to the bottom |
| `isAtBottom` | Boolean | Whether the entity is at the bottom |

## Features

- Supports both horizontal and vertical scrolling.
- Supports touch and mouse drag gestures.
- Supports mouse wheel scrolling.
- Supports automatic scrolling with custom speed and direction.
