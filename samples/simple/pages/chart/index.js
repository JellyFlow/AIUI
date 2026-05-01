const BASE_PRICE = 100;
const WINDOW_POINT_COUNT = 240;
const TICK_MS = 60 * 1000;
const WINDOW_SPAN_MS = (WINDOW_POINT_COUNT - 1) * TICK_MS;

function formatMinutesToTime(totalMinutes) {
  const hour = String(Math.floor(totalMinutes / 60)).padStart(2, '0');
  const minute = String(totalMinutes % 60).padStart(2, '0');
  return `${hour}:${minute}`;
}

function buildIntradayData(pointCount, startTime = '09:30', basePrice = BASE_PRICE) {
  const [hourText, minuteText] = startTime.split(':');
  let totalMinutes = Number(hourText) * 60 + Number(minuteText);
  const points = [];

  for (let i = 0; i < pointCount; i += 1) {
    const wave = Math.sin(i / 20) * 2.8 + Math.cos(i / 13) * 1.6 + Math.sin(i / 55) * 0.6;
    const price = Number((basePrice + wave).toFixed(2));
    points.push({
      time: formatMinutesToTime(totalMinutes),
      ts: totalMinutes * 60 * 1000,
      price,
      avg: basePrice,
    });
    totalMinutes += 1;
  }

  return points;
}

