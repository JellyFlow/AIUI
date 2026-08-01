# 局域网通信

AIUI 当前没有对外公开、稳定的局域网通信能力文档。本页用于保留 `toc.json` 中的章节结构，并说明当前状态与替代方案。

## 当前状态

- `toc.json` 中该能力标记为 `unsupported`
- 现阶段不建议把局域网直连能力作为可依赖的公开接口使用

## 可选替代方案

- 需要标准网络请求时，优先使用 [使用说明](/AIUI/guide/basic-network-usage)
- 需要服务端通信时，优先使用 [HTTPS](/AIUI/api/network-https)
- 需要实时双向消息时，优先使用 [WebSocket](/AIUI/api/network-websocket)
- 需要近场设备通信时，可结合 [蓝牙](/AIUI/guide/basic-device-bluetooth) 能力设计交互流程

## 后续建议

如果你的场景明确依赖局域网发现、广播或点对点连接，建议先在应用层预留协议抽象，等待 AIUI 后续公开正式能力后再接入。
