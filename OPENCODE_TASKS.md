# OpenCode Integration - Task Breakdown

**Total Tasks:** 23  
**Estimated Effort:** 4-6 hours (for experienced Lua developer)  
**Priority:** High

---

## Phase 1: Core Module & Initialization (6 tasks)

### Task 1.1: Create opencodeTerminal.lua Structure
**Assignee:** @developer  
**Effort:** 30 minutes  
**Depends On:** None  
**Acceptance Criteria:**
- [ ] File created at `~/.config/nvim/lua/custom/plugins/opencodeTerminal.lua`
- [ ] Module structure with `local M = {}` and `return M`
- [ ] State table initialized with window, buffer, process, config fields
- [ ] Module loads without errors

**Description:**
Create the base module file with proper Lua structure, state management table, and basic skeleton for all functions. Should be runnable without functionality.

---

### Task 1.2: Implement Configuration System
**Assignee:** @developer  
**Effort:** 20 minutes  
**Depends On:** Task 1.1  
**Acceptance Criteria:**
- [ ] Default config table has 8+ options
- [ ] User config via `vim.g.opencode_float_config` works
- [ ] Config is properly merged with defaults
- [ ] All config values used correctly

**Description:**
Setup configuration loading from `vim.g.opencode_float_config` and merge with defaults. Should allow users to customize window appearance and behavior.

---

### Task 1.3: Implement Notification Functions
**Assignee:** @developer  
**Effort:** 15 minutes  
**Depends On:** Task 1.1  
**Acceptance Criteria:**
- [ ] `show_error()` displays error notifications
- [ ] `show_info()` displays info notifications
- [ ] Messages are clear and helpful
- [ ] Uses `vim.notify()` correctly

**Description:**
Create helper functions for user notifications. These will be used throughout the module for error messages and status updates.

---

### Task 1.4: Implement Window Dimension Calculator
**Assignee:** @developer  
**Effort:** 15 minutes  
**Depends On:** Task 1.1  
**Acceptance Criteria:**
- [ ] `calculate_dimensions()` returns width, height, col, row
- [ ] Uses config percentages correctly
- [ ] Properly centers the window
- [ ] Handles edge cases (very small screens)

**Description:**
Create the dimension calculation function that determines floating window size and position based on config and screen size.

---

### Task 1.5: Implement Window Validation Functions
**Assignee:** @developer  
**Effort:** 20 minutes  
**Depends On:** Task 1.1  
**Acceptance Criteria:**
- [ ] `validate_window()` checks window validity
- [ ] `validate_buffer()` checks buffer validity
- [ ] Both update state.valid fields
- [ ] Handles invalid IDs correctly

**Description:**
Create validation functions that check if windows/buffers are still valid using Neovim API.

---

### Task 1.6: Setup Keymap & User Command
**Assignee:** @developer  
**Effort:** 15 minutes  
**Depends On:** Task 1.1  
**Acceptance Criteria:**
- [ ] `<leader>to` keymap set to `M.toggle()`
- [ ] `:OpencodeTerminal` user command created
- [ ] Works in both normal and terminal modes
- [ ] Descriptions are clear

**Description:**
Add keymap setup and user command creation at module initialization time.

---

## Phase 2: Window Management (5 tasks)

### Task 2.1: Implement Window Creation
**Assignee:** @developer  
**Effort:** 30 minutes  
**Depends On:** Task 1.4, Task 1.5  
**Acceptance Criteria:**
- [ ] Creates buffer if needed
- [ ] Creates window with proper config
- [ ] Sets Esc keymap to hide window
- [ ] Window centered on screen
- [ ] Title shown if configured

**Description:**
Implement `create_floating_window()` function that creates the actual floating window using `nvim_open_win()` and configures it properly.

---

### Task 2.2: Implement Window Show Function
**Assignee:** @developer  
**Effort:** 15 minutes  
**Depends On:** Task 2.1  
**Acceptance Criteria:**
- [ ] `show_floating_window()` reuses existing window
- [ ] Shows window from hidden state
- [ ] Uses `nvim_win_is_valid()` to check
- [ ] Updates state correctly

**Description:**
Create function to show a previously hidden floating window.

---

### Task 2.3: Implement Window Hide Function
**Assignee:** @developer  
**Effort:** 15 minutes  
**Depends On:** Task 2.1  
**Acceptance Criteria:**
- [ ] `hide_floating_window()` hides window
- [ ] Uses `nvim_win_hide()` API
- [ ] Keeps buffer alive
- [ ] Updates state correctly

**Description:**
Create function to hide the floating window while preserving the buffer.

---

### Task 2.4: Implement Force Close Function
**Assignee:** @developer  
**Effort:** 20 minutes  
**Depends On:** Task 2.1, Task 2.3  
**Acceptance Criteria:**
- [ ] `force_close_window()` closes and destroys
- [ ] Resets window and buffer IDs
- [ ] Cleans up state
- [ ] Safe to call on non-existent window

**Description:**
Create function to completely close and cleanup the floating window.

---

