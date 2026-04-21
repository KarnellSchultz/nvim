# OpenCode Command - Decision Matrix

Use this document to confirm your preferences before implementation starts.

---

## 🎯 Decision 1: Command & Keymap Names

### Question: What should the command be called?

| Option | Pros | Cons | Recommendation |
|--------|------|------|-----------------|
| `:OpenCode` | Clear, descriptive, matches tool name | Longer to type | ✅ **Primary** |
| `:OC` | Quick to type | Less discoverable | Consider as alias |
| `:OpenInCode` | Very explicit | Even longer | Not preferred |
| `:Code` | Short | Too generic | Avoid (conflicts likely) |

**Decision:** `:OpenCode` is recommended. Would you like an `:OC` alias too?

---

### Question: What keymap should we use?

| Option | Pros | Cons | Recommendation |
|--------|------|------|-----------------|
| `<leader>oo` | Intuitive, mnemonic ([O]pen [O]penCode) | Two 'o' presses | ✅ **Primary** |
| `<leader>co` | Alternative [C]ode [O]pen | Less intuitive | Alternative |
| `<leader>ec` | Another mnemonic | Harder to remember | Not preferred |
| `<C-o>` | Quick keyboard combo | Conflicts with jump history | Avoid |

**Decision:** `<leader>oo` is recommended. Acceptable for you?

---

## 🔄 Decision 2: File Handling

### Question: How should we handle unsaved changes?

```
Scenario: You edit file.lua, don't save, then press :OpenCode
```

| Option | Behavior | Pros | Cons | Recommendation |
|--------|----------|------|------|-----------------|
| **Warn Only** | Show warning but open OpenCode with disk version | User has choice | Might be confusing | ✅ **Recommended** |
| **Auto-Save** | Auto-save before opening OpenCode | Always up-to-date | Changes user expectations | Not recommended |
| **Block** | Show error, require save first | Explicit control | More friction | Not recommended |
| **Use Buffer** | Open OpenCode with current buffer content | Always accurate | Complex implementation | Future enhancement |

**Decision:** "Warn Only" is recommended.

```lua
-- What user sees:
vim.notify('Warning: File has unsaved changes', vim.log.levels.WARN)
-- Then OpenCode opens anyway (with disk version)
```

Acceptable?

---

### Question: How should we handle errors?

| Error Case | Action | Example Message |
|-----------|--------|-----------------|
| No file in buffer | Show error, don't launch | "Error: No file in current buffer" |
| OpenCode not installed | Show error, don't launch | "Error: OpenCode not installed or not in $PATH" |
| File doesn't exist | Show error, don't launch | "Error: File not found on disk" |
| SSH/remote file | Show warning, still try | "Warning: Remote file may not be accessible" |

**Decision:** This approach recommended. Acceptable?

---

## 🚀 Decision 3: Launch Behavior

### Question: How should OpenCode be launched?

```
Scenario: You press :OpenCode in Neovim
```

| Option | Behavior | Example | Recommended |
|--------|----------|---------|-------------|
| **Foreground** | OpenCode opens in front, Neovim in background | `opencode file.lua` (blocking) | ✅ **Yes** |
| **Background** | OpenCode opens, Neovim stays in front | `opencode file.lua &` (non-blocking) | No |
| **Detached** | OpenCode launches independently | `nohup opencode file.lua &` | No |
| **In Terminal** | OpenCode opens in Neovim terminal | `:terminal opencode` | No |

**Decision:** "Foreground" is recommended.
- OpenCode takes focus
- You work in OpenCode
- When closed, Neovim returns to foreground
- Natural workflow

Acceptable?

---

## 💬 Decision 4: User Feedback

### Question: What notifications should we show?

```lua
-- Option A: Minimal (just errors)
-- Only show errors, silent on success
if success then return end
vim.notify('Error: Failed to launch OpenCode', vim.log.levels.ERROR)

-- Option B: Balanced (errors + important events)
-- Show start, end, errors, and warnings
vim.notify('Opening ' .. filepath .. ' in OpenCode...', vim.log.levels.INFO)
-- ... opencode runs ...
vim.notify('Returned from OpenCode', vim.log.levels.INFO)

-- Option C: Verbose (all messages)
-- Show everything including debug info
vim.notify('OpenCode path: ' .. filepath, vim.log.levels.DEBUG)
-- ... lots of messages ...
```

| Option | Pros | Cons | Recommendation |
|--------|------|------|-----------------|
| **A: Minimal** | No notification spam | Silent failures confusing | Not recommended |
| **B: Balanced** | Clear feedback without spam | Might be verbose | ✅ **Recommended** |
| **C: Verbose** | Excellent for debugging | Too noisy for daily use | Only when debugging |

**Decision:** "Balanced" is recommended.

```lua
-- Show these:
✅ "Opening file.lua in OpenCode..." (INFO)
✅ "Returned from OpenCode" (INFO)
✅ "File has unsaved changes" (WARN)
✅ "OpenCode not installed" (ERROR)

-- Don't show:
❌ Debug/verbose messages
```

Acceptable?

---

## 🔧 Decision 5: Implementation Approach

### Question: How should the code be organized?

