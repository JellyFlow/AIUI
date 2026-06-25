<script type="application/json" def>
{
  "navigationBarTitleText": "Conditional Rendering"
}
</script>

<script setup>
function createListItems() {
  return [
    { id: 1, title: 'Draft fixture page', done: true, hidden: false, flagged: false },
    { id: 2, title: 'Add nested states', done: false, hidden: false, flagged: true },
    { id: 3, title: 'Verify branch replacement', done: false, hidden: true, flagged: false },
  ];
}

function createPanelItems() {
  return [
    {
      id: 1,
      title: 'Overview card',
      description: 'Shared status summary for the current dataset.',
      active: true,
      expanded: false,
    },
    {
      id: 2,
      title: 'Alert feed',
      description: 'Visible when the tester wants to inspect detail rows.',
      active: false,
      expanded: false,
    },
    {
      id: 3,
      title: 'Metrics block',
      description: 'Good for checking selected and expanded combinations.',
      active: true,
      expanded: true,
    },
  ];
}

function cloneItems(items) {
  return items.map((item) => ({ ...item }));
}

function nextId(items) {
  return items.reduce((maxId, item) => Math.max(maxId, item.id), 0) + 1;
}

function countVisiblePanelItems(items, showOnlyActive) {
  if (!showOnlyActive) {
    return items.length;
  }

  return items.filter((item) => item.active).length;
}

export default {
  data: {
    basicVisible: true,
    elifLoading: true,
    elifErrorMessage: '',
    statusCase: 'loading',
    listItems: createListItems(),
    sessionState: 'signed_out',
    profileState: 'loading',
    panelState: 'loading',
    panelItems: createPanelItems(),
    panelVisibleCount: countVisiblePanelItems(createPanelItems(), false),
    selectedItemId: 1,
    showOnlyActive: false,
  },

  resetAll() {
    this.setData({
      basicVisible: true,
      elifLoading: true,
      elifErrorMessage: '',
      statusCase: 'loading',
      listItems: createListItems(),
      sessionState: 'signed_out',
      profileState: 'loading',
      panelState: 'loading',
      panelItems: createPanelItems(),
      panelVisibleCount: countVisiblePanelItems(createPanelItems(), false),
      selectedItemId: 1,
      showOnlyActive: false,
    });
  },

  toggleBasic() {
    this.setData({
      basicVisible: !this.data.basicVisible,
    });
  },

  setElifScenario(e) {
    const scenario = e.currentTarget.attributes['data-scenario'];
    if (!scenario) {
      return;
    }

    if (scenario === 'loading') {
      this.setData({
        elifLoading: true,
        elifErrorMessage: '',
      });
      return;
    }

    if (scenario === 'error') {
      this.setData({
        elifLoading: false,
        elifErrorMessage: 'Network request failed',
      });
      return;
    }

    if (scenario === 'success') {
      this.setData({
        elifLoading: false,
        elifErrorMessage: '',
      });
      return;
    }

    this.setData({
      elifLoading: '',
      elifErrorMessage: '',
    });
  },

  setStatusCase(e) {
    const nextCase = e.currentTarget.attributes['data-case'];
    if (!nextCase) {
      return;
    }

    this.setData({
      statusCase: nextCase,
    });
  },

  toggleListItemDone(e) {
    const itemId = Number(e.currentTarget.attributes['data-id']);
    const listItems = this.data.listItems.map((item) =>
      item.id === itemId
        ? {
            ...item,
            done: !item.done,
          }
        : item
    );

    this.setData({ listItems });
  },

  toggleListItemHidden(e) {
    const itemId = Number(e.currentTarget.attributes['data-id']);
    const listItems = this.data.listItems.map((item) =>
      item.id === itemId
        ? {
            ...item,
            hidden: !item.hidden,
          }
        : item
    );

    this.setData({ listItems });
  },

  addListItem() {
    const listItems = cloneItems(this.data.listItems);
    const id = nextId(listItems);
    listItems.unshift({
      id,
      title: `Inserted item ${id}`,
      done: false,
      hidden: false,
      flagged: id % 2 === 0,
    });

    this.setData({ listItems });
  },

  removeLastListItem() {
    if (!this.data.listItems.length) {
      return;
    }

    this.setData({
      listItems: this.data.listItems.slice(0, -1),
    });
  },

  setSessionState(e) {
    const nextState = e.currentTarget.attributes['data-state'];
    if (!nextState) {
      return;
    }

    this.setData({
      sessionState: nextState,
    });
  },

  setProfileState(e) {
    const nextState = e.currentTarget.attributes['data-state'];
    if (!nextState) {
      return;
    }

    this.setData({
      profileState: nextState,
    });
  },

  setPanelState(e) {
    const nextState = e.currentTarget.attributes['data-state'];
    if (!nextState) {
      return;
    }

    this.setData({
      panelState: nextState,
    });
  },

  toggleShowOnlyActive() {
    const showOnlyActive = !this.data.showOnlyActive;
    this.setData({
      showOnlyActive,
      panelVisibleCount: countVisiblePanelItems(this.data.panelItems, showOnlyActive),
    });
  },

  selectPanelItem(e) {
    const itemId = Number(e.currentTarget.attributes['data-id']);
    if (!itemId) {
      return;
    }

    this.setData({
      selectedItemId: itemId,
    });
  },

  togglePanelItemExpanded(e) {
    const itemId = Number(e.currentTarget.attributes['data-id']);
    const panelItems = this.data.panelItems.map((item) =>
      item.id === itemId
        ? {
            ...item,
            expanded: !item.expanded,
          }
        : item
    );

    this.setData({
      panelItems,
      panelVisibleCount: countVisiblePanelItems(panelItems, this.data.showOnlyActive),
    });
  },

  togglePanelItemActive(e) {
    const itemId = Number(e.currentTarget.attributes['data-id']);
    const panelItems = this.data.panelItems.map((item) =>
      item.id === itemId
        ? {
            ...item,
            active: !item.active,
          }
        : item
    );

    this.setData({
      panelItems,
      panelVisibleCount: countVisiblePanelItems(panelItems, this.data.showOnlyActive),
    });
  },
};
</script>

