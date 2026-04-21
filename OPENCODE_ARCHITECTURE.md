# OpenCode Terminal - Architecture & Design Document

---

## System Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                     Neovim Instance                          │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────────────────────────────────────────────┐  │
│  │        Shell Terminal (floaTerminal.lua)             │  │
│  │  <leader>tt - Floating shell terminal               │  │
│  │  ┌────────────────────────────────────────────────┐  │  │
│  │  │ $ ls -la                                       │  │  │
│  │  │ total 24                                       │  │  │
│  │  │ drwx... . .. init.lua                          │  │  │
│  │  └────────────────────────────────────────────────┘  │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                               │
│  ┌──────────────────────────────────────────────────────┐  │
│  │     OpenCode Terminal (opencodeTerminal.lua)         │  │
│  │  <leader>to - OpenCode floating terminal            │  │
│  │  ┌────────────────────────────────────────────────┐  │  │
│  │  │ OpenCode CLI                                   │  │  │
│  │  │ > User input goes here                         │  │  │
│  │  │ Result: [relevant output]                      │  │  │
│  │  └────────────────────────────────────────────────┘  │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

---

## Module Architecture

### opencodeTerminal.lua Structure

```
opencodeTerminal.lua
├── STATE MANAGEMENT
│   ├── state.window
│   │   ├── id: window handle
│   │   └── valid: boolean
│   ├── state.buffer
│   │   ├── id: buffer handle
│   │   └── valid: boolean
│   ├── state.process
│   │   ├── job_id: Neovim job ID
│   │   └── running: boolean
│   └── state.config
│       ├── width_percent
│       ├── height_percent
│       ├── border_style
│       └── ...
│
├── HELPER FUNCTIONS
│   ├── is_opencode_installed()
│   ├── calculate_dimensions()
│   ├── get_window_config()
│   ├── validate_window()
│   ├── validate_buffer()
│   ├── show_error()
│   └── show_info()
│
├── WINDOW MANAGEMENT
│   ├── create_floating_window()
│   ├── show_floating_window()
│   ├── hide_floating_window()
│   └── force_close_window()
│
├── PROCESS MANAGEMENT
│   ├── start_opencode_process()
│   ├── setup_job_callbacks()
│   ├── stop_opencode_process()
│   └── restart()
│
├── PUBLIC API
│   ├── toggle()
│   ├── close()
│   ├── is_running()
│   └── get_status()
│
└── INITIALIZATION
    ├── Load user config
    ├── Setup keymaps
    └── Setup commands
```

---

## Data Flow Diagrams

### User Presses `<leader>to`

```
User presses <leader>to
        ↓
    M.toggle()
        ↓
  validate_window()
        ↓
Is window valid?
  ├─ YES → hide_floating_window()
  │         ├─ nvim_win_hide()
  │         ├─ Keep buffer alive
  │         ├─ Keep process running
  │         └─ show_info("OpenCode terminal hidden")
  │
  └─ NO → create_floating_window()
           ├─ Create/validate buffer
           ├─ Calculate dimensions
           ├─ Create window with nvim_open_win()
           ├─ Start process with start_opencode_process()
           │   ├─ Check if OpenCode installed
           │   ├─ vim.fn.jobstart("opencode")
           │   ├─ Setup job callbacks
           │   └─ Enter insert mode
           └─ show_info("OpenCode terminal opened")
```

### OpenCode Process Lifecycle

```
START_PROCESS
     ↓
is_opencode_installed()?
  ├─ NO → show_error() → return false
  │
  └─ YES → vim.fn.jobstart()
           ↓
       Already running?
       ├─ YES → return true (don't restart)
       │
       └─ NO → jobstart("opencode")
               ├─ Return job_id
               │
               ├─ Setup on_stdout callback
               ├─ Setup on_stderr callback
               ├─ Setup on_exit callback
               │   ├─ Set running = false
               │   ├─ Show error if code != 0
               │   └─ Close window if configured
               │
               ├─ Enter insert mode
               └─ Show info("OpenCode started")
```

### Window Toggle Sequence

