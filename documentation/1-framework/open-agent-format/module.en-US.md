# Modules

AIUI supports ES Modules for organizing code, reusing utilities, and managing static asset imports.

In addition to standard JavaScript modules, AIUI also supports importing `.ts` files directly. TypeScript syntax is removed before runtime evaluation, but there is currently no type checking, and TSX is not supported.

## Exporting And Importing

Modules can export functions, objects, or variables using standard ES Module syntax:

```javascript
// utils.js
export const formatTime = date => {
  return date.toISOString();
};

export default {
  sayHello: () => console.log('Hello')
};
```

Then import and use them in a page or component:

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

If you use TypeScript, `.ts` modules can also be imported directly. When the extension is omitted, resolution tries `.js` first and then `.ts`.

## Asset Modules

AIUI also supports importing images, audio files, and WebAssembly assets through ESM. By default, these assets are exported as `Blob`.

```javascript
import icon, { mimeType, path } from '../assets/icon.png';

console.log(icon instanceof Blob);
console.log(mimeType);
console.log(path);
```

The currently supported default asset types include:

- Images: `.png`, `.jpg`, `.jpeg`, `.webp`, `.svg`, `.gif`, `.bmp`
- Audio: `.wav`, `.mp3`, `.ogg`, `.m4a`, `.aac`, `.flac`, `.pcm`
- WebAssembly: `.wasm`

In addition to the default export, asset modules also expose `mimeType` and `path` as named exports.

## Typed Asset Imports

When you need explicit runtime materialization, import attributes can be used to get more specific objects:

```javascript
import icon from '../assets/icon.png' with { type: 'image' };
import click from '../assets/click.wav' with { type: 'sound' };

console.log(icon instanceof ImageData);
console.log(click instanceof Sound);
```

In this mode:

- `type: 'image'` only works with image assets and returns `ImageData`
- `type: 'sound'` only works with audio assets and returns `Sound`
- Unsupported types or mismatched asset types cause module loading to fail

## Notes

- Module support can be used in pages, components, and other reusable logic files
- Shared logic is best extracted into standalone modules to keep page files focused
- Prefer components for reusable UI structure, and modules for reusable logic or assets
