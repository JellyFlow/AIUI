# Introduction

The core of the AIUI agent framework is not simply "rendering a page." AIUI is an intent-driven development framework: developers describe what kind of agent they are building, what user intent should be captured, how that intent should be processed, and what interaction form should be used to return feedback. The runtime then connects these parts into a complete loop.

The interactive explanation below helps you understand the AIUI framework from two angles:

- What parts participate in the intent-to-feedback loop
- How a page update happens at runtime

<framework-runtime-explorer></framework-runtime-explorer>

## Core Concepts

AIUI adopts the classic separation between the logic layer and the view layer, but within an intent-driven agent framework this separation does not exist in isolation. Instead, it works together with the agent description, agent entry, and page structure:

1. **Agent Description**: Defined by `AGENTS.md`, which specifies the agent's identity, description, capabilities, and system instructions, determining how the platform understands what kinds of intent this agent should handle.
2. **Agent Entry (Application Entry)**: Defined by `app.json`, which specifies page entries and global window configuration, determining where the interaction starts.
3. **Logic Layer**: Runs in QuickJS and is responsible for interpreting user actions, running business logic, calling APIs, and managing data state.
4. **View Layer**: Built with WXML and WXSS, runs in the Ink rendering engine, and is responsible for presenting intent, collecting input, and rendering feedback.

This architecture not only provides smooth interface update capability, but also lets developers organize "what intent the agent should take on," "where the interaction starts," "how the logic flows," and "how the interface responds" as separate but connected concerns. That makes AIUI a better fit for AI + AR scenarios with high-frequency interaction and continuously evolving state.