```
HIDDEN STATE               VISIBLE STATE
     │                           │
     ├─────── <leader>to ────────┤
     │                           │
     │         Process still     │
     │         running in bg     │
     │                           │
     │                           ├─ Window visible
     │                           ├─ User typing
     │                           ├─ Process running
     │                           └─ Buffer active
     │                           │
     │◄────── <leader>to ────────┤
     │                           │
     ├─ Window hidden            │
     ├─ Process still running    │
     ├─ Buffer preserved         │
     └─ Ready to resume          │
```

---

## State Machine

### Window States

```
            ┌─────────────────────────────┐
            │    WINDOW_NOT_EXISTS        │
            │  (window.id = -1)           │
            │  (buffer.id = -1)           │
            └────────────┬────────────────┘
                         │
                    toggle() called
                    is_opencode_installed() = YES
                         │
                         ▼
            ┌─────────────────────────────┐
            │   WINDOW_CREATED_VISIBLE    │
            │   (window.id > 0)           │
            │   (buffer.id > 0)           │
            │   (valid = true)            │
            │   (process.running = true)  │
            └────────────┬────────────────┘
                         │
                    toggle() called
                         │
                         ▼
            ┌─────────────────────────────┐
            │   WINDOW_HIDDEN             │
            │   (window.id = -1)          │
            │   (buffer.id > 0)           │
            │   (valid = false)           │
            │   (process.running = true)  │
            └────────────┬────────────────┘
                         │
                    toggle() called
                         │
                         ▼
            ┌─────────────────────────────┐
            │   WINDOW_CREATED_VISIBLE    │
            │   (reuse buffer & process)  │
            └─────────────────────────────┘
```

### Process States

```
            ┌─────────────────────────────┐
            │   PROCESS_NOT_RUNNING       │
            │   (job_id = -1)             │
            │   (running = false)         │
            └────────────┬────────────────┘
                         │
              jobstart("opencode") called
                         │
                         ▼
            ┌─────────────────────────────┐
            │   PROCESS_RUNNING           │
            │   (job_id > 0)              │
            │   (running = true)          │
            │   Window may be hidden      │
            └────────────┬────────────────┘
                         │
              (process exits OR jobstop() called)
                         │
                         ▼
            ┌─────────────────────────────┐
            │   PROCESS_EXITED            │
            │   (job_id = -1)             │
            │   (running = false)         │
            │   Exit code stored          │
            └─────────────────────────────┘
```

---

## Integration Points

### With floaTerminal.lua (Shell Terminal)

**Similarities:**
- Both create floating windows with nvim_open_win()
- Both maintain persistent buffers
- Both toggle visibility with keymaps
- Both use similar dimension calculation

**Differences:**
- opencodeTerminal uses jobstart() for process
- floaTerminal uses built-in :terminal command
- Different keymaps (`<leader>to` vs `<leader>tt`)
- Different buffer types and management

**Conflict Prevention:**
```
floaTerminal State          opencodeTerminal State
├── state.floating.win      ├── state.window.id
├── state.floating.buf      ├── state.buffer.id
└── Terminal buffer ID=1    └── Terminal buffer ID=2
                            └── Job ID=X (independent)
```

Both use local state tables → No conflicts ✓

---

## Process Lifecycle Management

### Normal Lifecycle

```
1. USER STARTS NEOVIM
   ├─ opencodeTerminal.lua loaded
   ├─ state = { window = {-1}, buffer = {-1}, process = {-1}, ... }
   └─ Keymaps registered

2. USER PRESSES <leader>to
   ├─ create_floating_window()
   ├─ start_opencode_process()
   ├─ window visible, process running
   └─ User can interact with OpenCode

3. USER PRESSES <leader>to AGAIN
   ├─ hide_floating_window()
   ├─ Process continues in background
   └─ Window hidden, buffer preserved

4. USER PRESSES <leader>to AGAIN
   ├─ show_floating_window() (reuse buffer)
   ├─ Process still running (no restart)
   └─ Resume where left off

5. USER PRESSES <Esc>
   ├─ Mapped to toggle() in normal mode
   ├─ hide_floating_window()
   └─ Same as step 3

6. USER QUITS NEOVIM
   ├─ Process ends (Neovim cleanup)
   ├─ Windows/buffers cleaned up
   └─ Session ends
```

### Error Lifecycle

```
1. USER PRESSES <leader>to
   ├─ is_opencode_installed() checks
   └─ Result: NOT FOUND

2. SHOW ERROR MESSAGE
   ├─ show_error("OpenCode CLI not found...")
   ├─ No window created
   ├─ No process started
   └─ Neovim continues normally

3. USER CAN:
   ├─ Install OpenCode
   ├─ Try again (will work next time)
   └─ Continue using Neovim normally
```

