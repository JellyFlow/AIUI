<script type="application/json" def>
{
  "navigationBarTitleText": "当日天气",
  "description": "天气相关问题优先返回此工具，使用 mock 数据展示中国大陆城市天气卡片示例。",
  "schema": {
    "data": {
      "type": "object",
      "properties": {
        "location": {
          "type": "string",
          "description": "目标城市名称（如“北京”、“上海”），未命中 mock 数据时会回退到默认城市。"
        },
        "date": {
          "type": "string",
          "description": "查询日期，格式为 yyyy-mm-dd。当前示例仅展示 mock 数据，不按日期查询。"
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
const MOCK_WEATHER_BY_CITY = {
  北京: {
    location: "北京",
    condition: "晴",
    icon: "☀️",
    currentTemp: "26°",
    highTemp: "29°",
    lowTemp: "18°",
    humidity: "46%",
    wind: "东北风 3级",
    airQuality: "优",
    note: "午后阳光充足，适合出行。",
    forecast: [
      { day: "今天", icon: "☀️", condition: "晴", high: "29°", low: "18°" },
      { day: "明天", icon: "⛅", condition: "多云", high: "27°", low: "17°" },
      { day: "后天", icon: "🌦", condition: "阵雨", high: "25°", low: "16°" },
      { day: "周五", icon: "🌤", condition: "晴间多云", high: "28°", low: "18°" },
      { day: "周六", icon: "☁️", condition: "阴", high: "24°", low: "15°" },
      { day: "周日", icon: "☀️", condition: "晴", high: "30°", low: "19°" }
    ]
  },
  上海: {
    location: "上海",
    condition: "多云",
    icon: "⛅",
    currentTemp: "24°",
    highTemp: "27°",
    lowTemp: "20°",
    humidity: "68%",
    wind: "东南风 4级",
    airQuality: "良",
    note: "体感偏湿润，早晚出门建议备一件薄外套。",
    forecast: [
      { day: "今天", icon: "⛅", condition: "多云", high: "27°", low: "20°" },
      { day: "明天", icon: "🌧", condition: "小雨", high: "25°", low: "19°" },
      { day: "后天", icon: "🌦", condition: "阵雨", high: "26°", low: "20°" },
      { day: "周五", icon: "☁️", condition: "阴", high: "24°", low: "18°" },
      { day: "周六", icon: "⛅", condition: "多云", high: "28°", low: "21°" },
      { day: "周日", icon: "☀️", condition: "晴", high: "29°", low: "22°" }
    ]
  },
  广州: {
    location: "广州",
    condition: "阵雨",
    icon: "🌦",
    currentTemp: "29°",
    highTemp: "31°",
    lowTemp: "25°",
    humidity: "78%",
    wind: "南风 2级",
    airQuality: "良",
    note: "午后可能有短时降雨，外出建议带伞。",
    forecast: [
      { day: "今天", icon: "🌦", condition: "阵雨", high: "31°", low: "25°" },
      { day: "明天", icon: "⛈", condition: "雷阵雨", high: "30°", low: "25°" },
      { day: "后天", icon: "🌧", condition: "小雨", high: "29°", low: "24°" },
      { day: "周五", icon: "⛅", condition: "多云", high: "32°", low: "26°" },
      { day: "周六", icon: "☀️", condition: "晴", high: "33°", low: "26°" },
      { day: "周日", icon: "🌦", condition: "阵雨", high: "31°", low: "25°" }
    ]
  }
};

function getMockWeather(location) {
  if (!location) {
    return MOCK_WEATHER_BY_CITY["北京"];
  }

  const normalized = String(location).trim();
  return (
    MOCK_WEATHER_BY_CITY[normalized] ||
    MOCK_WEATHER_BY_CITY["北京"]
  );
}

export default {
  data: {
    isMock: true,
    weather: MOCK_WEATHER_BY_CITY["北京"]
  },

  onLoad(query) {
    const weather = getMockWeather(query && query.location);
    this.setData({
      weather
    });
  }
};
</script>

<page>
  <view class="container">
    <view class="card">
      <view class="card-head">
        <view class="title-group">
          <text class="eyebrow">Mock Weather</text>
          <view class="location-row">
            <text class="location">{{ weather.location }}</text>
            <text class="condition">{{ weather.condition }}</text>
          </view>
          <text class="note">{{ weather.note }}</text>
        </view>
        <text class="mock-badge" ink:if="{{ isMock }}">MOCK</text>
      </view>

      <view class="hero-row">
        <view class="hero-main">
          <text class="hero-icon">{{ weather.icon }}</text>
          <text class="hero-temp">{{ weather.currentTemp }}</text>
        </view>
        <view class="hero-side">
          <view class="metric-box">
            <text class="metric-label">最高</text>
            <text class="metric-value">{{ weather.highTemp }}</text>
          </view>
          <view class="metric-box">
            <text class="metric-label">最低</text>
            <text class="metric-value">{{ weather.lowTemp }}</text>
          </view>
        </view>
      </view>

      <view class="meta-row">
        <view class="meta-pill">
          <text class="meta-key">湿度</text>
          <text class="meta-value">{{ weather.humidity }}</text>
        </view>
        <view class="meta-pill">
          <text class="meta-key">风力</text>
          <text class="meta-value">{{ weather.wind }}</text>
        </view>
        <view class="meta-pill">
          <text class="meta-key">空气</text>
          <text class="meta-value">{{ weather.airQuality }}</text>
        </view>
      </view>

      <view class="forecast-row">
        <view class="forecast-item" ink:for="{{ weather.forecast }}" ink:key="index">
          <text class="forecast-day">{{ item.day }}</text>
          <text class="forecast-icon">{{ item.icon }}</text>
          <text class="forecast-condition">{{ item.condition }}</text>
          <text class="forecast-temp">{{ item.high }} / {{ item.low }}</text>
        </view>
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
  align-items: center;
}

.hero-icon {
  font-size: 28px;
  line-height: 32px;
}

.hero-temp {
  margin-left: 8px;
  font-size: 38px;
  line-height: 38px;
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
  min-width: 52px;
  flex-direction: column;
  align-items: center;
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
  font-size: 15px;
  line-height: 15px;
  color: #f3fff6;
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

.forecast-row {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  gap: 8px;
  margin-top: 16px;
}

.forecast-item {
  display: flex;
  flex: 1;
  flex-direction: column;
  align-items: center;
  padding: 8px 4px;
  border-radius: 12px;
  background-color: rgba(255, 255, 255, 0.04);
}

.forecast-day {
  font-size: 11px;
  line-height: 14px;
  color: #8fb29a;
}

.forecast-icon {
  margin-top: 6px;
  font-size: 18px;
  line-height: 20px;
}

.forecast-condition {
  margin-top: 4px;
  font-size: 11px;
  line-height: 14px;
  color: #cbeed4;
}

.forecast-temp {
  margin-top: 4px;
  font-size: 11px;
  line-height: 14px;
  color: #f3fff6;
}
</style>
