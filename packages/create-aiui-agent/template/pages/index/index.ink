<script def>
{
  "navigationBarTitleText": "Index Page"
}
</script>

<script setup>
export default {
  data: {
    focused: false,
    greeting: 'Hello AIUI!'
  },
  handleTap() {
    this.setData({
      greeting: '你好，世界！'
    });
    setTimeout(() => {
      this.setData({
        greeting: 'Hello AIUI!',
      });
    }, 1000);
  },
  onKeyUp(event) {
    if (!this.data.focused && (event.code === 'Enter' || event.code === 'GlobalHook')) {
      this.setData({
        focused: true,
      });
      return;
    }
    if (this.data.focused && event.code === 'Enter') {
      this.handleTap();
      this.setData({
        focused: false,
      });
    }
  }
}
</script>

<page>
  <view class="container">
    <text class="title">{{ greeting }}</text>
    <button class="{{ focused ? 'focused' : '' }}" bindtap="handleTap">点击我</button>
  </view>
</page>

<style>
.container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100vh;
}

card {
  width: 80%;
  margin-top: 
}

.title {
  color: #40FF5E;
  width: 100%;
  text-align: center;
  font-size: 24px;
  line-height: 24px;
  margin-bottom: 20px;
}

button {
  color: #40FF5E;
  border: 1px solid #40ff5d42;
  border-radius: 12px;
  box-sizing: border-box;
  padding: 5px;
  width: 100px;
  line-height: 24px;
  text-align: center;
}

button.focused {
  border: 2px solid #40FF5E;
}

</style>
