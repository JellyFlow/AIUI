# 常见问题

本页汇总 AIUI 开发过程中经常遇到的问题。开始开发前，建议先阅读[快速开始](/AIUI/guide/quickstart)；如果问题与某项具体能力有关，请同时查阅对应的组件或 API 文档。

## 我应该从哪里开始学习 AIUI？

第一次使用 AIUI 时，建议按以下顺序阅读：

1. 阅读[介绍](/AIUI/guide/quickstart-intro)，了解 AIUI 的适用场景。
2. 完成[快速入门](/AIUI/guide/quickstart-quickstart)，熟悉开发、调试与发布流程。
3. 根据产品形态选择[对话式 AIUI](/AIUI/guide/quickstart-first-chat)或[沉浸式 AIUI](/AIUI/guide/quickstart-first-immersive)。
4. 阅读[项目结构](/AIUI/guide/structure)，了解项目文件如何组织。

## 对话式 AIUI 和沉浸式 AIUI 有什么区别？

对话式 AIUI 适合在聊天流程中展示轻量、上下文相关的交互内容；沉浸式 AIUI 适合需要独立页面、持续操作或更完整视觉布局的任务。两者可以在同一个智能体中配合使用，具体选择取决于任务需要的交互深度。

## 在哪里查找组件和 API 的用法？

- 界面元素及其属性请查阅[组件](/AIUI/components)。
- JavaScript、设备、网络、媒体和 AI 能力请查阅 [API](/AIUI/api)。
- 智能体的组织方式和运行机制请查阅[智能体框架](/AIUI/guide/framework)与[智能体运行时](/AIUI/guide/runtime)。

## 遇到运行或显示问题时如何排查？

先确认项目结构和相关 API 用法是否符合当前文档，再使用[网页端模拟调试](/AIUI/guide/debug-web_debug)快速检查逻辑和界面。涉及设备能力、平台差异或真实运行环境的问题，应继续使用[真机调试](/AIUI/guide/debug-real_device_debug)验证。

## 如何打包和发布智能体？

请先了解 [AIX](/AIUI/guide/bundle-aix) 包格式，再根据[提审与发布](/AIUI/guide/bundle-publish)完成发布流程。需要在本地处理包文件时，可参考[命令行工具](/AIUI/guide/bundle-cli)。
