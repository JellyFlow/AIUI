<script def>
{
  "navigationBarTitleText": "Mahjong Game"
}
</script>

<script setup>
import wx from 'wx';

export default {
  data: {
    status: 'Your Turn',
    score: 25000,
    wind: 'East',
    selectedIndex: -1,
    hand: ['一', '二', '三', '五', '五', '六', '中', '中', '发', '发', '发', '白', '白'],
    drawTile: '白',
    discards: ['一', '九', '中', '南', '发', '东'],
    showWin: false
  },
  selectTile(e) {
    const index = parseInt(e.currentTarget.dataset.index);
    this.setData({
      selectedIndex: index,
      status: `Selected: ${index === 13 ? this.data.drawTile : this.data.hand[index]}`
    });
  },
  handleDiscard() {
    if (this.data.selectedIndex === -1) {
      wx.showToast({ title: 'Please select a tile' });
      return;
    }
    
    let tile = '';
    if (this.data.selectedIndex === 13) {
      tile = this.data.drawTile;
      this.setData({ drawTile: '' });
    } else {
      tile = this.data.hand[this.data.selectedIndex];
      // In a real app we'd update the array, but since no for-loop, 
      // we just simulate the UI change
    }

    const newDiscards = [...this.data.discards, tile];
    this.setData({
      status: `Discarded ${tile}. Opponent's turn...`,
      selectedIndex: -1,
      discards: newDiscards
    });

    setTimeout(() => {
      this.setData({ status: 'Your Turn' });
    }, 2000);
  },
  handleWin() {
    this.setData({
      showWin: true,
      status: 'TSUMO! 役満!'
    });
  },
  reset() {
    this.setData({
      showWin: false,
      status: 'Your Turn',
      drawTile: '白',
      selectedIndex: -1
    });
  },
  back() {
    wx.navigateBack();
  }
}
</script>

<page>
  <view class="game-container">
    <!-- Win Overlay -->
    <view class="overlay" ink:if="{{showWin}}">
      <view class="win-card">
        <text class="win-title">TSUMO!</text>
        <text class="win-subtitle">天和 (Tenhou)</text>
        <text class="win-points">32000 pts</text>
        <button class="reset-btn" bindtap="reset">Play Again</button>
      </view>
    </view>

    <view class="header">
      <view class="status-box">
        <view class="indicator {{status === 'Your Turn' ? 'active' : ''}}"></view>
        <text class="status">{{status}}</text>
      </view>
      <text class="info">{{wind}} - {{score}}</text>
    </view>

    <view class="board">
      <!-- Opponent Hand (Top) -->
      <view class="opponent-hand">
        <view class="tile hidden"></view>
        <view class="tile hidden"></view>
        <view class="tile hidden"></view>
        <view class="tile hidden"></view>
        <view class="tile hidden"></view>
        <view class="tile hidden"></view>
        <view class="tile hidden"></view>
        <view class="tile hidden"></view>
        <view class="tile hidden"></view>
        <view class="tile hidden"></view>
        <view class="tile hidden"></view>
        <view class="tile hidden"></view>
        <view class="tile hidden"></view>
      </view>

      <!-- Center Discard Area -->
      <view class="discard-area">
        <view class="discard-row">
          <view class="tile discard"><text>{{discards[0]}}</text></view>
          <view class="tile discard"><text>{{discards[1]}}</text></view>
          <view class="tile discard"><text>{{discards[2]}}</text></view>
          <view class="tile discard" ink:if="{{discards[6]}}"><text>{{discards[6]}}</text></view>
        </view>
        <view class="discard-row">
          <view class="tile discard"><text>{{discards[3]}}</text></view>
          <view class="tile discard"><text>{{discards[4]}}</text></view>
          <view class="tile discard"><text>{{discards[5]}}</text></view>
          <view class="tile discard" ink:if="{{discards[7]}}"><text>{{discards[7]}}</text></view>
        </view>
      </view>

      <!-- Player Hand (Bottom) -->
      <view class="player-hand">
        <view class="tile-group">
          <view class="tile active {{selectedIndex === 0 ? 'selected' : ''}}" bindtap="selectTile" data-index="0"><text>一</text></view>
          <view class="tile active {{selectedIndex === 1 ? 'selected' : ''}}" bindtap="selectTile" data-index="1"><text>二</text></view>
          <view class="tile active {{selectedIndex === 2 ? 'selected' : ''}}" bindtap="selectTile" data-index="2"><text>三</text></view>
          <view class="tile active {{selectedIndex === 3 ? 'selected' : ''}}" bindtap="selectTile" data-index="3"><text>五</text></view>
          <view class="tile active {{selectedIndex === 4 ? 'selected' : ''}}" bindtap="selectTile" data-index="4"><text>五</text></view>
          <view class="tile active {{selectedIndex === 5 ? 'selected' : ''}}" bindtap="selectTile" data-index="5"><text>六</text></view>
          <view class="tile active {{selectedIndex === 6 ? 'selected' : ''}}" bindtap="selectTile" data-index="6"><text>中</text></view>
          <view class="tile active {{selectedIndex === 7 ? 'selected' : ''}}" bindtap="selectTile" data-index="7"><text>中</text></view>
          <view class="tile active {{selectedIndex === 8 ? 'selected' : ''}}" bindtap="selectTile" data-index="8"><text>发</text></view>
          <view class="tile active {{selectedIndex === 9 ? 'selected' : ''}}" bindtap="selectTile" data-index="9"><text>发</text></view>
          <view class="tile active {{selectedIndex === 10 ? 'selected' : ''}}" bindtap="selectTile" data-index="10"><text>发</text></view>
          <view class="tile active {{selectedIndex === 11 ? 'selected' : ''}}" bindtap="selectTile" data-index="11"><text>白</text></view>
          <view class="tile active {{selectedIndex === 12 ? 'selected' : ''}}" bindtap="selectTile" data-index="12"><text>白</text></view>
        </view>
        <view class="tile draw {{selectedIndex === 13 ? 'selected' : ''}}" ink:if="{{drawTile}}" bindtap="selectTile" data-index="13">
          <text>{{drawTile}}</text>
        </view>
      </view>
    </view>

    <!-- Action Bar -->
    <view class="action-bar">
      <button class="action-btn discard-btn" bindtap="handleDiscard">打 (Discard)</button>
      <button class="action-btn win-btn" bindtap="handleWin">和 (Win)</button>
      <button class="action-btn quit-btn" bindtap="back">退出</button>
    </view>
  </view>
