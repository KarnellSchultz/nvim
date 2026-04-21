# OpenCode Floating Terminal Integration Plan

**Document Version:** 1.0  
**Date:** March 23, 2026  
**Status:** Ready for Implementation  
**Priority:** High

---

## Executive Summary

This document outlines the technical specification for integrating OpenCode into the existing Neovim floating terminal system. The integration will create a dedicated OpenCode floating terminal that maintains session persistence, operates independently from the shell terminal, and provides seamless user experience through the `<leader>to` keymap.

**Key Objectives:**
- Persistent OpenCode sessions that resume from previous state
- Separate, non-conflicting window management from shell terminal
- Clean integration with existing Lazy.nvim plugin architecture
- Robust error handling for missing OpenCode installations
- Clear visual/functional distinction from shell terminal

---

## Part 1: Architecture & Design

### 1.1 System Architecture Overview

```
Neovim Config Structure
├── lua/custom/plugins/
│   ├── floaTerminal.lua          [EXISTING] Shell terminal
│   ├── opencodeTerminal.lua      [NEW] OpenCode terminal
│   ├── keymaps.lua               [EXISTING] Keybindings
│   └── init.lua                  [EXISTING] Plugin loader
└── ~/.opencode/                  [EXTERNAL] OpenCode state dir
```

### 1.2 Design Decisions

#### Decision: Separate Implementation vs. Shared Code
**Choice:** Separate dedicated `opencodeTerminal.lua` module

**Rationale:**
- OpenCode and shell terminals have fundamentally different lifecycle management
- OpenCode requires persistent process management (not just terminal buffer)
- Visual styling needs can differ (borders, colors)
- Prevents coupling and reduces bug surface area
- Easier to maintain and test independently
- Users might want different keymaps/behaviors for each

**Shared Elements:**
- Both use `nvim_open_win()` for floating window creation
- Both maintain persistent state between toggles
- Both use Neovim's terminal mode

#### Decision: Session Persistence Strategy
**Choice:** Maintain OpenCode process in background using `jobstart()`

**Rationale:**
- OpenCode CLI supports background sessions inherently
- Neovim's `jobstart()` provides robust async job management
- Process survives terminal window hide/show cycles
- Allows clean resume without recreating state
- Better than relying on terminal buffer history alone

#### Decision: State Management
**Choice:** Local Lua module state with vim.fn storage for durability

**Rationale:**
- Maintains window/buffer references during session
- vim.fn globals survive Neovim restarts
- Separated from terminal buffer lifecycle
- Allows validation and recovery mechanisms

### 1.3 Integration Model

**Lazy.nvim Integration:**
```lua
-- Will be configured in lazy.nvim plugin spec (not a separate file)
-- OpenCode CLI is external dependency, not a Nvim plugin
-- Configuration happens in opencodeTerminal.lua
```

---

## Part 2: Technical Specifications

### 2.1 OpenCode Terminal Module Structure

**File:** `~/.config/nvim/lua/custom/plugins/opencodeTerminal.lua`

**Module Exports:**
```lua
{
  toggle = function(),          -- Toggle OpenCode terminal visibility
  close = function(),           -- Force close OpenCode session
  restart = function(),         -- Restart OpenCode process
  is_running = function(),      -- Check if OpenCode is active
  get_status = function(),      -- Get detailed status info
}
```

**Internal State:**
```lua
local state = {
  window = {
    id = -1,                    -- vim.api window ID
    valid = false,              -- Validity check
  },
  buffer = {
    id = -1,                    -- vim.api buffer ID
    valid = false,              -- Validity check
    buftype = 'terminal',       -- Neovim terminal type
  },
  process = {
    job_id = -1,                -- Neovim jobstart() ID
    running = false,            -- Process status
    pid = nil,                  -- System process ID (if available)
  },
  config = {
    width_percent = 0.8,        -- Percentage of screen width
    height_percent = 0.8,       -- Percentage of screen height
    border_style = 'rounded',   -- Window border style
    title = 'OpenCode',         -- Window title
  },
}
```

### 2.2 Window Management Strategy

