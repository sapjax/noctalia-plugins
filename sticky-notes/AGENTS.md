# AGENTS.md

This document serves as a guide for AI agents and human developers working on the `sticky-notes` plugin. It outlines the project's architecture, conventions, and the specialized roles an agent should adopt when contributing to the codebase.

## 1. Project Overview

`sticky-notes` (Sticky Notes) is a local, Quickshell-based plugin for Noctalia. It provides a system bar widget and a slide-out panel allowing users to quickly create, edit, and delete Markdown-supported sticky notes.

### Tech Stack
- **Frontend UI:** QML (Qt 6 / Qt Quick), Quickshell
- **Logic & Parsing:** JavaScript (Qt's QML engine)
- **State Management:** QML `ListModel`
- **Persistence:** Noctalia's `pluginSettings` JSON serialization

## 2. Directory Structure

- `manifest.json`: Core plugin metadata, versioning, and entry point definitions.
- `BarWidget.qml`: The system tray / bar icon that toggles the main panel.
- `Panel.qml`: The main application view, managing the `ListModel`, data marshaling, and injecting dependencies.
- `components/`: Reusable QML interface pieces.
  - `NoteList.qml`: Grid/Flow layout managing the lifecycle of notes (Create/Edit).
  - `NoteCard.qml`: The individual sticky note component (Display & Edit modes).
  - `NewNoteCard.qml`: The input form for creating fresh notes.
  - `EmptyState.qml`: Placeholder UI for an empty workspace.
- `utils/`: JavaScript libraries.
  - `storage.js`: Utilities for ID generation, color palettes, and relative timestamps.
  - `markdown.js`: A custom, lightweight Markdown-to-RichText renderer.
- `i18n/`: Internationalization JSON files (e.g., `zh.json`).
- `tests/`: Test suites and sample markdown for verifying logic (e.g., Markdown parsing).

## 3. AI Agent Roles

When tasked with a feature or bug fix, assume one of the following roles to ensure code consistency. Note: use multi-role switching when a task spans multiple domains (e.g., adding a UI button that modifies Markdown logic).

### 🛠️ [Role: QML UI Expert]
**Focus:** Modifying visual interfaces, animations, and Qt Quick layouts.
**Guidelines:**
- **Styling Hooks:** Always use Noctalia's native globals: `Style` (e.g., `Style.marginM`, `Style.uiScaleRatio`) and `Color` (e.g., `Color.mPrimary`). Avoid magic numbers.
- **Responsiveness:** Make use of `implicitWidth`, `implicitHeight`, and `Layout` properties (e.g., `Layout.fillWidth: true`) instead of hardcoded dimensions when possible.
- **Animations:** Use `Behavior` with `ColorAnimation` or `NumberAnimation` for smooth UI state transitions (e.g., hover states, dynamic resizing).
- **Component Communication:** Favor QML `signal` declarations in child components (e.g., `signal saveClicked(string content)`) rather than tightly coupling UI layers. 

### 🧠 [Role: JS Logic Developer]
**Focus:** Modifying scripts in `utils/`, updating data transformations, and fixing parser bugs.
**Guidelines:**
- **Environment:** Code runs within the Qt QML JavaScript engine. Stick to strictly compatible ES5/ES6 paradigms.
- **Markdown Processing:** `markdown.js` utilizes regex and placeholders. Always escape HTML securely before parsing to prevent injection. Ensure styling contrasts well with the pastel sticky colors.
- **Data Integrity:** When modifying stored data structures in `Panel.qml` or `storage.js`, include backward-compatibility checks for users who have older notebook JSON formats.

### 🌐 [Role: Plugin Maintainer]
**Focus:** Infrastructure, internationalization, and plugin releases.
**Guidelines:**
- **Translations:** Never hardcode English strings in the UI. Always use `pluginApi.tr("namespace.key", "Fallback text")`.
- **Localization Updates:** When adding a new string, update all relevant `i18n/*.json` files.
- **Versioning:** Increment the semantic version in `manifest.json` to reflect the scope of new changes.
- **Testing:** Ensure `tests/` coverage is maintained or expanded when parser or storage logic evolves.

## 4. Common Workflows

### ➕ Workflow: Adding a New UI Control
1. Create or open the relevant file in `components/`.
2. Use standard `QtQuick.Controls` or custom Noctalia `qs.Widgets` (e.g., `NIconButton`, `NText`).
3. Connect the control via a declarative `signal`.
4. In `Panel.qml` or `NoteList.qml`, attach to the signal (e.g., `onMySignalTriggered: { ... }`) to handle the state/data layer.

### 📝 Workflow: Modifying the Markdown Engine
1. Update `utils/markdown.js`.
2. Maintain the 5-step pipelined approach: extract code blocks -> escape HTML -> apply regex -> render tags -> restore code blocks.
3. Test against edge cases inside the `tests/` directory files like `markdown.md`. Ensure spacing and line height look correct in the `QML TextEdit.RichText` format.

### 💾 Workflow: Changing Data Storage 
1. The data is currently a serialized JSON array bound to `pluginApi.pluginSettings.notes`.
2. Make logic alterations in `Panel.qml`'s `loadNotes()` or `persistNotes()` functions.
3. Always implement a migration path inside `loadNotes()` to upgrade older parsed objects to the new schema cleanly.
