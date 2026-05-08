<script type="application/json" def>
{
  "navigationBarTitleText": "饮食推荐",
  "description": "根据当前本地时间自动推荐一道适合当前时间段的菜品，使用 mock 数据展示卡片样式。",
  "schema": {
    "data": {
      "type": "object",
      "properties": {
        "meal": {
          "type": "string",
          "description": "饮食分类，表示早餐、午餐、晚餐或夜宵。"
        },
        "food": {
          "type": "string",
          "description": "可选的食品名称；传入后可作为当前卡片的指定推荐菜品。"
        },
        "tip": {
          "type": "string",
          "description": "饮食贴士，用于补充当前推荐卡片的说明文案。"
        }
      },
      "required": [
        "meal"
      ]
    }
  }
}
</script>

<script setup>
const PERIODS = [
  {
    key: "breakfast",
    label: "早餐时段",
    hours: [5, 10],
    greeting: "早上好，来一份轻盈开胃的早餐",
    meal: {
      name: "番茄鸡蛋面",
      subtitle: "热汤顺口，醒胃不负担",
      emoji: "🍜",
      reason: "早晨更适合温热、易消化的主食，番茄的微酸和鸡蛋的蛋白质组合能快速补充能量。",
      pairWith: "搭配一杯温豆浆或无糖酸奶更合适",
      tags: ["热乎", "高蛋白", "易消化"]
    }
  },
  {
    key: "lunch",
    label: "午餐时段",
    hours: [10, 15],
    greeting: "中午补充能量，推荐一份扎实主菜",
    meal: {
      name: "黑椒牛肉饭",
      subtitle: "香气足，饱腹感刚刚好",
      emoji: "🍛",
      reason: "午餐适合吃得更均衡一些，牛肉补充蛋白质与铁元素，搭配米饭能更稳定地支撑下午精力。",
      pairWith: "搭配一份西兰花或玉米杯会更均衡",
      tags: ["饱腹", "能量补给", "咸香"]
    }
  },
  {
    key: "dinner",
    label: "晚餐时段",
    hours: [15, 22],
    greeting: "晚上适合吃得满足，但别太油腻",
    meal: {
      name: "香煎三文鱼配时蔬",
      subtitle: "鲜香清爽，适合收尾一天",
      emoji: "🥗",
      reason: "晚餐更适合清爽但有满足感的搭配，三文鱼口感细腻，配时蔬能控制负担又保留营养。",
      pairWith: "搭配一碗南瓜汤或糙米饭更舒服",
      tags: ["清爽", "高蛋白", "低负担"]
    }
  },
  {
    key: "lateNight",
    label: "夜宵时段",
    hours: [22, 24],
    greeting: "如果有点饿，夜宵尽量简单一点",
    meal: {
      name: "菌菇鸡丝粥",
      subtitle: "暖胃柔和，夜里吃也不重",
      emoji: "🥣",
      reason: "夜宵更适合少油少刺激的食物，粥类更容易消化，能缓解饥饿感也不容易造成太强负担。",
      pairWith: "搭配几片黄瓜或少量小菜即可",
      tags: ["暖胃", "柔和", "低刺激"]
    }
  }
];

function padNumber(value) {
  return value < 10 ? `0${value}` : String(value);
}

function getPeriodByHour(hour) {
  if (hour >= 0 && hour < 5) {
    return PERIODS[3];
  }

  for (let i = 0; i < PERIODS.length; i += 1) {
    const period = PERIODS[i];
    if (hour >= period.hours[0] && hour < period.hours[1]) {
      return period;
    }
  }

  return PERIODS[0];
}

function normalizeText(value) {
  return typeof value === "string" ? value.trim() : "";
}

function getPeriodByMeal(meal) {
  const normalized = normalizeText(meal).toLowerCase();
  const mealMap = {
    breakfast: "breakfast",
    "早餐": "breakfast",
    "早餐时段": "breakfast",
    lunch: "lunch",
    "午餐": "lunch",
    "午餐时段": "lunch",
    dinner: "dinner",
    "晚餐": "dinner",
    "晚餐时段": "dinner",
    latenight: "lateNight",
    "late-night": "lateNight",
    "late_night": "lateNight",
    "夜宵": "lateNight",
    "夜宵时段": "lateNight",
    "宵夜": "lateNight"
  };
  const periodKey = mealMap[normalized];

  if (!periodKey) {
    return null;
  }

  for (let i = 0; i < PERIODS.length; i += 1) {
    if (PERIODS[i].key === periodKey) {
      return PERIODS[i];
    }
  }

  return null;
}

