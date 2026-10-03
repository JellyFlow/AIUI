---
version: beta
name: Rokid AIUI 单色绿色科学界面
target:
  devices: ["RokidGlasses1", "RokidGlasses2"]
  display: "单绿色单色透明显示屏"
  reference-canvas: "480x352"

description: >
  Rokid AIUI 面向透明 AR 眼镜的单色绿色视觉语言。
  系统保留单一发光绿色通道的硬件约束，同时将视觉语法转向克制、类似仪器的界面：
  
  细结构线、稀疏的低亮度填充和紧凑的技术排版。
  信息层级通过亮度、排版、线条处理和留白建立，
  而不是通过大面积填充卡片或装饰性界面装饰建立。

constraints:
  - "仅支持单绿色显示。所有可见像素都通过不同亮度级别的单一绿色通道表达。"
  - "纯黑代表透明底层。不要依赖不透明黑色面板来遮挡真实环境。"
  - "全屏参考画布为 480x352px。关键信息必须保持在舒适的中央视野内。"
  - "关键文本、焦点状态和交互目标必须在任意真实背景上保持可读。"
  - "颜色不能单独编码语义。状态和严重程度还必须使用图标、标签、线型或动效表达。"
  - "装饰密度绝不能与任务内容竞争。"

colors:
  primary: "#40ff5e"                         # 最大显示亮度 / 活跃焦点
  primary-72: "rgba(64,255,94,0.72)"         # 主要可读文本 / 活跃结构线
  primary-48: "rgba(64,255,94,0.48)"         # 次要文本 / 普通边框 / 非活跃控件
  primary-24: "rgba(64,255,94,0.24)"         # 分隔线 / 非活跃结构线 / 辅助线
  primary-12: "rgba(64,255,94,0.12)"         # 选中或抬升表面的色调
  primary-06: "rgba(64,255,94,0.06)"         # 氛围 / 装饰表面色调
  background: "#000000"                      # 透明显示底层
  surface: "#000000"                         # 默认内容平面
  surface-subtle: "{colors.primary-06}"       # 仅用于可选的局部分组
  surface-active: "{colors.primary-12}"       # 选中 / 聚焦的局部区域
  ink: "{colors.primary}"                     # 最高强调级别的文本 / 数值
  ink-primary: "{colors.primary-72}"          # 普通可读文本
  ink-secondary: "{colors.primary-48}"        # 次要描述 / 元数据
  ink-disabled: "{colors.primary-24}"         # 禁用或不可用内容
  line-strong: "{colors.primary-72}"          # 焦点边框 / 活跃结构线
  line-default: "{colors.primary-48}"         # 普通交互边界
  line-muted: "{colors.primary-24}"           # 分隔线 / 装饰辅助线
  line-trace: "{colors.primary-12}"           # 氛围辅助线
  on-primary: "#000000"                       # 罕见纯绿色填充上的文本

typography:
  display:
    fontFamily: "sans-serif"
    fontSize: 22px
    fontWeight: 500
    lineHeight: 1.15
    letterSpacing: "0.01em"
  heading:
    fontFamily: "sans-serif"
    fontSize: 16px
    fontWeight: 500
    lineHeight: 1.25
    letterSpacing: "0.01em"
  body:
    fontFamily: "sans-serif"
    fontSize: 14px
    fontWeight: 400
    lineHeight: 1.45
    letterSpacing: 0
  body-sm:
    fontFamily: "sans-serif"
    fontSize: 12px
    fontWeight: 400
    lineHeight: 1.4
    letterSpacing: "0.01em"
  label:
    fontFamily: "sans-serif"
    fontSize: 11px
    fontWeight: 500
    lineHeight: 1.3
    letterSpacing: "0.08em"
    textTransform: uppercase
  caption:
    fontFamily: "sans-serif"
    fontSize: 10px
    fontWeight: 400
    lineHeight: 1.35
    letterSpacing: "0.05em"
  mono:
    fontFamily: "monospace"
    fontSize: 11px
    fontWeight: 400
    lineHeight: 1.35
    letterSpacing: "0.04em"
  data:
    fontFamily: "monospace"
    fontSize: 13px
    fontWeight: 500
    lineHeight: 1.3
    letterSpacing: "0.03em"

rounded:
  none: 0px
  xs: 2px
  sm: 4px
  md: 6px
  full: 9999px

spacing:
  xxs: 2px
  xs: 4px
  sm: 8px
  md: 12px
  lg: 16px
  xl: 24px
  xxl: 32px