#### Window Creation Flow
```
check_existing_window()
  ├─ Window valid? YES → show_window() → START_PROCESS
  │
  └─ Window invalid? → create_new_window()
      ├─ Create buffer
      ├─ Calculate dimensions
      ├─ Create floating window
      ├─ Configure window options
      └─ START_PROCESS
```

#### Process Lifecycle
```
START_PROCESS:
  ├─ Check: Is OpenCode installed?
  │   └─ NO → show_error("OpenCode not found")
  │
  ├─ YES → jobstart('opencode')
  │   ├─ Attach job callbacks (on_stdout, on_stderr, on_exit)
  │   └─ Enter insert mode
  │
HIDE_WINDOW:
  ├─ Hide window (nvim_win_hide)
  ├─ Keep buffer alive
  ├─ Keep process running in background
  └─ Allow resume on next toggle
```

### 2.3 Buffer Persistence Strategy

**Key Principle:** Buffers are lightweight; keep them alive between toggles

```lua
-- On first launch
buf = nvim_create_buf(false, true)  -- unlisted, scratch buffer

-- On toggle (window hidden)
nvim_win_hide(state.window.id)      -- Hide but preserve buffer

-- On toggle (window hidden, showing)
if buf_valid(state.buffer.id) then
  nvim_open_win(state.buffer.id, ...) -- Reuse existing buffer
else
  create_new_buffer()
end

-- Cleanup only on explicit close or Neovim exit
-- NOT on window hide
```

### 2.4 Error Handling Strategy

**Scenarios & Responses:**

| Scenario | Detection | Response | User Message |
|----------|-----------|----------|---------------|
| OpenCode not installed | `which opencode` fails | Show error, skip launch | "OpenCode CLI not found. Install it first." |
| Process exits unexpectedly | `on_exit` callback | Mark as non-running, show notice | "OpenCode process exited unexpectedly" |
| Window creation fails | `nvim_open_win()` throws | Fallback to minimal config | "Failed to create window (unusual setup)" |
| Buffer destroyed externally | `nvim_buf_is_valid()` false | Recreate buffer on toggle | (Transparent recovery) |
| Process job fails | `jobstart()` returns -1 | Show error with reason | "Failed to start OpenCode: [reason]" |
| Double toggle race condition | State inconsistency | Debounce via state checks | (No visible issue) |

### 2.5 Configuration System

**User-Customizable Options:**

```lua
local config = {
  -- Window dimensions
  width_percent = 0.8,           -- 80% of screen width
  height_percent = 0.8,          -- 80% of screen height
  
  -- Visual styling
  border_style = 'rounded',      -- 'rounded', 'solid', 'double', 'none'
  show_title = true,             -- Show window title
  
  -- Process configuration
  command = 'opencode',          -- OpenCode command (for PATH overrides)
  auto_insert_mode = true,       -- Start in insert mode
  
  -- Behavior
  close_on_exit = false,         -- Close window when process exits
  resume_session = true,         -- Resume previous session
}

-- Users can override in their init.lua:
-- vim.g.opencode_float_config = { width_percent = 0.9, ... }
```

---

## Part 3: Implementation Details

### 3.1 File: `opencodeTerminal.lua` - Complete Outline

