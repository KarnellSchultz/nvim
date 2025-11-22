return {
  -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
  -- Gruvbox
  {
    'ellisonleao/gruvbox.nvim',
    name = 'gruvbox',
    -- config = function()
    --   vim.cmd.colorscheme 'gruvbox'
    -- end,
  },

  -- Rose Pine
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    -- config = function()
    --   vim.cmd.colorscheme 'rose-pine'
    -- end,
  },

  -- Catppuccin
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    -- config = function()
    --   vim.cmd.colorscheme 'catppuccin-mocha'
    -- end,
  },

  -- Tokyo Night
  {
    'folke/tokyonight.nvim',
    name = 'tokyonight',
    -- config = function()
    --   vim.cmd.colorscheme 'tokyonight'
    -- end,
  },

  -- Dracula
  {
    'Mofiqul/dracula.nvim',
    name = 'dracula',
    -- config = function()
    --   vim.cmd.colorscheme 'dracula'
    -- end,
  },

  -- Nord
  {
    'shaunsingh/nord.nvim',
    name = 'nord',
    -- config = function()
    --   vim.cmd.colorscheme 'nord'
    -- end,
  },

  -- Nightfox
  {
    'EdenEast/nightfox.nvim',
    name = 'nightfox',
    -- config = function()
    --   vim.cmd.colorscheme 'nightfox'
    -- end,
  },

  -- GitHub Theme
  {
    'projekt0n/github-nvim-theme',
    name = 'github-theme',
    -- config = function()
    --   -- Some variants are available (e.g. github_dark, github_light)
    --   vim.cmd.colorscheme 'github_dark_default'
    -- end,
  },

  -- One Dark Pro
  {
    'navarasu/onedark.nvim',
    name = 'onedark',
    -- config = function()
    --   require('onedark').setup {
    --     style = 'dark', -- You can choose: "dark", "darker", "cool", "deep", "warm", "warmer"
    --   }
    --   require('onedark').load()
    -- end,
  },
  {
    'metalelf0/black-metal-theme-neovim',
    lazy = false,
    priority = 1000,
    config = function()
      require('black-metal').setup {
        theme = 'gorgoroth',
      }
      require('black-metal').load()
    end,
  },
}