border-width:
  hairline: 1px
  default: 1px
  strong: 2px

motion:
  duration-fast: 120ms
  duration-default: 200ms
  duration-slow: 320ms
  easing-enter: "cubic-bezier(0.16, 1, 0.3, 1)"
  easing-exit: "cubic-bezier(0.4, 0, 1, 1)"
  ambient-period-min: 4000ms
  ambient-period-max: 8000ms

components:
  app-canvas:
    description: "完整透明 HUD 画布。"
    width: 480px
    height: 352px
    safeInsetX: 16px
    safeInsetY: 12px
    backgroundColor: "{colors.background}"

  panel:
    description: >
      主要分组原语。优先使用稀疏边框或局部边界，而不是填充卡片。仅在分组能
      明显提升理解时使用。
    backgroundColor: "{colors.surface}"
    borderColor: "{colors.line-muted}"
    borderWidth: "{border-width.default}"
    rounded: "{rounded.md}"
    padding: "{spacing.md}"

  card:
    description: >
      面向向后兼容的 panel 别名。现有基于 card 的布局可以保留组件名称，
      但新设计在视觉上应遵循 panel 规则。
    backgroundColor: "{colors.surface}"
    borderColor: "{colors.line-muted}"
    borderWidth: "{border-width.default}"
    rounded: "{rounded.md}"
    padding: "{spacing.md}"

  card-highlight:
    description: "带克制色调的聚焦 / 选中局部区域。"
    backgroundColor: "{colors.surface-active}"
    borderColor: "{colors.line-strong}"
    borderWidth: "{border-width.default}"
    rounded: "{rounded.md}"
    padding: "{spacing.md}"

  divider:
    description: "细结构分隔线。"
    backgroundColor: "{colors.line-muted}"
    height: "{border-width.hairline}"

  button:
    description: "紧凑的轮廓式操作。填充按钮仅用于不可逆操作或主要确认时刻。"
    minHeight: 32px
    backgroundColor: transparent
    borderColor: "{colors.line-default}"
    borderWidth: "{border-width.default}"
    textColor: "{colors.ink-primary}"
    typography: "{typography.label}"
    rounded: "{rounded.sm}"
    padding: "0 {spacing.md}"

  button-active:
    backgroundColor: "{colors.surface-active}"
    borderColor: "{colors.line-strong}"
    textColor: "{colors.ink}"

  button-disabled:
    backgroundColor: transparent
    borderColor: "{colors.line-trace}"
    textColor: "{colors.ink-disabled}"

  chip:
    description: "紧凑的状态 / 筛选 token。"
    minHeight: 22px
    backgroundColor: transparent
    borderColor: "{colors.line-muted}"
    borderWidth: "{border-width.hairline}"
    textColor: "{colors.ink-secondary}"
    typography: "{typography.caption}"
    rounded: "{rounded.sm}"
    padding: "0 {spacing.sm}"

  text-input:
    description: "低填充输入字段。"
    minHeight: 36px
    backgroundColor: "{colors.surface-subtle}"
    borderColor: "{colors.line-default}"
    borderWidth: "{border-width.default}"
    textColor: "{colors.ink-primary}"
    placeholderColor: "{colors.ink-secondary}"
    typography: "{typography.body}"
    rounded: "{rounded.sm}"
    padding-y: 8px
    padding-x: 10px

  textarea:
    description: "遵循相同低填充字段语法的多行输入。"
    backgroundColor: "{colors.surface-subtle}"
    borderColor: "{colors.line-default}"
    borderWidth: "{border-width.default}"
    textColor: "{colors.ink-primary}"
    placeholderColor: "{colors.ink-secondary}"
    typography: "{typography.body}"
    rounded: "{rounded.sm}"
    padding-y: 8px
    padding-x: 10px

  list-row:
    description: "带分隔线的开放行；避免将每一行都包裹在卡片中。"
    minHeight: 40px
    padding: "{spacing.sm} 0"
    rowBorder: "{colors.line-muted}"
    title排版: "{typography.body}"
    meta排版: "{typography.caption}"

  status:
    description: "使用标签 + 图标 / 形状 + 可选线型的语义状态模式。"
    textColor: "{colors.ink-primary}"
    iconColor: "{colors.ink-primary}"
    typography: "{typography.caption}"

  error-state:
    description: >
      错误 / 严重程度容器。纯绿色硬件需要冗余编码：
      三角形 / 错误字形 + 明确标签 + 更强边界或虚线处理。
    backgroundColor: "{colors.surface-subtle}"
    borderColor: "{colors.line-strong}"
    borderWidth: "{border-width.default}"
    borderStyle: dashed
    textColor: "{colors.ink-primary}"
    typography: "{typography.body-sm}"
    rounded: "{rounded.sm}"
    padding: "{spacing.sm}"

  icon:
    description: "单线轮廓字形；避免大块实心图标。"
    color: "{colors.ink-primary}"
    strokeWidth: "{border-width.hairline}"

  progress:
    description: "线性进度 / 状态轨道。"
    height: 1px
    trackColor: "{colors.line-muted}"
    fillColor: "{colors.line-strong}"
    markerColor: "{colors.ink}"

  chart-container:
    description: >
      开放式可视化区域。默认不使用填充卡片；使用坐标轴、
      标签、稀疏辅助线和 1px 描边。
    backgroundColor: transparent
    borderColor: "{colors.line-trace}"
    borderWidth: "{border-width.hairline}"
    rounded: "{rounded.xs}"
    padding: "{spacing.sm}"

