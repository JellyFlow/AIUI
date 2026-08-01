# Performance Metrics

Performance work starts with observable data. In AIUI, the most useful metrics usually span startup, rendering, script execution, and networking.

## What To Measure

- Startup time: time from launch until the first visible screen
- First render: time before the page becomes meaningfully interactive
- JavaScript execution: cost of initialization, data processing, and callbacks
- Network latency: response time, retries, and failure rate under poor connectivity
- Memory usage: whether usage keeps growing after navigation or during long sessions

## How To Use These Metrics

- First decide whether the issue belongs to [Startup Performance](/AIUI/guide/performance-startup) or [Runtime Performance](/AIUI/guide/performance-runtime)
- Establish baselines for critical flows instead of relying only on subjective feel
- Review page metrics together with request metrics so the bottleneck is not misidentified

## Next Step

For deeper issue isolation, continue with [Performance Diagnostics](/AIUI/guide/performance-tool).
