# Command Line Tool

`aix` is a command line tool for AIX (AI eXecutable) agent packages. Use it to package and inspect AIUI projects, install agents on a device, and preview pages in a browser. This page follows the command groups in the [AIX CLI README](https://github.com/yodaos-project/aix/blob/main/packages/cli/README.md).

In the examples below, `./my-agent` is your project directory, `bundle.aix` is an existing package, and `<serial>` is a device serial number. Replace these with your own values; angle brackets mark placeholders and should not be typed literally.

## Installation

Install Node.js 20 or later, then run these commands in a terminal:

```bash
npm install -g @yodaos-pkg/aix-cli
aix --help
```

The first command installs the CLI. The second confirms that `aix` runs. To see every option for a command, run `aix pack --help`, replacing `pack` with the command you need.

## Package Commands

These commands work with a project directory or `.aix` file on your computer. They do not need a connected device.

### `aix pack <INPUT_DIR>`

Package a project directory as an `.aix` file. `<INPUT_DIR>` is the directory path. For example, run the following from the parent directory of `my-agent`:

```bash
aix pack ./my-agent
aix pack ./my-agent -o my-app.aix
aix pack ./my-agent --engine '^0.14.0'
aix pack ./my-agent --log-time
```

`-o` sets the output filename. Packing validates JSON, converts supported text to UTF-8, generates a UUID v4 `VERSION`, and writes `META-INF/aix/manifest.json`. JavaScript and TypeScript are minified by default, but the source files are not changed.

Add `-O` or `--optimize` to further optimize JSON, PNG, and JPEG. Optimization levels range from 1 to 3; `--opt-level` matters only when optimization is enabled.

```bash
aix pack ./my-agent --optimize
aix pack ./my-agent -O --opt-level 3
```

`--engine` sets the supported runtime version range. Without it, the CLI checks `app.json.engine`, then uses `*` if the field is absent. Add a `.aixignore` file at the project root to exclude files using syntax similar to `.gitignore`. `--log-time` adds local timestamps to packing logs.

### `aix show <INPUT>`

Print the effective Agent Definition JSON. `<INPUT>` may be a project directory or `.aix` package; ADB is not required. `show` and `install` resolve the Definition in the same way, so `show` is useful for checking what will be submitted before installation.

```bash
aix show ./my-agent
aix show ./bundle.aix --compact
aix show ./my-agent -o ./agent.json
```

`--compact` prints one-line JSON; `-o` writes the result to a file. Use `--definition <FILE>` to provide a custom Definition that overrides some generated fields, but not `agentId`.

### `aix list <AIX_FILE>`

List the files and sizes inside an existing `.aix` package without extracting it. `ls` is an alias for `list`.

```bash
aix list bundle.aix
aix ls bundle.aix
```

### `aix optimize <AIX_FILE>`

Optimize JSON, PNG, and JPEG in an existing package. `-o` specifies the new package path. `--level` accepts 1 to 3 and defaults to 2.

```bash
aix optimize input.aix -o output.aix --level 2
```

## Device Commands

These commands communicate with a device through ADB. Install ADB, connect the device, and authorize debugging first. The CLI selects the only online, authorized device automatically. If several are connected, it opens a selector. In a script or other noninteractive environment, you must specify a device with `-s, --serial <serial>`.

An active stage displays a spinner. Completed intermediate stages collapse to a single `✔` line, while the latest result keeps its details. If a command fails, check the device connection, Developer Mode, and package contents first.

### `aix device [ACTION]`

With no action, inspect Developer Mode, Widget readiness and layout, and installed `.aix` agents without changing the device. `set-dev` turns Developer Mode on; `unset-dev` turns it off.

```bash
aix device
aix device set-dev
aix device unset-dev
```

Changing Developer Mode reloads all Widgets. Dynamic Widgets must be launched again afterward.

### `aix install <INPUT>`

Install a project directory or existing `.aix` package on the device. When given a directory, the CLI packages it first, then submits it to AIUI DEVELOP over ADB. When given a package, it uses that package directly.

```bash
aix install ./my-agent
aix install ./bundle.aix
aix install ./my-agent --definition ./agent.json --serial <serial>
```

A directory installation reuses `.aix/agent-id`; an artifact installation uses the package's `VERSION`. `--definition` supplies your own Agent Definition JSON and can override generated metadata, but not `agentId`. The CLI checks both the device Apply result and the phone upload result. Phone upload confirmation does not mean cloud indexing has finished.

If the device reports an incompatible runtime version, change `app.json.engine` in the source project or rebuild it with `aix pack ./my-agent --engine '<compatible-range>' -o bundle.aix`, then install the new package. Installation options cannot rewrite the engine range of an existing `.aix` package.

### `aix launch-page <INPUT> [PATH]`

Open a page from an agent that is **already installed** on the device. This command does not install it. `<INPUT>` identifies the agent; optional `[PATH]` chooses a page. If omitted, the declared entry page is used.

```bash
aix launch-page ./my-agent
aix launch-page ./my-agent pages/index/index
aix launch-page ./my-agent pages/index/index --card
aix launch-page ./my-agent pages/index/index --params '{"id":"123"}'
```

`--card` opens a card instead of full screen. `--params` passes a JSON object; for longer parameters, use `--params-file <FILE>` to read a JSON file. Run `aix install` first if the agent is not installed yet.

### `aix launch-widget <INPUT> <PATH>`

Open a Widget from an installed agent. `<PATH>` is the Widget path. `--position` sets the starting grid position. You can also pass parameters with `--params` or `--params-file`.

```bash
aix launch-widget ./my-agent widgets/order/index
aix launch-widget ./my-agent widgets/order/index --position 2
```

Widget size comes from `app.json.widgets[].family`. The CLI keeps compatible existing placements. A position conflict replaces overlapping overlay Widgets; if there is no space, old overlay placements are cleared. Persistent Widgets are never removed automatically.

When needed, the CLI prepares, pushes `widget-config.json`, applies the layout, and opens the Widget. If the runtime has lost its placement, it reapplies the layout and retries opening once.

### `aix widget-layout [show]`

Inspect or clear the device's Widget layout. The default command and `show` are read-only. `--clear` removes persistent and overlay Widget placements while keeping the grid settings.

```bash
aix widget-layout
aix widget-layout show
aix widget-layout --clear
aix widget-layout --clear --yes
```

In an interactive terminal, `--clear` asks for confirmation. In a script, add `--yes` explicitly because there is no prompt to answer. `--yes` is only valid with `--clear`. Configure or launch any Widgets you still want after clearing the layout.

## Preview Commands

These commands preview a project on your computer without a connected device. Browser preview helps check pages; verify device interaction and performance on the actual device.

### `aix preview <INPUT>`

Preview a source directory or `.aix` package. By default, the CLI starts a local server and prints its address. Open that address in a browser, or add `--launch` to open your default browser automatically.

```bash
aix preview bundle.aix
aix preview ./my-agent
aix preview bundle.aix --launch
aix preview bundle.aix --launch --launch-target current
```

`--launch-target` selects a viewport: the default `blank` is `480×352`, while `current` is `448×150`. To export static HTML instead, use `--html-out`. It does not start a server and cannot be combined with `--launch`.

```bash
aix preview bundle.aix --html-out ./artifacts/preview.html
```

When working on source files, add `--dev` for live reload over WebSocket:

```bash
aix preview ./my-agent --dev
aix preview ./my-agent --dev --launch
```

### `aix runtime`

Inspect or select the runtime version used for local preview:

```bash
aix runtime versions
aix runtime current
aix runtime select
```

- `versions` lists stable versions and the current selection.
- `current` prints only the resolved version, which is useful in scripts.
- `select` lets you choose interactively and saves the choice to `~/.aix/runtime.json`.

The version list comes from an npm registry. The default is npm; set `AIX_NPM_REGISTRY=npmmirror` to use npmmirror instead.

## Development

You only need this section if you intend to modify or build the CLI from source. In the [AIX repository's `packages/cli` directory](https://github.com/yodaos-project/aix/tree/main/packages/cli), run:

```bash
npm install
npm run build
node dist/cli.js --help
```

The build compiles the Rust engine used by the CLI, then bundles the TypeScript program. Packaging, optimization, and reading logic are shared with other environments in that project.
