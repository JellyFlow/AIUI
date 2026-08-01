# Poor Network Experience

Poor network experience is not only about slow requests. It also includes whether loading feedback is clear, whether failures recover well, and whether the page remains usable under high latency.

## Design Priorities

- Show loading feedback early so the page does not feel frozen
- Define timeouts, retries, and failure messaging for critical requests
- Keep core information visible first and defer secondary content
- Reuse locally cached data when appropriate to avoid repeated requests

## Common Optimization Directions

- Build a consistent request layer based on [Usage](/AIUI/guide/basic-network-usage)
- When using [HTTPS](/AIUI/api/network-https), handle timeouts, status errors, and degraded messaging explicitly
- For real-time streaming flows, evaluate recovery behavior for [Event Source](/AIUI/api/network-event-source) or [WebSocket](/AIUI/api/network-websocket)

## Verification Tips

- Validate first load, reconnect, and resume-from-background scenarios under real poor-network conditions
- Check both chat-card and immersive pages for clear user feedback
