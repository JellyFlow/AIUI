# 模块

AIUI 支持基于 ES Modules 的模块组织方式，可用于拆分业务逻辑、复用工具函数以及管理静态资源导入。

除了普通的 JavaScript 模块外，AIUI 也支持直接导入 `.ts` 文件。运行时会在模块执行前移除 TypeScript 语法，但当前不会进行类型检查，且不支持 TSX。

## 导出与导入

模块可以使用标准 ES Module 语法导出函数、对象或变量：

```javascript
// utils.js
export const formatTime = date => {
  return date.toISOString();
};

export default {
  sayHello: () => console.log('Hello')
};
```

然后在页面或组件中导入并使用：

```javascript
import { formatTime } from '../../utils.js';
import myLib from '../../lib.js';

export default {
  onLoad() {
    console.log(formatTime(new Date()));
    myLib.sayHello();
  }
};
```

如果使用 TypeScript，也可以直接导入 `.ts` 模块；省略扩展名时会优先尝试 `.js`，再尝试 `.ts`。

## 资源模块

AIUI 也支持通过 ESM 方式导入图片、音频和 WebAssembly 等静态资源。默认情况下，这些资源会以 `Blob` 形式作为默认导出。

```javascript
import icon, { mimeType, path } from '../assets/icon.png';

console.log(icon instanceof Blob);
console.log(mimeType);
console.log(path);
```

当前默认支持的资源类型包括：

- 图片：`.png`、`.jpg`、`.jpeg`、`.webp`、`.svg`、`.gif`、`.bmp`
- 音频：`.wav`、`.mp3`、`.ogg`、`.m4a`、`.aac`、`.flac`、`.pcm`
- WebAssembly：`.wasm`

除默认导出外，资源模块还会额外提供 `mimeType` 和 `path` 两个命名导出。

## 类型化资源导入

在需要显式指定资源类型时，可以通过 import attributes 获取更具体的运行时对象：

```javascript
import icon from '../assets/icon.png' with { type: 'image' };
import click from '../assets/click.wav' with { type: 'sound' };

console.log(icon instanceof ImageData);
console.log(click instanceof Sound);
```

其中：

- `type: 'image'` 仅适用于图片资源，默认导出为 `ImageData`
- `type: 'sound'` 仅适用于音频资源，默认导出为 `Sound`
- 不支持的类型或不匹配的资源类型会导致模块加载失败

## 补充说明

- 模块能力适用于页面、组件及其他可复用逻辑文件
- 推荐将通用逻辑拆分到独立模块中，避免页面文件过于臃肿
- 如果需要复用组件能力，请优先使用组件；如果只是复用逻辑或资源，优先使用模块
