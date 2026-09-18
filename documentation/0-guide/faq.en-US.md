# Frequently Asked Questions

This page collects common questions that come up while developing with AIUI. Before you begin, read the [Quick Start](/AIUI/guide/quickstart). For questions about a specific capability, also check the relevant component or API documentation.

## Where Should I Start Learning AIUI?

If you are new to AIUI, follow this path:

1. Read the [Introduction](/AIUI/guide/quickstart-intro) to understand where AIUI fits.
2. Complete the [Quick Start](/AIUI/guide/quickstart-quickstart) to learn the development, debugging, and publishing workflow.
3. Choose [AIUI in Chat](/AIUI/guide/quickstart-first-chat) or [Immersive AIUI](/AIUI/guide/quickstart-first-immersive) based on your product experience.
4. Read [Project Structure](/AIUI/guide/structure) to understand how project files are organized.

## What Is the Difference Between AIUI in Chat and Immersive AIUI?

AIUI in Chat is designed for lightweight, context-aware interactions inside a conversation. Immersive AIUI is designed for tasks that need a standalone page, sustained interaction, or a richer visual layout. An agent can use both, depending on how much interaction a task requires.

## Where Can I Find Component and API Usage?

- For UI elements and their properties, see [Components](/AIUI/components).
- For JavaScript, device, network, media, and AI capabilities, see the [API documentation](/AIUI/api).
- For agent organization and runtime behavior, see [Agent Framework](/AIUI/guide/framework) and [Agent Runtime](/AIUI/guide/runtime).

## How Should I Troubleshoot Runtime or Display Issues?

First confirm that the project structure and related API usage match the current documentation. Then use [Web Simulation Debugging](/AIUI/guide/debug-web_debug) to check logic and UI quickly. For device capabilities, platform differences, or issues that depend on the real runtime environment, continue with [Real-Device Debugging](/AIUI/guide/debug-real_device_debug).

## How Do I Package and Publish an Agent?

Start with the [AIX format](/AIUI/guide/bundle-aix), then follow [Submit for Review and Publish](/AIUI/guide/bundle-publish). To work with packages locally, see the [CLI guide](/AIUI/guide/bundle-cli).
