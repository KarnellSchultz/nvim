# OpenCode Terminal Integration - Implementation Plan Summary

## Quick Overview

This directory contains a comprehensive plan for integrating OpenCode into your Neovim floating terminal system. The integration creates a dedicated OpenCode terminal that maintains persistent background sessions while providing seamless user experience.

**Status:** ✅ Ready for Implementation  
**Total Documentation:** 3 files  
**Implementation Effort:** ~11 hours  
**Complexity:** Moderate  

---

## 📄 Documentation Files

### 1. **OPENCODE_INTEGRATION_PLAN.md** (Primary Specification)
**→ START HERE**

The comprehensive technical specification covering:
- ✅ Full system architecture and design decisions
- ✅ Technical specifications for each component
- ✅ 18 specific acceptance criteria with test cases
- ✅ Implementation details with code examples
- ✅ Complete configuration system design
- ✅ Error handling strategy for 8+ scenarios
- ✅ 4-phase implementation roadmap

**Key Sections:**
- Part 1: Architecture & Design (Design decisions rationale)
- Part 2: Technical Specifications (What to build)
- Part 3: Implementation Details (Code outlines & logic)
- Part 4: Acceptance Criteria (18 success metrics)
- Part 5: Implementation Roadmap (4 phases)
- Part 10: Configuration Examples (User customization)

---

### 2. **OPENCODE_TASKS.md** (Task Breakdown)
**→ FOR PROJECT MANAGEMENT**

Detailed task breakdown for team coordination:
- ✅ 23 specific, actionable tasks
- ✅ Phase-based organization (6 phases)
- ✅ Clear effort estimates for each task
- ✅ Task dependencies documented
- ✅ Recommended team assignments
- ✅ Team coordination guide

**Key Information:**
- Total Effort: 23 tasks, ~11 hours
- Team: 1 developer (11 tasks), 1 tester (3 tasks), 1 doc writer (1 task)
- Critical Path: Phase 1 → Phase 2 → Phase 3 → Phase 4 → Phase 5 → Phase 6
- Dependencies graph included

---

### 3. **OPENCODE_ARCHITECTURE.md** (Technical Design)
**→ FOR DEVELOPERS**

Deep technical architecture documentation:
- ✅ System architecture diagrams
- ✅ Module structure breakdown
- ✅ Data flow diagrams
- ✅ State machine design
- ✅ Process lifecycle management
- ✅ Integration points with existing system
- ✅ Configuration system design
- ✅ Error scenarios & recovery
- ✅ Performance considerations
- ✅ Security analysis
- ✅ Testing strategy

**Key Diagrams:**
- Window/Buffer state machine
- Process lifecycle states
- Toggle sequence flow
- Error handling flowcharts
- Window dimension calculations

---

## 🎯 Quick Start for Developers

### Before You Start
1. Read **OPENCODE_INTEGRATION_PLAN.md** - understand requirements
2. Review **OPENCODE_ARCHITECTURE.md** - understand design
3. Check **OPENCODE_TASKS.md** - see task breakdown

### Implementation Path
```
Phase 1: Core Module (6 tasks) → ~2 hours
  ├─ Create module structure
  ├─ Setup configuration system
  ├─ Add notifications
  ├─ Dimension calculator
  ├─ Validation functions
  └─ Keymap setup

Phase 2: Window Management (5 tasks) → ~1.5 hours
  ├─ Window creation
  ├─ Window show/hide
  ├─ Force close
  └─ Toggle (main function)

Phase 3: Process Management (6 tasks) → ~2.5 hours
  ├─ OpenCode detection
  ├─ Process startup
  ├─ Job callbacks
  ├─ Process stop
  ├─ Restart function
  └─ Status functions

Phase 4: Error Handling (3 tasks) → ~0.5 hours
  ├─ Missing OpenCode
  ├─ Process exit errors
  └─ Window creation errors

Phase 5: Testing (3 tasks) → ~3.5 hours
  ├─ Unit tests
  ├─ Integration tests
  └─ Edge case tests

Phase 6: Documentation (2 tasks) → ~1 hour
  ├─ Code documentation
  └─ User documentation
```

