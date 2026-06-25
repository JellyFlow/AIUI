<script type="application/json" def>
  {
    "schema": {
      "data": {
        "a2uiData": "string",
        "lastMessageStatus": "string"
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
        "surfaceId": "surface-1",
        "containerId": "root"
      },
      {
        "version": "v0.9",
        "updateDataModel": {
          "surfaceId": "surface-1",
          "path": "/",
          "value": {
            "profile": {
              "name": "Alex Chen",
              "role": "Senior Software Engineer",
              "email": "alex.chen@example.com",
              "phone": "+1 (555) 123-4567",
              "location": {
                "city": "San Francisco",
                "state": "CA"
              }
            }
          }
        }
      },
      {
        "type": "updateComponents",
        "surfaceId": "surface-1",
        "components": [
          {
            "id": "root",
            "type": "view",
            "props": {
              "style": "display: flex; flex-direction: column; align-items: center; justify-content: center; width: 100%; background-color: var(--a2ui-page-background, var(--color-background));"
            },
            "children": ["card"]
          },
          {
            "id": "card",
            "type": "view",
            "props": {
              "style": "display: flex; flex-direction: column; width: 320px; background-color: var(--a2ui-card-background, var(--color-surface)); border-radius: 16px; padding: 24px; box-shadow: 0 8px 24px rgba(0,0,0,0.1);"
            },
            "children": ["header", "divider", "info-list"]
          },
          {
            "id": "header",
            "type": "view",
            "props": {
              "style": "display: flex; flex-direction: row; align-items: center; margin-bottom: var(--spacing-lg, 20px);"
            },
            "children": ["avatar", "title-group"]
          },
          {
            "id": "avatar",
            "type": "image",
            "props": {
              "src": "https://avatars.githubusercontent.com/u/14985020?v=4",
              "style": "width: 64px; height: 64px; border-radius: 32px; background-color: var(--a2ui-avatar-background, var(--color-surface-highlight)); margin-right: 16px;"
            }
          },
          {
            "id": "title-group",
            "type": "view",
            "props": {
              "style": "display: flex; flex-direction: column; justify-content: center;"
            },
            "children": ["name", "role"]
          },
          {
            "id": "name",
            "type": "text",
            "props": {
              "content": "{{ profile.name }}",
              "style": "font-size: 22px; font-weight: bold; color: var(--a2ui-heading-color, var(--color-text-primary)); margin-bottom: 4px;"
            }
          },
          {
            "id": "role",
            "type": "text",
            "props": {
              "content": "{{ profile.role }}",
              "style": "font-size: 14px; color: var(--a2ui-muted-text-color, var(--color-text-secondary));"
            }
          },
          {
            "id": "divider",
            "type": "view",
            "props": {
              "style": "width: 100%; height: 1px; background-color: var(--a2ui-divider-color, var(--border-color-default)); margin-bottom: var(--spacing-lg, 20px);"
            }
          },
          {
            "id": "info-list",
            "type": "view",
            "props": {
              "style": "display: flex; flex-direction: column;"
            },
            "children": ["info-email", "info-phone", "info-location"]
          },
          {
            "id": "info-email",
            "type": "view",
            "props": {
              "style": "display: flex; flex-direction: row; align-items: center; margin-bottom: var(--spacing-md, 12px);"
            },
            "children": ["icon-email", "text-email"]
          },
          {
            "id": "icon-email",
            "type": "text",
            "props": {
              "content": "✉️",
              "style": "font-size: 16px; margin-right: 12px;"
            }
          },
          {
            "id": "text-email",
            "type": "text",
            "props": {
              "content": "{{ profile.email }}",
              "style": "font-size: 14px; color: var(--a2ui-text-color, var(--color-text-primary));"
            }
          },
          {
            "id": "info-phone",
            "type": "view",
            "props": {
              "style": "display: flex; flex-direction: row; align-items: center; margin-bottom: var(--spacing-md, 12px);"
            },
            "children": ["icon-phone", "text-phone"]
          },
          {
            "id": "icon-phone",
            "type": "text",
            "props": {
              "content": "📱",
              "style": "font-size: 16px; margin-right: 12px;"
            }
          },
          {
            "id": "text-phone",
            "type": "text",
            "props": {
              "content": "{{ profile.phone }}",
              "style": "font-size: 14px; color: var(--a2ui-text-color, var(--color-text-primary));"
            }
          },
          {
            "id": "info-location",
            "type": "view",
            "props": {
              "style": "display: flex; flex-direction: row; align-items: center;"
            },
            "children": ["icon-location", "text-location"]
          },
          {
            "id": "icon-location",
            "type": "text",
            "props": {
              "content": "📍",
              "style": "font-size: 16px; margin-right: 12px;"
            }
          },
          {
            "id": "text-location",
            "type": "text",
            "props": {
              "content": "{{ profile.location.city }}, {{ profile.location.state }}",
              "style": "font-size: 14px; color: var(--a2ui-text-color, var(--color-text-primary));"
            }
          }
        ]
      }
    ]`,
      lastMessageStatus: 'Waiting for host message...',
    },

    onLoad() {
      console.log('A2UI test page loaded');
    },

    onMessage(event) {
      const payload = event.data;
      const a2uiCtx = a2ui.createA2UIContext('my-a2ui');
      if (!a2uiCtx) {
        console.error('A2UI context not found');
        this.setData({
          lastMessageStatus: 'Host message ignored: A2UI context not found',
        });
        return;
      }

      let payloadText = null;
      let appliedCommandCount = null;
      if (Array.isArray(payload)) {
        payloadText = JSON.stringify(payload, null, 2);
        appliedCommandCount = payload.length;
      } else if (
        payload &&
        payload.type === 'a2ui.commands' &&
        Array.isArray(payload.commands)
      ) {
        payloadText = JSON.stringify(payload.commands, null, 2);
        appliedCommandCount = payload.commands.length;
      } else if (
        payload &&
        payload.version === 'v0.9' &&
        payload.updateDataModel
      ) {
        payloadText = JSON.stringify(payload, null, 2);
        appliedCommandCount = 1;
      } else if (
        payload &&
        typeof payload.type === 'string' &&
        payload.type !== 'updateDataModel'
      ) {
        payloadText = JSON.stringify(payload, null, 2);
        appliedCommandCount = 1;
      }

      if (!payloadText) {
        console.warn('Unsupported host message payload:', payload);
        this.setData({
          lastMessageStatus: 'Host message received, but payload is unsupported',
        });
        return;
      }

      a2uiCtx.write(payloadText);
      this.setData({
        lastMessageStatus: `Applied ${appliedCommandCount} command(s) from ${event.origin || 'host'}`,
      });
    },

    updateA2ui() {
      console.log('Updating A2UI data');
      const a2uiCtx = a2ui.createA2UIContext('my-a2ui');
      if (!a2uiCtx) {
        console.error('A2UI context not found');
        return;
      }

      const json = [
        {
          type: "updateComponents",
          surfaceId: "surface-1",
          components: [
            {
              id: "name",
              type: "text",
              props: {
                content: "Alex Chen (Updated Full Write)",
                style:
                  "font-size: 22px; font-weight: bold; color: var(--a2ui-danger-color, var(--border-color-danger, #ff3b30)); margin-bottom: 4px;",
              },
            },
          ],
        },
      ];
      a2uiCtx.write(JSON.stringify(json, null, 2));
    },

    streamUpdateA2ui() {
      console.log('Stream updating A2UI data via API...');
      const ctx = a2ui.createA2UIContext('my-a2ui');
      if (!ctx) {
        console.error('Failed to get A2UI context');
        return;
      }

      const stream = ctx.startStream();
      const fullJson = `[
      {
        "type": "updateComponents",
        "surfaceId": "surface-1",
        "components": [
          {
            "id": "role",
            "type": "text",
            "props": {
              "content": "Staff Software Engineer (Streamed)",
              "style": "font-size: 14px; color: var(--a2ui-success-color, var(--border-color-success, #34c759)); font-style: italic;"
            }
          },
          {
            "id": "text-location",
            "type": "text",
            "props": {
              "content": "New York, NY (Streamed)",
              "style": "font-size: 14px; color: var(--a2ui-text-color, var(--color-text-primary)); font-weight: 500;"
            }
          }
        ]
      }
    ]`;

      // Simulate network chunks (e.g. 100 bytes per chunk)
      const chunkSize = 50;
      let offset = 0;

      const sendNextChunk = () => {
        console.info('send next chunk', offset);
        if (offset < fullJson.length) {
          const chunk = fullJson.slice(offset, offset + chunkSize);
          stream.writeChunk(chunk);
          offset += chunkSize;
          // Schedule next chunk with a slight delay to visualize streaming
          sendNextChunk();
        } else {
          console.log('Stream finished.');
          stream.close();
        }
      };

      sendNextChunk();
    },
  };
</script>

<page>
  <view class="container">
    <view class="page-title">A2UI Test</view>
    <view class="a2ui-container">
      <a2ui
        id="my-a2ui"
        commands="{{ a2uiData }}"
        style="display: flex; flex-direction: column; width: 100%;"
      />
    </view>
    <card class="action-card">
      <view class="action-title">Actions</view>
      <view class="button-stack" role="navigation">
        <button class="btn" bindtap="updateA2ui">Full Write Update</button>
        <button class="btn stream-btn" bindtap="streamUpdateA2ui">
          Stream Update
        </button>
      </view>
    </card>
    <view class="message-status">{{ lastMessageStatus }}</view>
  </view>
</page>

<style>
  .container {
    --a2ui-page-background: var(--color-background);
    --a2ui-card-background: var(--color-surface);
    --a2ui-surface-background: var(--color-surface);
    --a2ui-surface-highlight-background: var(--color-surface-highlight);
    --a2ui-heading-color: var(--color-text-primary);
    --a2ui-text-color: var(--color-text-primary);
    --a2ui-muted-text-color: var(--color-text-secondary);
    --a2ui-divider-color: var(--border-color-default);
    --a2ui-danger-color: var(--border-color-danger, #ff3b30);
    --a2ui-success-color: var(--border-color-success, #34c759);
    display: flex;
    flex-direction: column;
    width: 100%;
    background-color: var(--a2ui-page-background);
    padding: var(--spacing-lg, 20px);
    box-sizing: border-box;
  }

  .page-title,
  .title {
    font-size: 28px;
    font-weight: bold;
    color: var(--a2ui-heading-color);
    margin-bottom: var(--spacing-lg, 20px);
    text-align: center;
  }

  .a2ui-container {
    width: 100%;
    min-height: 320px;
    border: var(--border-width-thin, 1px) solid var(--border-color-default, #e5e5e5);
    border-radius: var(--radius-sm, 8px);
    box-sizing: border-box;
    background-color: var(--a2ui-surface-background);
    margin-bottom: var(--spacing-lg, 20px);
    overflow: hidden;
  }

  .action-card {
    flex-direction: column;
    margin-bottom: var(--spacing-lg, 20px);
  }

  .action-title {
    font-size: 16px;
    font-weight: bold;
    color: var(--a2ui-heading-color);
    margin-bottom: var(--spacing-md, 12px);
  }

  .button-stack {
    display: flex;
    flex-direction: column;
  }

  .btn {
    width: 100%;
    height: 44px;
    font-size: 16px;
    font-weight: bold;
    display: flex;
    justify-content: center;
    align-items: center;
    margin-bottom: var(--spacing-sm, 10px);
  }

  .message-status {
    font-size: 13px;
    color: var(--a2ui-muted-text-color);
    text-align: center;
    margin-top: 4px;
  }
</style>