```lua
-- opencodeTerminal.lua
-- Dedicated floating terminal for OpenCode with session persistence

local M = {}

-- ============================================================================
-- STATE MANAGEMENT
-- ============================================================================
local state = {
  window = { id = -1, valid = false },
  buffer = { id = -1, valid = false },
  process = { job_id = -1, running = false },
  initialized = false,
}

local config = {
  width_percent = 0.8,
  height_percent = 0.8,
  border_style = 'rounded',
  show_title = true,
  command = 'opencode',
  auto_insert_mode = true,
  close_on_exit = false,
  resume_session = true,
}

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================

--- Check if OpenCode is installed
local function is_opencode_installed()
  -- Implementation
end

--- Calculate window dimensions
local function calculate_dimensions()
  -- Implementation
end

--- Create floating window configuration
local function get_window_config(width, height)
  -- Implementation
end

--- Validate window state
local function validate_window()
  -- Implementation
end

--- Validate buffer state
local function validate_buffer()
  -- Implementation
end

--- Show error notification
local function show_error(msg)
  -- Implementation
end

--- Show info notification
local function show_info(msg)
  -- Implementation
end

-- ============================================================================
-- PROCESS MANAGEMENT
-- ============================================================================

--- Start OpenCode process
local function start_opencode_process()
  -- Implementation
end

--- Job callbacks (stdout, stderr, exit)
local function setup_job_callbacks(job_id)
  -- Implementation
end

--- Stop OpenCode process gracefully
local function stop_opencode_process()
  -- Implementation
end

--- Restart OpenCode process
function M.restart()
  -- Implementation
end

-- ============================================================================
-- WINDOW MANAGEMENT
-- ============================================================================

--- Create a new floating window
local function create_floating_window()
  -- Implementation
end

--- Show existing floating window
local function show_floating_window()
  -- Implementation
end

--- Hide floating window (keep buffer alive)
local function hide_floating_window()
  -- Implementation
end

--- Force close floating window and cleanup
local function force_close_window()
  -- Implementation
end

-- ============================================================================
-- PUBLIC API
-- ============================================================================

--- Toggle OpenCode floating terminal
function M.toggle()
  -- Implementation
end

--- Close OpenCode session
function M.close()
  -- Implementation
end

--- Check if OpenCode is running
function M.is_running()
  -- Implementation
end

--- Get status information
function M.get_status()
  -- Implementation
end

-- ============================================================================
-- INITIALIZATION
-- ============================================================================

--- Initialize module (setup keymaps, commands)
local function init()
  -- Setup keymaps
  vim.keymap.set({ 'n', 't' }, '<leader>to', M.toggle, { 
    desc = 'Toggle OpenCode Terminal' 
  })
  
  -- Setup user command
  vim.api.nvim_create_user_command('OpencodeTerminal', M.toggle, {})
  
  -- Load user config
  if vim.g.opencode_float_config then
    config = vim.tbl_extend('force', config, vim.g.opencode_float_config)
  end
  
  state.initialized = true
end

-- Run initialization on module load
init()

return M
```

### 3.2 Implementation Logic Details

#### A. `is_opencode_installed()`
```lua
local function is_opencode_installed()
  local result = vim.fn.system('which opencode 2>/dev/null')
  return vim.v.shell_error == 0 and result ~= ''
end
```

#### B. `calculate_dimensions()`
```lua
local function calculate_dimensions()
  local width = math.floor(vim.o.columns * config.width_percent)
  local height = math.floor(vim.o.lines * config.height_percent)
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)
  return width, height, col, row
end
```

#### C. `validate_window()` / `validate_buffer()`
```lua
local function validate_window()
  if state.window.id > 0 and vim.api.nvim_win_is_valid(state.window.id) then
    state.window.valid = true
    return true
  else
    state.window.valid = false
    state.window.id = -1
    return false
  end
end

local function validate_buffer()
  if state.buffer.id > 0 and vim.api.nvim_buf_is_valid(state.buffer.id) then
    state.buffer.valid = true
    return true
  else
    state.buffer.valid = false
    state.buffer.id = -1
    return false
  end
end
```

#### D. `create_floating_window()`
```lua
local function create_floating_window()
  -- Validate/create buffer
  if not validate_buffer() then
    state.buffer.id = vim.api.nvim_create_buf(false, true)
  end
  
  -- Calculate dimensions
  local width, height, col, row = calculate_dimensions()
  
  -- Create window config
  local win_config = {
    relative = 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    border = config.border_style,
  }
  
  if config.show_title then
    win_config.title = ' ' .. config.title .. ' '
    win_config.title_pos = 'center'
  end
  
  -- Create window
  state.window.id = vim.api.nvim_open_win(state.buffer.id, true, win_config)
  state.window.valid = true
  
  -- Configure buffer
  vim.api.nvim_buf_set_keymap(state.buffer.id, 'n', '<Esc>', 
    '<cmd>lua require("custom.plugins.opencodeTerminal").toggle()<CR>', 
    { noremap = true, silent = true }
  )
  
  return state.window.id
end
```