---

## Window Dimensions Logic

```
Terminal Width = 200 columns
Terminal Height = 50 lines

Config:
  width_percent = 0.8
  height_percent = 0.8

Calculation:
  window_width = floor(200 * 0.8) = 160 columns
  window_height = floor(50 * 0.8) = 40 lines
  
  offset_col = floor((200 - 160) / 2) = 20
  offset_row = floor((50 - 40) / 2) = 5

Result:
  Window starts at (col=20, row=5)
  Extends 160 columns wide, 40 lines tall
  Centered on screen
```

---

## Configuration System

### Load Priority

```
1. DEFAULTS (hardcoded in module)
   width_percent = 0.8
   height_percent = 0.8
   border_style = 'rounded'
   etc.

2. USER OVERRIDES (vim.g.opencode_float_config)
   vim.g.opencode_float_config = {
     width_percent = 0.9,  -- Override this
     -- others use defaults
   }

3. FINAL CONFIG
   Result: Merged with user values taking precedence
```

### Config Resolution Example

```
defaults = {
  width_percent = 0.8,
  height_percent = 0.8,
  border_style = 'rounded',
  command = 'opencode'
}

user_config = {
  width_percent = 0.9,
  border_style = 'double'
}

merged = {
  width_percent = 0.9,         -- from user_config
  height_percent = 0.8,        -- from defaults
  border_style = 'double',     -- from user_config
  command = 'opencode'         -- from defaults
}
```

---

## Error Handling Strategy

### Error Scenarios & Recovery

```
SCENARIO 1: OpenCode Not Installed
├─ Detection: which opencode fails
├─ Response: show_error() + return false
├─ Recovery: No window created, user installs OpenCode
└─ State: Unchanged, ready to retry

SCENARIO 2: jobstart() Fails
├─ Detection: job_id <= 0
├─ Response: show_error() + close window
├─ Recovery: Manual restart possible
└─ State: Reset, can retry

SCENARIO 3: Process Exits Unexpectedly
├─ Detection: on_exit callback
├─ Response: show_error() + set running=false
├─ Recovery: User can restart via <leader>to
└─ State: Can reopen and restart

SCENARIO 4: Window Creation Fails
├─ Detection: nvim_open_win() throws
├─ Response: try-catch + show_error()
├─ Recovery: Unlikely, might indicate config issue
└─ State: Reset to initial state

SCENARIO 5: Buffer Destroyed Externally
├─ Detection: validate_buffer() returns false
├─ Response: Create new buffer on next toggle
├─ Recovery: Transparent, user sees new buffer
└─ State: Automatically recovered
```

---

## Performance Considerations

### Memory Usage
```
Buffer (empty):              ~1-2 KB
Terminal buffer (with text): 10-50 KB (depends on history)
Window state:                ~1 KB
Process state:               ~5 KB
Total per session:           ~50 KB average
```

### Latency Goals
```
Action                      Target      Implementation
─────────────────────────────────────────────────────
Toggle window show/hide     < 50ms      nvim_win_hide() is fast
Create new window           < 100ms     nvim_open_win() + buffer creation
Start process               < 200ms     jobstart() execution
Process output display      < 50ms      Terminal buffer updates
```

### Optimization Notes
```
✓ Use local state (fast access)
✓ Avoid unnecessary API calls
✓ Cache window/buffer IDs
✓ Validate state before operations
✓ Use jobstart() for async execution
✗ Don't poll process status
✗ Don't re-create buffers unnecessarily
✗ Don't block on process operations
```

---

## Security Considerations

### Process Security
```
✓ OpenCode runs with user permissions (normal)
✓ Command is hardcoded: vim.fn.jobstart('opencode')
✓ No user input injected into command
✗ Could be enhanced: Allow custom command in config
```

### Buffer Security
```
✓ Buffers are unlisted (not in :buffers by default)
✓ Terminal mode is secure (Neovim's responsibility)
✓ No sensitive data hardcoded
```

### State Security
```
✓ State is local to module (not global)
✓ No vim.fn globals for state
✓ Window IDs are transient (lost on Neovim exit)
```

---

