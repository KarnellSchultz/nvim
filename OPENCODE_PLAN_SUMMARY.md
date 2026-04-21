# OpenCode Neovim Command - Quick Summary

## 🎯 Goal
Create a Neovim command that instantly opens your current file in OpenCode.

---

## 📋 Command Design

### Basic Usage
```vim
:OpenCode              " Opens current file in OpenCode
```

### With Keymap (Optional)
```vim
<leader>oo            " Same as :OpenCode (suggested)
```

---

## 🔧 How It Works

```
┌─────────────────────────────────────┐
│ You edit file.lua in Neovim         │
└─────────────────┬───────────────────┘
                  │
                  ▼
        ┌─────────────────────┐
        │  Press :OpenCode    │
        └──────────┬──────────┘
                   │
                   ▼
    ┌──────────────────────────────┐
    │ 1. Get current file path     │
    │ 2. Check file exists         │
    │ 3. Check OpenCode installed  │
    │ 4. Launch: opencode file.lua │
    └──────────┬───────────────────┘
               │
               ▼
    ┌──────────────────────────────┐
    │  OpenCode opens in           │
    │  foreground (you use it)     │
    │                              │
    │ Neovim waits in background   │
    └──────────┬───────────────────┘
               │
               ▼ (when you close OpenCode)
    ┌──────────────────────────────┐
    │  Neovim returns to foreground │
    │  Session preserved            │
    └──────────────────────────────┘
```

---

## 📦 What Gets Implemented

### File: `lua/custom/plugins/opencode.lua`

**Features:**
- ✅ Simple, clean Lua implementation
- ✅ Command registration: `:OpenCode`
- ✅ Optional keymap: `<leader>oo`
- ✅ Error handling for:
  - No file in buffer
  - OpenCode not installed
  - Unsaved changes (warning)
- ✅ User feedback (notifications)

**No plugins needed** - uses Neovim's built-in API

---

## 🎮 User Experience

### Scenario 1: Happy Path
```
You: :OpenCode
→ Notification: "Opening file.lua in OpenCode..."
→ OpenCode launches
→ You work in OpenCode...
→ You close OpenCode
→ Notification: "Returned from OpenCode"
→ Back to your Neovim session exactly as you left it
```

### Scenario 2: Unsaved Changes
```
You: :OpenCode
→ Notification (WARN): "File has unsaved changes"
→ OpenCode still launches with latest file on disk
→ You decide if you want to save first (your choice)
```

### Scenario 3: OpenCode Not Installed
```
You: :OpenCode
→ Notification (ERROR): "OpenCode not installed or not in $PATH"
→ Command exits gracefully
→ Nothing broken
```

---

## 🔍 Edge Cases Handled

| Situation | Behavior |
|-----------|----------|
| Empty buffer (no file) | Show error message |
| New unsaved file | Show error message |
| File in git repo | ✅ Works fine |
| File NOT in git repo | ✅ Works fine |
| OpenCode not installed | Show error message |
| Unsaved changes | Show warning, still launch |
| SSH/remote files | Show warning (might not work) |

---

## ⚙️ Technical Details

### What Happens Behind the Scenes
1. **File Path**: Uses `vim.fn.expand('%:p')` to get absolute path
2. **Validation**: Checks file exists and OpenCode is installed
3. **Launch**: Calls `vim.fn.system({ 'opencode', filepath })`
4. **Blocking**: Neovim waits for OpenCode to close (synchronous)
5. **Return**: Session resumes exactly as left

### System Requirements
- Neovim >= 0.9
- OpenCode installed and in `$PATH`
- macOS, Linux, or Windows (WSL)
- No additional Lua dependencies

---

## 📝 Code Organization

```
lua/custom/plugins/opencode.lua
├── Module setup function
├── Main open_in_opencode() function
├── Command registration
├── Keymap registration
└── Error handling
```

**Total lines of code:** ~60-80 lines (very simple)

---

## 🎯 Implementation Checklist

- [ ] Create `lua/custom/plugins/opencode.lua`
- [ ] Implement main function
- [ ] Register `:OpenCode` command
- [ ] Add optional keymap
- [ ] Add error handling
- [ ] Add notifications
- [ ] Test on your system
- [ ] Add documentation

---

## ❓ Questions to Answer Before Implementation

### 1. **Command/Keymap Names**
- `:OpenCode` ✅ (clear, explicit)
- `<leader>oo` ✅ (intuitive)
- Acceptable?

### 2. **Auto-save Behavior**
- **Option A:** Just warn if unsaved, don't auto-save
- **Option B:** Auto-save before opening
- Preference?

### 3. **Launch Method**
- Foreground (suspends Neovim)? ✅ **Recommended**
- Background (keeps Neovim in focus)?

### 4. **Verbosity**
- Show notifications? ✅ (INFO level)
- Show errors? ✅ (ERROR level)
- Show warnings? ✅ (WARN level)

### 5. **Future Features**
- **Phase 1 (now):** File path support
- **Phase 2 (later):** Visual selection support
- **Phase 3 (later):** Config options
- Okay with this approach?

---

## 📚 Resources

### Full Documentation
See: `OPENCODE_COMMAND_PLAN.md` (detailed technical specs)

### Related Code
- Neovim API: `:help api`
- User commands: `:help nvim_create_user_command`
- Keymaps: `:help nvim_set_keymap`
- System calls: `:help vim.fn.system`

---

## 🚀 Timeline

- **Design Review:** Now (you reading this)
- **Implementation:** ~15 minutes
- **Testing:** ~5 minutes
- **Total:** ~20 minutes for a working feature

---

## ✨ Expected Result

After implementation:
```vim
" In any file, press:
:OpenCode

" Or use keymap:
<leader>oo

" Result:
" → File opens in OpenCode
" → You work in OpenCode
" → Close OpenCode
" → Back to Neovim, exactly as you left it
```

Simple, elegant, no friction.

---

**Next Step:** Review the full plan and provide feedback on the questions above.