#### E. `start_opencode_process()`
```lua
local function start_opencode_process()
  -- Check if OpenCode is installed
  if not is_opencode_installed() then
    show_error('OpenCode CLI not found. Please install it first.')
    return false
  end
  
  -- Check if process already running
  if state.process.running and state.process.job_id > 0 then
    return true  -- Already running
  end
  
  -- Start process
  local job_id = vim.fn.jobstart(config.command, {
    on_stdout = function(_, data)
      -- Handle output if needed
    end,
    on_stderr = function(_, data)
      -- Handle errors if needed
    end,
    on_exit = function(_, code)
      state.process.running = false
      state.process.job_id = -1
      if code ~= 0 then
        show_error('OpenCode process exited with code: ' .. code)
      end
      if config.close_on_exit then
        force_close_window()
      end
    end,
  })
  
  if job_id <= 0 then
    show_error('Failed to start OpenCode process')
    return false
  end
  
  state.process.job_id = job_id
  state.process.running = true
  
  -- Enter insert mode
  if config.auto_insert_mode then
    vim.cmd('startinsert')
  end
  
  return true
end
```

#### F. `M.toggle()`
```lua
function M.toggle()
  -- Validate existing state
  local window_valid = validate_window()
  
  if window_valid then
    -- Window exists and is visible - hide it
    vim.api.nvim_win_hide(state.window.id)
    show_info('OpenCode terminal hidden')
  else
    -- Window doesn't exist or is hidden - show it
    create_floating_window()
    start_opencode_process()
    show_info('OpenCode terminal opened')
  end
end
```

---

## Part 4: Acceptance Criteria

### 4.1 Functional Requirements (15+ Criteria)

#### Criterion 1: Basic Toggle Functionality
- **Requirement:** Pressing `<leader>to` opens OpenCode floating terminal
- **Success Metric:** Floating window appears on first toggle
- **Test:** Start Neovim, press `<leader>to`, verify terminal opens
- **Related:** Requirements 2, 3

#### Criterion 2: Hide Toggle
- **Requirement:** Pressing `<leader>to` while terminal open hides it
- **Success Metric:** Window hidden without losing buffer/process
- **Test:** Press `<leader>to` again, verify window closes and returns to editor
- **Related:** Requirements 1, 3

#### Criterion 3: Session Resume
- **Requirement:** OpenCode session continues running while window is hidden
- **Success Metric:** Hidden terminal maintains OpenCode state
- **Test:** Toggle open, type commands, toggle hidden, toggle open - state preserved
- **Related:** Requirements 1, 2, 9

#### Criterion 4: Process Persistence
- **Requirement:** OpenCode process runs in background across window toggles
- **Success Metric:** `ps aux | grep opencode` shows running process
- **Test:** Toggle window hidden, verify process still running in shell
- **Related:** Requirement 3

#### Criterion 5: Separate from Shell Terminal
- **Requirement:** `<leader>to` and `<leader>tt` manage different terminals
- **Success Metric:** Can open both simultaneously without interference
- **Test:** Open `<leader>tt`, then open `<leader>to`, verify both visible
- **Related:** Requirements 6, 10

#### Criterion 6: No Buffer Conflicts
- **Requirement:** OpenCode and shell terminals use separate buffers
- **Success Metric:** `:buffers` shows two distinct terminal buffers
- **Test:** Verify buffer IDs differ between `<leader>tt` and `<leader>to` windows
- **Related:** Requirement 5

#### Criterion 7: Window Independence
- **Requirement:** Closing one terminal doesn't affect the other
- **Success Metric:** Closing `<leader>tt` preserves `<leader>to` state
- **Test:** Open both, close one, toggle other - still works
- **Related:** Requirements 5, 6

#### Criterion 8: Escape Key Handling
- **Requirement:** Pressing `<Esc>` in OpenCode terminal hides window (not exits OpenCode)
- **Success Metric:** Terminal hides without stopping process
- **Test:** In `<leader>to` terminal, press `<Esc>`, verify window hides
- **Related:** Requirement 2

