<script type="application/json" def>
{
  "navigationBarTitleText": "Camera Demo"
}
</script>

<script setup>
import wx from 'wx';

function toPreviewUrl(photo) {
  if (photo?.tempImagePath) {
    return photo.tempImagePath;
  }

  if (photo?.data) {
    const mimeType = photo.mimeType || 'image/jpeg';
    return `data:${mimeType};base64,${wx.arrayBufferToBase64(photo.data)}`;
  }

  return '';
}

export default {
  data: {
    status: 'READY',
    errorMessage: '',
    photoUrl: '',
  },

  onShow() {
    this.cameraCtx = wx.media.createCameraContext();
  },

  onHide() {
    this.cameraCtx = null;
  },

  goToTtsDemo() {
    wx.navigateTo({ url: '/pages/minimax-tts/index' });
  },

  async takePhoto() {
    this.setData({
      status: 'CAPTURING',
      errorMessage: '',
    });

    try {
      if (!this.cameraCtx) {
        this.cameraCtx = wx.media.createCameraContext();
      }

      const photo = await this.cameraCtx.takePhoto({ quality: 'high' });
      const photoUrl = toPreviewUrl(photo);

      if (!photoUrl) {
        throw new Error('Camera did not return previewable image data.');
      }

      this.setData({
        status: 'CAPTURED',
        photoUrl,
      });
    } catch (error) {
      this.setData({
        status: 'ERROR',
        errorMessage: error?.message || 'Failed to capture photo.',
      });
    }
  },
};
</script>

<page>
  <view class="page">
    <view class="header">
      <text class="title">Camera Demo</text>
      <text class="subtitle">Minimal sample for camera preview and photo capture.</text>
    </view>

    <view class="card">
      <camera class="camera-preview"></camera>
      <text class="status-label">Status: {{status}}</text>
      <text class="error-text" ink:if="{{errorMessage}}">{{errorMessage}}</text>
    </view>

    <view class="actions">
      <button class="primary-button" bindtap="takePhoto">Take Photo</button>
      <button class="secondary-button" bindtap="goToTtsDemo">Open TTS Demo</button>
    </view>

    <view class="card preview-card" ink:if="{{photoUrl}}">
      <text class="section-title">Latest Photo</text>
      <image class="photo-preview" src="{{photoUrl}}" mode="aspectFit"></image>
    </view>
  </view>
</page>

<style>
  .page {
    min-height: 100%;
    padding: 24px;
    box-sizing: border-box;
    background: #050505;
    color: #f5f7fa;
  }

  .header {
    display: flex;
    flex-direction: column;
    margin-bottom: 20px;
  }

  .title {
    font-size: 24px;
    font-weight: 600;
    margin-bottom: 6px;
  }

  .subtitle {
    font-size: 13px;
    line-height: 18px;
    color: #b6bcc8;
  }

  .card {
    display: flex;
    flex-direction: column;
    padding: 16px;
    margin-bottom: 16px;
    border: 1px solid #2b2f36;
    border-radius: 16px;
    background: #111418;
  }

  .camera-preview {
    width: 100%;
    height: 240px;
    border-radius: 12px;
    overflow: hidden;
    background: #000000;
  }

  .status-label {
    margin-top: 12px;
    font-size: 14px;
    color: #dfe5ef;
  }

  .error-text {
    margin-top: 8px;
    font-size: 13px;
    color: #ff8f8f;
  }

  .actions {
    display: flex;
    flex-direction: row;
    gap: 12px;
    margin-bottom: 16px;
  }

  .primary-button,
  .secondary-button {
    flex: 1;
    font-size: 14px;
    border-radius: 999px;
  }

  .primary-button {
    background: #f2f4f8;
    color: #111418;
  }

  .secondary-button {
    background: #1b2027;
    color: #f5f7fa;
    border: 1px solid #303643;
  }

  .preview-card {
    margin-bottom: 0;
  }

  .section-title {
    font-size: 16px;
    font-weight: 600;
    margin-bottom: 12px;
  }

  .photo-preview {
    width: 100%;
    height: 220px;
    border-radius: 12px;
    background: #000000;
  }
</style>
