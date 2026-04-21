# OpenCode Neovim Feature - Complete Specification

**Project:** Neovim OpenCode Command Integration  
**Date Created:** March 21, 2026  
**Status:** 📋 Planning Phase (Awaiting Feedback)  
**Owner:** Product Owner (Planning Agent)  
**Implementation Lead:** (To be assigned)  

---

## 📚 Documentation Guide

This feature has comprehensive planning documents. Read them in this order:

1. **START HERE:** `OPENCODE_PLAN_SUMMARY.md` - Quick overview (5 min read)
2. **DECISIONS:** `OPENCODE_DECISIONS.md` - Confirm your preferences (10 min read)
3. **DETAILS:** `OPENCODE_COMMAND_PLAN.md` - Full technical specification (15 min read)
4. **THIS FILE:** Feature specification and acceptance criteria

---

## 🎯 Feature Overview

### What is this?
A Neovim command that instantly opens your current file in OpenCode with a single keystroke.

### Why does it matter?
- **Workflow Integration:** Seamless context switching between Neovim and OpenCode
- **Quick Context:** Send current file immediately without manual file picking
- **Session Preservation:** Neovim session stays exactly as you left it

### Who benefits?
- Developers using both Neovim and OpenCode
- Users wanting quick AI context about current file
- Teams using OpenCode for code analysis/enhancement

---

## 📋 Feature Specification

### Command Specification

**Primary Command:**
```vim
:OpenCode
```

**Description:**  
Opens the currently edited file in OpenCode for context-aware AI assistance.

**Behavior:**
1. Retrieves absolute path of current buffer's file
2. Validates file exists and OpenCode is installed
3. Launches OpenCode with file as command-line argument
4. Neovim suspends (waits in background)
5. User works in OpenCode, then closes it
6. Neovim returns to foreground with session preserved

**Optional Keymap:**
```vim
<leader>oo    " Same as :OpenCode
```

### Functional Requirements

| # | Requirement | Priority | Status |
|---|-------------|----------|--------|
| FR-1 | Command `:OpenCode` must be registered and callable | HIGH | 🔄 Planned |
| FR-2 | Get current buffer file path using vim.fn.expand('%:p') | HIGH | 🔄 Planned |
| FR-3 | Validate file exists before launching OpenCode | HIGH | 🔄 Planned |
| FR-4 | Validate OpenCode executable exists in $PATH | HIGH | 🔄 Planned |
| FR-5 | Launch OpenCode with file path as argument | HIGH | 🔄 Planned |
| FR-6 | Wait for OpenCode to close (synchronous launch) | HIGH | 🔄 Planned |
| FR-7 | Return to Neovim session after OpenCode closes | HIGH | 🔄 Planned |
| FR-8 | Optional keymap `<leader>oo` bound to command | MEDIUM | 🔄 Planned |
| FR-9 | Show user notifications for start/end/errors | MEDIUM | 🔄 Planned |
| FR-10 | Warn if file has unsaved changes | MEDIUM | 🔄 Planned |

### Non-Functional Requirements

| # | Requirement | Priority | Status |
|---|-------------|----------|--------|
| NFR-1 | No additional Lua dependencies beyond Neovim stdlib | HIGH | 🔄 Planned |
| NFR-2 | Fast execution (< 100ms to launch OpenCode) | MEDIUM | 🔄 Planned |
| NFR-3 | Code documented with clear comments | MEDIUM | 🔄 Planned |
| NFR-4 | Support Neovim >= 0.9 | MEDIUM | 🔄 Planned |
| NFR-5 | Cross-platform (macOS, Linux) compatibility | LOW | 🔄 Planned |

### Error Handling

**Error Scenarios:**

| Scenario | Error Message | Recovery |
|----------|---------------|----------|
| No file in buffer | "Error: No file in current buffer" | User must open a file first |
| File doesn't exist on disk | "Error: File not found on disk" | User must save file or check path |
| OpenCode not installed | "Error: OpenCode not installed or not in $PATH" | User must install OpenCode |
| OpenCode launch fails | "Error: Failed to launch OpenCode" | User can check OpenCode installation |

**Warning Scenarios:**

| Scenario | Warning Message | Behavior |
|----------|-----------------|----------|
| Unsaved changes | "Warning: File has unsaved changes" | OpenCode opens with disk version (not current buffer) |
| SSH/remote file | "Warning: Remote file may not be accessible to OpenCode" | OpenCode still launches (may fail) |

---

## 🔍 Acceptance Criteria

### Core Functionality