---

# Rokid AIUI 单色绿色科学界面

## 概述

本规范定义 Rokid AIUI 在 **RokidGlasses1 / RokidGlasses2** 上的视觉语言，使用 **480 × 352 px** 单绿色透明显示屏。

硬件约束仍是基础：显示屏在透明黑色底层上呈现一个发光绿色通道。新的视觉方向将这一约束视为**亮度、线条和留白系统**。界面应当精确、轻量、技术化并具有空间感，更接近科学仪器或任务控制叠加层，而不是一叠传统应用卡片。

视觉系统由四个原语构成：

1. **亮度** — one green channel at controlled brightness levels.
2. **排版** —— 紧凑、技术化、低字重层级。
3. **线条** — hairline frames, dividers, and axes.
4. **留白** —— 在小视野内保持焦点的刻意空白区域。

大面积不透明表面、粗边框、重复圆角卡片和装饰性发光应当是例外。

## 1. 设计原则

### 1.1 仪器，而非应用外壳

AIUI 是用户视野中的信息叠加层。界面应以理解状态、关系和操作所需的最少外壳来呈现它们。

优先：

- 开放布局，
- 1px 结构线，
- 紧凑标签，
- 小型局部分组，
- 空间关系，
- 数据优先的构图。

避免将每个内容块都包裹在可见卡片中。

### 1.2 低视觉重量

透明眼镜本身已有复杂的真实背景。界面应尽可能少增加不透明视觉重量。

使用：

- 透明或黑色底层，
- 仅在需要分组时使用 6–12% 局部色调，
- 1px 边界，
- 稀疏填充，
- 开放列表行，
- 克制的图标。

### 1.3 可读性优先于氛围

关键信息必须在变化的背景上保持清晰可读。

最低指导：

- 主要可读文本： `{colors.primary-72}` 或更亮。
- 次要文本： `{colors.primary-48}` 使用 12px 或更大字号。
- 交互边界： `{colors.primary-48}` 或更亮。
- 装饰辅助线可以降至 `{colors.primary-24}` / `{colors.primary-12}`.
- 不要将关键信息放在 `{colors.primary-24}` 或更低亮度。

### 1.4 单一色相，冗余语义

错误、警告、成功、在线 / 离线、选中 / 未选中和禁用状态共享同一绿色通道。因此状态必须结合多个提示：

- 标签，
- 图标 / 形状，
- 线型，
- 边框强度，
- 填充级别，
- 适当的动效。

绝不要只通过不透明度表达重要状态。

## 2. Color & 亮度

调色板基于 `#40ff5e` 的单一绿色通道。

| Token | Value | Role |
|---|---|---|
| `{colors.primary}` | `#40ff5e` | 最高强调、选中数值、活跃点 |
| `{colors.primary-72}` | `rgba(64,255,94,.72)` | 主要可读文本、活跃线条 |
| `{colors.primary-48}` | `rgba(64,255,94,.48)` | 次要文本、普通边框 |
| `{colors.primary-24}` | `rgba(64,255,94,.24)` | 分隔线、非活跃线条、辅助线 |
| `{colors.primary-12}` | `rgba(64,255,94,.12)` | 活跃 / 选中局部表面色调 |
| `{colors.primary-06}` | `rgba(64,255,94,.06)` | 氛围分组色调 |
| `{colors.background}` | `#000000` | 透明底层 |

### 亮度 rules

