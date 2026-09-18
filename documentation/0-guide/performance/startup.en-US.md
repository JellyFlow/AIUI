# Startup Performance

AIUI startup performance is primarily determined by how much work the first Page or Widget must complete between opening the agent and showing the first meaningful frame.

During startup, the AIUI runtime reads and parses the entry source, merges global and page styles, parses the template and creates its node trees, loads custom components used by the initial screen, executes the application and entry scripts, and applies the initial `data` to template bindings. It then performs the first binding, layout, and paint work before submitting a frame to the display.

The goal is therefore not merely to reduce the total project size, but to shorten this initial-screen critical path.

## Keep the Initial Screen Small

The larger the initial template is, the more nodes the runtime must parse, bind, lay out, and paint before the first frame. Keep only content that users can see or use immediately on the entry page.

- Do not mount large lists, complex panels, or deeply nested structures that are not needed on the initial screen.
- Move later workflows to subsequent pages and load them when users enter those workflows.
- Start lists with a reasonable number of items instead of placing the entire dataset in `data`.
- Remove wrapper nodes that do not contribute layout, styling, or interaction.

Hiding content with CSS does not remove it from template parsing and node creation. For a complete feature area that is not needed during startup, remove it from the initial-screen structure instead of merely making it invisible.

### Split Independent Screens into Separate Pages

If the home, detail, and settings screens each serve a distinct task, implement them as separate Pages. Do not put every screen's template, state, and event logic into one Page and switch the complete interface with `ink:if` and page state. That approach keeps expanding the entry template and script while coupling the lifecycle, data, and interaction logic of otherwise independent screens.

For example, this structure places both the home and detail screens in one Page and does not scale well as features grow:

```html
<page>
  <view ink:if="{{ currentView === 'home' }}">
    <!-- Home content -->
  </view>

  <view ink:elif="{{ currentView === 'detail' }}">
    <!-- Detail content -->
  </view>
</page>
```

Instead, register the two Pages separately in `app.json`:

```json
{
  "pages": [
    "pages/home/index",
    "pages/detail/index"
  ]
}
```

Navigate from the home Page when the user opens a detail item:

```javascript
wx.navigateTo({
  url: '/pages/detail/index?id=42'
});
```

The entry Page now handles only the home task, while the detail Page keeps its own template, state, and business logic. Use `wx.redirectTo()` when the new Page should replace the current one, and `wx.navigateBack()` to return through the existing page stack.

`ink:if` remains appropriate for local conditions within one Page, such as loading, empty, error, and permission states or an expandable region. Use this rule of thumb: if the content represents a distinct task, complete layout, or navigation destination, prefer a separate Page; if it is only a local state of the current task, keep it in the current Page. See the [Routing API](/AIUI/api/route) for the complete navigation contract.

## Limit Custom Components on the Initial Screen

While parsing the entry template, the runtime loads referenced custom components and executes their scripts. A component's template, styles, nested components, and initialization code therefore become part of the startup critical path.

- Reference only custom components that the initial screen needs immediately.
- Avoid a deeply nested component tree for small static fragments.
- Check whether nested components repeatedly import the same resources or perform the same initialization.
- Move complex, nonessential features to later pages instead of mounting them on the entry page in advance.

Components remain valuable for maintainability, but a component boundary does not automatically provide lazy loading. Decide whether to reference a component based on whether the initial screen actually needs it.

## Reduce Synchronous Script and Resource Initialization

The application script, entry script, and initial-screen component scripts all run during startup. Synchronous work at module scope directly delays subsequent lifecycle work and the first frame.

- Do not transform large arrays, deeply clone objects, or repeatedly parse JSON at module scope.
- Do not create unused media, device, or other heavyweight objects during startup.
- Defer calculations and capability initialization that are not required by the initial screen until users enter the relevant workflow.
- Be careful when importing assets with `with { type: 'image' }` or `with { type: 'sound' }` from an entry module; the runtime decodes images or initializes sound objects while evaluating those modules.

Keep synchronous work in `onLoad` short as well. The initial screen can show a stable loading state while a network request runs, then update when data arrives:

```html
<script setup>
export default {
  data: {
    loading: true,
    items: [],
  },

  async onLoad() {
    const response = await fetch('https://api.example.com/items');
    const items = await response.json();

    this.setData({
      loading: false,
      items,
    });
  },
};
</script>
```

This does not remove network latency, but it prevents remote data from becoming a prerequisite for the first frame. Keep loading, empty, and error states dimensionally stable to reduce visible layout shifts when data arrives.

## Keep Initial `data` and Bindings Focused

After executing the entry script, the runtime reads the initial `data` and applies those fields to template bindings. Large objects, long lists, and many expressions increase initial data conversion and binding work.

- Keep only fields required to render the initial screen in initial `data`.
- Do not copy a complete API response into page state; extract the fields the UI actually uses.
- Avoid repeatedly reading the same deeply nested fields from many nodes.
- Apply related changes from one operation with one `setData()` call instead of triggering several consecutive updates.

Do not combine unrelated large objects into `setData()` merely to reduce the number of calls. The goal is to avoid redundant rendering while keeping every update focused on necessary data.

## Optimize Initial Styles and Media

The runtime parses global and page styles before constructing the initial screen and resolves styles while laying out nodes. Resources such as initial-screen images may continue loading after the first update and trigger another paint when they become available.

- Remove unused global styles so every page does not pay to parse unrelated rules.
- Limit complex selectors and deeply nested structures, especially rules that match many initial-screen nodes.
- Give initial-screen images explicit dimensions so completed resources do not reshape the entire layout.
- Compress images and use assets close to their rendered size instead of decoding images much larger than the display area.
- Do not let nonessential video, animation, or audio enter preparation or playback during startup.

## Measure the First Meaningful Frame

Measure startup on the target device with a real AIX package. A single launch on a development machine does not represent cold-start behavior on the device.

Record these points together:

1. The agent begins opening.
2. Required synchronous initialization in `onLoad` finishes.
3. The first frame is submitted.
4. The first frame containing meaningful content appears.
5. Primary initial-screen data finishes loading and the layout stabilizes.

Use `performance.mark()` and `performance.measure()` for application initialization stages. Use screen recording, host performance events, or device logs to confirm when content is actually displayed. Repeat cold-start runs and compare medians or percentiles before and after a change.

```html
<script setup>
export default {
  async onLoad() {
    performance.mark('home-data-start');

    const response = await fetch('https://api.example.com/summary');
    const summary = await response.json();
    this.setData({ summary });

    performance.mark('home-data-end');
    performance.measure(
      'home-data-ready',
      'home-data-start',
      'home-data-end',
    );
  },
};
</script>
```

`performance.measure()` reports JavaScript task duration; it does not by itself prove that a frame has reached the display. Evaluate startup by combining script measurements with first-frame and first-meaningful-frame observations.

## Current Capability Boundary

The runtime can currently parse the `subpackages` and `preloadRule` fields in `app.json`, but its startup and navigation paths do not yet use those fields to perform subpackage loading or subpackage prefetching. Do not treat the presence of these configuration fields as an active startup optimization.

Until the runtime provides complete subpackage scheduling, improve startup by simplifying the entry page, reducing initial-screen components and synchronous initialization, and controlling initial data and resource costs.

Continue with [Performance Metrics](/AIUI/guide/performance-data) to establish a performance baseline. If the problem mainly occurs after the page is visible, see [Runtime Performance](/AIUI/guide/performance-runtime).
