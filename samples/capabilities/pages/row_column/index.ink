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
                "section-centered",
                "section-info-panel",
                "section-settings",
                "section-media",
                "section-dual-column"
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
                "style": "padding: 8px 14px; border-radius: 999px; font-size: 14px; font-weight: 600;"
              }
            },
            {
              "id": "chip-2",
              "component": "text",
              "props": {
                "content": "Row 2",
                "style": "padding: 8px 14px; border-radius: 999px; font-size: 14px; font-weight: 600;"
              }
            },
            {
              "id": "chip-3",
              "component": "text",
              "props": {
                "content": "Row 3",
                "style": "padding: 8px 14px; border-radius: 999px; font-size: 14px; font-weight: 600;"
              }
            },
            {
              "id": "section-basic-column",
              "component": "Column",
              "props": {
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
                "style": "padding: 14px 16px; border-radius: var(--radius-md, 10px); font-size: 14px;"
              }
            },
            {
              "id": "list-2",
              "component": "text",
              "props": {
                "content": "Column item 2",
                "style": "padding: 14px 16px; border-radius: var(--radius-md, 10px); font-size: 14px;"
              }
            },
            {
              "id": "list-3",
              "component": "text",
              "props": {
                "content": "Column item 3",
                "style": "padding: 14px 16px; border-radius: var(--radius-md, 10px); font-size: 14px;"
              }
            },
            {
              "id": "section-nested",
              "component": "Column",
              "props": {
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
                "style": "padding: 6px 12px; border-radius: 999px; font-size: 13px; font-weight: 600;"
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
                "style": "width: 72px; height: 72px; padding-top: 20px; text-align: center; border-radius: 36px; font-size: 24px; font-weight: bold;"
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
            },
            {
              "id": "section-info-panel",
              "component": "Column",
              "props": {
                "padding": 16,
                "gap": 12,
                "borderRadius": 12
              },
              "children": ["title-info-panel", "info-panel"]
            },
            {
              "id": "title-info-panel",
              "component": "text",
              "props": {
                "content": "Information Panel",
                "style": "font-size: 16px; font-weight: 600;"
              }
            },
            {
              "id": "info-panel",
              "component": "Column",
              "props": {
                "padding": 14,
                "gap": 12,
                "borderRadius": 10
              },
              "children": ["info-header", "info-body"]
            },
            {
              "id": "info-header",
              "component": "Row",
              "props": {
                "justify": "spaceBetween",
                "align": "center",
                "gap": 12
              },
              "children": ["info-title-group", "info-badge"]
            },
            {
              "id": "info-title-group",
              "component": "Column",
              "props": {
                "gap": 4
              },
              "children": ["info-title", "info-subtitle"]
            },
            {
              "id": "info-title",
              "component": "text",
              "props": {
                "content": "Playback Session",
                "style": "font-size: 17px; font-weight: 700;"
              }
            },
            {
              "id": "info-subtitle",
              "component": "text",
              "props": {
                "content": "Header row + stacked detail content",
                "style": "font-size: 13px;"
              }
            },
            {
              "id": "info-badge",
              "component": "text",
              "props": {
                "content": "Active",
                "style": "padding: 6px 12px; border-radius: 999px; font-size: 13px; font-weight: 600;"
              }
            },
            {
              "id": "info-body",
              "component": "Row",
              "props": {
                "gap": 12,
                "align": "stretch"
              },
              "children": ["info-body-left", "info-body-right"]
            },
            {
              "id": "info-body-left",
              "component": "Column",
              "props": {
                "gap": 6,
                "padding": 12,
                "borderRadius": 8
              },
              "children": ["info-left-title", "info-left-desc"]
            },
            {
              "id": "info-left-title",
              "component": "text",
              "props": {
                "content": "Now Playing",
                "style": "font-size: 14px; font-weight: 600;"
              }
            },
            {
              "id": "info-left-desc",
              "component": "text",
              "props": {
                "content": "A column can hold primary details and helper copy.",
                "style": "font-size: 12px;"
              }
            },
            {
              "id": "info-body-right",
              "component": "Column",
              "props": {
                "gap": 6,
                "padding": 12,
                "borderRadius": 8
              },
              "children": ["info-right-title", "info-right-desc"]
            },
            {
              "id": "info-right-title",
              "component": "text",
              "props": {
                "content": "Session Stats",
                "style": "font-size: 14px; font-weight: 600;"
              }
            },
            {
              "id": "info-right-desc",
              "component": "text",
              "props": {
                "content": "Use a row to split secondary blocks evenly.",
                "style": "font-size: 12px;"
              }
            },
            {
              "id": "section-settings",
              "component": "Column",
              "props": {
                "padding": 16,
                "gap": 12,
                "borderRadius": 12
              },
              "children": ["title-settings", "settings-list"]
            },
            {
              "id": "title-settings",
              "component": "text",
              "props": {
                "content": "Settings Rows",
                "style": "font-size: 16px; font-weight: 600;"
              }
            },
            {
              "id": "settings-list",
              "component": "Column",
              "props": {
                "gap": 10
              },
              "children": ["setting-row-1", "setting-row-2", "setting-row-3"]
            },
            {
              "id": "setting-row-1",
              "component": "Row",
              "props": {
                "justify": "spaceBetween",
                "align": "center",
                "gap": 12,
                "padding": 12,
                "borderRadius": 10
              },
              "children": ["setting-label-1", "setting-value-1"]
            },
            {
              "id": "setting-label-1",
              "component": "Column",
              "props": {
                "gap": 2
              },
              "children": ["setting-title-1", "setting-desc-1"]
            },
            {
              "id": "setting-title-1",
              "component": "text",
              "props": {
                "content": "Notifications",
                "style": "font-size: 14px; font-weight: 600;"
              }
            },
            {
              "id": "setting-desc-1",
              "component": "text",
              "props": {
                "content": "Left column for label and helper text",
                "style": "font-size: 12px;"
              }
            },
            {
              "id": "setting-value-1",
              "component": "text",
              "props": {
                "content": "Enabled",
                "style": "font-size: 13px; font-weight: 600;"
              }
            },
            {
              "id": "setting-row-2",
              "component": "Row",
              "props": {
                "justify": "spaceBetween",
                "align": "center",
                "gap": 12,
                "padding": 12,
                "borderRadius": 10
              },
              "children": ["setting-label-2", "setting-value-2"]
            },
            {
              "id": "setting-label-2",
              "component": "Column",
              "props": {
                "gap": 2
              },
              "children": ["setting-title-2", "setting-desc-2"]
            },
            {
              "id": "setting-title-2",
              "component": "text",
              "props": {
                "content": "Layout Density",
                "style": "font-size: 14px; font-weight: 600;"
              }
            },
            {
              "id": "setting-desc-2",
              "component": "text",
              "props": {
                "content": "A row aligns content with trailing values",
                "style": "font-size: 12px;"
              }
            },
            {
              "id": "setting-value-2",
              "component": "text",
              "props": {
                "content": "Compact",
                "style": "font-size: 13px; font-weight: 600;"
              }
            },
            {
              "id": "setting-row-3",
              "component": "Row",
              "props": {
                "justify": "spaceBetween",
                "align": "center",
                "gap": 12,
                "padding": 12,
                "borderRadius": 10
              },
              "children": ["setting-label-3", "setting-value-3"]
            },
            {
              "id": "setting-label-3",
              "component": "Column",
              "props": {
                "gap": 2
              },
              "children": ["setting-title-3", "setting-desc-3"]
            },
            {
              "id": "setting-title-3",
              "component": "text",
              "props": {
                "content": "Download Mode",
                "style": "font-size: 14px; font-weight: 600;"
              }
            },
            {
              "id": "setting-desc-3",
              "component": "text",
              "props": {
                "content": "Nested columns keep label groups organized",
                "style": "font-size: 12px;"
              }
            },
            {
              "id": "setting-value-3",
              "component": "text",
              "props": {
                "content": "Wi-Fi Only",
                "style": "font-size: 13px; font-weight: 600;"
              }
            },
            {
              "id": "section-media",
              "component": "Column",
              "props": {
                "padding": 16,
                "gap": 12,
                "borderRadius": 12
              },
              "children": ["title-media", "media-card"]
            },
            {
              "id": "title-media",
              "component": "text",
              "props": {
                "content": "Media Summary",
                "style": "font-size: 16px; font-weight: 600;"
              }
            },
            {
              "id": "media-card",
              "component": "Row",
              "props": {
                "gap": 12,
                "align": "center",
                "padding": 14,
                "borderRadius": 10
              },
              "children": ["media-thumb", "media-content"]
            },
            {
              "id": "media-thumb",
              "component": "text",
              "props": {
                "content": "Cover",
                "style": "width: 80px; height: 80px; padding-top: 28px; text-align: center; border-radius: 12px; font-size: 12px; font-weight: 600;"
              }
            },
            {
              "id": "media-content",
              "component": "Column",
              "props": {
                "gap": 6
              },
              "children": ["media-title", "media-desc", "media-meta"]
            },
            {
              "id": "media-title",
              "component": "text",
              "props": {
                "content": "Thumbnail + Text Stack",
                "style": "font-size: 16px; font-weight: 700;"
              }
            },
            {
              "id": "media-desc",
              "component": "text",
              "props": {
                "content": "A row can pair a fixed media area with a flexible column of text.",
                "style": "font-size: 12px;"
              }
            },
            {
              "id": "media-meta",
              "component": "Row",
              "props": {
                "gap": 10,
                "align": "center"
              },
              "children": ["media-meta-1", "media-meta-2", "media-meta-3"]
            },
            {
              "id": "media-meta-1",
              "component": "text",
              "props": {
                "content": "12 min",
                "style": "font-size: 12px; font-weight: 600;"
              }
            },
            {
              "id": "media-meta-2",
              "component": "text",
              "props": {
                "content": "Stereo",
                "style": "font-size: 12px; font-weight: 600;"
              }
            },
            {
              "id": "media-meta-3",
              "component": "text",
              "props": {
                "content": "Saved",
                "style": "font-size: 12px; font-weight: 600;"
              }
            },
            {
              "id": "section-dual-column",
              "component": "Column",
              "props": {
                "padding": 16,
                "gap": 12,
                "borderRadius": 12
              },
              "children": ["title-dual-column", "dual-columns"]
            },
            {
              "id": "title-dual-column",
              "component": "text",
              "props": {
                "content": "Dual Column Content",
                "style": "font-size: 16px; font-weight: 600;"
              }
            },
            {
              "id": "dual-columns",
              "component": "Row",
              "props": {
                "gap": 12,
                "align": "stretch"
              },
              "children": ["dual-left", "dual-right"]
            },
            {
              "id": "dual-left",
              "component": "Column",
              "props": {
                "gap": 8,
                "padding": 12,
                "borderRadius": 10
              },
              "children": ["dual-left-title", "dual-left-item-1", "dual-left-item-2"]
            },
            {
              "id": "dual-left-title",
              "component": "text",
              "props": {
                "content": "Left Column",
                "style": "font-size: 14px; font-weight: 700;"
              }
            },
            {
              "id": "dual-left-item-1",
              "component": "text",
              "props": {
                "content": "Top aligned content"
              }
            },
            {
              "id": "dual-left-item-2",
              "component": "text",
              "props": {
                "content": "Nested vertical stack"
              }
            },
            {
              "id": "dual-right",
              "component": "Column",
              "props": {
                "gap": 8,
                "padding": 12,
                "borderRadius": 10
              },
              "children": ["dual-right-title", "dual-right-item-1", "dual-right-item-2"]
            },
            {
              "id": "dual-right-title",
              "component": "text",
              "props": {
                "content": "Right Column",
                "style": "font-size: 14px; font-weight: 700;"
              }
            },
            {
              "id": "dual-right-item-1",
              "component": "text",
              "props": {
                "content": "Independent spacing"
              }
            },
            {
              "id": "dual-right-item-2",
              "component": "text",
              "props": {
                "content": "Same row, different content"
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
