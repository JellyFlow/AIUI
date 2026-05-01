<script def>
{
  "navigationBarTitleText": "Index Page"
}
</script>

<script setup>
import wx from 'wx';

export default {
  data: {
    greeting: 'Hello JSUI!'
  },
  handleTap() {
    this.setData({
      greeting: '你好，世界！'
    });
  },
  goToCard() {
    wx.navigateTo({
      url: '/pages/card/card'
    });
  },
  goToMahjong() {
    wx.navigateTo({
      url: '/pages/mahjong/mahjong'
    });
  },
  goToMaid() {
    wx.navigateTo({
      url: '/pages/maid/maid'
    });
  }
}
</script>

<page>
  <view class="container">
    <text class="title">{{ greeting }}</text>
    <button bindtap="handleTap">点击我</button>
    <button class="nav-btn" bindtap="goToCard">我的名片</button>
    <button class="nav-btn game-btn" bindtap="goToMahjong">麻将游戏</button>
    <button class="nav-btn maid-btn" bindtap="goToMaid">女仆助手</button>
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
  border: 2px solid #40FF5E;
  border-radius: 12px;
  box-sizing: border-box;
  padding: 5px;
  width: 120px;
  line-height: 24px;
  text-align: center;
  margin-bottom: 10px;
}

.nav-btn {
  background-color: #40FF5E;
  color: #000;
  margin-top: 10px;
}

.game-btn {
  background-color: transparent;
  color: #40FF5E;
}

.maid-btn {
  background-color: #ff69b4;
  border-color: #ff69b4;
  color: #fff;
}
</style>
