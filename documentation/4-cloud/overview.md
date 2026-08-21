# Cloud 能力概览

AIUI Cloud 为第三方系统提供连接 Rokid 云服务和 Glasses 设备的服务端集成能力。它适合由业务服务、定时任务或外部 Agent 发起调用，将云端事件转化为用户在 Glasses 上可以接收和处理的信息。

当前提供的主要能力是智能体通知下发：第三方系统可以向指定用户推送文本通知，也可以让通知在点击后打开已注册的 AIUI 页面并传递参数。

## 集成方式

AIUI Cloud 支持以下两种调用方式：

- 使用 `@yodaos-pkg/cloud-integration` npm 包，在 Node.js 服务中通过结构化 API 发起请求。
- 直接使用 HTTP 或 `curl` 调用云端接口，适用于其他语言、自动化脚本或不方便安装 npm 包的环境。

两种方式使用相同的账号凭证、业务参数和服务端接口。选择方式不会改变通知在 Glasses 端的行为。

## 安装 npm 包

`@yodaos-pkg/cloud-integration` 面向 Node.js 20 及以上环境，并使用运行时内置的 `fetch`：

```bash
npm install @yodaos-pkg/cloud-integration
```

```js
import { CloudIntegration } from '@yodaos-pkg/cloud-integration'

const cloud = new CloudIntegration({
  token: process.env.ROKID_SK,
})
```

SK 是智能体所属账号的敏感凭证。请将它保存在服务端环境变量或密钥管理服务中，不要写入 AIUI 页面代码、客户端包、源码仓库或日志。

## 安装 Cloud Integration Skill

`aiui-cloud-integration` Skill 为 AI 编码助手提供 npm、HTTP、`curl`、页面跳转和错误处理的集成上下文。可以通过以下命令添加：

```bash
npx skills add https://github.com/jsar-project/AIUI/tree/main/skills/aiui-cloud-integration
```

Skill 用于辅助开发和生成集成代码，不会代替 SK，也不会自动发送通知。

## 下一步

请参阅[通知下发](./notifications.md)，了解凭证准备、请求参数、npm 与 `curl` 示例、页面跳转和响应处理。