#### Criterion 9: Proper Startup
- **Requirement:** OpenCode process starts correctly with environment variables
- **Success Metric:** OpenCode initializes and shows prompt/interface
- **Test:** Open `<leader>to`, verify OpenCode UI appears
- **Related:** Requirements 3, 4

#### Criterion 10: Error Handling - Missing OpenCode
- **Requirement:** Graceful error if OpenCode not installed
- **Success Metric:** User sees error notification instead of crash
- **Test:** Run with OpenCode removed from PATH, press `<leader>to`
- **Related:** Requirement 11

#### Criterion 11: Error Recovery
- **Requirement:** Errors don't leave Neovim in broken state
- **Success Metric:** Can continue using Neovim normally after error
- **Test:** Trigger error condition, verify Neovim still responsive
- **Related:** Requirement 10

#### Criterion 12: Process Cleanup
- **Requirement:** OpenCode process terminates when Neovim closes
- **Success Metric:** No orphaned OpenCode processes after Neovim exit
- **Test:** Start `<leader>to`, quit Neovim, verify no orphaned processes
- **Related:** Requirement 4

#### Criterion 13: Terminal Insert Mode
- **Requirement:** OpenCode terminal starts in insert mode by default
- **Success Metric:** Can type immediately without pressing `i`
- **Test:** Open `<leader>to`, verify cursor is in insert mode
- **Related:** Requirement 9

#### Criterion 14: Keymap Description
- **Requirement:** `<leader>to` shows helpful description in keymap list
- **Success Metric:** `:map <leader>to` shows "Toggle OpenCode Terminal"
- **Test:** Run `:map <leader>to` command, verify description visible
- **Related:** Integration requirement

#### Criterion 15: User Command
- **Requirement:** `:OpencodeTerminal` command works as alternative to keymap
- **Success Metric:** `:OpencodeTerminal` toggles terminal
- **Test:** Run `:OpencodeTerminal` from normal mode, verify toggle works
- **Related:** Integration requirement

#### Criterion 16: State Persistence Across Session
- **Requirement:** Buffer persists across Neovim restart (optional advanced feature)
- **Success Metric:** On Neovim restart, `<leader>to` recalls previous buffer
- **Test:** Type in OpenCode, save session, restart Neovim, toggle `<leader>to`
- **Related:** Requirement 3

#### Criterion 17: Configuration Override
- **Requirement:** Users can customize window appearance via `vim.g.opencode_float_config`
- **Success Metric:** User config overrides defaults
- **Test:** Set `vim.g.opencode_float_config = { width_percent = 0.5 }`, verify width changes
- **Related:** Architecture requirement

#### Criterion 18: Border Styling
- **Requirement:** Window displays with rounded border (customizable)
- **Success Metric:** Visual border appears around floating window
- **Test:** Open `<leader>to`, verify rounded border visible
- **Related:** Requirement 17

---

### 4.2 Non-Functional Requirements

#### Performance
- Window opens within 200ms
- Toggle response time < 50ms
- No noticeable lag when typing in terminal
- Memory footprint < 10MB for terminal buffers

#### Reliability
- Process cleanup on abnormal Neovim exit
- No memory leaks across multiple toggles
- Graceful handling of unusual edge cases

#### Maintainability
- Code is well-commented
- Follows Lua conventions used in floaTerminal.lua
- Single-responsibility functions
- Clear error messages for debugging

#### Compatibility
- Works with recent Neovim versions (0.9+)
- Compatible with existing plugins
- Works across Linux, macOS, Windows

---

## Part 5: Implementation Roadmap

### Phase 1: Core Module (Foundation)
**Tasks:**
1. Create `opencodeTerminal.lua` with state management
2. Implement basic window creation/hiding
3. Add toggle function
4. Setup keymaps and user command
5. Basic error handling

**Deliverable:** `<leader>to` opens/closes window (no process yet)

