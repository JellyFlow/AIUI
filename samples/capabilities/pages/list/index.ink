<script setup>
  export default {
    data: {
      fruits: ['Apple', 'Banana', 'Cherry', 'Durian', 'Elderberry'],
      contacts: [
        { id: 1, name: 'Yorkie', role: 'Maintainer' },
        { id: 2, name: 'Alice', role: 'Contributor' },
        { id: 3, name: 'Bob', role: 'Reviewer' },
      ],
      tasks: [
        { id: 1, title: 'Design API', done: true },
        { id: 2, title: 'Implement ink:for', done: true },
        { id: 3, title: 'Write tests', done: true },
        { id: 4, title: 'Add fixture page', done: false },
      ],
      categories: [
        {
          name: 'Fruits',
          items: ['Apple', 'Banana', 'Cherry'],
        },
        {
          name: 'Vegetables',
          items: ['Carrot', 'Broccoli', 'Spinach'],
        },
        {
          name: 'Drinks',
          items: ['Water', 'Juice', 'Tea'],
        },
      ],
      dynamicItems: ['Item A', 'Item B', 'Item C'],
      styledItems: [
        { label: 'Red', color: '#ff6b6b' },
        { label: 'Green', color: '#51cf66' },
        { label: 'Blue', color: '#339af0' },
        { label: 'Orange', color: '#ff922b' },
        { label: 'Purple', color: '#cc5de8' },
      ],
      horizontalItems: [
        { icon: '🍎', label: 'Apple' },
        { icon: '🍌', label: 'Banana' },
        { icon: '🍒', label: 'Cherry' },
        { icon: '🥕', label: 'Carrot' },
        { icon: '🥦', label: 'Broccoli' },
        { icon: '🍇', label: 'Grape' },
        { icon: '🍊', label: 'Orange' },
        { icon: '🍋', label: 'Lemon' },
      ],
      largeList: [],
      chatMessages: [
        { id: 1, from: 'me', text: 'Hello, how are you?' },
        { id: 2, from: 'other', text: 'I am fine, thanks! How about you?' },
        { id: 3, from: 'me', text: 'Doing great! Are you free to talk?' },
        { id: 4, from: 'other', text: 'Yes, what would you like to discuss?' },
        { id: 5, from: 'me', text: 'Let us review the project design doc.' },
        { id: 6, from: 'other', text: 'Good idea. I have some feedback on the architecture.' },
        { id: 7, from: 'me', text: 'What do you think about the data layer?' },
        { id: 8, from: 'other', text: 'Looks solid, but we should add caching.' },
        { id: 9, from: 'me', text: 'Agreed. Can you draft a proposal?' },
        { id: 10, from: 'other', text: 'Sure, I will send it over tomorrow morning.' },
        { id: 11, from: 'me', text: 'Perfect, looking forward to it!' },
      ],
    },
    onLoad() {
      // 1s later: mutate fruits list
      setTimeout(() => {
        this.setData({
          fruits: ['Apple', 'Banana', 'Elderberry'],
        });
      }, 1000);

      // 2s later: add an item to dynamic list
      setTimeout(() => {
        this.setData({
          dynamicItems: ['Item A', 'Item B', 'Item C', 'Item D (new)'],
        });
      }, 2000);

      // 3s later: remove first item from dynamic list
      setTimeout(() => {
        this.setData({
          dynamicItems: ['Item B', 'Item C', 'Item D (new)'],
        });
      }, 3000);

      // Build a large list of 50 items for scroll perf test
      const largeList = [];
      for (let i = 1; i <= 50; i++) {
        largeList.push({ index: i, text: `Row ${String(i).padStart(2, '0')}` });
      }
      this.setData({ largeList });
    },
  };
</script>

