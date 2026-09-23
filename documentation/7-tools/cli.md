# 命令行工具

`aix` 是处理 AIX（AI eXecutable）智能体包的命令行工具。它可以打包和检查 AIUI 工程、安装智能体到设备，以及在浏览器中预览页面。本页按 [AIX CLI README](https://github.com/yodaos-project/aix/blob/main/packages/cli/README.md) 的结构介绍全部命令。

下文的 `./my-agent` 是工程目录，`bundle.aix` 是已经打好的包，`<serial>` 是设备序列号。请换成自己的路径和序列号；尖括号只是占位符，不要原样输入。

## 安装

先安装 Node.js 20 或更新版本，再在终端运行：

```bash
npm install -g @yodaos-pkg/aix-cli
aix --help
```

第一行安装 CLI，第二行确认安装成功。要查看某个命令的所有选项，可运行 `aix pack --help`，把 `pack` 换成相应命令即可。

## 包管理命令

这组命令在电脑上处理工程目录或 `.aix` 包，无需连接设备。

### `aix pack <INPUT_DIR>`

将工程目录打包成 `.aix`。`<INPUT_DIR>` 是目录路径。例如，从 `my-agent` 的上一级目录运行：

```bash
aix pack ./my-agent
aix pack ./my-agent -o my-app.aix
aix pack ./my-agent --engine '^0.14.0'
aix pack ./my-agent --log-time
```

`-o` 指定输出文件。打包会校验 JSON、将支持的文本转换为 UTF-8、生成 UUID v4 格式的 `VERSION`，并写入 `META-INF/aix/manifest.json`。JavaScript 和 TypeScript 默认会压缩，但源码文件不会被改动。

需要额外优化 JSON、PNG 和 JPEG 时加 `-O` 或 `--optimize`。优化等级可选 1～3；只有启用优化时 `--opt-level` 才有意义。

```bash
aix pack ./my-agent --optimize
aix pack ./my-agent -O --opt-level 3
```

`--engine` 指定包支持的运行时版本范围。未指定时，CLI 先读取 `app.json.engine`，没有则使用 `*`。工程根目录的 `.aixignore` 可用类似 `.gitignore` 的语法排除文件。`--log-time` 给打包日志添加本地时间。

### `aix show <INPUT>`

输出最终生效的 Agent Definition JSON。`<INPUT>` 可以是工程目录或 `.aix` 包，无需 ADB。`show` 与 `install` 使用同一套解析逻辑，适合安装前检查将提交的配置。

```bash
aix show ./my-agent
aix show ./bundle.aix --compact
aix show ./my-agent -o ./agent.json
```

`--compact` 将 JSON 输出为一行；`-o` 把结果写入文件。`--definition <FILE>` 可指定自定义 Definition，覆盖部分生成字段，但不能覆盖 `agentId`。

### `aix list <AIX_FILE>`

列出已有 `.aix` 包中的文件和大小，不必解压。`ls` 是 `list` 的简写。

```bash
aix list bundle.aix
aix ls bundle.aix
```

### `aix optimize <AIX_FILE>`

优化已有包中的 JSON、PNG 和 JPEG。`-o` 指定新包的路径，`--level` 可选 1～3，默认是 2。

```bash
aix optimize input.aix -o output.aix --level 2
```

## 设备命令

这些命令通过 ADB 与设备通信。先安装 ADB、连接设备并授权调试。只有一台在线且已授权设备时会自动选择；多台设备会弹出选择器。脚本等无法交互的环境必须用 `-s, --serial <serial>` 指定设备。

运行中的步骤会显示进度动画，完成的中间步骤收敛为一行 `✔`，最新结果保留详细信息。遇到失败时，可先检查设备连接、开发者模式和包内容。

### `aix device [ACTION]`

不带参数时，只查看设备的 Developer Mode、Widget 就绪状态与布局，以及已安装的 `.aix` 智能体。`set-dev` 开启开发者模式，`unset-dev` 关闭。

```bash
aix device
aix device set-dev
aix device unset-dev
```

切换 Developer Mode 会重新加载所有 Widget；动态 Widget 之后需要重新启动。

### `aix install <INPUT>`

将工程目录或现成的 `.aix` 包安装到设备。输入目录时会先打包，再通过 ADB 提交到 AIUI DEVELOP；输入包时直接使用该包。

```bash
aix install ./my-agent
aix install ./bundle.aix
aix install ./my-agent --definition ./agent.json --serial <serial>
```

目录安装会复用 `.aix/agent-id`，归档安装会使用包内 `VERSION`。`--definition` 可用自己的 Agent Definition JSON 覆盖生成的元数据，但不能覆盖 `agentId`。命令会检查设备应用和手机上传的结果；手机确认上传不代表云端已完成索引。

若设备报运行时版本不兼容，须从源码工程调整 `app.json.engine`，或用 `aix pack ./my-agent --engine '<兼容范围>' -o bundle.aix` 重新打包后再安装。不能通过安装选项改写已有 `.aix` 包的版本范围。

### `aix launch-page <INPUT> [PATH]`

打开设备上**已经安装**的智能体页面，不会自动安装。`<INPUT>` 用来定位智能体，`[PATH]` 是可选的页面路径；省略时使用声明的入口页。

```bash
aix launch-page ./my-agent
aix launch-page ./my-agent pages/index/index
aix launch-page ./my-agent pages/index/index --card
aix launch-page ./my-agent pages/index/index --params '{"id":"123"}'
```

`--card` 以卡片而非全屏方式打开。`--params` 传入 JSON 对象；参数较长时，可用 `--params-file <FILE>` 从 JSON 文件读取。尚未安装时，先运行 `aix install`。

### `aix launch-widget <INPUT> <PATH>`

打开已安装智能体的 Widget。`<PATH>` 是 Widget 路径，`--position` 指定网格起始位置；还可以使用 `--params` 或 `--params-file` 传入参数。

```bash
aix launch-widget ./my-agent widgets/order/index
aix launch-widget ./my-agent widgets/order/index --position 2
```

Widget 的尺寸来自 `app.json.widgets[].family`。CLI 保留兼容的已有布局；位置冲突时替换重叠的可叠加 Widget，没有空间时清理旧的可叠加布局。常驻 Widget 不会被自动删除。

需要时，命令会准备、推送 `widget-config.json`、应用布局并打开 Widget。如果运行时丢失位置信息，会重新应用布局并重试打开一次。

### `aix widget-layout [show]`

查看或清空设备上的 Widget 布局。不带参数及 `show` 都只查看，不修改设备。`--clear` 会清空常驻和可叠加 Widget 的布局项，但保留网格设置。

```bash
aix widget-layout
aix widget-layout show
aix widget-layout --clear
aix widget-layout --clear --yes
```

交互式终端中，`--clear` 会询问是否确认；脚本里无法回答时，必须明确加 `--yes`。`--yes` 只能与 `--clear` 同用。清空后，想继续显示的 Widget 需要重新配置或启动。

## 预览命令

这组命令在电脑上预览工程，无需连接设备。浏览器预览可检查页面；设备交互和性能仍需在真机验证。

### `aix preview <INPUT>`

预览源码目录或 `.aix` 包。默认启动本地服务并打印访问地址；复制到浏览器即可打开。`--launch` 则直接打开默认浏览器。

```bash
aix preview bundle.aix
aix preview ./my-agent
aix preview bundle.aix --launch
aix preview bundle.aix --launch --launch-target current
```

`--launch-target` 选择视口：默认 `blank` 为 `480×352`，`current` 为 `448×150`。只想导出静态 HTML 时，用 `--html-out`，它不会启动服务，也不能与 `--launch` 同用。

```bash
aix preview bundle.aix --html-out ./artifacts/preview.html
```

开发源码时，可加 `--dev`，让预览通过 WebSocket 实时重载：

```bash
aix preview ./my-agent --dev
aix preview ./my-agent --dev --launch
```

### `aix runtime`

查看或选择本地预览使用的运行时版本：

```bash
aix runtime versions
aix runtime current
aix runtime select
```

- `versions`：列出可用稳定版本及当前选择。
- `current`：只输出实际解析到的版本号，方便脚本读取。
- `select`：交互选择版本，并保存到 `~/.aix/runtime.json`。

默认从 npm registry 获取版本列表；如需使用 npmmirror，可设置环境变量 `AIX_NPM_REGISTRY=npmmirror`。

## 开发

只有准备从源码修改或构建 CLI 时才需要这一节。进入 [AIX 仓库的 `packages/cli` 目录](https://github.com/yodaos-project/aix/tree/main/packages/cli) 后运行：

```bash
npm install
npm run build
node dist/cli.js --help
```

构建过程会编译 CLI 使用的 Rust 引擎，再打包 TypeScript 程序。打包、优化和读取逻辑与该项目的其他运行环境共用。
