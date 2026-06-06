const TRAFFIC_BASELINE = 1840;
const CONVERSION_BASELINE = 0.184;
const LATENCY_BASELINE = 132;
const SATISFACTION_BASELINE = 92;
const WINDOW_POINT_COUNT = 120;
const TICK_MS = 60 * 1000;
const WINDOW_SPAN_MS = (WINDOW_POINT_COUNT - 1) * TICK_MS;
const DASHBOARD_REFRESH_MS = 2000;

function clamp(value, minimum, maximum) {
  return Math.max(minimum, Math.min(maximum, value));
}

function formatMinutesToTime(totalMinutes) {
  const hour = String(Math.floor(totalMinutes / 60)).padStart(2, '0');
  const minute = String(totalMinutes % 60).padStart(2, '0');
  return `${hour}:${minute}`;
}

function toUtcDayTimestamp(year, month, day) {
  return Date.UTC(year, month - 1, day);
}

function formatCompactNumber(value) {
  if (value >= 10000) {
    return `${(value / 1000).toFixed(1).replace('.0', '')}k`;
  }
  return String(Math.round(value));
}

function formatSigned(value, suffix = '', fractionDigits = 0) {
  const sign = value > 0 ? '+' : value < 0 ? '-' : '';
  const absolute = Math.abs(value).toFixed(fractionDigits).replace(/\.0+$/, '');
  return `${sign}${absolute}${suffix}`;
}

function buildTrafficData(pointCount, startTime = '08:00', baseTraffic = TRAFFIC_BASELINE) {
  const [hourText, minuteText] = startTime.split(':');
  let totalMinutes = Number(hourText) * 60 + Number(minuteText);
  const points = [];

  for (let index = 0; index < pointCount; index += 1) {
    const trafficWave =
      Math.sin(index / 6) * 92 + Math.cos(index / 11) * 48 + Math.sin(index / 18) * 24;
    const traffic = Math.round(
      clamp(baseTraffic + trafficWave, baseTraffic - 280, baseTraffic + 320),
    );
    const conversion = Number(
      clamp(
        CONVERSION_BASELINE + Math.sin(index / 9) * 0.02 + Math.cos(index / 15) * 0.007,
        0.13,
        0.26,
      ).toFixed(3),
    );
    const latency = Math.round(
      clamp(LATENCY_BASELINE + Math.cos(index / 8) * 11 + Math.sin(index / 14) * 6, 96, 196),
    );
    const satisfaction = Number(
      clamp(
        SATISFACTION_BASELINE + Math.sin(index / 10) * 1.9 - (latency - LATENCY_BASELINE) * 0.02,
        87,
        96,
      ).toFixed(1),
    );

    points.push({
      time: formatMinutesToTime(totalMinutes),
      ts: totalMinutes * 60 * 1000,
      traffic,
      conversion,
      latency,
      satisfaction,
      baseline: baseTraffic,
    });
    totalMinutes += 1;
  }

  return points;
}

function getTrafficTrendColor(points, baseline = TRAFFIC_BASELINE) {
  const latestTraffic = points[points.length - 1]?.traffic ?? baseline;
  return latestTraffic >= baseline
    ? 'var(--chart-positive-color, #00C853)'
    : 'var(--chart-negative-color, #F44336)';
}

function resolveViewportBounds(data) {
  const firstTs = data[0]?.ts ?? 0;
  const latestTs = data[data.length - 1]?.ts ?? firstTs;
  const openingMaximum = firstTs + WINDOW_SPAN_MS;

  if (latestTs <= openingMaximum) {
    return {
      minimum: firstTs,
      maximum: openingMaximum,
    };
  }

  return {
    minimum: latestTs - WINDOW_SPAN_MS,
    maximum: latestTs,
  };
}

function createRealtimeChartProps(data) {
  const { minimum, maximum } = resolveViewportBounds(data);
  const color = getTrafficTrendColor(data);

  return {
    type: 'line',
    series: [
      {
        yName: 'traffic',
        xName: 'ts',
        color,
        width: 2,
        smooth: true,
      },
    ],
    data,
    animate: false,
    yAxis: {
      minimum: TRAFFIC_BASELINE - 320,
      maximum: TRAFFIC_BASELINE + 320,
      showAxisLine: false,
      showGridLines: false,
      showLabels: false,
      showTicks: false,
      stripLines: [
        {
          start: TRAFFIC_BASELINE,
          color: 'var(--chart-page-strip-line-color, var(--chart-reference-color, #FBC02D))',
          width: 1,
          dashArray: [6, 4],
        },
      ],
    },
    xAxis: {
      valueType: 'DateTime',
      minimum,
      maximum,
    },
  };
}