<page>
  <view class="container">
    <view class="page-title">List</view>

    <!-- Basic List -->
    <view class="card section">
      <view class="title">Basic List (ink:for)</view>
      <view class="list-item" ink:for="{{ fruits }}" ink:key="index">
        <text class="item-index">{{ index }}.</text>
        <text class="item-name">{{ item }}</text>
      </view>
    </view>

    <!-- Object List -->
    <view class="card section">
      <view class="title">Object List</view>
      <view class="list-card" ink:for="{{ contacts }}" ink:key="index">
        <text class="card-name">{{ item.name }}</text>
        <text class="card-role">{{ item.role }}</text>
      </view>
    </view>

    <!-- Filtered List -->
    <view class="card section">
      <view class="title">Filtered List (ink:for + ink:if)</view>
      <view class="task-item" ink:for="{{ tasks }}" ink:key="index">
        <view ink:if="{{ item.done }}">
          <text class="task-done">✓ {{ item.title }}</text>
        </view>
        <view ink:else>
          <text class="task-pending">○ {{ item.title }}</text>
        </view>
      </view>
    </view>

    <!-- Nested List (ink:for inside ink:for) -->
    <view class="card section">
      <view class="title">Nested List</view>
      <view class="category-group" ink:for="{{ categories }}" ink:key="index">
        <text class="category-name">{{ item.name }}</text>
        <view class="sub-item" ink:for="{{ item.items }}" ink:key="index">
          <text class="sub-dot">•</text>
          <text class="sub-name">{{ item }}</text>
        </view>
      </view>
    </view>

    <!-- Dynamic List (add/remove) -->
    <view class="card section">
      <view class="title">Dynamic List (mutates via setData)</view>
      <view class="dynamic-item" ink:for="{{ dynamicItems }}" ink:key="index">
        <text class="dynamic-label">{{ item }}</text>
        <text class="dynamic-hint">(index: {{ index }})</text>
      </view>
    </view>

    <!-- Inline-Styled List -->
    <view class="card section">
      <view class="title">Inline-Styled List</view>
      <view
        class="color-chip"
        ink:for="{{ styledItems }}"
        ink:key="index"
        style="background-color: {{ item.color }};"
      >
        <text class="chip-label">{{ item.label }}</text>
      </view>
    </view>

    <!-- Horizontal Scrolling List -->
    <view class="card section">
      <view class="title">Horizontal List</view>
      <view class="h-scroll">
        <view class="h-card" ink:for="{{ horizontalItems }}" ink:key="index">
          <text class="h-icon">{{ item.icon }}</text>
          <text class="h-label">{{ item.label }}</text>
        </view>
      </view>
    </view>

    <!-- Scroll-View Chat Window -->
    <view class="card section">
      <view class="title">Scroll-View Chat Window</view>
      <scroll-view class="chat-window" scroll-y="true" auto-scroll="true" scroll-direction="vertical" scroll-speed="60.0">
        <view
          class="chat-bubble"
          ink:for="{{ chatMessages }}"
          ink:key="index"
        >
          <text class="chat-from">{{ item.from === 'me' ? 'You' : 'Other' }}:</text>
          <text class="chat-text">{{ item.text }}</text>
        </view>
      </scroll-view>
    </view>

    <!-- Large List (50 items, scroll perf) -->
    <view class="card section">
      <view class="title">Large List ({{ largeList.length }} items)</view>
      <view class="large-item" ink:for="{{ largeList }}" ink:key="index">
        <text class="large-index">#{{ item.index }}</text>
        <view class="large-bar">
          <view
            class="large-fill"
            style="width: {{ item.index * 2 }}%;"
          />
        </view>
        <text class="large-text">{{ item.text }}</text>
      </view>
    </view>
  </view>
</page>