### Task 2.5: Implement Toggle Function (Main Entrypoint)
**Assignee:** @developer  
**Effort:** 20 minutes  
**Depends On:** Task 2.1, Task 2.2, Task 2.3  
**Acceptance Criteria:**
- [ ] `M.toggle()` opens window if hidden
- [ ] `M.toggle()` hides window if open
- [ ] Handles edge cases (invalid state)
- [ ] Calls process start when opening
- [ ] Shows user feedback messages

**Description:**
Implement the main public `toggle()` function that is the core entrypoint for the module.

---

## Phase 3: Process Management (6 tasks)

### Task 3.1: Implement OpenCode Detection
**Assignee:** @developer  
**Effort:** 15 minutes  
**Depends On:** Task 1.1  
**Acceptance Criteria:**
- [ ] `is_opencode_installed()` checks `which opencode`
- [ ] Returns true/false correctly
- [ ] Handles missing OpenCode gracefully
- [ ] Works across systems (Linux, macOS, Windows)

**Description:**
Create function to detect if OpenCode CLI is installed and available in PATH.

---

### Task 3.2: Implement Process Start Function
**Assignee:** @developer  
**Effort:** 40 minutes  
**Depends On:** Task 3.1, Task 2.1  
**Acceptance Criteria:**
- [ ] `start_opencode_process()` calls `vim.fn.jobstart()`
- [ ] Checks if OpenCode installed first
- [ ] Handles job_id <= 0 errors
- [ ] Sets up job callbacks
- [ ] Enters insert mode
- [ ] Returns success/failure
- [ ] Handles already-running process

**Description:**
Implement the core process startup function using `jobstart()` with proper error handling.

---

### Task 3.3: Implement Job Callbacks
**Assignee:** @developer  
**Effort:** 30 minutes  
**Depends On:** Task 3.2, Task 1.3  
**Acceptance Criteria:**
- [ ] `on_stdout` handler implemented (can be no-op)
- [ ] `on_stderr` handler implemented
- [ ] `on_exit` handler sets running=false
- [ ] Exit handler shows error if code!=0
- [ ] Exit handler closes window if configured

**Description:**
Implement job lifecycle callbacks for stdout, stderr, and exit events.

---

### Task 3.4: Implement Process Stop Function
**Assignee:** @developer  
**Effort:** 20 minutes  
**Depends On:** Task 3.2  
**Acceptance Criteria:**
- [ ] `stop_opencode_process()` gracefully stops job
- [ ] Uses `vim.fn.jobstop()` if available
- [ ] Handles non-running process
- [ ] Updates state.process.running

**Description:**
Create function to stop the OpenCode process gracefully.

---

### Task 3.5: Implement Restart Function
**Assignee:** @developer  
**Effort:** 20 minutes  
**Depends On:** Task 3.2, Task 3.4  
**Acceptance Criteria:**
- [ ] `M.restart()` stops and starts process
- [ ] Window stays open during restart
- [ ] Shows info message
- [ ] Handles errors

**Description:**
Implement public `restart()` function to restart the OpenCode process while keeping window open.

---

### Task 3.6: Implement Status Functions
**Assignee:** @developer  
**Effort:** 20 minutes  
**Depends On:** Task 3.2, Task 3.4  
**Acceptance Criteria:**
- [ ] `M.is_running()` returns boolean
- [ ] `M.get_status()` returns detailed info
- [ ] Status includes window, buffer, process status
- [ ] Info is accurate and useful

**Description:**
Implement status query functions for debugging and monitoring.

---

## Phase 4: Error Handling & Edge Cases (3 tasks)

### Task 4.1: Handle Missing OpenCode Error
**Assignee:** @developer  
**Effort:** 15 minutes  
**Depends On:** Task 3.1, Task 1.3  
**Acceptance Criteria:**
- [ ] Error shown if OpenCode not found
- [ ] Window doesn't open
- [ ] User gets actionable message
- [ ] Neovim continues working

**Description:**
Ensure graceful handling when OpenCode is not installed.

---

### Task 4.2: Handle Process Exit Errors
**Assignee:** @developer  
**Effort:** 20 minutes  
**Depends On:** Task 3.3, Task 1.3  
**Acceptance Criteria:**
- [ ] Error shown if process exits unexpectedly
- [ ] Exit code displayed
- [ ] Window can be manually closed
- [ ] Neovim continues working

**Description:**
Handle and display errors when OpenCode process exits.

---

### Task 4.3: Handle Window Creation Errors
**Assignee:** @developer  
**Effort:** 15 minutes  
**Depends On:** Task 2.1, Task 1.3  
**Acceptance Criteria:**
- [ ] Catches nvim_open_win() failures
- [ ] Shows helpful error message
- [ ] Provides fallback if possible
- [ ] Neovim continues working

**Description:**
Handle rare cases where window creation fails.

---

## Phase 5: Testing & Validation (3 tasks)

