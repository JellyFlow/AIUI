# Page Definition

An AIUI Page combines **Page configuration**, **Page logic**, **Page structure**, and **Page styles**. The recommended `.ink` single-file form uses `<script def>` for configuration, `<script setup>` for exported Page logic, `<page>` for the interface structure, and `<style>` for Page styles.

The distinction matters: `<script def>` contains JSON, not executable JavaScript. Put lifecycle callbacks, event handlers, and initial state in the object exported from `<script setup>`.

## Complete Page Example

```html
<script type="application/json" def>
{
  "navigationBarTitleText": "Weather",
  "description": "Displays weather for a city.",
  "schema": {
    "data": {
      "type": "object",
      "properties": {
        "city": {
          "type": "string",
          "description": "The city to query."
        }
      },
      "required": ["city"]
    }
  },
  "usingComponents": {
    "weather-card": "components/weather-card"
  },
  "disableScroll": true
}
</script>

<script setup>
export default {
  data: {
    city: '',
    status: 'Waiting'
  },
  onLoad(query) {
    this.setData({
      city: query.city || '',
      status: query.city ? 'Ready' : 'Choose a city'
    });
  },
  handleComplete() {
    this.finish();
  }
}
</script>

<page>
  <weather-card city="{{city}}" status="{{status}}" />
  <button bindtap="handleComplete">Done</button>
</page>

<style>
page {
  padding: 16px;
}
</style>
```

The same Page can be split into matching `.json`, `.js`, `.wxml`, and `.wxss` files. In that form, `.json` is equivalent to `<script def>`, and `.js` is equivalent to the default export in `<script setup>`. Do not mix both forms for the same route.

## `<script def>` Page Configuration

`<script def>` must contain a valid JSON object. It cannot contain comments, functions, variables, or trailing commas. Keeping `type="application/json"` is recommended because it makes the content type explicit.

### Common Fields

| Field | Type | Required | Purpose |
| :--- | :--- | :--- | :--- |
| `navigationBarTitleText` | string | No | Sets the Page title; whether it is visible depends on how the host presents navigation |
| `description` | string | Recommended for conversational Pages | Explains to the model what the Page does and when to use it; describe observable capability rather than a generic title |
| `schema` | Object | No | Describes data that the host or model can provide when opening the Page; Page input belongs in `schema.data` |
| `usingComponents` | Object | No | Registers custom components used by this Page; each key is a template tag name and each value is a component path or package export |
| `disableScroll` | boolean | No | Disables default scrolling on the Page root; defaults to `false` |

Together, `description` and `schema.data` describe a Page as a callable UI tool. An immersive agent commonly enters the first Page registered in `app.json`, so that Page does not always need to be exposed as an independent tool. A conversational card Page should define both fields precisely.

### `schema.data`

`schema.data` uses JSON Schema to describe data passed into the Page. Common fields include:

| Field | Type | Purpose |
| :--- | :--- | :--- |
| `type` | string | Root data type; Page input normally uses `object` |
| `properties` | Object | Defines each input field, including its type, meaning, and constraints |
| `required` | string[] | Lists fields that must be supplied; fields not listed are optional |
| `properties.<name>.type` | string | Field type, such as `string`, `number`, `integer`, `boolean`, `object`, or `array` |
| `properties.<name>.description` | string | Tells the model the field's meaning, format, unit, and value requirements |
| `properties.<name>.enum` | any[] | Restricts the field to a set of values |
| `properties.<name>.items` | Object | Describes array elements when the field type is `array` |
| `properties.<name>.default` | any | Describes a suggested default; Page logic should still handle a missing field |

`schema.data` describes **input used to open the Page**. It is different from `data` in the Page logic object: the former helps the model and host construct invocation arguments, while the latter is local state for the first render. Read incoming values from `onLoad(query)`, then copy them into Page state with `setData()`.

```json
{
  "description": "Displays weather for a city and date.",
  "schema": {
    "data": {
      "type": "object",
      "properties": {
        "city": {
          "type": "string",
          "minLength": 1,
          "description": "City name, for example Hangzhou."
        },
        "date": {
          "type": "string",
          "description": "Query date in YYYY-MM-DD format."
        },
        "unit": {
          "type": "string",
          "enum": ["celsius", "fahrenheit"],
          "default": "celsius",
          "description": "Temperature unit."
        }
      },
      "required": ["city"]
    }
  }
}
```