| Option | Structure | Pros | Cons | Recommendation |
|--------|-----------|------|------|-----------------|
| **A: Simple module** | `lua/custom/plugins/opencode.lua` with function | Lightweight, easy | Not lazy-loaded | ✅ **Recommended** |
| **B: Lazy plugin** | Full lazy.nvim plugin spec | Can be lazy-loaded | Overkill | Not recommended |
| **C: In keymaps.lua** | Command + keymap together in keymaps.lua | Single file | Mixes concerns | Not recommended |

**Decision:** "Simple module" recommended.

**File:** `/Users/karnellschultz/.config/nvim/lua/custom/plugins/opencode.lua`

**Load in:** `init.lua` or via lazy import

```lua
-- In init.lua:
require('custom.plugins.opencode').setup()

-- Or in lazy.nvim:
{ import = 'custom.plugins' },  -- already enabled
```

Acceptable?

---

## 📦 Decision 6: Configuration Options

### Question: Should we add configuration?

| Option | Features | Complexity | Recommendation |
|--------|----------|-----------|-----------------|
| **A: None** | No options, hardcoded behavior | Minimal | ✅ **Phase 1** |
| **B: Basic** | `auto_save`, `confirm_unsaved`, `show_notifications` | Low | Phase 2 |
| **C: Advanced** | Custom command args, templates, git integration | High | Phase 3+ |

**Decision for Phase 1:**
```lua
-- No configuration, just use:
require('custom.plugins.opencode').setup()

-- Hardcoded defaults:
-- - auto_save = false
-- - confirm_unsaved = true
-- - show_notifications = true
```

Later phases can add options if needed.

Acceptable for now?

---

## 🎯 Decision 7: Feature Scope

### Question: What should Phase 1 include?

| Feature | Phase 1 | Phase 2 | Phase 3 | Your Choice |
|---------|---------|---------|---------|------------|
| Open current file | ✅ Yes | - | - | Required |
| Keymap binding | ✅ Yes | - | - | Recommended |
| Error handling | ✅ Yes | - | - | Required |
| Visual selection | - | Maybe | - | Optional |
| Git context | - | - | Maybe | Future |
| Config options | - | Maybe | - | Future |
| Logging | - | Maybe | - | Future |

**Decision:** Phase 1 = Current file + keymap + errors only.

Is this scope appropriate?

---

## ✅ Confirmation Checklist

Please confirm your preferences:

- [ ] **Command Name:** `:OpenCode` ✅
  - [ ] Also want `:OC` alias?
  
- [ ] **Keymap:** `<leader>oo` ✅
  
- [ ] **Unsaved Changes:** Warn only, don't auto-save ✅
  
- [ ] **Error Handling:** As specified in Decision 2 ✅
  
- [ ] **Launch Method:** Foreground (blocking) ✅
  
- [ ] **Notifications:** Balanced level (start, end, warn, error) ✅
  
- [ ] **Implementation:** Simple module in opencode.lua ✅
  
- [ ] **Configuration:** None in Phase 1 ✅
  
- [ ] **Scope:** Current file + keymap + errors ✅

---

## 📝 Final Code Outline

Based on these decisions, here's the structure:

```lua
-- lua/custom/plugins/opencode.lua

local M = {}

-- Configuration (no user options in Phase 1)
local config = {
  auto_save = false,
  confirm_unsaved = true,
  show_notifications = true,
}

-- Main function: open current file in OpenCode
function M.open_in_opencode()
  -- 1. Get file path
  local filepath = vim.fn.expand('%:p')
  
  -- 2. Validate: file exists in buffer
  if filepath == '' then
    vim.notify('Error: No file in current buffer', vim.log.levels.ERROR)
    return
  end
  
  -- 3. Validate: OpenCode installed
  if vim.fn.executable('opencode') == 0 then
    vim.notify('Error: OpenCode not installed or not in $PATH', vim.log.levels.ERROR)
    return
  end
  
  -- 4. Warn if unsaved changes
  if vim.bo.modified then
    vim.notify('Warning: File has unsaved changes', vim.log.levels.WARN)
  end
  
  -- 5. Launch OpenCode (blocking call)
  if config.show_notifications then
    vim.notify('Opening ' .. filepath .. ' in OpenCode...', vim.log.levels.INFO)
  end
  
  local success = pcall(function()
    vim.fn.system({ 'opencode', filepath })
  end)
  
  if not success then
    vim.notify('Error: Failed to launch OpenCode', vim.log.levels.ERROR)
    return
  end
  
  if config.show_notifications then
    vim.notify('Returned from OpenCode', vim.log.levels.INFO)
  end
end

-- Setup function
function M.setup(opts)
  -- Register command
  vim.api.nvim_create_user_command('OpenCode', M.open_in_opencode, {
    desc = 'Open current file in OpenCode',
  })
  
  -- Register keymap
  vim.keymap.set('n', '<leader>oo', M.open_in_opencode, {
    desc = '[O]pen in [O]penCode',
    noremap = true,
  })
end

return M
```

Does this structure match your expectations?

---

## 🚀 Next Steps

1. **Review** this document
2. **Confirm** your preferences (check all boxes above)
3. **Provide feedback** on any decisions
4. **Approve** the design
5. **Implementation begins** with your confirmation

---

**Ready to proceed?** Once you confirm the decisions above, implementation can start immediately.
