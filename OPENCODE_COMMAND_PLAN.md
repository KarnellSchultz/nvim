# OpenCode Neovim Command - Technical Plan

**Date:** March 21, 2026  
**Status:** Planning  
**Objective:** Create a Neovim command to open OpenCode with the current file as context

---

## 1. User Experience & Command Design

### 1.1 Command Options

**Primary Command Name: `:OpenCode`**

- **Rationale:** Clear, explicit, descriptive name that matches the tool
- **Alternative:** Consider short alias `:OC` for power users
- **Discoverability:** Integrates with Neovim's `:help` system

### 1.2 Command Behavior

The command should:
1. **Capture the current file path** being viewed in the buffer
2. **Invoke OpenCode** with the file passed as context/argument
3. **Launch OpenCode** in a way that:
   - Opens in the system's default manner (foreground application)
   - Suspends Neovim session temporarily (allows user to return)
   - Preserves current buffer state when user returns to Neovim

### 1.3 Optional Arguments/Flags

```vim
" Basic usage - opens current file in OpenCode
:OpenCode

" With selection - send highlighted code to OpenCode
:OpenCode            " (when text is selected in visual mode)

" Potential flags (future enhancement)
:OpenCode --no-wait  " Don't wait for OpenCode to close
:OpenCode --bg       " Run OpenCode in background
```

**Recommendation:** Start with simple implementation (just current file), add visual selection support as enhancement

### 1.4 Edge Cases & Handling

| Edge Case | Current Behavior | Proposed Handling |
|-----------|------------------|-------------------|
| **Unsaved changes** | File exists but not saved | Send current buffer content to OpenCode (not disk version) |
| **New file (no path)** | `vim.fn.expand('%:p')` returns empty | Show error: "Cannot open new unsaved file in OpenCode" |
| **File not in git repo** | File path is valid | Allow opening; OpenCode handles context resolution |
| **OpenCode not installed** | External command fails silently | Show error: "OpenCode is not installed or not in $PATH" |
| **Directory instead of file** | User runs `:OpenCode` on a directory listing | Show error: "OpenCode expects a file, not a directory" |
| **Remote/SSH files** | Accessing files over SSH | Show warning: "Remote files may not be accessible to OpenCode" |

---

## 2. Technical Implementation

### 2.1 Architecture Overview

```
┌──────────────────────────────────────────┐
│     Neovim Buffer (Current File)         │
├──────────────────────────────────────────┤
│  :OpenCode Command                       │
│  ├─ Validate current buffer/file         │
│  ├─ Get file path: vim.fn.expand('%:p')  │
│  ├─ Optionally: capture selection        │
│  └─ Launch OpenCode with context         │
├──────────────────────────────────────────┤
│  System Command Execution                │
│  └─ vim.fn.system() or vim.uv.spawn()    │
├──────────────────────────────────────────┤
│     OpenCode Process (Foreground)        │
│     └─ Receives file + context           │
├──────────────────────────────────────────┤
│  User returns to Neovim session          │
│  (session was suspended, now resumed)    │
└──────────────────────────────────────────┘
```

### 2.2 Implementation Details

#### File Path Retrieval
```lua
-- Get absolute path of current file
local filepath = vim.fn.expand('%:p')

-- Get relative path from project root
local relative_path = vim.fn.expand('%:.')

-- Get just the filename
local filename = vim.fn.expand('%:t')

-- Get current working directory
local cwd = vim.fn.getcwd()
```

**Recommendation:** Use absolute path `%:p` for OpenCode (most reliable)

#### OpenCode Invocation Methods

**Option A: vim.fn.system() - Synchronous**
```lua
vim.fn.system({ 'opencode', filepath })
```
- **Pros:** Simple, blocks until OpenCode closes
- **Cons:** Neovim UI might freeze briefly

**Option B: vim.uv.spawn() - Asynchronous with callback**
```lua
local handle
handle = vim.uv.spawn('opencode', {
  args = { filepath }
}, function()
  -- OpenCode closed
  vim.notify('OpenCode closed', vim.log.levels.INFO)
end)
```
- **Pros:** Non-blocking, more responsive
- **Cons:** More complex code, harder to determine success/failure

**Recommendation:** Start with Option A (synchronous) for simplicity; upgrade to Option B if performance issues arise

#### Launch Method (Foreground vs Background)

**Foreground (Recommended):**
```bash
opencode file.txt
```
- User can interact with OpenCode, then close it
- Returns to Neovim when done
- More intuitive workflow

**Background:**
```bash
opencode file.txt &
```
- Opens OpenCode but keeps Neovim in foreground
- Less disruptive but potentially confusing

**Recommendation:** Use foreground mode (standard behavior)

### 2.3 System Requirements

