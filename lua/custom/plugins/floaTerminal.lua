local state = {
  floating = {
    win = -1,
    buf = -1,
  },
}

local function create_floating_window(opts)
  opts = opts or {}
  -- Get the current window dimensions
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)

  -- Create or reuse a buffer
  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true) -- create a new buffer
  end

  -- Configure the floating window
  local win_config = {
    relative = 'editor',
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    border = 'rounded', -- You can change this to 'single', 'double', etc.
  }

  -- Create a new floating window
  local win = vim.api.nvim_open_win(buf, true, win_config)

  -- Set terminal options and key mappings
  vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', '<cmd>close<CR>', { noremap = true, silent = true })

  return { buf = buf, win = win }
end

-- Function to toggle the terminal
local function toggle_terminal()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    -- Create a new floating window and start the terminal
    state.floating = create_floating_window { buf = state.floating.buf }
    if vim.bo[state.floating.buf].buftype ~= 'terminal' then
      vim.cmd.terminal()
    end
    -- start in insert mode
    vim.cmd 'normal i'
  else
    -- Hide the floating window
    vim.api.nvim_win_hide(state.floating.win)
  end
end

-- Create a user command and key mapping for toggling the terminal
vim.api.nvim_create_user_command('Floaterminal', toggle_terminal, {})
vim.keymap.set({ 'n', 't' }, '<leader>tt', toggle_terminal, { desc = 'Toggle Floating Terminal' })
return {}