### Task 5.1: Unit Testing (Manual)
**Assignee:** @tester  
**Effort:** 1.5 hours  
**Depends On:** Task 2.5, Task 3.2, Task 4.1  
**Acceptance Criteria:**
- [ ] Test 1: Window opens on `<leader>to`
- [ ] Test 2: Window hides on second `<leader>to`
- [ ] Test 3: OpenCode process running in window
- [ ] Test 4: Process continues when hidden
- [ ] Test 5: Process stops on Neovim exit
- [ ] Test 6: Error shown if OpenCode missing
- [ ] Test 7: `:OpencodeTerminal` command works
- [ ] Test 8: `<Esc>` hides window (not exits OpenCode)
- [ ] All tests passing

**Description:**
Run manual tests against acceptance criteria 1-14 in the plan.

---

### Task 5.2: Integration Testing (Manual)
**Assignee:** @tester  
**Effort:** 1 hour  
**Depends On:** Task 2.5, Task 3.2  
**Acceptance Criteria:**
- [ ] Test 9: `<leader>tt` and `<leader>to` work together
- [ ] Test 10: Closing one doesn't affect other
- [ ] Test 11: Can toggle between them
- [ ] Test 12: No buffer conflicts
- [ ] Test 13: No window conflicts
- [ ] All integration tests passing

**Description:**
Test interaction with existing shell terminal.

---

### Task 5.3: Edge Case Testing (Manual)
**Assignee:** @tester  
**Effort:** 1 hour  
**Depends On:** All previous tasks  
**Acceptance Criteria:**
- [ ] Test 14: Rapid toggle (10 times) works
- [ ] Test 15: Resize terminal window works
- [ ] Test 16: OpenCode exit handled gracefully
- [ ] Test 17: Configuration override works
- [ ] Test 18: All 18 acceptance criteria pass
- [ ] All edge case tests passing

**Description:**
Test edge cases and unusual scenarios.

---

## Phase 6: Documentation & Polish (2 tasks)

### Task 6.1: Code Documentation
**Assignee:** @developer  
**Effort:** 30 minutes  
**Depends On:** All implementation tasks  
**Acceptance Criteria:**
- [ ] All functions documented with comments
- [ ] State variables documented
- [ ] Complex logic explained
- [ ] Configuration options documented
- [ ] Code is self-explanatory

**Description:**
Add comprehensive comments and documentation to the code.

---

### Task 6.2: Create Usage Documentation
**Assignee:** @documentation-writer  
**Effort:** 30 minutes  
**Depends On:** Task 5.3  
**Acceptance Criteria:**
- [ ] Basic usage documented
- [ ] Keymap documented
- [ ] Configuration options documented
- [ ] Troubleshooting section included
- [ ] Examples provided
- [ ] Integration with floaTerminal.lua explained

**Description:**
Create user-facing documentation for OpenCode terminal integration.

---

## Summary

| Phase | Tasks | Effort | Status |
|-------|-------|--------|--------|
| 1: Core | 6 | 2 hrs | Not Started |
| 2: Windows | 5 | 1.5 hrs | Not Started |
| 3: Process | 6 | 2.5 hrs | Not Started |
| 4: Errors | 3 | 0.5 hrs | Not Started |
| 5: Testing | 3 | 3.5 hrs | Not Started |
| 6: Docs | 2 | 1 hr | Not Started |
| **TOTAL** | **23** | **11 hrs** | Not Started |

---

## Task Dependencies Graph

```
1.1 (Module Structure)
├── 1.2 (Config)
├── 1.3 (Notifications)
├── 1.4 (Dimensions)
├── 1.5 (Validation)
├── 1.6 (Keymaps)
└── 3.1 (OpenCode Detection)
    └── 3.2 (Process Start)
        ├── 3.3 (Job Callbacks)
        ├── 3.4 (Process Stop)
        ├── 3.5 (Restart)
        └── 3.6 (Status)
            
2.1 (Window Creation)
├── 2.2 (Show Window)
├── 2.3 (Hide Window)
├── 2.4 (Force Close)
└── 2.5 (Toggle) [Depends on 2.1, 2.2, 2.3, 3.2]

4.1 (Missing OpenCode) [Depends on 3.1]
4.2 (Process Exit) [Depends on 3.3]
4.3 (Window Errors) [Depends on 2.1]

5.1 (Unit Tests) [Depends on 2.5, 3.2, 4.x]
5.2 (Integration Tests) [Depends on 5.1]
5.3 (Edge Cases) [Depends on 5.2]

6.1 (Code Docs) [Depends on all implementation]
6.2 (User Docs) [Depends on 5.3, 6.1]
```

---

## Recommended Assignment

- **@developer**: Tasks 1.1-3.6, 4.1-4.3, 6.1 (Core implementation - 11 tasks)
- **@tester**: Tasks 5.1-5.3 (Validation - 3 tasks)
- **@documentation-writer**: Task 6.2 (User documentation - 1 task)

---

## Success Criteria

✅ All 23 tasks completed  
✅ All 18 acceptance criteria from main plan passing  
✅ Code review approved  
✅ Documentation complete  
✅ Ready for user deployment  

