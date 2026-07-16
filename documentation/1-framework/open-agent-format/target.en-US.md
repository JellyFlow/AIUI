# Target

`target` describes what hosting slot the page is currently placed into by the host. For the same page, `target` usually determines information density, layout space, and interaction level.

## Available Targets

In the current documentation, the common page `target` values include:

| `target` | Description |
| :--- | :--- |
| `_current` | Stay in the current context, such as the current card or inline page inside the chat flow |
| `_blank` | Switch to a standalone page, standalone window, or a more complete hosting space |

## Target Mapping Across Devices

Different host devices use their own container models to render pages, so the concrete meaning of the same `target` can vary by device. The currently public documentation starts with Rokid Glasses:

### Rokid Glasses

- `_current`: The card container inside the conversation flow, where the page appears inline in the current chat context
- `_blank`: The full-screen container entered by double-tapping from the conversation flow, where the page switches into a more complete full-screen presentation and interaction space

## Styling Different Targets With CSS

If the same page is reused across multiple hosting targets, you can branch styles directly by `target`:

```css
.panel {
  padding: 16rpx;
}

@media (target: _current) {
  .panel {
    max-height: 320rpx;
  }
}

@media (target: _blank) {
  .panel {
    max-width: 100%;
    padding: 24rpx;
  }
}
```

It is recommended to use `target` mainly for:

- Information density differences
- Layout size differences
- Whether auxiliary action areas should be shown
- Style switching between compact card mode and expanded mode

## Listening To Target Changes In App And Page

If you want to switch layout or data strategy in the logic layer based on the hosting target, implement `onTargetChanged(target, previousTarget)` on `App` and `Page`.

```javascript
export default {
  onTargetChanged(target, previousTarget) {
    console.log('app target changed:', previousTarget, '->', target);
  }
}
```

```javascript
export default {
  data: {
    hostTarget: '_current'
  },
  onTargetChanged(target, previousTarget) {
    console.log('page target changed:', previousTarget, '->', target);
    this.setData({ hostTarget: target });
  }
}
```

Common use cases include:

- Showing only summary content in `_current`
- Expanding into a full operation flow after switching to `_blank`

## Design Boundaries

`target` mainly expresses hosting-position semantics. It should not replace these concepts:

- The exact viewport size
- A specific business-state transition

A better separation is:

- Use `target` to describe where the page is hosted
- Use page data to describe the current stage of the business flow

## Recommended Reading

- [Page Overview](/AIUI/guide/open-agent-format-page)
- [Events](/AIUI/guide/open-agent-format-page-events)
- [Focus System](/AIUI/framework/open-agent-format-page-focus)
