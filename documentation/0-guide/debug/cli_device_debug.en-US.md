# Real-Device Debugging (CLI)

Use the command line workflow when you want to install a locally edited AIUI project on glasses and check a page or Widget immediately. The `aix` command communicates with the device over ADB. If you build in AIUI Studio and update the glasses resource package through the phone app, see [Real-Device Debugging (AIUI Studio)](/AIUI/guide/debug-real_device_debug).

The examples use `./my-agent` for a local project directory and `pages/index/index` for a page path. Replace them with paths from your project.

## 1. Prepare the Tools and Device

Install Node.js 20 or later, ADB, and the AIX command line tool on your computer. Connect the glasses and allow debugging. Check that ADB sees the device, then inspect its status:

```bash
npm install -g @yodaos-pkg/aix-cli
adb devices
aix device
```

`adb devices` should show a device with status `device`. If it shows `unauthorized`, allow debugging on the device. `aix device` displays Developer Mode, Widget status, and installed agents. With one online, authorized device, `aix` selects it automatically. If several are connected, append `--serial <device-serial>` to a command. In a noninteractive script, the serial is required.

## 2. Inspect and Install the Local Project

Inspect the effective Agent Definition, then install the project. `aix install` packages a directory before submitting it to the device, so you do not need to run `aix pack` first.

```bash
aix show ./my-agent
aix install ./my-agent
```

If you already have an `.aix` package, you can run `aix install ./bundle.aix` instead. Installation checks the device Apply and phone upload results; an installation success message does not mean cloud indexing has finished. After changing local code, run `aix install ./my-agent` again, then open a page on the device to check the new version.

## 3. Open a Page or Widget

After installation, open the project's entry page. Supply a project page path to open a particular page:

```bash
aix launch-page ./my-agent
aix launch-page ./my-agent pages/index/index
```

Add `--card` to open a card, or use `--params` to pass a JSON object. `launch-page` only sends an open request. It does not install the agent or prove that the page rendered successfully.

```bash
aix launch-page ./my-agent pages/index/index --card
aix launch-page ./my-agent pages/index/index --params '{"id":"123"}'
```

To debug a Widget, enable Developer Mode, install the project, and launch the Widget. Replace the sample Widget path with one declared in your `app.json`.

```bash
aix device set-dev
aix install ./my-agent
aix launch-widget ./my-agent widgets/order/index
aix widget-layout
```

`aix widget-layout` shows the current layout. Changing Developer Mode reloads Widgets, so dynamic Widgets must be launched again. See [Command Line Tool](/AIUI/tools/cli) for more Widget layout options.

## 4. Verify on the Device

On the glasses, check the initial screen, main interactions, return path, speech and temple controls, network behavior, and local capabilities. A command line message saying that a launch request was accepted only confirms that the device accepted the request. Confirm the rendered page and extended use on the glasses.

If the device cannot be reached, check its status in `adb devices` and the value of `--serial`. If installation reports an incompatible runtime version, change `app.json.engine` in the source project or reinstall it with `aix install ./my-agent --engine '<compatible-range>'`. The version range in an existing `.aix` package cannot be changed during installation; rebuild it from source.

For complete packaging, device, and preview command details, see [Command Line Tool](/AIUI/tools/cli).
