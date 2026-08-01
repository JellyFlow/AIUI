# Data Prefetch

Data prefetch prepares request results, caches, or key assets before a page is fully presented, helping reduce perceived first-screen latency. AIUI does not yet publish a formal public API for this capability, so this page keeps the documented structure and outlines the recommended approach.

## Current Status

- This capability is marked as `unsupported` in `toc.json`
- There is no stable public page-level prefetch API yet

## Recommended Approach Today

- Start critical requests early in `onLoad` or `onShow`
- Use [Storage](/AIUI/guide/basic-storage) or [localStorage](/AIUI/api/storage-api) for short-lived cached data
- Split first-screen data from secondary data so only immediately visible content is fetched first

## Design Notes

- Treat prefetch as an optimization, not as a correctness requirement
- Prepare loading fallbacks for slow networks and expired caches
- Avoid prefetching too much unrelated data during startup
