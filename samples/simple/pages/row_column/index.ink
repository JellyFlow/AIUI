<script type="application/json" def>
  {
    "schema": {
      "data": {
        "a2uiData": "string"
      }
    }
  }
</script>

<script setup>
  export default {
    data: {
      a2uiData: `[
        {
          "type": "createSurface",
          "surfaceId": "row-column-surface"
        },
        {
          "type": "updateComponents",
          "surfaceId": "row-column-surface",
          "components": [
            {
              "id": "root",
              "component": "Column",
              "props": {
                "width": "100%",
                "height": "100%",
                "padding": 0,
                "gap": 16,
                "boxSizing": "border-box"
              },
              "children": [
                "page-title",
                "section-basic-row",
                "section-basic-column",
                "section-nested",
                "section-centered"
              ]
            },
            {
              "id": "page-title",
              "component": "text",
              "props": {
                "content": "A2UI Row / Column",
                "style": "font-size: 24px; font-weight: bold;"
              }
            },
            {
              "id": "section-basic-row",
              "component": "Column",
              "props": {
                "backgroundColor": "var(--row-column-section-background, var(--color-surface-highlight))",
                "padding": 16,
                "gap": 12,
                "borderRadius": 12
              },
              "children": ["title-basic-row", "basic-row"]
            },
            {
              "id": "title-basic-row",
              "component": "text",
              "props": {
                "content": "Basic Row",
                "style": "font-size: 16px; font-weight: 600;"
              }
            },
            {
              "id": "basic-row",
              "component": "Row",
              "props": {
                "align": "center",
                "gap": 10
              },
              "children": ["chip-1", "chip-2", "chip-3"]
            },
            {
              "id": "chip-1",
              "component": "text",
              "props": {
                "content": "Row 1",
                "style": "padding: 8px 14px; border-radius: 999px; font-size: 14px; font-weight: 600; background-color: var(--row-column-chip-background, var(--color-surface-highlight));"
              }
            },
            {
              "id": "chip-2",
              "component": "text",
              "props": {
                "content": "Row 2",
                "style": "padding: 8px 14px; border-radius: 999px; font-size: 14px; font-weight: 600; background-color: var(--row-column-chip-background, var(--color-surface-highlight));"
              }
            },
            {
              "id": "chip-3",
              "component": "text",
              "props": {
                "content": "Row 3",
                "style": "padding: 8px 14px; border-radius: 999px; font-size: 14px; font-weight: 600; background-color: var(--row-column-chip-background, var(--color-surface-highlight));"
              }
            },
            {
              "id": "section-basic-column",
              "component": "Column",
              "props": {
                "backgroundColor": "var(--row-column-section-background, var(--color-surface-highlight))",
                "padding": 16,
                "gap": 12,
                "borderRadius": 12
              },
              "children": ["title-basic-column", "basic-column"]
            },
            {
              "id": "title-basic-column",
              "component": "text",
              "props": {
                "content": "Basic Column",
                "style": "font-size: 16px; font-weight: 600;"
              }
            },
            {
              "id": "basic-column",
              "component": "Column",
              "props": {
                "gap": 10
              },
              "children": ["list-1", "list-2", "list-3"]
            },
            {
              "id": "list-1",
              "component": "text",
              "props": {
                "content": "Column item 1",
                "style": "padding: 14px 16px; border-radius: 10px; font-size: 14px; background-color: var(--row-column-chip-background, var(--color-surface-highlight));"
              }
            },
            {
              "id": "list-2",
              "component": "text",
              "props": {
                "content": "Column item 2",
                "style": "padding: 14px 16px; border-radius: 10px; font-size: 14px; background-color: var(--row-column-chip-background, var(--color-surface-highlight));"
              }
            },
            {
              "id": "list-3",
              "component": "text",
              "props": {
                "content": "Column item 3",
                "style": "padding: 14px 16px; border-radius: 10px; font-size: 14px; background-color: var(--row-column-chip-background, var(--color-surface-highlight));"
              }
            },
            {
              "id": "section-nested",
              "component": "Column",
              "props": {
                "backgroundColor": "var(--row-column-section-background, var(--color-surface-highlight))",
                "padding": 16,
                "gap": 12,
                "borderRadius": 12
              },
              "children": ["title-nested", "nested-card"]
            },
            {
              "id": "title-nested",
              "component": "text",
              "props": {
                "content": "Nested Row + Column",
                "style": "font-size: 16px; font-weight: 600;"
              }
            },
            {
              "id": "nested-card",
              "component": "Column",
              "props": {
                "backgroundColor": "var(--row-column-section-background, var(--color-surface-highlight))",
                "gap": 12,
                "padding": 14,
                "borderRadius": 10
              },
              "children": ["device-summary", "metrics-row"]
            },
            {
              "id": "device-summary",
              "component": "Row",
              "props": {
                "justify": "spaceBetween",
                "align": "center"
              },
              "children": ["device-info", "status-pill"]
            },
            {
              "id": "device-info",
              "component": "Column",
              "props": {
                "gap": 4
              },
              "children": ["device-label", "device-value"]
            },
            {
              "id": "device-label",
              "component": "text",
              "props": {
                "content": "Device",
                "style": "font-size: 12px;"
              }
            },
            {
              "id": "device-value",
              "component": "text",
              "props": {
                "content": "Ink Glasses",
                "style": "font-size: 16px; font-weight: 600;"
              }
            },
            {
              "id": "status-pill",
              "component": "text",
              "props": {
                "content": "Online",
                "style": "padding: 6px 12px; border-radius: 999px; font-size: 13px; font-weight: 600; background-color: var(--row-column-chip-background, var(--color-surface-highlight));"
              }
            },
            {
              "id": "metrics-row",
              "component": "Row",
              "props": {
                "justify": "spaceAround",
                "align": "stretch",
                "gap": 10
              },
              "children": ["metric-1", "metric-2", "metric-3"]
            },
            {
              "id": "metric-1",
              "component": "Column",
              "props": {
                "backgroundColor": "var(--row-column-metric-background, var(--color-surface-highlight))",
                "padding": 12,
                "gap": 4,
                "borderRadius": 8
              },
              "children": ["metric-1-value", "metric-1-label"]
            },
            {
              "id": "metric-1-value",
              "component": "text",
              "props": {
                "content": "92%",
                "style": "font-size: 18px; font-weight: 700;"
              }
            },
            {
              "id": "metric-1-label",
              "component": "text",
              "props": {
                "content": "Battery",
                "style": "font-size: 12px;"
              }
            },
            {
              "id": "metric-2",
              "component": "Column",
              "props": {
                "backgroundColor": "var(--row-column-metric-background, var(--color-surface-highlight))",
                "padding": 12,
                "gap": 4,
                "borderRadius": 8
              },
              "children": ["metric-2-value", "metric-2-label"]
            },
            {
              "id": "metric-2-value",
              "component": "text",
              "props": {
                "content": "18ms",
                "style": "font-size: 18px; font-weight: 700;"
              }
            },
            {
              "id": "metric-2-label",
              "component": "text",
              "props": {
                "content": "Latency",
                "style": "font-size: 12px;"
              }
            },
            {
              "id": "metric-3",
              "component": "Column",
              "props": {
                "backgroundColor": "var(--row-column-metric-background, var(--color-surface-highlight))",
                "padding": 12,
                "gap": 4,
                "borderRadius": 8
              },
              "children": ["metric-3-value", "metric-3-label"]
            },
            {
              "id": "metric-3-value",
              "component": "text",
              "props": {
                "content": "5",
                "style": "font-size: 18px; font-weight: 700;"
              }
            },
            {
              "id": "metric-3-label",
              "component": "text",
              "props": {
                "content": "Sensors",
                "style": "font-size: 12px;"
              }
            },
            {
              "id": "section-centered",
              "component": "Column",
              "props": {
                "backgroundColor": "var(--row-column-section-background, var(--color-surface-highlight))",
                "padding": 16,
                "gap": 12,
                "borderRadius": 12
              },
              "children": ["title-centered", "center-stage"]
            },
            {
              "id": "title-centered",
              "component": "text",
              "props": {
                "content": "Centered Composition",
                "style": "font-size: 16px; font-weight: 600;"
              }
            },
            {
              "id": "center-stage",
              "component": "Row",
              "props": {
                "backgroundColor": "var(--row-column-section-background, var(--color-surface-highlight))",
                "justify": "center",
                "align": "center",
                "height": 180,
                "padding": 12,
                "borderRadius": 10
              },
              "children": ["center-stack"]
            },
            {
              "id": "center-stack",
              "component": "Column",
              "props": {
                "justify": "center",
                "align": "center",
                "gap": 8
              },
              "children": ["center-avatar", "center-title", "center-subtitle"]
            },
            {
              "id": "center-avatar",
              "component": "text",
              "props": {
                "content": "AI",
                "style": "width: 72px; height: 72px; padding-top: 20px; text-align: center; border-radius: 36px; font-size: 24px; font-weight: bold; background-color: var(--row-column-chip-background, var(--color-surface-highlight));"
              }
            },
            {
              "id": "center-title",
              "component": "text",
              "props": {
                "content": "Assistant",
                "style": "font-size: 18px; font-weight: 600;"
              }
            },
            {
              "id": "center-subtitle",
              "component": "text",
              "props": {
                "content": "Aligned by A2UI Row/Column props",
                "style": "font-size: 13px;"
              }
            }
          ]
        }
      ]`,
    },
  };
</script>

<page>
  <view class="container">
    <a2ui
      id="row-column-demo"
      commands="{{ a2uiData }}"
      style="display: flex; flex-direction: column; width: 100%; height: 100%;"
    />
  </view>
</page>

<style>
  .container {
    display: flex;
    flex-direction: column;
    box-sizing: border-box;
    width: 100%;
  }
</style>