function createRetentionChartProps(data) {
  return {
    type: 'area',
    series: [
      {
        yName: 'score',
        xName: 'ts',
      },
    ],
    data,
    smooth: true,
    yAxis: {
      minimum: 60,
      maximum: 100,
      tickCount: 5,
      showAxisLine: false,
      showGridLines: true,
      showLabels: true,
      showTicks: false,
    },
    xAxis: {
      valueType: 'DateTime',
      showAxisLine: true,
      showLabels: true,
      showTicks: false,
      tickCount: 4,
    },
  };
}

function createCategoryBarChartProps(data) {
  return {
    type: 'bar',
    direction: 'vertical',
    series: [
      {
        yName: 'gmv',
      },
    ],
    data,
    yAxis: {
      minimum: 0,
      maximum: 180,
      tickCount: 5,
      showAxisLine: false,
      showGridLines: true,
      showLabels: true,
      showTicks: false,
      labelFormat: 'compact',
    },
    xAxis: {
      showAxisLine: true,
      showLabels: true,
      showTicks: false,
    },
  };
}

function createChannelBarChartProps(data) {
  return {
    type: 'bar',
    direction: 'horizontal',
    series: [
      {
        yName: 'value',
      },
    ],
    data,
    yAxis: {
      minimum: 0,
      maximum: 100,
      tickCount: 5,
      showAxisLine: false,
      showGridLines: false,
      showLabels: false,
      showTicks: false,
    },
    xAxis: {
      showAxisLine: false,
      showGridLines: true,
      showLabels: true,
      showTicks: false,
    },
  };
}

function createSegmentScatterChartProps(data) {
  return {
    type: 'scatter',
    series: [
      {
        yName: 'retention',
        xName: 'activation',
      },
      {
        yName: 'goal',
        xName: 'activation',
      },
    ],
    data,
    pointSize: 4,
    yAxis: {
      minimum: 20,
      maximum: 75,
      tickCount: 6,
      showAxisLine: true,
      showGridLines: true,
      showLabels: true,
      showTicks: false,
    },
    xAxis: {
      minimum: 10,
      maximum: 60,
      tickCount: 6,
      showAxisLine: true,
      showGridLines: true,
      showLabels: true,
      showTicks: false,
    },
  };
}

function buildDashboardMetrics(point) {
  const trafficDelta = point.traffic - TRAFFIC_BASELINE;
  const conversionDelta = (point.conversion - CONVERSION_BASELINE) * 100;
  const latencyDelta = point.latency - LATENCY_BASELINE;
  const satisfactionDelta = point.satisfaction - SATISFACTION_BASELINE;

  return {
    sessionMetric: {
      label: '实时会话',
      value: formatCompactNumber(point.traffic),
      delta: formatSigned(trafficDelta),
      tone: trafficDelta >= 0 ? 'positive' : 'negative',
      hint: '近 1 分钟活跃会话',
    },
    conversionMetric: {
      label: '即时转化率',
      value: `${(point.conversion * 100).toFixed(1)}%`,
      delta: formatSigned(conversionDelta, 'pp', 1),
      tone: conversionDelta >= 0 ? 'positive' : 'negative',
      hint: '详情到下单',
    },
    latencyMetric: {
      label: '平均响应',
      value: `${Math.round(point.latency)}ms`,
      delta: formatSigned(latencyDelta, 'ms'),
      tone: latencyDelta <= 0 ? 'positive' : 'negative',
      hint: '入口接口耗时',
    },
    satisfactionMetric: {
      label: '满意度',
      value: `${Math.round(point.satisfaction)}分`,
      delta: formatSigned(satisfactionDelta, '分'),
      tone: satisfactionDelta >= 0 ? 'positive' : 'negative',
      hint: '最近 30 分钟问卷',
    },
  };
}

function mutateSeriesValue(data, key, minimum, maximum, magnitude) {
  return (Array.isArray(data) ? data : []).map((point, index) => ({
    ...point,
    [key]: Math.round(
      clamp(
        point[key] +
          Math.sin((index + Date.now() / 1000) / 4) * magnitude +
          (Math.random() - 0.5) * magnitude,
        minimum,
        maximum,
      ),
    ),
  }));
}

