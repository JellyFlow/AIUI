# Focus System

AIUI pages not only have hosting semantics, but also participate in a focus model tied to interactive activation. Understanding focus helps you design keyboard navigation, card activation, element selection, and page-level event handling correctly.

## Two Layers Of Focus

In AIUI, it is useful to distinguish between two layers of focus:

- **Host Focus**: Whether the current page instance is in the host's active interactive state
- **Element Focus**: Which specific node in the page tree is currently selected or receiving focus semantics

These two concepts are related, but they are not the same:

- Host focus determines whether the page can take over directional keys, confirm keys, and other interactions, and whether it is in an actively navigable state
- Element focus determines which node inside the page shows focus styles, receives `focus` / `blur` events, or becomes the currently activatable object

You can think of it this way: host focus answers "can this page interact right now," while element focus answers "where is the interaction currently inside the page."

## Styling Focus States With CSS

At the CSS level, the currently supported focus-related pseudo-class is `:host-focus`, which is used to express whether the page is currently in host focus.

```css
.agent-shell {
  opacity: 0.72;
  transform: scale(0.98);
  transition: opacity 0.2s, transform 0.2s;
}

.agent-shell:host-focus {
  opacity: 1;
  transform: scale(1);
}
```

It is recommended to use this state to express whether the page has returned to the active foreground interaction context.

## Listening To Focus Events In App And Page

If you need to react to host focus changes in the logic layer, you can listen to these callbacks on `App` or `Page`:

- `onHostFocus()`: Triggered when the page regains host focus
- `onHostBlur()`: Triggered when the page loses host focus

`App` is suitable for global state coordination, such as pausing global shortcuts, restoring sound effects, or rebuilding global interaction state:

```javascript
export default {
  onHostFocus() {
    console.log('app host focus restored');
  },
  onHostBlur() {
    console.log('app host blurred');
  }
}
```

`Page` is suitable for page-specific styling, text, and interaction feedback:

```javascript
export default {
  data: {
    hostFocused: false
  },
  onHostFocus() {
    this.setData({ hostFocused: true });
  },
  onHostBlur() {
    this.setData({ hostFocused: false });
  }
}
```

## Element-Level Focus

Beyond host focus, the runtime also maintains element-level focus inside the page. You can use element events and state to implement UI feedback for the currently selected item.

```xml
<view
  class="action-item {{focused ? 'action-item--focused' : ''}}"
  bindfocus="onItemFocus"
  bindblur="onItemBlur"
>
  Open details
</view>
```

```javascript
export default {
  data: {
    focused: false
  },
  onItemFocus() {
    this.setData({ focused: true });
  },
  onItemBlur() {
    this.setData({ focused: false });
  }
}
```

This kind of element-level focus is commonly used for:

- Highlighting list items
- Switching inside button groups
- Focusing form inputs
- Indicating the current navigation position

## Navigation Interaction Mode

On hosts that support directional keys or device buttons, pages usually participate in a focus-driven Navigation interaction mode. Its purpose is to let users move, choose, and activate content without relying on touch.

You can understand this mode in the following way:

- `Enter`: Enter navigation mode, or activate the current target
- `ArrowUp` / `ArrowDown`: Move within the current navigation path, or scroll the root view when the page does not take over
- `Backspace`: Exit the current level, go back to the previous level, or request the page to close

If the page needs to take over these behaviors, call `event.preventDefault()` in the corresponding event callback, and then manage focus movement, scrolling, and activation on your own. For the built-in key behaviors, continue reading [Events](/AIUI/guide/open-agent-format-page-events).

## What Is Limited When The Page Is Not Focused

When a page is not in host focus, the first thing that is usually affected is interaction takeover rather than rendering:

- Directional navigation and confirm-key activation that depend on the current active page are usually limited
- The page's ability to take over default key behavior is usually limited
- Focus movement, selection, and confirm flows that depend on the page being the active interactive context are usually limited

Pure presentation capabilities are usually unaffected, for example:

- The page can keep rendering existing content
- Asynchronous data updates and `setData`
- Normal styling and state changes that do not depend on active focus

The exact boundary still depends on the host implementation, so it is best to treat "is the page in host focus" as an explicit state in your interaction design.

## Recommended Reading

- [Page Overview](/AIUI/guide/open-agent-format-page)
- [Events](/AIUI/guide/open-agent-format-page-events)
- [Target](/AIUI/framework/open-agent-format-page-target)