### Phase 2: Process Management (Functionality)
**Tasks:**
1. Implement `start_opencode_process()`
2. Add job callbacks
3. Add process validation
4. Implement process cleanup
5. Add error messages for missing OpenCode

**Deliverable:** OpenCode actually runs in the terminal

### Phase 3: Polish & Testing (Quality)
**Tasks:**
1. Test all 18 acceptance criteria
2. Add configuration system
3. Improve error messages
4. Add status/info functions
5. Documentation and comments

**Deliverable:** Production-ready module

### Phase 4: Integration (Deployment)
**Tasks:**
1. Add to Lazy.nvim plugin spec (if desired)
2. Create usage documentation
3. Add to keymaps reference
4. Test with existing system
5. User validation

**Deliverable:** Fully integrated, tested system

---

## Part 6: Code Quality Checklist

### Pre-Implementation
- [ ] Module architecture documented
- [ ] State management strategy defined
- [ ] Error scenarios identified
- [ ] Configuration system planned

### During Implementation
- [ ] Code follows Lua style guide
- [ ] Functions are documented with comments
- [ ] Error messages are user-friendly
- [ ] State validation is comprehensive
- [ ] No global variable pollution

### Post-Implementation
- [ ] All 18 acceptance criteria tested
- [ ] Error handling verified
- [ ] Edge cases covered
- [ ] Documentation complete
- [ ] Code review pass

---

## Part 7: Testing Strategy

### Unit-Level Tests (Manual)

**Test 1: Window Creation**
```
Precondition: Neovim running, OpenCode installed
Action: Press <leader>to
Expected: Floating window appears centered
Evidence: Visual inspection
```

**Test 2: Process Start**
```
Precondition: Window open
Action: In terminal, type: ps -p $$ -o comm=
Expected: Output shows "opencode" running
Evidence: Terminal output shows opencode process
```

**Test 3: Process Persistence**
```
Precondition: Window open with OpenCode running
Action: Press <leader>to to hide
Action: Wait 5 seconds
Action: Press <leader>to to show
Expected: OpenCode still running, prompt visible
Evidence: OpenCode interface unchanged
```

### Integration Tests (Manual)

**Test 4: Dual Terminal**
```
Precondition: Both terminals closed
Action: Press <leader>tt (shell)
Action: Press <leader>to (opencode)
Expected: Both visible simultaneously
Evidence: Two separate floating windows
```

**Test 5: Error Handling**
```
Precondition: OpenCode removed from PATH
Action: Press <leader>to
Expected: Friendly error message, no crash
Evidence: User notification shown, Neovim responsive
```

### Edge Cases

**Test 6: Rapid Toggle**
```
Action: Rapidly press <leader>to (10 times)
Expected: No crashes, consistent behavior
Evidence: No errors, final state correct
```

**Test 7: Neovim Resize**
```
Precondition: OpenCode window open
Action: Resize terminal window (drag)
Action: Resize by changing columns/lines
Expected: Floating window responds appropriately
Evidence: Window re-centers or adjusts
```

**Test 8: Process Exit**
```
Precondition: OpenCode running
Action: In OpenCode: exit or quit command
Expected: Process exits gracefully, window closes or shows exit message
Evidence: No orphaned processes
```

---

## Part 8: Known Limitations & Future Improvements

### Current Limitations
1. **Single Instance:** Only one OpenCode window at a time (by design)
2. **No State Save:** Session doesn't survive Neovim restart (could add in future)
3. **Basic Job Management:** Relies on vim.fn.jobstart (adequate for current needs)
4. **No Async Feedback:** Job output not captured in detail (not needed for user terminal)

### Future Enhancements
1. Session state serialization/restore across restarts
2. Multiple concurrent OpenCode windows
3. Custom commands for OpenCode operations
4. Integration with Neovim's terminal mode for better UX
5. Performance profiling and optimization
6. Configuration presets (size, theme, etc.)

---

## Part 9: File Organization Summary

