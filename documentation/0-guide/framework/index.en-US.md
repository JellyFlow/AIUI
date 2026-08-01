# Agent Framework

AIUI is an intent-driven development framework for building intelligent agents. Its goal is not only to render interfaces or execute page logic, but to turn user intent into a complete product flow: the agent understands intent, selects the right interaction form, runs the required logic, and continuously maps the result back into UI feedback.

At the implementation level, AIUI is built around two core layers:

- **Logic Layer**: Interprets intent, runs agent and page logic, manages state, calls APIs, and responds to user events.
- **View Layer**: Uses WXML, WXSS, and built-in components to present intent, collect user input, and reflect state changes.

But AIUI is not defined only by the split between logic and UI. In a real agent project, the framework also works together with:

- `AGENTS.md`, which defines the agent's identity, goals, capabilities, and behavioral boundaries
- `app.json`, which defines page entries and global configuration
- page files, which connect intent handling, business logic, and visual structure into a runnable experience

Together, these parts form a full loop from **intent understanding** to **interaction orchestration** to **interface feedback**.

## What You Will Learn

This section explains the framework from four perspectives:

- **Introduction**: Learn how AIUI organizes intent, runtime, and UI into one coherent framework.
- **Categories**: Understand different intent-carrying interaction forms, such as conversational AIUI and immersive AIUI.
- **Logic Development**: Learn how to organize lifecycle hooks, state, and business logic around user intent.
- **User Interface (UI) Development**: Learn how to build interfaces that expose intent, collect actions, and return feedback with WXML and WXSS.

## Suggested Reading Path

- If you are new to AIUI, start with **Introduction** to understand why AIUI is framed around intent rather than pages alone.
- Then read **Categories** to decide what interaction form should carry your product's intent.
- Continue with **Logic Development** to understand how intent is translated into state, lifecycle, and business behavior.
- Finally, read **User Interface (UI) Development** to connect intent-driven logic with a concrete interface.

Use the sub-sections in the left-side menu to continue reading.
