# Craft Platform

Craft is an integrated workspace for AIUI and Ink projects. It helps developers complete project import, file browsing, code editing, and page preview within a single interface.

Access URL: <https://js.rokid.com/craft>

## Core Capabilities

- **Import Projects**: Supports opening local projects and quickly entering the workspace based on the project directory.
- **File Browsing**: View the project structure in the file tree on the left and quickly locate key files with the page and structure sections.
- **Code Editing**: Modify project file contents directly while keeping the local project synchronized with the editor.
- **Real-Time Preview**: Render the current page inside the workspace, making it easy to verify the UI, page configuration, and runtime results.

## Applicable Scenarios

- **Page Debugging**: Check whether page titles, descriptions, schemas, and entry files are configured correctly.
- **Parameter Validation**: Use the runtime configuration panel to select pages and test runtime parameters.
- **Project Inspection**: Quickly understand the directory structure, page distribution, and key resources after importing a project.
- **Integrated Development**: Observe preview changes immediately after editing code, shortening the feedback loop between modification and verification.

## Relationship with AIUI

Craft is part of the AIUI development toolchain and does not replace the AIUI framework itself. You can think of it as the workspace entry point that connects project structure, page configuration, and runtime preview:

- AIUI is responsible for page structure, the component system, and the development model for agent applications.
- Craft is responsible for connecting project import, file editing, page discovery, and runtime preview.

## Usage Recommendations

- Start by visiting <https://js.rokid.com/craft> to enter the Craft workspace, then import your local AIUI or Ink project to begin development.
- Use Craft first to check whether `app.json`, page files, and runtime parameter configurations match.
- When debugging page issues, use `Pages`, `Outline`, and the rendering area on the right together.
- Switch to the appropriate development tool when you need packaging, publishing, or other toolchain capabilities.