### Final Directory Structure
```
~/.config/nvim/
├── lua/custom/plugins/
│   ├── floaTerminal.lua           [EXISTING] Shell terminal - unchanged
│   ├── opencodeTerminal.lua       [NEW] OpenCode terminal - new implementation
│   ├── keymaps.lua                [EXISTING] Keybindings - no changes needed
│   └── init.lua                   [EXISTING] Plugin loader - no changes needed
├── OPENCODE_INTEGRATION_PLAN.md   [NEW] This plan document
└── [other existing files...]
```

### No Changes Required To
- `~/.config/nvim/lua/custom/plugins/floaTerminal.lua` (independent system)
- `~/.config/nvim/lua/custom/plugins/keymaps.lua` (keymaps set in opencodeTerminal.lua)
- `~/.config/nvim/lua/custom/plugins/init.lua` (already returns {})
- `~/.config/nvim/lua/custom/plugins/opencode.lua` (will be replaced by this approach)

---

## Part 10: Configuration Examples

### Default Configuration (In Module)
```lua
local config = {
  width_percent = 0.8,
  height_percent = 0.8,
  border_style = 'rounded',
  show_title = true,
  command = 'opencode',
  auto_insert_mode = true,
  close_on_exit = false,
  resume_session = true,
}
```

### User Customization (In user init.lua)
```lua
-- Override defaults
vim.g.opencode_float_config = {
  width_percent = 0.9,           -- Wider window
  height_percent = 0.9,          -- Taller window
  border_style = 'double',       -- Double-line border
  auto_insert_mode = false,      -- Start in normal mode
  close_on_exit = true,          -- Close when OpenCode exits
}
```

### Advanced Customization (Post-Load)
```lua
-- Access module for dynamic behavior
local opencode = require('custom.plugins.opencodeTerminal')

-- Check status
if opencode.is_running() then
  print('OpenCode is running')
end

-- Manual restart
vim.keymap.set('n', '<leader>tor', opencode.restart, 
  { desc = 'Restart OpenCode' })
```

---

## Part 11: Success Metrics

### For Implementation Completion
- ✅ All 18 acceptance criteria pass
- ✅ No compilation or runtime errors
- ✅ Handles all 8 identified error scenarios gracefully
- ✅ Code reviewed and approved

### For User Adoption
- ✅ Users report smooth `<leader>to` experience
- ✅ Session persistence works reliably
- ✅ No conflicts with existing `<leader>tt` terminal
- ✅ Clear error messages when issues occur

### For Code Quality
- ✅ <5 comments per function (self-documenting code)
- ✅ <50 lines per function
- ✅ Cyclomatic complexity < 5
- ✅ No global state pollution

---

## Appendix A: Related Files Reference

### floaTerminal.lua (Existing - For Reference)
- Uses `nvim_create_buf()` for buffer creation
- Uses `nvim_open_win()` for floating window
- Manages state in local `state` table
- Toggles window hide/show
- Uses Neovim's built-in terminal mode

### Key Differences in opencodeTerminal.lua
1. Uses `jobstart()` instead of `:terminal` command
2. Manages an external process, not Neovim terminal
3. Separate window/buffer management
4. Different error scenarios (process exits, OpenCode not found)
5. Configuration system for customization

---

## Appendix B: Common Questions

**Q: Why separate from floaTerminal.lua?**
A: Different lifecycle, different process management, easier to maintain independently.

**Q: What if OpenCode isn't installed?**
A: Graceful error message, Neovim continues working normally.

**Q: Does this replace the opencode.nvim plugin?**
A: This is an alternative approach - a floating terminal for the OpenCode CLI, not the plugin-based integration.

**Q: Can I have multiple OpenCode windows?**
A: Current design supports one. Future enhancement could support multiple.

**Q: How does session persistence work?**
A: The OpenCode process runs continuously in the background. Hiding the window doesn't stop the process.

**Q: What terminal does OpenCode run in?**
A: In a Neovim terminal buffer managed by `jobstart()`, displayed in a floating window.

---

## Sign-Off

**Document Status:** ✅ Ready for Implementation  
**Date:** March 23, 2026  
**Reviewed By:** Product Owner  
**Next Step:** Invoke @developer for implementation using Phase 1-4 roadmap

