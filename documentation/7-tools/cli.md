# 命令行工具

`aix` 是 [AIX CLI](https://github.com/yodaos-project/aix/tree/main/packages/cli) 提供的命令行工具，可打包和检查 AIUI 工程、在设备上安装与启动智能体，以及在浏览器中预览页面。

## 安装

需要 Node.js 20 或更新版本。安装后可用 `aix --help` 查看当前版本支持的命令和选项。

```bash
npm install -g @yodaos-pkg/aix-cli
aix --help
```

## 打包与检查

在工程目录的上一级执行 `pack`，生成 `.aix` 包。`show` 可查看源码目录或现有包最终使用的 Agent Definition；`list` 查看包内文件，`optimize` 优化已有包。

```bash
aix pack ./my-agent -o ./my-agent.aix
aix show ./my-agent
aix show ./my-agent.aix --compact
aix list ./my-agent.aix
aix optimize ./my-agent.aix -o ./my-agent-optimized.aix --level 2
```

源码根目录中的 `.aixignore` 可排除不需要打包的文件。打包时可用 `--engine` 指定运行时版本范围；未指定时依次使用 `app.json.engine` 和 `*`。

## 安装到设备并启动页面

设备命令需要 ADB 和已连接、授权的设备。`install` 接受源码目录或 `.aix` 包；多台设备或非交互环境下用 `--serial` 指定设备。页面启动命令只打开已安装的智能体，需先安装。

```bash
aix device
aix install ./my-agent --serial <serial>
aix launch-page ./my-agent pages/index/index --serial <serial>
```

如需启动 Widget，可使用 `aix launch-widget <INPUT> <PATH>`；查看或清空布局可使用 `aix widget-layout`。完整设备命令与选项参见 [AIX CLI 文档](https://github.com/yodaos-project/aix/tree/main/packages/cli#device-commands)。

## 在浏览器中预览

`preview` 接受源码目录或 `.aix` 包，启动本地预览服务并打印访问地址。开发时可用 `--dev` 启用实时重载；`--launch` 自动打开浏览器。

```bash
aix preview ./my-agent --dev --launch
aix preview ./my-agent.aix
```

预览用于本地检查页面；设备上的交互与性能仍应通过真机验证。
