# Components

Components encapsulate reusable state, view structure, and event logic. They are useful for splitting complex pages into smaller modules with better reuse and maintainability.

AIUI currently supports component-local `data`, `properties`, `setData()`, `triggerEvent()`, lifecycle hooks, nested components, and scoped component styles.

## Registration And Usage

Pages or components can reference components through `usingComponents`. A common pattern is declaring them in `<script def>` inside an AIUI `.ink` file:

```html
<script def>
{
  "usingComponents": {
    "demo-card": "components/demo-card"
  }
}
</script>
```

If the current file is itself a component, declare `"component": true` as well:

```html
<script def>
{
  "component": true,
  "usingComponents": {
    "demo-badge": "components/demo-badge"
  }
}
</script>
```

After registration, the component can be used like a built-in tag:

```xml
<demo-card title="{{title}}" bindchange="onCardChange" />
```

## Recommended Form

AIUI recommends using `.ink` single-file components so that metadata, template, styles, and logic stay in one file:

```html
<script def>
{
  "component": true
}
</script>

<template>
  <view class="card">
    <text>{{title}}</text>
  </view>
</template>

<style>
.card {
  display: flex;
  padding: 12px;
}
</style>

<script setup>
export default {
  properties: {
    title: {
      type: String,
      value: 'Untitled'
    }
  }
}
</script>
```

In this form:

- `<script def>` declares component metadata such as `"component": true` and `usingComponents`
- `<template>` defines the component structure
- `<style>` defines component-local styles
- `<script setup>` exports the component logic

## Component Instance API

Component instances currently support these core capabilities:

- `properties`: read-only inputs passed from the parent
- `data`: component-local state
- `methods`: component methods, called directly as `this.xxx()`
- `this.setData(patch)`: updates local state
- `this.triggerEvent(name, detail)`: dispatches a custom event to the parent

Example:

```javascript
export default {
  data: {
    count: 0
  },
  properties: {
    title: {
      type: String,
      value: 'Untitled'
    }
  },
  methods: {
    emitChange() {
      const nextCount = this.data.count + 1;
      this.setData({ count: nextCount });
      this.triggerEvent('change', {
        value: `${this.properties.title}:${nextCount}`
      });
    }
  }
}
```

## Lifecycle

The currently supported component lifecycle hooks are:

- `created`
- `attached`
- `ready`
- `detached`

Declare them under `lifetimes`:

```javascript
export default {
  lifetimes: {
    created() {},
    attached() {},
    ready() {},
    detached() {}
  }
}
```

## Notes

- Components can reference other components to build nested component trees
- Component styles are scoped to the component subtree and do not leak to the page
- Child component events can be forwarded outward through parent components when needed