## Testing Strategy

### Unit Tests (Module Functions)
```
├── Window Management
│   ├─ create_floating_window() creates valid window
│   ├─ show_floating_window() shows hidden window
│   ├─ hide_floating_window() hides window without errors
│   └─ force_close_window() properly cleans up
│
├── Process Management
│   ├─ is_opencode_installed() detects installation
│   ├─ start_opencode_process() starts process
│   ├─ stop_opencode_process() stops process
│   └─ restart() stops and starts process
│
└── State Management
    ├─ validate_window() checks validity correctly
    ├─ validate_buffer() checks validity correctly
    └─ State updates are accurate
```

### Integration Tests (With Neovim)
```
├─ Press <leader>to opens OpenCode
├─ Press <leader>to again hides OpenCode
├─ OpenCode process runs in background
├─ Window toggling doesn't affect shell terminal
├─ Process exits are handled gracefully
├─ Configuration overrides work
└─ `:OpencodeTerminal` command works
```

### Edge Case Tests
```
├─ Rapid toggling (10+ times)
├─ Resize terminal while window open
├─ OpenCode exits while window open
├─ Neovim forced quit with OpenCode running
├─ Configuration with invalid values
└─ OpenCode reinstalled during session
```

---

## Comparison: floaTerminal vs opencodeTerminal

| Aspect | floaTerminal | opencodeTerminal |
|--------|-------------|-----------------|
| **Purpose** | Shell terminal | OpenCode CLI |
| **Keymap** | `<leader>tt` | `<leader>to` |
| **Process** | Neovim terminal | External job |
| **Startup** | `:terminal` command | `jobstart()` |
| **Buffer Type** | `terminal` | `terminal` |
| **Persistence** | Buffer saved | Buffer + process |
| **Kill Command** | Neovim `:quit` | `on_exit` callback |
| **Conflicts** | None (separate) | None (separate) |
| **State** | Local `state.floating` | Local `state` |
| **Size** | ~60 lines code | ~150 lines code |

---

## Dependencies & Requirements

### Hard Requirements
```
✓ Neovim 0.9+
✓ OpenCode CLI installed
✓ Lua 5.1+ (bundled with Neovim)
```

### Soft Requirements
```
○ vim.notify() (Neovim feature)
○ vim.fn.jobstart() (Neovim feature)
○ Floating window support (all recent Neovim)
```

### No External Plugin Dependencies
```
✓ No opencode.nvim plugin needed
✓ No plugin manager required (standalone Lua module)
✓ Works with Lazy.nvim or packer.nvim or vim-plug
```

---

## File Organization

```
~/.config/nvim/
├── lua/
│   └── custom/
│       └── plugins/
│           ├── floaTerminal.lua         [EXISTING]
│           ├── opencodeTerminal.lua     [NEW]
│           ├── keymaps.lua              [EXISTING]
│           ├── init.lua                 [EXISTING]
│           └── ... (other plugins)
├── OPENCODE_INTEGRATION_PLAN.md        [NEW]
├── OPENCODE_TASKS.md                   [NEW]
├── OPENCODE_ARCHITECTURE.md            [THIS FILE]
└── init.lua                            [EXISTING]
```

---

## Future Enhancements

### Version 2.0 Ideas
```
1. Session Serialization
   ├─ Save buffer contents to ~/.opencode/
   ├─ Restore on next Neovim session
   └─ Persistent history

2. Multiple OpenCode Windows
   ├─ Allow opening multiple sessions
   ├─ Switch between them with keymaps
   └─ Unique naming/identification

3. Custom Commands
   ├─ Send commands to OpenCode from Lua
   ├─ Capture output programmatically
   └─ Integration with other plugins

4. Advanced Styling
   ├─ Highlight groups for borders
   ├─ Theme support
   └─ Custom fonts/sizing
```

---

## Conclusion

This architecture provides a clean, maintainable, and robust implementation of OpenCode integration as a dedicated floating terminal with persistent background sessions. Key strengths:

✅ **Separation of Concerns**: Distinct from shell terminal  
✅ **Process Persistence**: Background execution while window hidden  
✅ **Robust Error Handling**: Graceful degradation on errors  
✅ **Extensible Configuration**: User customization support  
✅ **Clean State Management**: Local state, no global pollution  
✅ **Production Ready**: All edge cases considered  