- [ ] **AC-1:** Command `:OpenCode` is registered in Neovim and callable from normal mode
- [ ] **AC-2:** Pressing `:OpenCode` retrieves the absolute file path of the current buffer
- [ ] **AC-3:** OpenCode launches in foreground with the file path as argument
- [ ] **AC-4:** Neovim session is preserved (cursor position, window state, buffers)
- [ ] **AC-5:** After closing OpenCode, user returns to Neovim with all state intact
- [ ] **AC-6:** Command works with files in any directory (absolute and relative paths)

### Error Handling

- [ ] **AC-7:** Error shown when no file is open ("No file in current buffer")
- [ ] **AC-8:** Error shown when OpenCode is not installed ("OpenCode not installed")
- [ ] **AC-9:** Warning shown when file has unsaved changes
- [ ] **AC-10:** Command gracefully exits on any error (no crashes)

### User Experience

- [ ] **AC-11:** Notification shown when opening OpenCode ("Opening file.lua in OpenCode...")
- [ ] **AC-12:** Notification shown when returning ("Returned from OpenCode")
- [ ] **AC-13:** All notifications are non-blocking and dismissible
- [ ] **AC-14:** Keymap `<leader>oo` triggers the command successfully

### Code Quality

- [ ] **AC-15:** Code is well-commented explaining each step
- [ ] **AC-16:** No additional dependencies required (uses Neovim API only)
- [ ] **AC-17:** Code follows Neovim Lua style guidelines
- [ ] **AC-18:** Function names are descriptive and self-documenting

### Documentation

- [ ] **AC-19:** Setup instructions included in code comments
- [ ] **AC-20:** Usage examples provided in documentation
- [ ] **AC-21:** All configuration options documented (if any)

---

## 📐 Architecture

### Module Structure
```
lua/custom/plugins/opencode.lua
├── Module definition (M = {})
├── Configuration table (defaults)
├── Main function: open_in_opencode()
├── Setup function: setup(opts)
└── Module export (return M)
```

### Function Flow
```
User Input (:OpenCode or <leader>oo)
    ↓
M.open_in_opencode()
    ├─ Get file path: vim.fn.expand('%:p')
    ├─ Check: File path empty? → Error
    ├─ Check: OpenCode in $PATH? → Error
    ├─ Warn: File unsaved? → Warning
    ├─ Notify: "Opening..."
    ├─ Launch: vim.fn.system({ 'opencode', filepath })
    ├─ Wait: (blocking until OpenCode closes)
    └─ Notify: "Returned from OpenCode"
```

### External Dependencies
- ✅ Neovim API (built-in)
- ✅ vim.fn.expand() (built-in)
- ✅ vim.fn.executable() (built-in)
- ✅ vim.fn.system() (built-in)
- ✅ vim.api.nvim_create_user_command() (built-in)
- ✅ vim.notify() (built-in)
- ❌ No external Lua libraries required

---

## 🚀 Implementation Plan

### Phase 1: Core Implementation (Estimate: 15-20 minutes)

**Tasks:**
1. Create `lua/custom/plugins/opencode.lua`
2. Implement `open_in_opencode()` function
3. Register `:OpenCode` command
4. Add error handling and validation
5. Add user notifications
6. Test basic functionality

**Deliverables:**
- ✅ Working `:OpenCode` command
- ✅ Error handling for edge cases
- ✅ User feedback via notifications

### Phase 2: Polish & Keymap (Estimate: 5 minutes)

**Tasks:**
1. Add keymap `<leader>oo`
2. Add code comments/documentation
3. Test with multiple file types
4. Verify notifications work

**Deliverables:**
- ✅ Optional keymap binding
- ✅ Well-documented code
- ✅ Tested on macOS

### Phase 3: Future Enhancements (Later)

**Potential additions:**
- Support for visual selection
- Configuration options (auto-save, etc.)
- Custom command arguments
- Git repo context detection
- Logging/debug mode

---

## 📊 Success Metrics

After implementation, success is measured by:

1. **Functionality:** `:OpenCode` works reliably in all tested scenarios
2. **Usability:** Keymaps are intuitive and fast
3. **Reliability:** No crashes, graceful error handling
4. **User Satisfaction:** Feature works as expected without surprises
5. **Code Quality:** Clean, maintainable, well-documented code

---

## 🔗 Integration Points

### Current Neovim Configuration

**Existing Files Modified:**
- None (new feature is isolated)

**Existing Files Used:**
- `init.lua` - for loading the module
- `lua/custom/plugins/` - directory for new module

**Compatibility:**
- ✅ No conflicts with existing plugins
- ✅ No conflicts with existing keymaps
- ✅ Follows Kickstart Neovim conventions

