return {
  'mikavilpas/yazi.nvim',
  event = 'VeryLazy',
  keys = {
    -- 👇 in this section, choose your own keymappings!
    {
      '<leader>n',
      '<cmd>Yazi<cr>',
      desc = '[N]etrw alternative - Open yazi',
    },
    {
      -- Open in the current working directory
      '<leader>y',
      '<cmd>Yazi cwd<cr>',
      desc = '[Y]azi in current working directory',
    },
    {
      -- NOTE: this requires a version of yazi that includes
      -- https://github.com/sxyazi/yazi/pull/1305 from 2024-07-18
      '<leader>yr',
      '<cmd>Yazi toggle<cr>',
      desc = '[Y]azi [R]esume session',
    },
  },
  opts = {
    -- if you want to open yazi instead of netrw, see below for more info
    open_for_directories = false,
    keymaps = {
      show_help = '<f1>',
    },
    yazi_floating_window_border = 'none',
  },
}
