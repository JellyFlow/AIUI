# Package

Package 是 AIUI 中组织可复用模块和组件的基本单元。开发者可以将一组相关的模块、组件、资源文件和配置组织为一个独立 Package，便于在多个项目之间复用与分发。

目前 AIUI 支持通过 npm 发布 Package，并在应用中通过 `node_modules` 加载。

## 推荐目录结构

一个典型的 Package 通常包含以下内容：

```text
my-package/
  package.json
  index.js
  utils.js
  components/
    demo-card.ink
```

其中最关键的是根目录下的 `package.json`，它决定了 Package 的名称、入口和导出方式。

## package.json

AIUI 会根据 `package.json` 中的元数据解析 Package。常用字段包括：

- `name`：Package 名称，也是导入时使用的包名
- `main`：默认 JavaScript 入口
- `module`：可选的模块入口
- `exports`：显式声明可导出的子路径
- `ink.components`：显式声明可供 `usingComponents` 使用的组件导出

示例：

```json
{
  "name": "@demo/ui",
  "main": "./index.js",
  "exports": {
    ".": "./index.js",
    "./utils": "./utils.js"
  },
  "ink": {
    "components": {
      "./demo-card": "./components/demo-card"
    }
  }
}
```

## 模块导出

如果 Package 主要提供 JavaScript 或 TypeScript 能力，推荐通过 `exports`、`module` 或 `main` 暴露入口。

例如：

```javascript
// index.js
export function formatMessage(name) {
  return `Hello ${name}`;
}
```

应用中可以这样使用：

```javascript
import { formatMessage } from '@demo/ui';

export default {
  onLoad() {
    console.log(formatMessage('AIUI'));
  }
};
```

如果需要导出子路径能力，则优先使用 `exports`，这样可以让导出边界更清晰、更稳定。

## 组件导出

组件不会从文件系统中自动发现，必须通过 `ink.components` 显式导出。

例如：

```json
{
  "ink": {
    "components": {
      "./demo-card": "./components/demo-card"
    }
  }
}
```

然后在页面或组件中通过 `usingComponents` 引入：

```html
<script def>
{
  "usingComponents": {
    "demo-card": "@demo/ui/demo-card"
  }
}
</script>
```

这种方式适合将通用 UI 组件封装为独立 Package，在多个 AIUI 应用中复用。

## 开发与发布

开发 Package 时，建议遵循以下原则：

- 保持 `package.json.name` 稳定，避免频繁变更包名
- 将公共能力通过明确入口导出，不直接依赖内部文件路径
- 如果同时包含模块与组件，分别通过模块入口和 `ink.components` 管理
- 将资源文件与逻辑文件按功能组织，避免根目录过于杂乱

当前推荐的发布方式是发布到 npm。发布后，应用即可通过安装依赖的方式获取该 Package。

常见流程如下：

1. 编写并整理 Package 目录结构
2. 配置 `package.json`
3. 根据需要补充 `exports` 和 `ink.components`
4. 发布到 npm
5. 在 AIUI 应用中安装依赖

## 在 AIUI 中使用

发布后的 Package 可以通过 `node_modules` 被 AIUI 应用加载。

例如安装后：

```bash
npm install @demo/ui
```

即可在应用中直接导入模块：

```javascript
import { formatMessage } from '@demo/ui';
```

也可以引用其中显式导出的组件：

```html
<script def>
{
  "usingComponents": {
    "demo-card": "@demo/ui/demo-card"
  }
}
</script>
```

## 补充说明

- Package 更适合承载跨项目复用的模块和组件集合
- 如果只是当前应用内部复用逻辑，通常直接拆分本地模块即可
- 如果需要复用 UI 结构与交互，推荐将组件封装进 Package 后统一发布与维护
