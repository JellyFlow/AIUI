# Widget Development

Widgets provide compact surfaces that a host can keep visible. They use the same `.ink` single-file format and data-binding model as pages, but have their own declaration entry, root element, family, and lifecycle.

## Create a Widget File

Create an `.ink` file under `widgets/` and declare its family in the JSON definition:

```xml
<script type="application/json" def>
{
  "widget": {
    "family": "1x1"
  }
}
</script>

<script setup>
export default {
  data: {
    count: 0,
  },

  increment() {
    this.setData({ count: this.data.count + 1 });
  },
};
</script>

<widget>
  <button class="counter" bindtap="increment">
    <text>{{count}}</text>
  </button>
</widget>

<style>
.counter {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
}
</style>
```

A Widget template must use `<widget>` as its root element. Supported families are currently `1x1` and `1x2`.

## Register the Widget in `app.json`

Declare the Widget path and family in the application's `widgets` array:

```json
{
  "pages": [
    "pages/index/index"
  ],
  "widgets": [
    {
      "path": "widgets/counter/index",
      "family": "1x1"
    }
  ]
}
```

Do not include the `.ink` extension in `path`. The `family` in `app.json` must match `widget.family` in the Widget file's JSON definition, or the runtime rejects the entry as a Widget.

A typical project structure is:

```text
agent-app/
  app.json
  pages/
    index/
      index.ink
  widgets/
    counter/
      index.ink
```

## Manage State and Interaction

The `data` object in the Widget's default export is reactive state. Calling `this.setData()` updates matching template bindings:

```javascript
export default {
  data: {
    status: 'Ready',
  },

  activate() {
    this.setData({ status: 'Active' });
  },
};
```

Template events work like page events and invoke same-named methods on the default export. Template events such as `bindtap` and input handlers are dispatched only while the host permits interaction; read `this.interactive` for the current state.

## Respond to the Widget Lifecycle

```javascript
export default {
  onCreate() {
    console.log('created', this.widgetId, this.family);
  },

  onAttach() {
    this.setData({ status: 'Attached' });
  },

  onDetach() {
    console.log('detached');
  },

  onDestroy() {
    console.log('destroyed');
  },
};
```

- `onCreate()` runs after the Widget loads and host state is initialized.
- `onAttach()` runs when the Widget becomes active in its host surface.
- `onDetach()` runs when the Widget is deactivated or before teardown.
- `onDestroy()` runs during final teardown.

Read `this.hostWidth` and `this.hostHeight` for logical host dimensions and `this.family` for the current family. A Widget's presentation target is always `_widget`.

## Continue Reading

- [app.json](/AIUI/framework/open-agent-format-app-json): configure page and Widget entries.
- [Widget API](/AIUI/api/framework-widget): see the complete instance-member, `setData()`, and lifecycle reference.
- [Components](/AIUI/framework/open-agent-format-custom-components): encapsulate reusable UI as custom components.
