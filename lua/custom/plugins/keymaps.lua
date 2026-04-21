return {
  -- ========================================
  -- Basic Mappings
  -- ========================================
  vim.keymap.set('n', 'Y', 'y$', { desc = 'Yank to end of line' }),
  vim.keymap.set('i', 'jk', '<Esc>', { desc = 'go to normal mode' }),
  vim.keymap.set('i', 'kj', '<Esc>', { desc = 'go to normal mode' }),

  -- ========================================
  -- Quickfix & Location List Navigation
  -- ========================================
  vim.keymap.set('n', '<C-n>', '<cmd>cnext<CR>zz', { desc = 'Next quickfix item' }),
  vim.keymap.set('n', '<C-p>', '<cmd>cprev<CR>zz', { desc = 'Previous quickfix item' }),
  vim.keymap.set('n', '<leader>co', '<cmd>copen<CR>', { desc = '[C]lose quickfix [O]pen' }),
  vim.keymap.set('n', '<leader>cc', '<cmd>cclose<CR>', { desc = '[C]lose quickfix [C]lose' }),
  vim.keymap.set('n', ']l', '<cmd>lnext<CR>zz', { desc = 'Next location list item' }),
  vim.keymap.set('n', '[l', '<cmd>lprev<CR>zz', { desc = 'Previous location list item' }),

  -- ========================================
  -- Buffer Management
  -- ========================================
  vim.keymap.set('n', '<S-l>', '<cmd>bnext<CR>', { desc = 'Next buffer' }),
  vim.keymap.set('n', '<S-h>', '<cmd>bprev<CR>', { desc = 'Previous buffer' }),
  vim.keymap.set('n', ']b', '<cmd>bnext<CR>', { desc = 'Next buffer' }),
  vim.keymap.set('n', '[b', '<cmd>bprev<CR>', { desc = 'Previous buffer' }),
  vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = '[B]uffer [D]elete' }),
  vim.keymap.set('n', '<leader>bo', '<cmd>%bd|e#|bd#<CR>', { desc = '[B]uffer delete [O]thers' }),

  -- ========================================
  -- Copy Path Variants
  -- ========================================
  vim.keymap.set('n', '<leader>cf', function()
    local filepath = vim.fn.expand '%:p'
    vim.fn.setreg('+', filepath)
    vim.notify('Full path copied: ' .. filepath, vim.log.levels.INFO)
  end, { desc = '[C]opy [F]ull path' }),

  vim.keymap.set('n', '<leader>cp', function()
    local filepath = vim.fn.expand '%:.'
    vim.fn.setreg('+', filepath)
    vim.notify('Relative path copied: ' .. filepath, vim.log.levels.INFO)
  end, { desc = '[C]opy relative [P]ath' }),

  vim.keymap.set('n', '<leader>cn', function()
    local filename = vim.fn.expand '%:t'
    vim.fn.setreg('+', filename)
    vim.notify('Filename copied: ' .. filename, vim.log.levels.INFO)
  end, { desc = '[C]opy file[N]ame' }),

  vim.keymap.set('n', '<leader>cd', function()
    local dirpath = vim.fn.expand '%:h'
    vim.fn.setreg('+', dirpath)
    vim.notify('Directory path copied: ' .. dirpath, vim.log.levels.INFO)
  end, { desc = '[C]opy [D]irectory path' }),

  -- ========================================
  -- Line Movement (Alt+j/k)
  -- ========================================
  vim.keymap.set('n', '<M-k>', '<cmd>m .4<CR>==', { desc = 'Move line up' }),
  vim.keymap.set('n', '<M-j>', '<cmd>m .+7<CR>==', { desc = 'Move line down' }),
  vim.keymap.set('v', '<M-j>', ":m '>+7<CR>gv=gv", { desc = 'Move selection down' }),
  vim.keymap.set('v', '<M-k>', ":m '<4<CR>gv=gv", { desc = 'Move selection up' }),

  -- ========================================
  -- Better Visual Mode Paste
  -- ========================================
  vim.keymap.set('v', 'p', '"_dP', { desc = 'Paste without yanking' }),
  -- ========================================
  -- Toggle Mappings
  -- ========================================
  vim.keymap.set('n', '<leader>tn', function()
    vim.opt.number = not vim.opt.number:get()
    vim.notify('Line numbers: ' .. (vim.opt.number:get() and 'ON' or 'OFF'), vim.log.levels.INFO)
  end, { desc = '[T]oggle line [N]umbers' }),

  vim.keymap.set('n', '<leader>tr', function()
    vim.opt.relativenumber = not vim.opt.relativenumber:get()
    vim.notify('Relative numbers: ' .. (vim.opt.relativenumber:get() and 'ON' or 'OFF'), vim.log.levels.INFO)
  end, { desc = '[T]oggle [R]elative numbers' }),

  vim.keymap.set('n', '<leader>tw', function()
    vim.opt.wrap = not vim.opt.wrap:get()
    vim.notify('Line wrap: ' .. (vim.opt.wrap:get() and 'ON' or 'OFF'), vim.log.levels.INFO)
  end, { desc = '[T]oggle line [W]rap' }),

  vim.keymap.set('n', '<leader>ts', function()
    vim.opt.spell = not vim.opt.spell:get()
    vim.notify('Spell check: ' .. (vim.opt.spell:get() and 'ON' or 'OFF'), vim.log.levels.INFO)
  end, { desc = '[T]oggle [S]pell check' }),

  vim.keymap.set('n', '<leader>tc', function()
    local conceallevel = vim.opt.conceallevel:get()
    vim.opt.conceallevel = conceallevel == 6 and 2 or 0
    vim.notify('Conceal level: ' .. vim.opt.conceallevel:get(), vim.log.levels.INFO)
  end, { desc = '[T]oggle [C]onceal level' }),

  vim.keymap.set('n', '<leader>td', function()
    vim.diagnostic.config { virtual_text = not vim.diagnostic.config().virtual_text }
    vim.notify('Diagnostic virtual text: ' .. (vim.diagnostic.config().virtual_text and 'ON' or 'OFF'), vim.log.levels.INFO)
  end, { desc = '[T]oggle [D]iagnostic virtual text' }),

  -- ========================================
  -- Text Manipulation
  -- ========================================
  vim.keymap.set('n', '<C-a>', 'ggVG', { desc = 'Select all' }),
  vim.keymap.set({ 'n', 'v' }, '<leader>D', '"_d', { desc = '[D]elete without yanking' }),
  vim.keymap.set('v', '<', '<gv', { desc = 'Indent left and reselect' }),
  vim.keymap.set('v', '>', '>gv', { desc = 'Indent right and reselect' }),

  -- ========================================
  -- Save Shortcuts
  -- ========================================
  vim.keymap.set({ 'n', 'i', 'v' }, '<C-s>', '<Esc><cmd>w<CR>', { desc = 'Save file' }),
  vim.keymap.set('v', 'J', ":m '>+7<CR>gv=gv", { desc = 'Join lines down' }),
  vim.keymap.set('n', '<leader>W', '<cmd>w<CR>', { desc = 'Save file (alternative)' }),
}