- 满亮度绿色是一种稀缺资源。将它留给焦点、活跃数据和屏幕上最重要的数值。
- 普通正文应使用 72% 亮度，而不是 100%。
- 重复结构线默认使用 24–48%。
- 大面积区域不应使用 24% 以上的绿色填充；这会造成过度泛光和视觉遮挡。
- 选中区域可以使用 12% 填充加更强边框。
- 禁用内容使用 24% 文本亮度，并且必须明确可识别为禁用。

## 3. 排版

新的方向不再依赖粗体等宽标题。排版应更接近技术仪表盘：紧凑、克制且信息密度高。

### 字体策略

使用通用系统字体族，以保持运行时可移植：

- `sans-serif` — 界面文本、标题、操作、描述。
- `monospace` — 数值、日志、时间戳、ID、坐标、技术元数据。

核心系统不应要求品牌字体文件。

### 字号比例

| Token | 大小 | 字重 | 字距 | 用途 |
|---|---:|---:|:---:|---|
| `{typography.display}` | 22px | 500 | 0.01em | 主要页面 / 状态标题 |
| `{typography.heading}` | 16px | 500 | 0.01em | 章节标题 |
| `{typography.body}` | 14px | 400 | 0 | 主要可读正文 |
| `{typography.body-sm}` | 12px | 400 | 0.01em | 紧凑次要文本 |
| `{typography.label}` | 11px | 500 | 0.08em | 操作、类别标签、大写微标题 |
| `{typography.caption}` | 10px | 400 | 0.05em | 元数据、时间戳、状态 |
| `{typography.mono}` | 11px | 400 | 0.04em | 日志、ID、坐标 |
| `{typography.data}` | 13px | 500 | 0.03em | 关键数值 |

### 规则

- 避免将 700 / 粗体作为默认层级手段。
- 界面标题的常规最大字重使用 500。
- 仅对短技术标签使用大写 + 字距。
- 不要将长正文设置为大写或宽字距。
- 保持文本块足够窄，使用户无需横跨整个 480px 画布移动视线即可浏览。
- 单个屏幕通常不应同时呈现超过三种字号层级。

## 4. 布局

### 画布

- 参考尺寸： **480 × 352 px**
- 水平安全内边距： **16px**
- 垂直安全内边距： **12px**
- 默认有效内容宽度： **448px**

系统仍支持必要时滚动内容，但首选体验是在初始视野中呈现最少的可操作信息。

### 间距比例

`2 / 4 / 8 / 12 / 16 / 24 / 32px`

组件内部节奏使用 8px 和 12px，章节分隔使用 16px，仅在需要更强视觉停顿时使用 24px。

### 构图模式

AIUI 支持三种主要构图模式：

**A. 线性** —— 列表、表单、状态摘要、对话结果。

**B. 空间** —— 对象关系、智能体 / 工具排列、视觉搜索。

**C. 仪器** —— 指标、进度、时间线、捕获区域、系统状态。

当关系是主要内容时，不要强行将空间可视化放进卡片列表。

## 5. Shapes & 线条

### 圆角

| Token | 值 | 用途 |
|---|---:|---|
| `{rounded.none}` | 0px | 网格、坐标轴、数据框 |
| `{rounded.xs}` | 2px | 科学视口 / 微型框 |
| `{rounded.sm}` | 4px | 按钮、芯片、输入框 |
| `{rounded.md}` | 6px | 面板和局部分组 |
| `{rounded.full}` | 9999px | 仅圆形标记 / 胶囊 |

视觉系统不应再让每个容器默认使用 12px 圆角。

### 边框

- 默认：1px。
- 强 / 聚焦：2px。
- 2px 应表示选中或强焦点，而不是普通容器外壳。
- 虚线可用于表达临时、不可用、新增或错误 / 严重程度状态。
- 分隔线通常应使用 24% 亮度的 1px。

## 6. 组件

### 面板 / 卡片

`panel` 是首选新术语。`card` 作为兼容别名保留。

默认：

- 黑色 / 透明底层，
- 1px、24% 边框，
- 6px 圆角，
- 12px 内边距，
- 无阴影，
- 无持续的明亮轮廓。

当对齐、留白或角标已提供足够分组时，面板可以省略一个或多个边框。

### 高亮区域

选中 / 聚焦区域：

- 12% 绿色局部填充，
- 72% 亮度的 1px 边框，
- 可选的 2px 焦点标记，
- 主要文本 / 数值可提升至 100%。

普通强调不要使用 40% 的整面填充。

### 按钮

默认：