### Other Compatibility Fields

The Page configuration parser also accepts mini-app-style window, background, renderer, and host extension fields, including `navigationBarBackgroundColor`, `navigationBarTextStyle`, `navigationStyle`, `homeButton`, `backgroundColor`, `backgroundColorContent`, `backgroundTextStyle`, `backgroundColorTop`, `backgroundColorBottom`, `enablePullDownRefresh`, `onReachBottomDistance`, `pageOrientation`, `viewport`, `style`, `initialRenderingCache`, `singlePage`, `restartStrategy`, `handleWebviewPreload`, `visualEffectInBackground`, `enablePassiveEvent`, `renderer`, `rendererOptions`, and `componentFramework`.

These fields primarily provide compatibility with different hosts or reserve future behavior. Their presence does not mean every host implements the corresponding visual or interaction effect. Unless your target host documents such a contract, prefer the common fields above and use `<style>` for Page content styling.

## `<script setup>` Page Logic

Page logic default-exports an object. Its fields become the current Page instance's state, lifecycle callbacks, and event handlers.

| Field | Type | Required | Purpose |
| :--- | :--- | :--- | :--- |
| `data` | Object | No | Initial render state; values must be JSON-serializable |
| `onLoad` | function | No | Runs once when the Page loads and receives route or tool invocation parameters |
| `onShow` | function | No | Runs when the Page appears or returns to the foreground |
| `onReady` | function | No | Runs once after the first render completes |
| `onHide` | function | No | Runs when the Page is hidden or enters the background |
| `onUnload` | function | No | Runs when the Page is unloaded; release timers, listeners, and other resources here |
| `onKeyDown` | function | No | Runs when a key is pressed; read its code from `event.code` |
| `onKeyUp` | function | No | Runs when a key is released; `event.preventDefault()` can intercept selected host defaults |
| `onVoiceWakeup` | function | No | Runs for voice or touch wakeup events; use `event.keyword` when the source must be distinguished |
| Custom methods | function | No | Handle template events or share Page logic; access the Page instance through `this` |
| Custom fields | any | No | Store members that do not participate in rendering; values that drive the UI should live in `data` |

Do not use `options` here as a standard Page field. Parameters used to open a Page are received by `onLoad(query)`, while custom component configuration belongs in `usingComponents` inside `<script def>`.

## Page Instance

Inside Page callbacks and custom methods, `this` refers to the current Page instance.

### `this.data`

Reads the current Page state. Do not rely on direct `this.data` mutation to update the UI; use `this.setData()` for values bound by the template.

### `this.setData(Object patch, Function? callback)`

Asynchronously sends an update to the view layer while updating `this.data`. `patch` supports path keys such as `'user.name': 'Rokid'`. The optional callback runs after this view update completes.

```javascript
this.setData({
  status: 'ready',
  'user.name': 'Rokid'
}, () => {
  console.log('view updated');
});
```

### `this.finish()`

Notifies the host that the current Page task is complete. For a Cut agent, this commonly returns focus and leaves the current presentation. For a Scene agent, it commonly marks the end of the current interaction flow. It is not a general Page-back API, so call it only when the business task is actually complete.

## Lifecycle and Events

The first opening follows `onLoad` → `onShow` → `onReady`. Covering a Page triggers `onHide`, showing it again triggers another `onShow`, and destroying it triggers `onUnload`.

For default key and wakeup behavior, event fields, and interception, see [Events](/AIUI/framework/open-agent-format-page-events). For the full lifecycle, see [Lifecycle](/AIUI/framework/open-agent-format-page-lifecycle).

## Recommended Reading

- [Page Overview](/AIUI/framework/open-agent-format-page)
- [Lifecycle](/AIUI/framework/open-agent-format-page-lifecycle)
- [Events](/AIUI/framework/open-agent-format-page-events)
- [Components](/AIUI/framework/open-agent-format-custom-components)
