<script def>
{
  "navigationBarTitleText": "AI Maid"
}
</script>

<script setup>
import wx from 'wx';

export default {
  data: {
    message: 'dlover 好',
    isSpeaking: false
  },
  onLoad() {
    this.sayHello();
  },
  sayHello() {
    if (this.data.isSpeaking) return;
    
    this.setData({ isSpeaking: true });
    
    const utterance = new SpeechSynthesisUtterance(this.data.message);
    utterance.lang = 'zh-CN';
    utterance.onend = () => {
      this.setData({ isSpeaking: false });
    };
    speechSynthesis.speak(utterance);
  },
  back() {
    wx.navigateBack();
  }
}
</script>

<page>
  <view class="container">
    <view class="maid-container">
      <!-- Simple CSS Maid Representation -->
      <view class="maid-head">
        <view class="maid-hair-back"></view>
        <view class="maid-face">
          <view class="maid-eyes">
            <view class="eye left"></view>
            <view class="eye right"></view>
          </view>
          <view class="maid-blush"></view>
          <view class="maid-mouth {{isSpeaking ? 'speaking' : ''}}"></view>
        </view>
        <view class="maid-hair-front"></view>
        <view class="maid-headband"></view>
      </view>
      
      <view class="speech-bubble">
        <text>{{message}}</text>
      </view>
    </view>

    <view class="controls">
      <button class="talk-btn" bindtap="sayHello">
        <text>{{isSpeaking ? 'Speaking...' : 'Talk to me'}}</text>
      </button>
      <button class="back-btn" bindtap="back">Back</button>
    </view>
  </view>
</page>

<style>
.container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  width: 480px;
  height: 380px;
  background-color: #000;
  padding: 20px;
  box-sizing: border-box;
}

.maid-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 30px;
  position: relative;
}

.maid-head {
  width: 150px;
  height: 150px;
  position: relative;
}

.maid-face {
  width: 100px;
  height: 100px;
  background-color: #ffdbac;
  border-radius: 50%;
  position: absolute;
  top: 30px;
  left: 25px;
  z-index: 2;
  border: 2px solid #333;
}

.maid-hair-back {
  width: 120px;
  height: 120px;
  background-color: #4a3728;
  border-radius: 50%;
  position: absolute;
  top: 20px;
  left: 15px;
  z-index: 1;
}

.maid-hair-front {
  width: 100px;
  height: 40px;
  background-color: #4a3728;
  border-radius: 50% 50% 0 0;
  position: absolute;
  top: 25px;
  left: 25px;
  z-index: 3;
}

.maid-headband {
  width: 110px;
  height: 20px;
  background-color: #fff;
  border: 2px solid #333;
  border-radius: 10px;
  position: absolute;
  top: 20px;
  left: 20px;
  z-index: 4;
}

.maid-eyes {
  display: flex;
  justify-content: space-around;
  width: 60px;
  position: absolute;
  top: 40px;
  left: 20px;
}

.eye {
  width: 12px;
  height: 12px;
  background-color: #333;
  border-radius: 50%;
}

.maid-blush {
  width: 80px;
  height: 10px;
  display: flex;
  justify-content: space-between;
  position: absolute;
  top: 60px;
  left: 10px;
}

.maid-blush::before, .maid-blush::after {
  content: '';
  width: 15px;
  height: 8px;
  background-color: rgba(255, 100, 100, 0.3);
  border-radius: 50%;
}

.maid-mouth {
  width: 20px;
  height: 10px;
  border-bottom: 2px solid #333;
  border-radius: 0 0 10px 10px;
  position: absolute;
  top: 75px;
  left: 40px;
}

.maid-mouth.speaking {
  height: 15px;
  background-color: #333;
  border-radius: 50%;
  animation: speak-anim 0.2s infinite alternate;
}

@keyframes speak-anim {
  from { height: 5px; }
  to { height: 15px; }
}

.speech-bubble {
  background-color: #fff;
  border: 2px solid #40FF5E;
  border-radius: 15px;
  padding: 10px 20px;
  margin-top: 20px;
  position: relative;
}

.speech-bubble::after {
  content: '';
  position: absolute;
  top: -10px;
  left: 50%;
  margin-left: -10px;
  border-left: 10px solid transparent;
  border-right: 10px solid transparent;
  border-bottom: 10px solid #fff;
}

.speech-bubble text {
  color: #333;
  font-size: 18px;
  font-weight: bold;
}

.controls {
  display: flex;
  flex-direction: row;
  gap: 20px;
}

.talk-btn {
  background-color: #40FF5E;
  color: #000;
  border-radius: 12px;
  padding: 10px 30px;
  font-weight: bold;
}

.back-btn {
  background-color: rgba(64, 255, 94, 0.2);
  color: #40FF5E;
  border: 1px solid #40FF5E;
  border-radius: 12px;
  padding: 10px 20px;
}
</style>