const TRAFFIC_SAMPLE_DATA = buildTrafficData(180);
const INITIAL_TRAFFIC_WINDOW = TRAFFIC_SAMPLE_DATA.slice(-WINDOW_POINT_COUNT);
const INITIAL_METRICS = buildDashboardMetrics(
  INITIAL_TRAFFIC_WINDOW[INITIAL_TRAFFIC_WINDOW.length - 1],
);
const VIEWPORT_STORY_SAMPLES = {
  launch: createRealtimeChartProps(TRAFFIC_SAMPLE_DATA.slice(0, 1)),
  rampUp: createRealtimeChartProps(TRAFFIC_SAMPLE_DATA.slice(0, 45)),
  fullWindow: createRealtimeChartProps(TRAFFIC_SAMPLE_DATA.slice(0, WINDOW_POINT_COUNT)),
  rollingWindow: createRealtimeChartProps(TRAFFIC_SAMPLE_DATA.slice()),
};
const RETENTION_SAMPLE_DATA = [
  { ts: toUtcDayTimestamp(2026, 5, 25), score: 72 },
  { ts: toUtcDayTimestamp(2026, 5, 26), score: 76 },
  { ts: toUtcDayTimestamp(2026, 5, 27), score: 74 },
  { ts: toUtcDayTimestamp(2026, 5, 28), score: 79 },
  { ts: toUtcDayTimestamp(2026, 5, 29), score: 84 },
  { ts: toUtcDayTimestamp(2026, 5, 30), score: 87 },
  { ts: toUtcDayTimestamp(2026, 5, 31), score: 82 },
];
const CATEGORY_SAMPLE_DATA = [
  { label: '运动健康', gmv: 148 },
  { label: '通勤提醒', gmv: 116 },
  { label: '陪伴聊天', gmv: 102 },
  { label: '音乐播报', gmv: 81 },
];
const CHANNEL_SAMPLE_DATA = [
  { label: '自然推荐', value: 92 },
  { label: 'Push 回流', value: 78 },
  { label: '搜索入口', value: 64 },
  { label: '伙伴分发', value: 51 },
];
const SEGMENT_SAMPLE_DATA = [
  { activation: 16, retention: 28, goal: 32 },
  { activation: 22, retention: 37, goal: 36 },
  { activation: 30, retention: 41, goal: 45 },
  { activation: 36, retention: 54, goal: 48 },
  { activation: 43, retention: 58, goal: 56 },
  { activation: 51, retention: 61, goal: 62 },
];
const FUNNEL_SAMPLE_DATA = [
  { stage: '曝光', amount: 12400 },
  { stage: '到达详情', amount: 6020 },
  { stage: '发起咨询', amount: 2310 },
  { stage: '确认下单', amount: 960 },
];
const SOURCE_MIX_DATA = [{ value: 34 }, { value: 27 }, { value: 21 }, { value: 18 }];
const RADAR_SAMPLE_DATA = [
  { label: '发现', value: 84 },
  { label: '转化', value: 76 },
  { label: '留存', value: 72 },
  { label: '服务', value: 88 },
  { label: '交付', value: 81 },
  { label: '稳定性', value: 90 },
];