### Which-key Integration

If which-key is active, the keymap will appear automatically:
```
<leader>
  ├─ ...
  └─ oo → [O]pen in [O]penCode
```

---

## 🧪 Testing Strategy

### Manual Testing Checklist

**Test Environment:** macOS with Neovim 0.9+

**Test Cases:**

1. ✅ **Basic Command**
   - [ ] Open file in Neovim
   - [ ] Run `:OpenCode`
   - [ ] Verify OpenCode opens with file
   - [ ] Close OpenCode
   - [ ] Verify Neovim restored with state intact

2. ✅ **Keymap**
   - [ ] Open file in Neovim
   - [ ] Press `<leader>oo`
   - [ ] Verify same behavior as `:OpenCode`

3. ✅ **Error: No File**
   - [ ] Open empty buffer (no file)
   - [ ] Run `:OpenCode`
   - [ ] Verify error message: "No file in current buffer"

4. ✅ **Error: OpenCode Not Found**
   - [ ] Temporarily remove OpenCode from $PATH (or rename binary)
   - [ ] Run `:OpenCode`
   - [ ] Verify error message: "OpenCode not installed"
   - [ ] Restore OpenCode

5. ✅ **Warning: Unsaved Changes**
   - [ ] Open file, make changes, don't save
   - [ ] Run `:OpenCode`
   - [ ] Verify warning message: "File has unsaved changes"
   - [ ] Verify OpenCode still opens

6. ✅ **Various File Types**
   - [ ] Test with .lua file
   - [ ] Test with .py file
   - [ ] Test with .js file
   - [ ] Test with other file types

---

## 📝 Documentation Requirements

### Inline Code Documentation
```lua
-- Clear comments explaining each step
-- Describe what the function does
-- Explain why, not just what
```

### User-Facing Documentation
- [ ] Add description to `:OpenCode` command
- [ ] Add description to `<leader>oo` keymap
- [ ] Include in which-key hints (automatic)

### Developer Documentation
- [ ] README section in planning documents
- [ ] Function signatures documented
- [ ] Error cases explained

---

## 🎓 Related Information

### Neovim API References
- `:help vim.api.nvim_create_user_command`
- `:help vim.fn.expand`
- `:help vim.fn.executable`
- `:help vim.fn.system`
- `:help vim.notify`
- `:help vim.keymap.set`

### OpenCode CLI
- Assumes OpenCode accepts file path as command-line argument
- Example: `opencode /path/to/file.lua`
- Behavior: OpenCode receives file as context

---

## ❓ FAQ

**Q: Will this slow down Neovim?**  
A: No. The command only runs on-demand when you press `:OpenCode`. No background processes.

**Q: Can I use this with remote/SSH files?**  
A: Possibly, but OpenCode may not be able to access remote paths. A warning will be shown.

**Q: What happens if I edit the file in OpenCode and also in Neovim?**  
A: File on disk will reflect OpenCode's changes. Neovim will detect the change via `autoread` option.

**Q: Can I send selected text to OpenCode?**  
A: Not in Phase 1. This is planned as a Phase 2 enhancement.

**Q: Can I configure the command behavior?**  
A: Not in Phase 1. Configuration options are planned for Phase 2 if needed.

**Q: Will this work with unsaved buffers?**  
A: OpenCode will receive the disk version. Neovim will warn if changes are unsaved.

---

## 📋 Sign-Off Checklist

Before implementation, confirm:

- [ ] **Planning Document:** Full technical specification reviewed
- [ ] **Decision Matrix:** All design decisions confirmed
- [ ] **Scope:** Phase 1 scope is clear and acceptable
- [ ] **User:** Ready to proceed with implementation
- [ ] **No Blockers:** All questions answered, no concerns

---

## 🔄 Version History

| Version | Date | Status | Notes |
|---------|------|--------|-------|
| 1.0 | 2026-03-21 | Planning | Initial specification created |
| | | | Awaiting user feedback and approval |

---

## 📞 Communication

**Questions or feedback?**
- Review the planning documents
- Raise concerns before implementation starts
- Suggest modifications to the design
- Request clarification on any aspect

---

## ✨ Next Steps

1. **Review** all planning documents (10-15 minutes)
2. **Provide Feedback** on design decisions
3. **Approve Design** (checkbox confirmation)
4. **Implementation Begins** with your go-ahead
5. **Testing** verifies all acceptance criteria
6. **Deployment** to your Neovim config

---

**Status:** 📋 **Awaiting User Feedback**

Ready to move forward? Please review the planning documents and confirm your preferences in `OPENCODE_DECISIONS.md`.