| Requirement | Details |
|-------------|---------|
| **OpenCode Installation** | Must be installed on system and in `$PATH` |
| **CLI Support** | OpenCode must accept file path as command-line argument |
| **OS Support** | macOS, Linux, Windows (with WSL or native support) |
| **Neovim Version** | >= 0.9 (for `vim.fn.expand` and command registration) |
| **Dependencies** | No Lua dependencies required (uses Neovim stdlib) |

### 2.4 Command Registration Method

**Using Lua (Recommended):**
```lua
vim.api.nvim_create_user_command('OpenCode', function(opts)
  -- Implementation here
end, {
  desc = 'Open current file in OpenCode',
  -- Optional: nargs = '?', range = '%', etc.
})
```

**Location:** `/Users/karnellschultz/.config/nvim/lua/custom/plugins/opencode.lua`

---

## 3. Integration Points

### 3.1 File Organization

```
/Users/karnellschultz/.config/nvim/
├── lua/custom/plugins/
│   ├── opencode.lua          ← Main command implementation
│   └── keymaps.lua           ← Optional keymap for command
```

### 3.2 Module Structure

**opencode.lua:**
```lua
-- Module: opencode.nvim command
-- Purpose: Open current buffer in OpenCode

local M = {}

-- Configuration
local defaults = {
  auto_save = false,    -- Save buffer before opening
  confirm = false,      -- Ask for confirmation
}

-- Main command function
function M.open_in_opencode(opts)
  -- Validation
  -- File path retrieval
  -- OpenCode invocation
  -- Error handling
end

-- Setup function (called by lazy.nvim)
function M.setup(opts)
  opts = vim.tbl_deep_extend('force', defaults, opts or {})
  
  vim.api.nvim_create_user_command('OpenCode', M.open_in_opencode, {
    desc = 'Open current file in OpenCode',
  })
end

return M
```

### 3.3 Lazy.nvim Plugin Configuration

Current state: `opencode.lua` returns `{ nil }` (plugin disabled)

**Proposed change:**
```lua
return {
  dir = 'opencode.nvim',  -- Custom local plugin
  config = function()
    require('opencode').setup()
  end,
}
```

Or keep as simple module (not a plugin spec):
```lua
-- Load in init.lua or custom module
require('custom.modules.opencode').setup()
```

### 3.4 Keymap Integration

**Option A: Add to keymaps.lua**
```lua
vim.keymap.set('n', '<leader>oo', '<cmd>OpenCode<CR>', 
  { desc = '[O]pen in [O]penCode' })
```

**Option B: Add to opencode.lua**
```lua
vim.keymap.set('n', '<leader>oo', '<cmd>OpenCode<CR>', 
  { desc = '[O]pen in [O]penCode' })
```

**Recommendation:** Option B (keep all OpenCode-related code together)

### 3.5 Integration with Existing Plugins

**Which-key Integration:**
- The command will automatically appear in which-key if registered properly
- Keymaps using `<leader>oo` will show: `[O]pen in [O]penCode`

**No conflicts with:**
- Telescope (file picker)
- Gitsigns (git integration)
- LSP (language server protocol)
- Comment.nvim (commenting)

---

## 4. Implementation Considerations

### 4.1 Session Management

**Neovim Session Behavior:**
1. User presses `:OpenCode` while editing `file.lua`
2. OpenCode launches in **foreground**
3. Neovim session is **suspended** (background process)
4. User works in OpenCode, then closes it
5. Neovim returns to **foreground** automatically
6. Buffer state preserved exactly as left

**No special code needed** - this is default OS behavior for foreground processes

### 4.2 Error Handling Strategy

```lua
-- Check 1: Is current buffer a file?
if vim.fn.expand('%') == '' then
  vim.notify('Error: No file in current buffer', vim.log.levels.ERROR)
  return
end

-- Check 2: Is OpenCode installed?
if vim.fn.executable('opencode') == 0 then
  vim.notify('Error: OpenCode not found in $PATH', vim.log.levels.ERROR)
  return
end

-- Check 3: Is file saved? (optional)
if vim.bo.modified and config.auto_save == false then
  vim.notify('Warning: File has unsaved changes', vim.log.levels.WARN)
end

-- Execution with error checking
local success = pcall(function()
  vim.fn.system({ 'opencode', filepath })
end)

if not success then
  vim.notify('Error: Failed to launch OpenCode', vim.log.levels.ERROR)
  return
end

vim.notify('OpenCode closed', vim.log.levels.INFO)
```

### 4.3 Confirmation/Logging

**Proposed User Feedback:**

1. **Success Message (optional):**
   ```
   vim.notify('Opening ' .. filepath .. ' in OpenCode...', vim.log.levels.INFO)
   ```

2. **After Return:**
   ```
   vim.notify('Returned to Neovim', vim.log.levels.INFO)
   ```

