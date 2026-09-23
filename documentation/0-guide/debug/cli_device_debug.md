# 真机调试（命令行）

命令行真机调试适合在本地修改 AIUI 工程后，直接安装到眼镜并检查页面或 Widget。使用 `aix` 命令通过 ADB 操作设备；如果你使用 AIUI Studio 构建版本并通过手机 App 更新眼镜资源包，请参阅[真机调试（AIUI Studio）](/AIUI/guide/debug-real_device_debug)。

下面用 `./my-agent` 表示本地工程目录，`pages/index/index` 表示要打开的页面路径。请按自己的工程替换。

## 1. 准备工具和设备

在电脑上安装 Node.js 20 或更新版本、ADB 和 AIX 命令行工具，然后连接眼镜并允许调试。先确认 ADB 能识别设备，再查看设备状态：

```bash
npm install -g @yodaos-pkg/aix-cli
adb devices
aix device
```

`adb devices` 应显示一台状态为 `device` 的设备。如果显示 `unauthorized`，请在设备上允许调试。`aix device` 会显示开发者模式、Widget 状态和已安装的智能体。只有一台在线且已授权的设备时，`aix` 会自动选择；连接多台设备时可在命令末尾添加 `--serial <设备序列号>`。在无法交互的脚本中必须指定序列号。

## 2. 检查并安装本地工程

先查看即将使用的 Agent Definition，再安装工程。`aix install` 会自动打包目录并提交给设备，无需预先运行 `aix pack`。

```bash
aix show ./my-agent
aix install ./my-agent
```

如果已有 `.aix` 包，也可以执行 `aix install ./bundle.aix`。安装命令会检查设备应用和手机上传的结果；显示安装成功不代表云端索引已经完成。修改本地代码后，重新运行 `aix install ./my-agent`，再在设备上打开页面检查新版本。

## 3. 打开页面或 Widget

安装完成后，打开工程的入口页面；要检查指定页面时，提供它在工程中的路径：

```bash
aix launch-page ./my-agent
aix launch-page ./my-agent pages/index/index
```

需要以卡片形式打开时添加 `--card`；要传入页面参数，可用 `--params` 提供 JSON 对象。`launch-page` 只发送打开请求，不会自动安装，也不代表页面已经渲染成功。

```bash
aix launch-page ./my-agent pages/index/index --card
aix launch-page ./my-agent pages/index/index --params '{"id":"123"}'
```

调试 Widget 时，先开启开发者模式，再安装并启动对应的 Widget。`<Widget 路径>` 应换成 `app.json` 中声明的实际路径。

```bash
aix device set-dev
aix install ./my-agent
aix launch-widget ./my-agent widgets/order/index
aix widget-layout
```

`aix widget-layout` 可查看当前布局。开启或关闭开发者模式会重载 Widget；动态 Widget 需要重新启动。调整 Widget 布局的更多选项见[命令行工具](/AIUI/tools/cli)。

## 4. 在设备上验证结果

在眼镜上检查首屏、核心交互、返回路径、语音与镜腿操作，以及网络和本地能力。命令行显示“启动请求已接受”只能说明设备接受了请求；页面是否正确显示、持续运行是否稳定，仍需在眼镜上确认。

如果设备无法连接，先检查 `adb devices` 的状态和 `--serial`。如果安装提示运行时版本不兼容，应从源码工程调整 `app.json.engine` 或使用 `aix install ./my-agent --engine '<兼容范围>'` 重新打包安装；现成 `.aix` 包的版本范围不能在安装时直接修改，必须从源码重新打包。

完整的打包、设备和预览命令说明见[命令行工具](/AIUI/tools/cli)。
