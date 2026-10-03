# AIUI 视觉设计语言

本目录存放 AIUI 的视觉设计语言规范。每份规范都针对一种
特定的**显示类型**，因为 AIUI 运行在颜色表现能力差异很大的硬件上。


## 目录结构

```text
design/
├── monochrome/          # 单色显示规范（纯黑背景上的单通道）
│   ├── design-system-green.md
│   └── preview-green.html
└── fullcolor/           # 规划中 — 全 RGB 显示规范（尚未编写）
```

目前只有**单色绿色**变体；全彩区域为未来硬件预留。


| 子目录 | 显示类型 | 状态 |
|--------|--------------|--------|
| [`monochrome/`](./monochrome/) | 单色显示（纯黑背景上的单通道） | 活跃 — 提供 `green` 色相变体 |
| `fullcolor/` | 全 RGB 彩色显示 | 规划中 — 尚未编写 |

## 当前规范

单色绿色系统面向 RokidGlasses1 / RokidGlasses2，这些设备的
硬件只能在纯黑背景上呈现一个发光的绿色通道；该系统位于：


- [`monochrome/design-system-green.md`](./monochrome/design-system-green.md) — 完整 token 规范
- [`monochrome/preview-green.html`](./monochrome/preview-green.html) — 可在浏览器中查看的视觉展示

详情请参阅 [`monochrome/README.md`](./monochrome/README.md)。

## 在仓库中的位置

| 使用者 | 获取设计语言的位置 |
|----------|------------------------------------|
| AI 智能体（Claude Code、Cursor、Codex 等） | 通过 `npx skills add` 以 `skills/aiui-dev/design-system-green.md` 的形式打包 |
| 人类开发者 | 本目录，由根目录 [`README.md`](../README.md) 链接 |
| 示例作者 | 在 [`samples/`](../samples/) 下镜像这些 token |

技能副本与此处的 `monochrome/design-system-green.md` 保持有意一致，因此智能体无需
此处的 `monochrome/design-system-green.md` 与技能副本保持一致，因此智能体无需
获取远程 URL 即可对齐生成代码。编辑其中一份时，请同步更新另一份。

## 许可证

Apache License 2.0，继承自仓库根目录。