export default {
  data: {
    updateMode: 'all',
    updateModeLabel: '全局刷新',
    sessionMetric: INITIAL_METRICS.sessionMetric,
    conversionMetric: INITIAL_METRICS.conversionMetric,
    latencyMetric: INITIAL_METRICS.latencyMetric,
    satisfactionMetric: INITIAL_METRICS.satisfactionMetric,
    liveTrafficChartProps: createRealtimeChartProps(INITIAL_TRAFFIC_WINDOW),
    retentionChartProps: createRetentionChartProps(RETENTION_SAMPLE_DATA),
    categoryBarChartProps: createCategoryBarChartProps(CATEGORY_SAMPLE_DATA),
    channelBarChartProps: createChannelBarChartProps(CHANNEL_SAMPLE_DATA),
    segmentScatterChartProps: createSegmentScatterChartProps(SEGMENT_SAMPLE_DATA),
    funnelChartProps: {
      type: 'funnel',
      data: FUNNEL_SAMPLE_DATA,
      labelKey: 'stage',
      valueKey: 'amount',
      showConversion: true,
    },
    sourceMixData: SOURCE_MIX_DATA,
    radarData: RADAR_SAMPLE_DATA,
    liveChartWidth: 350,
    liveChartHeight: 120,
    sampleChartWidth: 350,
    sampleChartHeight: 64,
    viewportStorySamples: VIEWPORT_STORY_SAMPLES,
  },
  onLoad() {
    const flushPendingTick = () => {
      const refreshAllCharts = this.data.updateMode === 'all';
      const currentChartProps = this.data.liveTrafficChartProps || createRealtimeChartProps([]);
      const currentData =
        Array.isArray(currentChartProps.data) && currentChartProps.data.length > 0
          ? currentChartProps.data
          : buildTrafficData(1);
      const lastPoint = currentData[currentData.length - 1];
      const nextTs = (lastPoint?.ts ?? 0) + TICK_MS;
      const totalMinutes = Math.floor(nextTs / (60 * 1000));
      const frame = currentData.length;
      const projectedTraffic = Math.round(
        clamp(
          lastPoint.traffic +
            Math.sin(frame / 4) * 32 +
            Math.cos(frame / 7) * 18 +
            (Math.random() - 0.5) * 48 +
            (TRAFFIC_BASELINE - lastPoint.traffic) * 0.15,
          TRAFFIC_BASELINE - 300,
          TRAFFIC_BASELINE + 330,
        ),
      );
      const projectedConversion = Number(
        clamp(
          lastPoint.conversion +
            Math.sin(frame / 6) * 0.005 +
            (Math.random() - 0.5) * 0.008 +
            (CONVERSION_BASELINE - lastPoint.conversion) * 0.12,
          0.13,
          0.26,
        ).toFixed(3),
      );
      const projectedLatency = Math.round(
        clamp(
          lastPoint.latency +
            Math.cos(frame / 5) * 4 +
            (Math.random() - 0.5) * 8 -
            (projectedTraffic - TRAFFIC_BASELINE) * 0.01,
          96,
          198,
        ),
      );
      const projectedSatisfaction = Number(
        clamp(
          lastPoint.satisfaction +
            (projectedConversion - CONVERSION_BASELINE) * 8 -
            (projectedLatency - LATENCY_BASELINE) * 0.02 +
            (Math.random() - 0.5) * 1.2,
          87,
          96,
        ).toFixed(1),
      );

      const nextPoint = {
        time: formatMinutesToTime(totalMinutes),
        ts: nextTs,
        traffic: projectedTraffic,
        conversion: projectedConversion,
        latency: projectedLatency,
        satisfaction: projectedSatisfaction,
        baseline: TRAFFIC_BASELINE,
      };

      const appended = [...currentData, nextPoint];
      const { minimum, maximum } = resolveViewportBounds(appended);
      const nextTrafficData = appended.filter(
        (point) => point.ts >= minimum && point.ts <= maximum,
      );
      const nextMetrics = buildDashboardMetrics(nextPoint);
      const trendColor = getTrafficTrendColor(nextTrafficData, TRAFFIC_BASELINE);

      const nextState = {
        liveTrafficChartProps: {
          ...currentChartProps,
          data: nextTrafficData,
          series: (Array.isArray(currentChartProps.series) ? currentChartProps.series : []).map(
            (series, index) => (index === 0 ? { ...series, color: trendColor } : series),
          ),
          xAxis: {
            ...(currentChartProps.xAxis || {}),
            minimum,
            maximum,
          },
        },
        sessionMetric: nextMetrics.sessionMetric,
        conversionMetric: nextMetrics.conversionMetric,
        latencyMetric: nextMetrics.latencyMetric,
        satisfactionMetric: nextMetrics.satisfactionMetric,
      };

      if (refreshAllCharts) {
        nextState.retentionChartProps = {
          ...this.data.retentionChartProps,
          data: mutateSeriesValue(this.data.retentionChartProps?.data, 'score', 68, 92, 2),
        };
        nextState.channelBarChartProps = {
          ...this.data.channelBarChartProps,
          data: mutateSeriesValue(this.data.channelBarChartProps?.data, 'value', 42, 95, 3),
        };
      }

      this.setData(nextState);
    };

    this.timer = setInterval(flushPendingTick, DASHBOARD_REFRESH_MS);
  },
  toggleUpdateMode() {
    const nextMode = this.data.updateMode === 'realtime-only' ? 'all' : 'realtime-only';
    this.setData({
      updateMode: nextMode,
      updateModeLabel: nextMode === 'all' ? '全局刷新' : '仅实时卡片',
    });
  },
  onUnload() {
    if (this.timer) {
      clearInterval(this.timer);
    }
  },
};