<page>
  <view class="container">
    <view class="hero">
      <view class="page-title">Conditional Rendering</view>
      <text class="page-description">
        Interactive coverage for boolean branches, multi-state views, list item conditions,
        nested branches, and realistic combined cases.
      </text>
      <view class="button-row">
        <button class="btn btn-primary" bindtap="resetAll">Reset All</button>
      </view>
    </view>

    <view class="card section">
      <view class="section-header">
        <text class="section-title">Basic Boolean Branch</text>
        <text class="section-meta">basicVisible = {{basicVisible}}</text>
      </view>
      <text class="section-note">
        The simplest ink:if and ink:else pair. Toggle it repeatedly to verify clean branch
        replacement.
      </text>
      <view class="button-row">
        <button class="btn" bindtap="toggleBasic">Toggle Branch</button>
      </view>
      <view class="state-block success-block" ink:if="{{basicVisible}}">
        <text class="state-title">Visible branch</text>
        <text class="state-copy">This block exists only when basicVisible is true.</text>
      </view>
      <view class="state-block muted-block" ink:else>
        <text class="state-title">Fallback branch</text>
        <text class="state-copy">This block replaces the visible branch when the flag flips.</text>
      </view>
    </view>

    <view class="card section">
      <view class="section-header">
        <text class="section-title">Elif Boolean Expression</text>
        <text class="section-meta">
          loading = {{elifLoading}} / error = {{elifErrorMessage || 'none'}}
        </text>
      </view>
      <text class="section-note">
        This card explicitly covers ink:elif="" with a final else
        fallback branch.
      </text>
      <view class="button-row">
        <button class="btn" bindtap="setElifScenario" data-scenario="loading">Loading</button>
        <button class="btn" bindtap="setElifScenario" data-scenario="error">Error</button>
        <button class="btn" bindtap="setElifScenario" data-scenario="success">Success</button>
        <button class="btn" bindtap="setElifScenario" data-scenario="fallback">Fallback</button>
      </view>
      <view ink:if="{{elifLoading}}" class="state-block warning-block">
        <text class="state-title">If branch</text>
        <text class="state-copy">Loading is truthy, so the first branch wins.</text>
      </view>
      <view ink:elif="{{ !elifLoading && !elifErrorMessage }}" class="state-block success-block">
        <text class="state-title">Elif branch</text>
        <text class="state-copy">
          This is the target case: loading is falsy and errorMessage is empty.
        </text>
      </view>
      <view ink:else class="state-block danger-block">
        <text class="state-title">Else branch</text>
        <text class="state-copy">
          Reached when loading is falsy but errorMessage is still truthy, or when the if and elif
          conditions both fail.
        </text>
      </view>
    </view>

    <view class="card section">
      <view class="section-header">
        <text class="section-title">Multi-State Branch</text>
        <text class="section-meta">statusCase = {{statusCase}}</text>
      </view>
      <text class="section-note">
        Switch between loading, empty, error, and success to verify mutually exclusive branches.
      </text>
      <view class="button-row">
        <button class="btn" bindtap="setStatusCase" data-case="loading">Loading</button>
        <button class="btn" bindtap="setStatusCase" data-case="empty">Empty</button>
        <button class="btn" bindtap="setStatusCase" data-case="error">Error</button>
        <button class="btn" bindtap="setStatusCase" data-case="success">Success</button>
      </view>
      <view ink:if="{{statusCase === 'loading'}}" class="state-block warning-block">
        <text class="state-title">Loading branch</text>
        <text class="state-copy">Waiting for data and rendering a compact progress placeholder.</text>
      </view>
      <view ink:else>
        <view ink:if="{{statusCase === 'empty'}}" class="state-block muted-block">
          <text class="state-title">Empty branch</text>
          <text class="state-copy">No results are available for the current state.</text>
        </view>
        <view ink:else>
          <view ink:if="{{statusCase === 'error'}}" class="state-block danger-block">
            <text class="state-title">Error branch</text>
            <text class="state-copy">A request-level failure replaces the other states.</text>
          </view>
          <view ink:else class="state-block success-block">
            <text class="state-title">Success branch</text>
            <view class="success-list">
              <text class="success-item">Branch one: summary card</text>
              <text class="success-item">Branch two: content row</text>
              <text class="success-item">Branch three: confirmation footer</text>
            </view>
          </view>
        </view>
      </view>
    </view>

    <view class="card section">
      <view class="section-header">
        <text class="section-title">List Item Conditions</text>
        <text class="section-meta">items = {{listItems.length}}</text>
      </view>
      <text class="section-note">
        Each row uses ink:for with nested conditions so insertion, removal, and toggles update
        only the affected branch.
      </text>
      <view class="button-row">
        <button class="btn" bindtap="addListItem">Insert Item</button>
        <button class="btn" bindtap="removeLastListItem">Remove Last</button>
      </view>
      <view class="list-stack">
        <view class="list-item" ink:for="{{listItems}}" ink:key="id">
          <view class="list-item-header">
            <text class="list-item-title">#{{item.id}} {{item.title}}</text>
            <text class="list-item-meta">flagged = {{item.flagged}}</text>
          </view>
          <view ink:if="{{item.hidden}}" class="inline-branch muted-branch">
            <text class="branch-title">Hidden branch</text>
            <text class="branch-copy">This row still exists, but its content switches to hidden.</text>
          </view>
          <view ink:else>
            <view ink:if="{{item.done}}" class="inline-branch success-branch">
              <text class="branch-title">Done branch</text>
              <text class="branch-copy">
                Completed items render a different branch from active items.
              </text>
            </view>
            <view ink:else class="inline-branch warning-branch">
              <text class="branch-title">Active branch</text>
              <text class="branch-copy">
                Pending items stay visible until the tester marks them done or hidden.
              </text>
            </view>
          </view>
          <view class="button-row">
            <button class="btn btn-small" bindtap="toggleListItemDone" data-id="{{item.id}}">
              Toggle Done
            </button>
            <button class="btn btn-small" bindtap="toggleListItemHidden" data-id="{{item.id}}">
              Toggle Hidden
            </button>
          </view>
        </view>
      </view>
    </view>

    <view class="card section">
      <view class="section-header">
        <text class="section-title">Nested Conditions</text>
        <text class="section-meta">
          {{sessionState}} / {{profileState}}
        </text>
      </view>
      <text class="section-note">
        The outer branch controls whether a session exists. The inner branch changes the signed-in
        content between loading, empty, and ready states.
      </text>
      <view class="button-row">
        <button class="btn" bindtap="setSessionState" data-state="signed_out">Signed Out</button>
        <button class="btn" bindtap="setSessionState" data-state="signed_in">Signed In</button>
      </view>
      <view class="button-row">
        <button
          class="btn btn-small"
          bindtap="setProfileState"
          data-state="loading"
          disabled="{{sessionState !== 'signed_in'}}"
        >
          Profile Loading
        </button>
        <button
          class="btn btn-small"
          bindtap="setProfileState"
          data-state="empty"
          disabled="{{sessionState !== 'signed_in'}}"
        >
          Profile Empty
        </button>
        <button
          class="btn btn-small"
          bindtap="setProfileState"
          data-state="ready"
          disabled="{{sessionState !== 'signed_in'}}"
        >
          Profile Ready
        </button>
      </view>
      <view ink:if="{{sessionState === 'signed_in'}}" class="nested-panel">
        <text class="state-title">Signed-in branch</text>
        <view ink:if="{{profileState === 'loading'}}" class="inline-branch warning-branch">
          <text class="branch-copy">Loading profile data for the active session.</text>
        </view>
        <view ink:else>
          <view ink:if="{{profileState === 'empty'}}" class="inline-branch muted-branch">
            <text class="branch-copy">Session exists, but no profile details are available yet.</text>
          </view>
          <view ink:else class="inline-branch success-branch">
            <text class="branch-copy">Profile ready: Yorkie, Maintainer, Notifications enabled.</text>
          </view>
        </view>
      </view>
      <view ink:else class="state-block muted-block">
        <text class="state-title">Signed-out branch</text>
        <text class="state-copy">Nested signed-in content should disappear completely here.</text>
      </view>
    </view>

    <view class="card section">
      <view class="section-header">
        <text class="section-title">Combined Real-World Case</text>
        <text class="section-meta">
          {{panelState}} / onlyActive = {{showOnlyActive}}
        </text>
      </view>
      <text class="section-note">
        This card combines request state, list rendering, selection, expansion, and empty fallback.
      </text>
      <view class="button-row">
        <button class="btn" bindtap="setPanelState" data-state="loading">Panel Loading</button>
        <button class="btn" bindtap="setPanelState" data-state="error">Panel Error</button>
        <button class="btn" bindtap="setPanelState" data-state="ready">Panel Ready</button>
        <button class="btn" bindtap="toggleShowOnlyActive">
          {{showOnlyActive ? 'Show All' : 'Only Active'}}
        </button>
      </view>
      <view ink:if="{{panelState === 'loading'}}" class="state-block warning-block">
        <text class="state-title">Loading results</text>
        <text class="state-copy">Use this to verify top-level replacement before list content mounts.</text>
      </view>
      <view ink:else>
        <view ink:if="{{panelState === 'error'}}" class="state-block danger-block">
          <text class="state-title">Request failed</text>
          <text class="state-copy">The request branch overrides any selected or expanded row state.</text>
        </view>
        <view ink:else class="panel-list">
          <view ink:if="{{panelVisibleCount === 0}}" class="state-block muted-block">
            <text class="state-title">Filtered empty branch</text>
            <text class="state-copy">
              The request succeeded, but no active rows remain after applying the current filter.
            </text>
          </view>
          <view ink:else>
            <view class="panel-row" ink:for="{{panelItems}}" ink:key="id">
              <view ink:if="{{showOnlyActive === false || item.active}}">
                <view class="panel-header">
                  <text class="panel-title">
                    {{item.title}} {{selectedItemId === item.id ? '(selected)' : ''}}
                  </text>
                  <text class="panel-meta">
                    active = {{item.active}} / expanded = {{item.expanded}}
                  </text>
                </view>
                <view class="button-row">
                  <button class="btn btn-small" bindtap="selectPanelItem" data-id="{{item.id}}">
                    Select
                  </button>
                  <button class="btn btn-small" bindtap="togglePanelItemExpanded" data-id="{{item.id}}">
                    Toggle Expand
                  </button>
                  <button class="btn btn-small" bindtap="togglePanelItemActive" data-id="{{item.id}}">
                    Toggle Active
                  </button>
                </view>
                <view ink:if="{{item.expanded}}" class="inline-branch success-branch">
                  <text class="branch-copy">{{item.description}}</text>
                </view>
                <view ink:else class="inline-branch muted-branch">
                  <text class="branch-copy">Collapsed detail branch for {{item.title}}.</text>
                </view>
              </view>
            </view>
          </view>
        </view>
      </view>
    </view>
  </view>
