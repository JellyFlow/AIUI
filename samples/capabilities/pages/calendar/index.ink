<script setup>
  const holidayCalendar = [
    'BEGIN:VCALENDAR',
    'BEGIN:VEVENT',
    'DTSTART;VALUE=DATE:20261224',
    'DTEND;VALUE=DATE:20261226',
    'SUMMARY:Company Shutdown',
    'END:VEVENT',
    'BEGIN:VEVENT',
    'DTSTART;VALUE=DATE:20261225',
    'SUMMARY:Christmas Day',
    'CATEGORIES:holiday,company',
    'END:VEVENT',
    'BEGIN:VEVENT',
    'DTSTART;VALUE=DATE:20240210',
    'SUMMARY:Lunar New Year',
    'CATEGORIES:holiday',
    'RRULE:FREQ=YEARLY;INTERVAL=1',
    'END:VEVENT',
    'END:VCALENDAR',
  ].join('\n');

  export default {
    data: {
      holidayCalendar,
    },
    onLoad() {
      console.log('Calendar component test page loaded');
    },
  };
</script>

<page>
  <view class="container">
    <text class="page-title">Calendar Component</text>
    <text class="page-subtitle">
      Display-only calendar demos for month / week layouts, custom week start, and inline
      iCalendar input.
    </text>

    <card class="section-card" title="Month View">
      <text class="section-copy">
        Default month mode with a selected date. Cross-month padding days stay visible to keep a
        stable 6-row grid.
      </text>
      <calendar
        class="demo-calendar"
        displayDate="2026-04-15"
        value="2026-04-30"
      />
      <text class="caption">
        Props: mode=month, displayDate=2026-04-15, value=2026-04-30, locale=en-US
      </text>
    </card>

    <card class="section-card" title="Week View With Sunday Start">
      <text class="section-copy">
        Compact week mode reuses the same selected-day and today semantics while switching the
        weekday order to Sunday-first.
      </text>
      <calendar
        class="demo-calendar"
        mode="week"
        displayDate="2026-05-01"
        value="2026-04-30"
        weekStart="sunday"
      />
      <text class="caption">
        Props: mode=week, displayDate=2026-05-01, value=2026-04-30, weekStart=sunday
      </text>
    </card>

    <card class="section-card" title="Inline iCalendar Event Source">
      <text class="section-copy">
        `eventSource` accepts raw iCalendar text. This sample includes a multi-day shutdown,
        Christmas Day, and a yearly recurring Lunar New Year entry. Month cells surface a primary
        label when space allows.
      </text>
      <calendar
        class="demo-calendar"
        displayDate="2026-12-01"
        value="2026-12-25"
        locale="en-US"
        eventSource="{{holidayCalendar}}"
      />
      <text class="caption">
        Props: displayDate=2026-12-01, value=2026-12-25, locale=en-US, eventSource=ICS
      </text>
      <text class="note">
        V1 keeps the component display-only: no date tap event, no paging gesture, and no built-in
        remote fetch. In UI, month mode shows a compact primary label and week mode collapses the
        same resolved data into a presence marker.
      </text>
    </card>

    <card class="section-card" title="Chinese Locale">
      <text class="section-copy">
        `locale` switches weekday labels, month titles, and fallback event copy. Week range titles
        remain numeric across locales.
      </text>
      <calendar
        class="demo-calendar"
        displayDate="2026-12-01"
        value="2026-12-25"
        locale="zh-CN"
        eventSource="{{holidayCalendar}}"
      />
      <text class="caption">
        Props: displayDate=2026-12-01, value=2026-12-25, locale=zh-CN, eventSource=ICS
      </text>
    </card>
  </view>
</page>

<style>
  .container {
    flex-direction: column;
    padding: var(--spacing-lg, 20px);
    background-color: var(--color-background);
  }

  .page-title {
    font-size: 28px;
    font-weight: bold;
    color: var(--color-text-primary);
    margin-bottom: var(--spacing-sm, 10px);
  }

  .page-subtitle {
    font-size: 14px;
    line-height: 20px;
    color: var(--color-text-secondary);
    margin-bottom: var(--spacing-lg, 20px);
  }

  .section-card {
    flex-direction: column;
    margin-bottom: var(--spacing-lg, 20px);
  }

  .section-copy {
    font-size: 14px;
    line-height: 20px;
    color: var(--color-text-secondary);
    margin-bottom: 14px;
  }

  .demo-calendar {
    width: 100%;
    margin-bottom: var(--spacing-md, 12px);
  }

  .caption {
    font-size: 12px;
    line-height: 18px;
    color: var(--color-text-secondary);
    font-family: monospace;
  }

  .note {
    font-size: 12px;
    line-height: 18px;
    color: var(--color-text-secondary);
    margin-top: 10px;
  }
</style>
