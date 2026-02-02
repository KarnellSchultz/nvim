return {
  -- vim.keymap.set('n', '<C-q>j', '<cmd>:cnext<CR>'),
  -- vim.keymap.set('n', '<C-q>k', '<cmd>:cprev<CR>'),
  vim.keymap.set('n', 'Y', 'y$', { desc = 'Yank to end of line' }),
  vim.keymap.set('i', 'jk', '<Esc>', { desc = 'go to normal mode' }),
  vim.keymap.set('i', 'kj', '<Esc>', { desc = 'go to normal mode' }),
  vim.keymap.set('n', '<leader>cp', function()
    local filepath = vim.fn.expand '%:p'
    vim.fn.setreg('+', filepath)
    print('✨copied✨:' .. filepath)
  end, { noremap = true, desc = 'Copy file path' }),
}
