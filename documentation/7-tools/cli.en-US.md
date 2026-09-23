# Command Line Tool

`aix` is the command line tool provided by [AIX CLI](https://github.com/yodaos-project/aix/tree/main/packages/cli). It packages and inspects AIUI projects, installs and launches agents on devices, and previews pages in a browser.

## Install

Node.js 20 or later is required. Run `aix --help` to see the commands and options supported by your installed version.

```bash
npm install -g @yodaos-pkg/aix-cli
aix --help
```

## Package and Inspect

Run `pack` from the parent directory of your project to create an `.aix` package. `show` prints the effective Agent Definition for a source directory or package; `list` shows package entries, and `optimize` optimizes an existing package.

```bash
aix pack ./my-agent -o ./my-agent.aix
aix show ./my-agent
aix show ./my-agent.aix --compact
aix list ./my-agent.aix
aix optimize ./my-agent.aix -o ./my-agent-optimized.aix --level 2
```

Use `.aixignore` in the source root to exclude files. `--engine` sets the runtime version range when packaging; without it, the tool uses `app.json.engine`, then `*`.

## Install on a Device and Launch a Page

Device commands require ADB and a connected, authorized device. `install` accepts a source directory or `.aix` package. Use `--serial` when multiple devices are connected or in a noninteractive environment. Page launch opens an already installed agent, so install it first.

```bash
aix device
aix install ./my-agent --serial <serial>
aix launch-page ./my-agent pages/index/index --serial <serial>
```

Use `aix launch-widget <INPUT> <PATH>` to launch a Widget and `aix widget-layout` to inspect or clear its layout. See the [AIX CLI documentation](https://github.com/yodaos-project/aix/tree/main/packages/cli#device-commands) for all device commands and options.

## Preview in a Browser

`preview` accepts a source directory or `.aix` package, starts a local preview server, and prints its URL. Use `--dev` for live reload during development and `--launch` to open the browser.

```bash
aix preview ./my-agent --dev --launch
aix preview ./my-agent.aix
```

Use the preview to check pages locally; verify device interaction and performance on a real device.
