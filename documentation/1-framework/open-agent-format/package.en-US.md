# Packages

Packages are the basic unit AIUI uses to organize reusable modules and components. Developers can group related modules, components, assets, and configuration into a standalone package for reuse and distribution across multiple projects.

AIUI currently supports publishing packages to npm and loading them in applications through `node_modules`.

## Recommended Layout

A typical package usually contains the following structure:

```text
my-package/
  package.json
  index.js
  utils.js
  components/
    demo-card.ink
```

The most important file is the root `package.json`, which defines the package name, entry points, and export behavior.

## package.json

AIUI resolves packages from the metadata declared in `package.json`. Common fields include:

- `name`: the package name used in imports
- `main`: the default JavaScript entry
- `module`: an optional module entry
- `exports`: explicit exported subpaths
- `ink.components`: explicit component exports for `usingComponents`

Example:

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

## Module Exports

If a package mainly provides JavaScript or TypeScript capabilities, expose its entry points through `exports`, `module`, or `main`.

For example:

```javascript
// index.js
export function formatMessage(name) {
  return `Hello ${name}`;
}
```

Applications can consume it like this:

```javascript
import { formatMessage } from '@demo/ui';

export default {
  onLoad() {
    console.log(formatMessage('AIUI'));
  }
};
```

When subpath APIs are needed, prefer `exports` so the public surface stays explicit and stable.

## Component Exports

Components are not auto-discovered from package files. They must be exported explicitly through `ink.components`.

For example:

```json
{
  "ink": {
    "components": {
      "./demo-card": "./components/demo-card"
    }
  }
}
```

Then reference them in a page or component through `usingComponents`:

```html
<script def>
{
  "usingComponents": {
    "demo-card": "@demo/ui/demo-card"
  }
}
</script>
```

This pattern works well when you want to reuse shared UI components across multiple AIUI applications.

## Development And Publishing

When developing a package, these practices are recommended:

- Keep `package.json.name` stable and avoid frequent renaming
- Export public capabilities through explicit entry points instead of internal file paths
- If the package contains both modules and components, manage them separately through module entries and `ink.components`
- Organize assets and logic by feature so the package root stays clean

The recommended distribution path is publishing to npm. After publishing, AIUI applications can install the package as a dependency.

A typical flow looks like this:

1. Build and organize the package structure
2. Configure `package.json`
3. Add `exports` and `ink.components` as needed
4. Publish to npm
5. Install the dependency in an AIUI application

## Using Packages In AIUI

Published packages can be loaded by AIUI applications through `node_modules`.

For example, after installation:

```bash
npm install @demo/ui
```

You can import its modules directly:

```javascript
import { formatMessage } from '@demo/ui';
```

Or use its explicitly exported components:

```html
<script def>
{
  "usingComponents": {
    "demo-card": "@demo/ui/demo-card"
  }
}
</script>
```

## Notes

- Packages are a good fit for shared modules and components reused across projects
- If logic is only reused inside one application, local modules are usually enough
- If UI structure and interactions need to be reused, packaging components into a published package is the better approach