</page>

<style>
  .container {
    display: flex;
    flex-direction: column;
    gap: 16px;
    padding: var(--theme-padding, 20px);
  }

  .hero,
  .card,
  .section,
  .nested-panel,
  .list-stack,
  .panel-list,
  .success-list {
    display: flex;
    flex-direction: column;
  }

  .hero,
  .card {
    gap: 12px;
  }

  .card {
    padding: 16px;
    border-radius: var(--radius-md, 12px);
    border: var(--border-width-thin, 1px) solid var(--border-color-muted, #d1d1d6);
  }

  .page-title {
    font-size: 28px;
    font-weight: bold;
    color: var(--color-text-primary);
  }

  .page-description,
  .section-note,
  .state-copy,
  .branch-copy,
  .panel-meta,
  .list-item-meta,
  .section-meta {
    font-size: 13px;
    line-height: 18px;
    color: var(--color-text-secondary);
  }

  .section-header,
  .button-row,
  .list-item-header,
  .panel-header {
    display: flex;
    flex-direction: row;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
    flex-wrap: wrap;
  }

  .section-title,
  .state-title,
  .branch-title,
  .list-item-title,
  .panel-title {
    font-size: 16px;
    font-weight: bold;
    color: var(--color-text-primary);
  }

  .btn {
    font-size: 14px;
    border: var(--border-width-thin, 1px) solid var(--border-color-default, #d1d1d6);
    background-color: transparent;
  }

  .btn-primary {
    border-color: var(--color-primary, #0a84ff);
  }

  .btn-small {
    font-size: 12px;
  }

  .state-block,
  .inline-branch,
  .list-item,
  .panel-row,
  .nested-panel {
    display: flex;
    flex-direction: column;
    gap: 8px;
    padding: 12px;
    border-radius: var(--radius-md, 10px);
    border: var(--border-width-thin, 1px) solid var(--border-color-muted, #d1d1d6);
  }

  .success-block,
  .success-branch {
    border-color: var(--border-color-success, #34c759);
  }

  .warning-block,
  .warning-branch {
    border-color: var(--border-color-warning, #ff9f0a);
  }

  .danger-block {
    border-color: var(--border-color-danger, #ff3b30);
  }

  .muted-block,
  .muted-branch {
    border-color: var(--border-color-default, #d1d1d6);
  }

  .success-item {
    font-size: 13px;
    line-height: 18px;
    color: var(--color-text-primary);
  }
</style>