### Key Implementation File
**Location:** `~/.config/nvim/lua/custom/plugins/opencodeTerminal.lua`

**Size:** ~150 lines of Lua code

**Key Functions:**
```lua
M.toggle()          -- Toggle terminal visibility
M.close()           -- Close terminal
M.restart()         -- Restart OpenCode process
M.is_running()      -- Check if process running
M.get_status()      -- Get detailed status
```

---

## ✅ Acceptance Criteria (18 Total)

### Core Functionality
1. `<leader>to` opens floating terminal
2. `<leader>to` hides floating terminal
3. OpenCode session resumes on re-open
4. Process runs in background when hidden
5. Separate from shell terminal (`<leader>tt`)
6. No buffer conflicts with shell terminal
7. Window independent from shell terminal
8. `<Esc>` hides window without exiting OpenCode
9. OpenCode starts with proper initialization
10. Error shown if OpenCode not installed
11. Errors don't crash Neovim
12. Process cleanup on Neovim exit
13. Terminal starts in insert mode
14. `:OpencodeTerminal` user command works
15. Configuration via `vim.g.opencode_float_config`
16. Window displays with rounded border
17. Session state persists across toggles
18. All criteria pass comprehensive testing

---

## 📋 Requirements Summary

### System Requirements
- ✅ Neovim 0.9+
- ✅ OpenCode CLI installed
- ✅ Lua 5.1+ (included with Neovim)

### Key Features
- ✅ Persistent background sessions
- ✅ Floating window with configurable size
- ✅ Process lifecycle management
- ✅ Graceful error handling
- ✅ User configuration support
- ✅ Status query functions
- ✅ Integration with existing system

### No External Dependencies
- ✅ No additional Neovim plugins
- ✅ Works standalone as Lua module
- ✅ Compatible with Lazy.nvim, packer, vim-plug

---

## 🔑 Key Design Decisions

### 1. **Separate from floaTerminal.lua**
- Independent lifecycle (process vs terminal)
- Easier to maintain
- No coupling between systems
- Easier to debug

### 2. **Process Persistence via jobstart()**
- Keeps OpenCode running in background
- Survives window hide/show cycles
- Clean resume on re-open
- Better than relying on buffer history

### 3. **Local State Management**
- No global variables
- State survives window operations
- Validation before every operation
- Automatic recovery on errors

### 4. **Configuration via vim.g**
- User-friendly customization
- Sane defaults
- Runtime configuration
- Non-breaking changes possible

---

## 🚀 Quick Reference

### Keymap Setup
```lua
vim.keymap.set({ 'n', 't' }, '<leader>to', M.toggle, { 
  desc = 'Toggle OpenCode Terminal' 
})
```

### User Configuration Example
```lua
vim.g.opencode_float_config = {
  width_percent = 0.9,      -- Wider window
  height_percent = 0.9,     -- Taller window
  border_style = 'double',  -- Double border
  auto_insert_mode = false, -- Start in normal mode
}
```

### Status Check
```lua
local opencode = require('custom.plugins.opencodeTerminal')
if opencode.is_running() then
  print("OpenCode is running")
end
```

---

## 📊 Implementation Statistics

| Metric | Value |
|--------|-------|
| Total Tasks | 23 |
| Implementation Tasks | 17 |
| Testing Tasks | 3 |
| Documentation Tasks | 2 |
| Total Effort | ~11 hours |
| Module Size | ~150 lines |
| Acceptance Criteria | 18 |
| Error Scenarios | 8+ |
| Functions to Implement | 14+ |
| State Variables | 10+ |

---

## 🔗 Integration Points

### With Existing System
- **floaTerminal.lua**: Separate state, no conflicts
- **keymaps.lua**: No changes needed
- **init.lua**: No changes needed
- **opencode.lua**: Can be deprecated (different approach)

### Visual Distinction
```
Current Setup:
├─ <leader>tt → Shell terminal in floating window
│
After Integration:
├─ <leader>tt → Shell terminal in floating window (unchanged)
└─ <leader>to → OpenCode in separate floating window (new)
```