</page>

<style>
.game-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 480px;
  height: 380px;
  background-color: #000;
  padding: 10px;
  box-sizing: border-box;
  position: relative;
}

.overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0,0,0,0.8);
  z-index: 100;
  display: flex;
  align-items: center;
  justify-content: center;
}

.win-card {
  background-color: #1a1a1a;
  border: 3px solid #40FF5E;
  border-radius: 20px;
  padding: 40px;
  display: flex;
  flex-direction: column;
  align-items: center;
  box-shadow: 0 0 20px #40FF5E;
}

.win-title {
  color: #40FF5E;
  font-size: 48px;
  font-weight: bold;
  margin-bottom: 10px;
}

.win-subtitle {
  color: #fff;
  font-size: 24px;
  margin-bottom: 20px;
}

.win-points {
  color: #40FF5E;
  font-size: 32px;
  margin-bottom: 30px;
}

.reset-btn {
  background-color: #40FF5E;
  color: #000;
  padding: 10px 30px;
  border-radius: 12px;
  font-weight: bold;
}

.header {
  width: 100%;
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
  padding: 0 10px;
}

.status-box {
  display: flex;
  flex-direction: row;
  align-items: center;
}

.indicator {
  width: 10px;
  height: 10px;
  border-radius: 5px;
  background-color: #555;
  margin-right: 10px;
}

.indicator.active {
  background-color: #40FF5E;
  box-shadow: 0 0 5px #40FF5E;
}

.status {
  color: #40FF5E;
  font-size: 16px;
  font-weight: bold;
}

.info {
  color: rgba(64, 255, 94, 0.7);
  font-size: 14px;
}

.board {
  flex: 1;
  width: 100%;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  align-items: center;
  padding: 10px 0;
}

.opponent-hand {
  display: flex;
  flex-direction: row;
}

.tile {
  width: 22px;
  height: 30px;
  background-color: #eee;
  border: 1px solid #999;
  border-radius: 3px;
  margin: 0 1px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.tile.hidden {
  background-color: #2c3e50;
  border-color: #34495e;
}

.tile text {
  color: #333;
  font-size: 14px;
  font-weight: bold;
}

.discard-area {
  display: flex;
  flex-direction: column;
  align-items: center;
  background-color: rgba(64, 255, 94, 0.05);
  padding: 10px;
  border-radius: 10px;
}

.discard-row {
  display: flex;
  flex-direction: row;
  margin-bottom: 3px;
}

.tile.discard {
  width: 18px;
  height: 24px;
  opacity: 0.9;
}

.tile.discard text {
  font-size: 10px;
}

.player-hand {
  display: flex;
  flex-direction: row;
  align-items: flex-end;
  padding-bottom: 10px;
}

.tile-group {
  display: flex;
  flex-direction: row;
}

.tile.active {
  background-color: #fff;
  border: 1px solid #ccc;
  width: 26px;
  height: 36px;
  transition: transform 0.2s;
}

.tile.active.selected {
  transform: translateY(-10px);
  border: 2px solid #40FF5E;
  box-shadow: 0 5px 10px rgba(64, 255, 94, 0.3);
}

.tile.draw {
  margin-left: 8px;
  background-color: #fff;
  border: 1px solid #ccc;
  width: 26px;
  height: 36px;
}

.tile.draw.selected {
  transform: translateY(-10px);
  border: 2px solid #40FF5E;
}

.action-bar {
  display: flex;
  flex-direction: row;
  width: 100%;
  justify-content: space-around;
  padding: 10px 0;
  border-top: 1px solid rgba(64, 255, 94, 0.2);
}

.action-btn {
  font-size: 12px;
  padding: 5px 10px;
  border-radius: 8px;
  width: 100px;
}

.discard-btn {
  border: 1px solid #40FF5E;
  color: #40FF5E;
}

.win-btn {
  background-color: #40FF5E;
  color: #000;
  font-weight: bold;
}

.quit-btn {
  color: rgba(255, 255, 255, 0.5);
  font-size: 10px;
  width: 60px;
}
</style>
