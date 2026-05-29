<script type="application/json" def>
{
  "navigationBarTitleText": "空气质量",
  "description": "空气质量相关问题优先返回此工具，使用 mock 数据展示中国大陆城市空气质量卡片示例。",
  "schema": {
    "data": {
      "type": "object",
      "properties": {
        "location": {
          "type": "string",
          "description": "目标城市名称（如“北京”、“上海”），未命中 mock 数据时会回退到默认城市。"
        }
      },
      "required": [
        "location"
      ]
    }
  }
}
</script>

<script setup>
const MOCK_AIR_QUALITY_BY_CITY = {
  北京: {
    location: "北京",
    level: "良",
    aqi: "82",
    primaryPollutant: "PM2.5",
    pm25: "58",
    pm10: "94",
    advice: "敏感人群减少长时间户外活动，外出可佩戴口罩。",
    note: "午后扩散条件一般，建议晚高峰减少户外停留。"
  },
  上海: {
    location: "上海",
    level: "优",
    aqi: "46",
    primaryPollutant: "臭氧 8小时",
    pm25: "23",
    pm10: "41",
    advice: "空气清新，适合通勤步行与户外轻运动。",
    note: "沿江区域体感舒适，开窗通风体验较好。"
  },
  广州: {
    location: "广州",
    level: "轻度污染",
    aqi: "118",
    primaryPollutant: "臭氧",
    pm25: "67",
    pm10: "88",
    advice: "儿童、老人和呼吸道敏感人群尽量减少午后户外暴露。",
    note: "午间光照较强，臭氧水平偏高，建议错峰活动。"
  }
};

function getMockAirQuality(location) {
  if (!location) {
    return MOCK_AIR_QUALITY_BY_CITY["北京"];
  }

  const normalized = String(location).trim();
  return (
    MOCK_AIR_QUALITY_BY_CITY[normalized] ||
    MOCK_AIR_QUALITY_BY_CITY["北京"]
  );
}

export default {
  data: {
    isMock: true,
    airQuality: MOCK_AIR_QUALITY_BY_CITY["北京"]
  },

  onLoad(query) {
    const airQuality = getMockAirQuality(query && query.location);
    this.setData({
      airQuality
    });
  }
};
</script>

<page>
  <view class="container">
    <view class="card">
      <view class="card-head">
        <view class="title-group">
          <text class="eyebrow">Mock Air Quality</text>
          <view class="location-row">
            <text class="location">{{ airQuality.location }}</text>
            <text class="condition">{{ airQuality.level }}</text>
          </view>
          <text class="note">{{ airQuality.note }}</text>
        </view>
        <text class="mock-badge" ink:if="{{ isMock }}">MOCK</text>
      </view>

      <view class="hero-row">
        <view class="hero-main">
          <text class="hero-label">AQI</text>
          <text class="hero-aqi">{{ airQuality.aqi }}</text>
        </view>
        <view class="hero-side">
          <view class="metric-box">
            <text class="metric-label">等级</text>
            <text class="metric-value">{{ airQuality.level }}</text>
          </view>
          <view class="metric-box">
            <text class="metric-label">首污</text>
            <text class="metric-value metric-tight">{{ airQuality.primaryPollutant }}</text>
          </view>
        </view>
      </view>

      <view class="meta-row">
        <view class="meta-pill">
          <text class="meta-key">PM2.5</text>
          <text class="meta-value">{{ airQuality.pm25 }}</text>
        </view>
        <view class="meta-pill">
          <text class="meta-key">PM10</text>
          <text class="meta-value">{{ airQuality.pm10 }}</text>
        </view>
        <view class="meta-pill">
          <text class="meta-key">首要污染物</text>
          <text class="meta-value">{{ airQuality.primaryPollutant }}</text>
        </view>
      </view>

      <view class="advice-box">
        <text class="advice-title">健康建议</text>
        <text class="advice-text">{{ airQuality.advice }}</text>
      </view>
    </view>
  </view>
</page>

<style>
.container {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  min-height: 100vh;
  padding: 12px;
  box-sizing: border-box;
  background-color: #020402;
  color: #dfffe6;
}

.card {
  display: flex;
  width: 449px;
  min-height: 167px;
  flex-direction: column;
  border: 1.5px solid #40ff5e;
  border-radius: 16px;
  padding: 14px;
  box-sizing: border-box;
  background: linear-gradient(135deg, #07120a 0%, #0f2116 100%);
  box-shadow: 0 12px 28px rgba(0, 0, 0, 0.32);
}

.card-head {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: flex-start;
  gap: 12px;
}

.title-group {
  display: flex;
  flex: 1;
  flex-direction: column;
}

.eyebrow {
  font-size: 11px;
  line-height: 14px;
  color: #76d98a;
  text-transform: uppercase;
}

.location-row {
  display: flex;
  flex-direction: row;
  align-items: baseline;
  gap: 8px;
  margin-top: 4px;
}

.location {
  font-size: 26px;
  line-height: 30px;
  font-weight: bold;
  color: #f3fff6;
}

.condition {
  font-size: 13px;
  line-height: 18px;
  color: #9ed8aa;
}

.note {
  margin-top: 6px;
  font-size: 12px;
  line-height: 17px;
  color: #8fb29a;
}

.mock-badge {
  padding: 4px 8px;
  border-radius: 999px;
  background-color: #183823;
  border: 1px solid #2f8f49;
  color: #7cff9a;
  font-size: 11px;
  line-height: 11px;
  font-weight: 700;
}

.hero-row {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  gap: 14px;
  margin-top: 14px;
}

.hero-main {
  display: flex;
  flex-direction: row;
  align-items: baseline;
}

.hero-label {
  font-size: 14px;
  line-height: 18px;
  color: #7fc48f;
}

.hero-aqi {
  margin-left: 10px;
  font-size: 44px;
  line-height: 44px;
  font-weight: 700;
  color: #ffffff;
}

.hero-side {
  display: flex;
  flex-direction: row;
  gap: 8px;
}

.metric-box {
  display: flex;
  min-width: 68px;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 8px 10px;
  border-radius: 12px;
  background-color: rgba(255, 255, 255, 0.05);
}

.metric-label {
  font-size: 11px;
  line-height: 12px;
  color: #8eb299;
}

.metric-value {
  margin-top: 6px;
  font-size: 14px;
  line-height: 16px;
  color: #f3fff6;
  text-align: center;
}

.metric-tight {
  font-size: 12px;
  line-height: 14px;
}

.meta-row {
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
  gap: 8px;
  margin-top: 14px;
}

.meta-pill {
  display: flex;
  flex-direction: row;
  align-items: center;
  padding: 6px 10px;
  border-radius: 999px;
  background-color: rgba(64, 255, 94, 0.08);
  border: 1px solid rgba(64, 255, 94, 0.16);
}

.meta-key {
  font-size: 11px;
  line-height: 14px;
  color: #7fc48f;
}

.meta-value {
  margin-left: 6px;
  font-size: 11px;
  line-height: 14px;
  color: #f0fff4;
}

.advice-box {
  display: flex;
  flex-direction: column;
  margin-top: 16px;
  padding: 12px;
  border-radius: 12px;
  background-color: rgba(255, 255, 255, 0.04);
}

.advice-title {
  font-size: 12px;
  line-height: 14px;
  color: #76d98a;
}

.advice-text {
  margin-top: 8px;
  font-size: 12px;
  line-height: 18px;
  color: #e8fff0;
}
</style>