---

## ⚠️ Known Limitations

### Current Version (1.0)
- Single OpenCode window at a time (by design)
- Session doesn't survive Neovim restart (could add)
- No session history persistence (could add)

### Future Enhancements (v2.0+)
- Session serialization and restore
- Multiple concurrent OpenCode windows
- Custom command integration
- Advanced theming options

---

## ✨ Highlights

### Strengths of This Design
✅ Clean separation of concerns  
✅ Robust error handling  
✅ Flexible configuration  
✅ Production-ready  
✅ Well-documented  
✅ Comprehensive testing  
✅ Easy to maintain  
✅ Easy to extend  

### Code Quality Goals
✅ < 50 lines per function  
✅ Self-documenting code  
✅ Comprehensive comments  
✅ No global pollution  
✅ Proper state validation  

---

## 📞 Questions & Answers

**Q: Why not use the opencode.nvim plugin?**
A: This is a floating terminal approach for the OpenCode CLI, not plugin integration. Different use case.

**Q: What if OpenCode isn't installed?**
A: User sees friendly error message, Neovim continues working normally.

**Q: Can I have multiple OpenCode windows?**
A: Current design supports one. Future enhancement could add this.

**Q: Does this conflict with my shell terminal?**
A: No. Completely separate windows, buffers, and state.

**Q: How do I customize the appearance?**
A: Via `vim.g.opencode_float_config` in your init.lua.

**Q: What about session persistence?**
A: Process runs in background while window hidden. Session survives toggles but not Neovim restart.

---

## 🎓 Document Cross-References

**Reading Order:**
1. This README (you are here)
2. OPENCODE_INTEGRATION_PLAN.md (requirements & specs)
3. OPENCODE_ARCHITECTURE.md (design details)
4. OPENCODE_TASKS.md (implementation tasks)

**By Role:**
- **Project Manager**: README → TASKS → PLAN
- **Developer**: PLAN (Part 3) → ARCHITECTURE → TASKS
- **Tester**: PLAN (Part 4) → TASKS (Phase 5) → ARCHITECTURE (Testing)
- **Documentation Writer**: TASKS (Phase 6) → ARCHITECTURE → PLAN

---

## 📝 Implementation Checklist

- [ ] Read OPENCODE_INTEGRATION_PLAN.md completely
- [ ] Review OPENCODE_ARCHITECTURE.md for design
- [ ] Review OPENCODE_TASKS.md for task breakdown
- [ ] Create opencodeTerminal.lua (Phase 1)
- [ ] Implement window management (Phase 2)
- [ ] Implement process management (Phase 3)
- [ ] Add error handling (Phase 4)
- [ ] Run all tests (Phase 5)
- [ ] Complete documentation (Phase 6)
- [ ] Code review pass
- [ ] All 18 acceptance criteria pass
- [ ] Ready for user deployment ✅

---

## 📚 Additional Resources

### Files in This Plan
```
~/.config/nvim/
├── OPENCODE_INTEGRATION_PLAN.md    [11 sections, 450+ lines]
├── OPENCODE_TASKS.md               [23 tasks, 400+ lines]
├── OPENCODE_ARCHITECTURE.md        [15 sections, 600+ lines]
├── OPENCODE_README.md              [This file]
└── lua/custom/plugins/
    └── opencodeTerminal.lua        [To be created, ~150 lines]
```

### External References
- Neovim API: https://neovim.io/doc/user/api.html
- OpenCode CLI: https://github.com/NickvanDyke/opencode
- Terminal Mode: https://neovim.io/doc/user/terminal.html

---

## ✅ Sign-Off

**Documentation Complete:** ✅  
**Ready for Implementation:** ✅  
**All Requirements Specified:** ✅  
**Team Assignments Clear:** ✅  

**Next Step:** Invoke @developer with Phase 1 tasks from OPENCODE_TASKS.md

---

**Document Version:** 1.0  
**Last Updated:** March 23, 2026  
**Status:** Ready for Development  