- minimum height 32px,
- 1px 48% outline,
- 4px radius,
- 11px / 500 uppercase 标签，
- transparent background.

活跃：

- 12% 局部填充，
- 72–100% 文本，
- 更强边界。

禁用：

- 24% 文本，
- 12% 边界，
- 无活跃动效。

只有当交互需要单一且高置信度的确认状态时，才允许使用纯绿色按钮。

### 芯片 / 标签

- minimum height 22px,
- 1px 24% border,
- 4px radius,
- 10px caption typography,
- 仅限短标签。

使用芯片表示筛选器、状态标签、来源标识或紧凑模式指示器。

### 输入框

- 36px minimum height,
- 6% 局部色调，
- 1px 48% boundary,
- 4px radius,
- 14px primary text,
- 48% 占位符。

焦点状态应将边框提升至 72%，并可添加局部标记。避免大面积发光。

### 列表

列表行应保持视觉开放：

- 40px minimum row height,
- 8px vertical rhythm,
- optional 1px 24% divider,
- no card wrapper per row by default.

使用对齐和留白建立层级。

### 状态 / 语义消息

一种状态至少需要两个信号：

- 明确的文本标签，以及
- 图标 / 形状 / 线条处理。

示例：

- error: triangle + `ERROR` + dashed strong boundary,
- warning: alert glyph + `WARN` + strong side marker,
- success: check glyph + `DONE`,
- offline: hollow dot + `OFFLINE`,
- active: solid dot + `ACTIVE`.

全部保持绿色。

### 图标

- monoline outline,
- 1px stroke,
- size scale 16 / 20 / 24px,
- 无不必要的实心填充，
- 使用能经受低分辨率渲染的简单形状。

### 进度

- 1px track,
- 24% 基础轨道，
- 72% 填充段，
- 100% 标记仅用于当前位置。

当径向结构具有语义价值时可以使用环形进度；不要仅为视觉新奇而使用圆形。

## 7. 可视化

图表和图示应继承同样克制的语法。

### 默认可视化处理

- 透明背景，
- 1px 线条，
- 稀疏坐标轴，
- 24% 辅助网格，
- 48–72% 数据系列，
- 100% 活跃点或当前值，
- 标签使用 caption / mono 排版，
- 填充区域通常不超过 12%，临时高亮时除外。

### 数据编码

由于无法使用色相，请通过以下方式区分数据系列或状态：

- 实线 / 虚线 / 点线，
- 标记形状，
- 描边亮度，
- 线条粗细，
- 位置，
- 标签，
- 仅在必要时使用纹理 / 图案。

不要创建仅通过绿色不透明度区分的多个数据系列。

## 8. 动效

动效应指示状态变化、方向、进度或注意力。

### 时序

- 快速反馈： `{motion.duration-fast}`.
- 标准过渡： `{motion.duration-default}`.
- 结构过渡： `{motion.duration-slow}`.
- 氛围循环： `{motion.ambient-period-min}`–`{motion.ambient-period-max}` 仅在必须持续显示系统状态时使用。

### 规则

- 优先使用事件驱动动效，而不是连续装饰动画。
- 活跃数值可以轻微脉冲；同一时间只能有一个主导脉冲。
- 加载 / 进度动画必须保持空间稳定。
- 避免全屏视差、持续发光呼吸或多个独立氛围循环。
- 界面静止时，动效必须停止或简化。

## 9. 深度

系统使用三种克制的深度层级。

| 层级 | 处理 | 用途 |
|---|---|---|
| 0 — 开放区域 | 透明 / 黑色，无边界 | 默认画布 |
| 1 — 局部分组 | 6% 色调或 24% 边框 | 次级面板、输入框分组 |
| 2 — 活跃分组 | 12% 色调 + 72% 边框 | 选中 / 聚焦区域 |

不定义通用投影。

当硬件泛光不足时，可以在活跃点或光标上使用微弱发光，但不能将其变成组件级的抬升系统。

## 10. 交互状态

### 焦点

使用：

- 更强边框，
- 活跃标记，
- 100% 关键数值，
- 可选的 12% 局部色调。

除非空间定位需要，否则不要放大整个组件。

### 按下

- 短暂的 12% 填充，
- 120ms 反馈，
- 保持尺寸以避免布局跳动。

### 禁用

- 24% 文本和结构线，
- 可能产生歧义时明确表达不可用 / 禁用语义，
- 无脉冲或活跃动画。

### 加载

优先选择以下一种：

- 沿路径移动的点，
- 短线扫描，
- 标记旋转，
- 确定性进度。

