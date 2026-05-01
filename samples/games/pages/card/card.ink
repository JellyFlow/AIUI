<script def>
{
  "navigationBarTitleText": "Business Card"
}
</script>

<script setup>
import wx from 'wx';

export default {
  data: {
    name: 'JSUI Developer',
    title: 'Senior Agent Engineer',
    company: 'JSUI Open Source',
    email: 'agent@jsui.dev',
    phone: '+86 123 4567 8901'
  },
  back() {
    wx.navigateBack();
  }
}
</script>

<page>
  <view class="container">
    <view class="card">
      <view class="header">
        <view class="avatar-placeholder"></view>
        <view class="info">
          <text class="name">{{name}}</text>
          <text class="title">{{title}}</text>
        </view>
      </view>
      <view class="divider"></view>
      <view class="details">
        <view class="detail-item">
          <text class="label">Company</text>
          <text class="value">{{company}}</text>
        </view>
        <view class="detail-item">
          <text class="label">Email</text>
          <text class="value">{{email}}</text>
        </view>
        <view class="detail-item">
          <text class="label">Phone</text>
          <text class="value">{{phone}}</text>
        </view>
      </view>
      <button class="back-btn" bindtap="back">返回</button>
    </view>
  </view>
</page>

<style>
.container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100vh;
  background-color: #000;
}

.card {
  width: 440px;
  background-color: #1a1a1a;
  border: 2px solid #40FF5E;
  border-radius: 12px;
  padding: 30px;
  box-sizing: border-box;
}

.header {
  display: flex;
  flex-direction: row;
  align-items: center;
  margin-bottom: 25px;
}

.avatar-placeholder {
  width: 70px;
  height: 70px;
  border-radius: 35px;
  background-color: #40FF5E;
  margin-right: 20px;
}

.info {
  display: flex;
  flex-direction: column;
}

.name {
  color: #40FF5E;
  font-size: 28px;
  font-weight: bold;
  margin-bottom: 5px;
}

.title {
  color: rgba(64, 255, 94, 0.7);
  font-size: 16px;
}

.divider {
  height: 2px;
  background-color: rgba(64, 255, 94, 0.2);
  margin-bottom: 25px;
}

.details {
  display: flex;
  flex-direction: column;
  margin-bottom: 30px;
}

.detail-item {
  display: flex;
  flex-direction: row;
  margin-bottom: 12px;
}

.label {
  color: rgba(64, 255, 94, 0.5);
  width: 100px;
  font-size: 14px;
}

.value {
  color: #40FF5E;
  font-size: 14px;
  flex: 1;
}

.back-btn {
  color: #000;
  background-color: #40FF5E;
  border-radius: 12px;
  padding: 10px;
  text-align: center;
  font-size: 16px;
  font-weight: bold;
  width: 100%;
}
</style>