3. **Verbose Logging (for debugging):**
   - Log to file: `~/.config/nvim/log/opencode.log`
   - Only if explicitly enabled in config

**Recommendation:** Show minimal feedback (start/end messages only)

### 4.4 Auto-Save Consideration

**Should we auto-save before opening OpenCode?**

| Approach | Pros | Cons |
|----------|------|------|
| **Auto-save** | OpenCode always sees latest | Changes user expectation |
| **Manual save required** | User explicit control | Requires extra step |
| **Warn only** | Balanced approach | User might forget |
| **Config option** | Maximum flexibility | More complexity |

**Recommendation:** Warn if unsaved, don't auto-save. Let user decide.

---

## 5. Acceptance Criteria

The implementation will be complete when:

1. ✅ Command `:OpenCode` is registered and callable in Neovim
2. ✅ Retrieves current file path accurately
3. ✅ Launches OpenCode with file as argument
4. ✅ OpenCode runs in foreground (Neovim suspends)
5. ✅ Session resumes correctly when OpenCode closes
6. ✅ Error messages displayed for:
   - No file in buffer
   - OpenCode not installed
   - Unsaved changes (warning only)
7. ✅ Optional keymap `:leader>oo` works and is discoverable
8. ✅ Code is documented with comments
9. ✅ No dependencies added beyond Neovim stdlib
10. ✅ Works on macOS (tested on your system)

---

## 6. Implementation Roadmap

### Phase 1: Core Implementation (Immediate)
- [ ] Create basic command function
- [ ] Handle file path retrieval
- [ ] Invoke OpenCode with error checking
- [ ] Test on macOS

### Phase 2: Polish & Features (Follow-up)
- [ ] Add keymap
- [ ] Add documentation
- [ ] Add configuration options
- [ ] Test edge cases

### Phase 3: Enhancements (Future)
- [ ] Visual selection support
- [ ] Configurable launch behavior
- [ ] OpenCode command output handling
- [ ] Integration with git context

---

## 7. Code Sketch (Preliminary)

```lua
-- /Users/karnellschultz/.config/nvim/lua/custom/plugins/opencode.lua

local M = {}

local defaults = {
  auto_save = false,
  confirm_unsaved = true,
}

function M.open_in_opencode()
  -- Get current buffer file path
  local filepath = vim.fn.expand('%:p')
  
  -- Validation
  if filepath == '' then
    vim.notify('Error: No file in current buffer', vim.log.levels.ERROR)
    return
  end
  
  if vim.fn.executable('opencode') == 0 then
    vim.notify('Error: OpenCode not installed or not in $PATH', vim.log.levels.ERROR)
    return
  end
  
  -- Warning for unsaved changes
  if vim.bo.modified then
    vim.notify('Warning: File has unsaved changes', vim.log.levels.WARN)
  end
  
  -- Launch OpenCode
  vim.notify('Opening ' .. filepath .. ' in OpenCode...', vim.log.levels.INFO)
  local success, result = pcall(function()
    vim.fn.system({ 'opencode', filepath })
  end)
  
  if not success then
    vim.notify('Error: Failed to launch OpenCode', vim.log.levels.ERROR)
    return
  end
  
  vim.notify('Returned from OpenCode', vim.log.levels.INFO)
end

function M.setup(opts)
  local config = vim.tbl_deep_extend('force', defaults, opts or {})
  
  -- Register command
  vim.api.nvim_create_user_command('OpenCode', M.open_in_opencode, {
    desc = 'Open current file in OpenCode',
  })
  
  -- Register keymap
  vim.keymap.set('n', '<leader>oo', M.open_in_opencode, {
    desc = '[O]pen in [O]penCode',
  })
end

return M
```

**Usage in init.lua or plugin spec:**
```lua
require('custom.plugins.opencode').setup()
```

---

## 8. Questions for User Review

Before implementation, please review:

1. **Command Naming**: Is `:OpenCode` the preferred name, or would you prefer `:OC` or something else?

2. **Keymap**: Does `<leader>oo` work for you, or prefer different keys?

3. **Auto-save**: Should we auto-save unsaved files before opening OpenCode, or just warn?

4. **Foreground Launch**: Confirmed you want OpenCode to launch in foreground (suspending Neovim)?

5. **Error Handling**: Are the error messages clear and helpful?

6. **Visual Selection**: Should we implement support for sending selected text to OpenCode now, or later?

7. **Configuration**: Do you want configuration options (e.g., auto_save, confirm_unsaved)?

---

## 9. Next Steps

1. **Review Plan**: User reviews and provides feedback
2. **Address Questions**: Clarify any uncertainties
3. **Implementation**: Code is written and tested
4. **Testing**: Verify all acceptance criteria met
5. **Documentation**: Add comments and update keymaps list

---

**Last Updated:** March 21, 2026
**Status:** Awaiting User Feedback