<style>
  .container {
    display: flex;
    flex-direction: column;
    padding: var(--spacing-lg, 20px);
  }

  .section {
    flex-direction: column;
    margin-bottom: 24px;
    border-radius: var(--radius-md, 12px);
    padding: var(--spacing-md, 16px);
  }

  .title {
    font-size: 18px;
    font-weight: bold;
    margin-bottom: var(--spacing-md, 12px);
    border-bottom: var(--border-width-default, 2px) solid var(--border-color-accent, #1989fa);
    padding-bottom: 8px;
  }

  /* Basic / Object / Filtered */
  .list-item {
    display: flex;
    flex-direction: row;
    align-items: center;
    padding: 10px 0;
    border-bottom: var(--border-width-thin, 1px) solid var(--border-color-muted, #eee);
  }

  .item-index {
    font-size: 14px;
    width: 30px;
  }

  .item-name {
    font-size: 16px;
  }

  .list-card {
    border-radius: var(--radius-sm, 8px);
    padding: var(--spacing-md, 12px);
    margin-bottom: 8px;
  }

  .card-name {
    font-size: 16px;
    font-weight: bold;
  }

  .card-role {
    font-size: 13px;
    margin-top: 4px;
  }

  .task-item {
    margin-bottom: 8px;
  }

  .task-done {
    font-size: 15px;
  }

  .task-pending {
    font-size: 15px;
  }

  /* Nested List */
  .category-group {
    flex-direction: column;
    margin-bottom: 16px;
  }

  .category-name {
    font-size: 16px;
    font-weight: bold;
    margin-bottom: 6px;
  }

  .sub-item {
    display: flex;
    flex-direction: row;
    align-items: center;
    padding: 4px 0 4px 16px;
  }

  .sub-dot {
    font-size: 14px;
    width: 16px;
  }

  .sub-name {
    font-size: 14px;
  }

  /* Dynamic List */
  .dynamic-item {
    display: flex;
    flex-direction: row;
    align-items: center;
    padding: 10px 0;
    border-bottom: var(--border-width-thin, 1px) solid var(--border-color-muted, #eee);
  }

  .dynamic-label {
    font-size: 15px;
    flex: 1;
  }

  .dynamic-hint {
    font-size: 12px;
  }

  /* Inline-Styled List */
  .color-chip {
    display: flex;
    flex-direction: row;
    align-items: center;
    justify-content: center;
    border-radius: var(--radius-sm, 8px);
    padding: var(--spacing-sm, 10px);
    margin-bottom: 8px;
  }

  .chip-label {
    font-size: 15px;
    font-weight: bold;
    color: #fff;
  }

  /* Horizontal List */
  .h-scroll {
    display: flex;
    flex-direction: row;
    overflow-x: auto;
  }

  .h-card {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    width: 80px;
    height: 80px;
    border-radius: var(--radius-md, 12px);
    background-color: #f5f7fa;
    margin-right: 10px;
    flex-shrink: 0;
  }

  .h-icon {
    font-size: 24px;
    margin-bottom: 4px;
  }

  .h-label {
    font-size: 11px;
  }

  /* Large List */
  .large-item {
    display: flex;
    flex-direction: row;
    align-items: center;
    padding: 8px 0;
    border-bottom: var(--border-width-thin, 1px) solid var(--border-color-muted, #eee);
  }

  .large-index {
    font-size: 13px;
    width: 36px;
  }

  .large-bar {
    flex: 1;
    height: 8px;
    border-radius: 4px;
    background-color: #e9ecef;
    margin: 0 10px;
    overflow: hidden;
  }

  .large-fill {
    height: 8px;
    border-radius: 4px;
    background-color: var(--brand-primary, #1989fa);
  }

  .large-text {
    font-size: 13px;
    width: 56px;
    text-align: right;
  }

  /* Scroll-View Chat Window */
  .chat-window {
    height: 220px;
    overflow: hidden;
    border: var(--border-width-thin, 1px) solid var(--border-color-muted, #eee);
    border-radius: var(--radius-sm, 8px);
    padding: var(--spacing-sm, 10px);
  }

  .chat-bubble {
    display: flex;
    flex-direction: column;
    margin-bottom: 8px;
    padding: 6px 10px;
    border-radius: var(--radius-sm, 8px);
    border: var(--border-width-thin, 1px) solid var(--border-color-muted, #eee);
  }

  .chat-from {
    font-size: 11px;
    font-weight: bold;
    margin-bottom: 2px;
  }

  .chat-text {
    font-size: 14px;
  }
</style>