function buildRecommendation(query) {
  const now = new Date();
  const hour = now.getHours();
  const minute = now.getMinutes();
  const input = query || {};
  const period = getPeriodByMeal(input.meal) || getPeriodByHour(hour);
  const food = normalizeText(input.food);
  const tip = normalizeText(input.tip);
  const meal = {
    ...period.meal
  };

  if (food) {
    meal.name = food;
  }

  if (tip) {
    meal.pairWith = tip;
  }

  return {
    currentTime: `${padNumber(hour)}:${padNumber(minute)}`,
    periodLabel: period.label,
    greeting: period.greeting,
    meal
  };
}

export default {
  data: {
    recommendation: buildRecommendation()
  },

  onLoad(query) {
    this.setData({
      recommendation: buildRecommendation(query)
    });
  }
};
</script>

<page>
  <view class="container">
    <view class="card">
      <view class="card-head">
        <view class="title-group">
          <text class="eyebrow">Meal Suggestion</text>
          <text class="time">{{ recommendation.currentTime }}</text>
          <text class="period">{{ recommendation.periodLabel }}</text>
          <text class="greeting">{{ recommendation.greeting }}</text>
        </view>
        <view class="dish-mark">
          <text class="dish-emoji">{{ recommendation.meal.emoji }}</text>
        </view>
      </view>

      <view class="dish-section">
        <text class="dish-name">{{ recommendation.meal.name }}</text>
        <text class="dish-subtitle">{{ recommendation.meal.subtitle }}</text>
      </view>

      <view class="reason-box">
        <text class="section-title">推荐理由</text>
        <text class="reason-text">{{ recommendation.meal.reason }}</text>
      </view>

      <view class="tags-row">
        <view class="tag" ink:for="{{ recommendation.meal.tags }}" ink:key="index">
          <text class="tag-text">{{ item }}</text>
        </view>
      </view>

      <view class="pair-box">
        <text class="section-title">建议搭配</text>
        <text class="pair-text">{{ recommendation.meal.pairWith }}</text>
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
  background:
    radial-gradient(circle at top, rgba(255, 187, 92, 0.20), transparent 36%),
    linear-gradient(180deg, #21120a 0%, #120b08 100%);
  color: #fff5ea;
}

.card {
  display: flex;
  width: 449px;
  min-height: 167px;
  flex-direction: column;
  padding: 16px;
  box-sizing: border-box;
  border-radius: 18px;
  border: 1.5px solid rgba(255, 182, 96, 0.55);
  background: linear-gradient(145deg, rgba(49, 26, 16, 0.96) 0%, rgba(27, 16, 12, 0.98) 100%);
  box-shadow: 0 16px 32px rgba(0, 0, 0, 0.30);
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
  text-transform: uppercase;
  color: #ffca8c;
}

.time {
  margin-top: 4px;
  font-size: 14px;
  line-height: 18px;
  color: #ffdcb3;
}

.period {
  margin-top: 4px;
  font-size: 26px;
  line-height: 30px;
  font-weight: 700;
  color: #fff9f2;
}

.greeting {
  margin-top: 6px;
  font-size: 12px;
  line-height: 17px;
  color: #f1cfa8;
}

.dish-mark {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 52px;
  height: 52px;
  border-radius: 16px;
  background: linear-gradient(180deg, rgba(255, 185, 107, 0.22) 0%, rgba(255, 140, 63, 0.14) 100%);
  border: 1px solid rgba(255, 197, 132, 0.28);
}

.dish-emoji {
  font-size: 28px;
  line-height: 28px;
}

.dish-section {
  display: flex;
  flex-direction: column;
  margin-top: 16px;
}

.dish-name {
  font-size: 32px;
  line-height: 36px;
  font-weight: 700;
  color: #ffffff;
}

.dish-subtitle {
  margin-top: 6px;
  font-size: 13px;
  line-height: 18px;
  color: #f3d8bc;
}

.reason-box,
.pair-box {
  display: flex;
  flex-direction: column;
  margin-top: 14px;
  padding: 12px;
  border-radius: 14px;
  background-color: rgba(255, 255, 255, 0.05);
}

.section-title {
  font-size: 11px;
  line-height: 14px;
  color: #ffca8c;
}

.reason-text,
.pair-text {
  margin-top: 6px;
  font-size: 12px;
  line-height: 18px;
  color: #fff0e0;
}

.tags-row {
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
  gap: 8px;
  margin-top: 14px;
}

.tag {
  display: flex;
  flex-direction: row;
  align-items: center;
  padding: 6px 10px;
  border-radius: 999px;
  background-color: rgba(255, 188, 117, 0.12);
  border: 1px solid rgba(255, 188, 117, 0.18);
}

.tag-text {
  font-size: 11px;
  line-height: 14px;
  color: #ffe6c7;
}
</style>
