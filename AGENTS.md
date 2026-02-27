# AGENTS.md - MP Shader Lib

## Project Overview

This is a Godot 4.6 EditorPlugin (shader library) located in `addons/mp_shader_lib/`. The plugin provides shader include management and compute shader utilities for the Godot editor.

## Build & Development Commands

### Research about Godot specifics
- always reference https://docs.godotengine.org/de/4.x/index.html for engine and gdscript details

### Running the Project
- Open the project in **Godot 4.6+** (Forward Plus renderer)
- Press F5 to run, or use the Godot editor directly
- The plugin loads automatically when the project opens

### Testing
- **No formal test framework exists** - manual testing via Godot editor
- Test shader includes by creating them via the dock UI
- Test compute shaders by running the example scenes

### Linting
- Godot has no built-in linter for GDScript
- Use **GDShader** extension in VS Code for syntax highlighting
- Follow Godot GDScript style guide (see below)

## Code Style Guidelines

### File Organization
```
addons/mp_shader_lib/
├── mp_shader_lib.gd          # Main plugin entry point
├── plugin.cfg                # Plugin metadata
├── dock/                     # Editor dock UI scripts
│   ├── include_browser_dock.gd
│   ├── dynamic_texture_ui.gd
│   └── shader_wizard.gd
├── shaders/
│   ├── includes/             # .gdshaderinc files (reusable shader snippets)
│   ├── templates/            # Template files for shader generation
│   └── examples/             # Example shaders and compute demos
```

### GDScript Conventions

**Naming:**
- Classes: `PascalCase` (e.g., `IncludeBrowserDock`)
- Functions: `snake_case` with verb prefix (e.g., `_on_tree_item_selected`)
- Variables: `snake_case` (e.g., `texture_amount`, `cache_data`)
- Constants: `SCREAMING_SNAKE_CASE` for values, `PascalCase` for type constants (e.g., `const ROOT := "res://..."`)
- Private variables: prefix with `_` (e.g., `_internal_var`)

**Type Annotations:**
- Always use type hints: `var count: int = 0`
- Use Godot 4.x syntax: `var items: Array[TreeItem] = []`
- Return types: `func get_data() -> Dictionary:`

**Formatting:**
- Use tabs for indentation (Godot default)
- Max line length: ~120 characters
- Use spaces around operators: `var x := a + b`
- Align dictionary keys and array items when readable

**Example:**
```gdscript
@tool
extends Control

const ROOT := "res://addons/mp_shader_lib/shaders"

@export var textures: Array[Texture2D] = []

@onready var tree: Tree = $PanelContainer/VBoxContainer/Tree

func _ready() -> void:
    _refresh_tree()

func _refresh_tree() -> void:
    tree.clear()
    var root := tree.create_item()
    root.set_text(0, "Root")
```

### Imports & Autoloads
- Use `@onready` for node references in scene trees
- Use `preload()` for compile-time resource loading: `preload("res://path/to/scene.tscn")`
- Use `load()` for runtime loading (when needed)

### Error Handling
- Check `DirAccess.open()` for null before using
- Use `FileAccess.open()` with error checking: `var f := FileAccess.open(path, FileAccess.READ)`
- Use `await` for async operations properly
- Log errors with `push_error()` or `print()` for debugging

### Godot-Specific Patterns

**Node References:**
```gdscript
@onready var label: Label = $Panel/HBoxContainer/Label
@export var my_resource: Resource
```

**Signals:**
```gdscript
signal item_selected(item: TreeItem)
some_button.pressed.connect(_on_button_pressed)
```

**EditorPlugin:**
```gdscript
@tool
extends EditorPlugin

func _enter_tree() -> void:
    add_control_to_dock(DOCK_SLOT_RIGHT_UR, my_dock)

func _exit_tree() -> void:
    remove_control_from_docks(my_dock)
    my_dock.queue_free()
```

### Shader File Conventions

**Include Files (`.gdshaderinc`):**
- Use GLSL-style syntax
- Prefix functions with unique identifier (e.g., `gdsl_`)
- Document with `// @` comments for the parser:
  ```glsl
  // @name Feature Name
  // @description Does something useful
  // @param value Description
  ```

**Compute Shaders (`.compute.glsl`):**
- Use `#version 450`
- Follow standard GLSL compute shader patterns

### UI Construction
- Build UI in Godot's scene editor (.tscn files)
- Use `.gd` scripts for logic
- Reference nodes with `@onready` or `$NodePath` syntax

### Git & UIDs
- Godot 4 uses `.uid` files for resource tracking
- Do not commit `.godot/` folder (already in .gitignore)
- Commit plugin source files normally