当任务可以展示有意义的进度时，避免使用大型通用加载旋转器。

## 11. 向后兼容

现有 AIUI 页面和文档可以继续引用旧 token / 组件名称。

### 兼容映射

| 现有名称 | 新行为 |
|---|---|
| `card` | `panel` 的别名；使用稀疏 1px 边框 |
| `card-highlight` | 12% 局部色调 + 更强 1px 边框 |
| `border-default` | 替换为 `line-default` |
| `border-muted` | 替换为 `line-muted` |
| `border-accent` | 替换为 `line-strong` |
| `primary-60` | 可读文本迁移至 `primary-72`，结构迁移至 `primary-48` |
| `primary-40` | 结构迁移至 `primary-48`，辅助线迁移至 `primary-24` |
| `primary-08` | 根据表面状态迁移至 `primary-06` / `primary-12` |
| 12px universal radius | 控件迁移至 4px / 面板迁移至 6px |
| 2px normal card border | 迁移至 1px；2px 保留给强焦点 |
| bold monospace heading | 迁移至 500 无衬线；数据 / 日志保留等宽字体 |

实现可以暂时保留旧 CSS 变量，但新组件应使用新的语义 token。

## 12. 从 Alpha 视觉语言迁移

此前的单色规范以明亮轮廓卡片为界面中心。新系统保留相同的硬件和运行时基础，同时改变视觉语法。

### 变更摘要

**旧版：** 4 级绿色不透明度阶梯  
**新版：** 6 级亮度阶梯，更紧密地区分可读内容、结构和氛围。

**旧版：** 大多数控件和卡片使用 12px 圆角  
**新版：** 2 / 4 / 6px 功能性圆角比例。

**旧版：** 2px 普通卡片轮廓、4px 强轮廓  
**新版：** 1px 默认结构线，2px 保留给强焦点。

**旧版：** 40% 高亮表面  
**新版：** 12% 最大普通局部选中色调。

**旧版：** 粗体等宽标题作为主要识别线索  
**新版：** 紧凑的中等字重无衬线字体用于界面层级；等宽字体保留给数据和技术元数据。

**旧版：** 卡片优先的垂直构图  
**新版：** 开放区域构图，仅在需要分组时使用面板。

**旧版：** 通过填充表面和边框粗细表达组件深度  
**新版：** 通过局部色调、亮度、线型和留白表达深度。

## 13. 应做与避免

### 应做

- 将 480 × 352 画布作为主要空间约束。
- 普通结构使用 1px 线条和低视觉重量。
- 将满亮度绿色留给焦点和关键数值。
- 将留白作为主要分组工具。
- 优先使用开放列表行，而不是重复卡片。
- 日志、坐标、ID 和数据值使用等宽字体。
- 每个语义状态都配合文本和几何 / 图标提示。
- 装饰线保持在 24% 或更低亮度。
- 在明亮、昏暗和视觉杂乱的真实背景上测试屏幕。

### 应做n't

- 不要将界面重构成一叠厚重发光卡片。
- 不要让每个容器默认使用 12px 圆角。
- 不要将 2–4px 边框作为常规界面外壳。
- 不要将 40% 绿色作为大面积高亮填充。
- 不要让所有标题都使用粗体等宽字体。
- 不要只通过亮度表达状态。
- 不要同时运行多个连续氛围动画。
- 不要将阴影作为主要深度模型。
- 不要引入第二种色相。
- 不要将关键文本或交互边界降到 trace 级亮度。
- 不要让视觉实验降低任务可读性。

## 14. 验收清单

新的 AIUI 屏幕在满足以下条件时即符合视觉规范：

- [ ] 适配 480 × 352 参考画布，或具有明确的溢出策略。
- [ ] 主要可读文本至少使用 72% 绿色亮度。
- [ ] 普通结构线为 1px。
- [ ] 2px 边框仅用于强焦点或等效强调。
- [ ] 普通状态下大面积绿色填充保持在 12% 或以下。
- [ ] 控件使用 4px 圆角，面板使用 6px 圆角，除非布局要求直角边缘。
- [ ] 屏幕不依赖为每个内容块添加卡片包裹。
- [ ] 语义状态至少使用两个冗余提示。
- [ ] 装饰辅助线不与内容竞争。
- [ ] 等宽排版仅用于技术 / 数据内容。
- [ ] 界面在视觉嘈杂的透明背景上仍然易于理解。
- [ ] 设计不需要 Rokid Green 之外的其他色相。