function getTrendColor(points, basePrice = BASE_PRICE) {
  const lastPrice = points[points.length - 1]?.price ?? basePrice;
  return lastPrice >= basePrice
    ? 'var(--chart-negative-color, #F44336)'
    : 'var(--chart-positive-color, #00C853)';
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

function mutateLineChartData(data) {
  return (Array.isArray(data) ? data : []).map((point) => ({
    ...point,
    rate: Number(Math.max(0, Math.min(0.6, point.rate + (Math.random() - 0.5) * 0.08)).toFixed(2)),
  }));
}

function mutateAreaChartData(data) {
  return (Array.isArray(data) ? data : []).map((point) => ({
    ...point,
    score: Math.max(0, Math.min(36, Math.round(point.score + (Math.random() - 0.5) * 8))),
  }));
}

function createWindowChartProps(data) {
  const color = getTrendColor(data);
  const { minimum, maximum } = resolveViewportBounds(data);
  return {
    type: 'line',
    series: [
      {
        yName: 'price',
        xName: 'ts',
        color,
        width: 2,
        smooth: true,
      },
    ],
    data,
    animate: false,
    yAxis: {
      minimum: BASE_PRICE - 6,
      maximum: BASE_PRICE + 6,
      showAxisLine: false,
      showGridLines: false,
      showLabels: false,
      showTicks: false,
      stripLines: [
        {
          start: BASE_PRICE,
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

const INTRADAY_SAMPLE_DATA = buildIntradayData(320);
const INTRADAY_WINDOW_SAMPLES = {
  opening: createWindowChartProps(INTRADAY_SAMPLE_DATA.slice(0, 1)),
  midSession: createWindowChartProps(INTRADAY_SAMPLE_DATA.slice(0, 120)),
  fullWindow: createWindowChartProps(INTRADAY_SAMPLE_DATA.slice(0, 240)),
  rollingWindow: createWindowChartProps(INTRADAY_SAMPLE_DATA.slice()),
};
const BAR_SAMPLE_DATA = [
  { label: '美式', volume: 520 },
  { label: '卡布奇诺', volume: 1500 },
  { label: '拿铁', volume: 220 },
  { label: '绿茶', volume: 2250 },
];
const HORIZONTAL_BAR_DATA = [
  { label: '金融保险', volume: 1234 },
  { label: '医疗卫生', volume: 1083 },
  { label: '社会公共管理', volume: 672 },
  { label: 'IT 通讯电子', volume: 301 },
  { label: '教育', volume: 167 },
];
const LINE_AXIS_DATA = [
  { year: 1990, rate: 0.24 },
  { year: 1994, rate: 0.27 },
  { year: 1998, rate: 0.21 },
  { year: 2002, rate: 0.33 },
  { year: 2006, rate: 0.39 },
  { year: 2008, rate: 0.34 },
  { year: 2010, rate: 0.41 },
];
const AREA_AXIS_DATA = [
  { year: 2018, score: 12 },
  { year: 2019, score: 18 },
  { year: 2020, score: 16 },
  { year: 2021, score: 24 },
  { year: 2022, score: 29 },
  { year: 2023, score: 34 },
];
const SCATTER_SAMPLE_DATA = [
  { x: 12, score: 18, benchmark: 14 },
  { x: 18, score: 28, benchmark: 24 },
  { x: 24, score: 22, benchmark: 30 },
  { x: 30, score: 35, benchmark: 33 },
  { x: 36, score: 44, benchmark: 38 },
  { x: 42, score: 39, benchmark: 46 },
];
const FUNNEL_SAMPLE_DATA = [
  { stage: '曝光', amount: 1250 },
  { stage: '点击', amount: 860 },
  { stage: '加购', amount: 420 },
  { stage: '购买', amount: 168 },
];

export default {
  data: {
    updateMode: 'all',
    lineChartProps: {
      type: 'line',
      series: [
        {
          yName: 'rate',
          xName: 'year',
        },
      ],
      data: LINE_AXIS_DATA,
      smooth: true,
      yAxis: {
        minimum: 0,
        maximum: 0.6,
        tickCount: 6,
        showAxisLine: false,
        showGridLines: true,
        showLabels: true,
        showTicks: false,
        labelFormat: 'percent',
      },
      xAxis: {
        showAxisLine: true,
        showLabels: true,
        showTicks: false,
        tickCount: 6,
      },
    },
    areaChartProps: {
      type: 'area',
      series: [
        {
          yName: 'score',
          xName: 'year',
        },
      ],
      data: AREA_AXIS_DATA,
      smooth: false,
      yAxis: {
        minimum: 0,
        maximum: 36,
        tickCount: 5,
        showAxisLine: false,
        showGridLines: true,
        showLabels: true,
        showTicks: false,
      },
      xAxis: {
        showAxisLine: true,
        showLabels: true,
        showTicks: false,
        tickCount: 6,
        title: '年度',
      },
    },
    scatterChartProps: {
      type: 'scatter',
      series: [
        {
          yName: 'score',
          xName: 'x',
        },
        {
          yName: 'benchmark',
          xName: 'x',
        },
      ],
      data: SCATTER_SAMPLE_DATA,
      pointSize: 4,
      yAxis: {
        minimum: 0,
        maximum: 50,
        tickCount: 6,
        showAxisLine: true,
        showGridLines: true,
        showLabels: true,
        showTicks: false,
      },
      xAxis: {
        minimum: 10,
        maximum: 45,
        tickCount: 6,
        showAxisLine: true,
        showGridLines: true,
        showLabels: true,
        showTicks: false,
      },
    },
    funnelChartProps: {
      type: 'funnel',
      data: FUNNEL_SAMPLE_DATA,
      labelKey: 'stage',
      valueKey: 'amount',
      showConversion: true,
    },
    barVerticalChartProps: {
      type: 'bar',
      direction: 'vertical',
      series: [
        {
          yName: 'volume',
        },
      ],
      data: BAR_SAMPLE_DATA,
      yAxis: {
        minimum: 0,
        maximum: 2500,
        tickCount: 6,
        showAxisLine: true,
        showGridLines: true,
        showLabels: true,
        labelFormat: 'compact',
      },
      xAxis: {
        showAxisLine: true,
        showLabels: true,
      },
    },
    barHorizontalChartProps: {
      type: 'bar',
      direction: 'horizontal',
      series: [
        {
          yName: 'volume',
        },
      ],
      data: HORIZONTAL_BAR_DATA,
      yAxis: {
        minimum: 0,
        maximum: 1400,
        tickCount: 5,
        showAxisLine: false,
        showGridLines: false,
        showLabels: false,
        showTicks: false,
        title: '销量（M）',
      },
      xAxis: {
        showAxisLine: false,
        showGridLines: false,
        showLabels: true,
        showTicks: false,
      },
    },
    priceChartWidth: 350,
    priceChartHeight: 80,
    chartProps: createWindowChartProps([
      { time: '09:30', ts: 9.5 * 3600 * 1000, price: BASE_PRICE, avg: BASE_PRICE },
    ]),
    intradaySampleWidth: 350,
    intradaySampleHeight: 60,
    intradayWindowSamples: INTRADAY_WINDOW_SAMPLES,
    pieData: [{ value: 30 }, { value: 20 }, { value: 50 }],
    radarData: [
      { label: 'Design', value: 90 },
      { label: 'Development', value: 80 },
      { label: 'Marketing', value: 55 },
      { label: 'Users', value: 40 },
      { label: 'Test', value: 62 },
      { label: 'Language', value: 78 },
      { label: 'Technology', value: 48 },
      { label: 'Support', value: 28 },
      { label: 'Sales', value: 70 },
      { label: 'UX', value: 58 },
    ],
  },
  onLoad() {
    console.log('Chart test page loaded');
    const flushPendingTick = () => {
      const refreshAllCharts = this.data.updateMode === 'all';
      const currentChartProps = this.data.chartProps || createWindowChartProps([]);
      const currentPriceData =
        Array.isArray(currentChartProps.data) && currentChartProps.data.length > 0
          ? currentChartProps.data
          : [{ time: '09:30', ts: 9.5 * 3600 * 1000, price: BASE_PRICE, avg: BASE_PRICE }];
      const lastPoint = currentPriceData[currentPriceData.length - 1];
      const nextTs = (lastPoint?.ts ?? 0) + TICK_MS;
      const totalMinutes = Math.floor(nextTs / (60 * 1000));
      const nextTime = formatMinutesToTime(totalMinutes);
      const lastPrice = lastPoint?.price ?? BASE_PRICE;
      const pullToMean = (BASE_PRICE - lastPrice) * 0.12;
      const drift = (Math.random() - 0.5) * 0.5 + pullToMean;
      const nextPrice = Math.max(
        BASE_PRICE - 5,
        Math.min(BASE_PRICE + 5, Number((lastPrice + drift).toFixed(2))),
      );

      const appended = [...currentPriceData, { time: nextTime, ts: nextTs, price: nextPrice }];
      const { minimum, maximum } = resolveViewportBounds(appended);
      const nextPriceData = appended.filter((point) => point.ts >= minimum && point.ts <= maximum);
      const trendColor = getTrendColor(nextPriceData, BASE_PRICE);

      const nextState = {
        chartProps: {
          ...currentChartProps,
          data: nextPriceData,
          series: (Array.isArray(currentChartProps.series) ? currentChartProps.series : []).map(
            (series, index) => (index === 0 ? { ...series, color: trendColor } : series),
          ),
          xAxis: {
            ...(currentChartProps.xAxis || {}),
            minimum,
            maximum,
          },
        },
      };
      if (refreshAllCharts) {
        this.setData({
          ...nextState,
          lineChartProps: {
            ...this.data.lineChartProps,
            data: mutateLineChartData(this.data.lineChartProps?.data),
          },
          areaChartProps: {
            ...this.data.areaChartProps,
            data: mutateAreaChartData(this.data.areaChartProps?.data),
          },
        });
        return;
      }
      this.setData(nextState);
    };

    this.timer = setInterval(flushPendingTick, 2000);
  },
  toggleUpdateMode() {
    this.setData({
      updateMode: this.data.updateMode === 'realtime-only' ? 'all' : 'realtime-only',
    });
  },
  onUnload() {
    if (this.timer) {
      clearInterval(this.timer);
    }
  },
};
