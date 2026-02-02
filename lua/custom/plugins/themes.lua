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
    -- config = function()
    --   require('black-metal').setup {
    --     theme = 'gorgoroth',
    --   }
    --   require('black-metal').load()
    -- end,
  },
  {
    'ydkulks/cursor-dark.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      -- vim.cmd.colorscheme("cursor-dark-midnight")
      require('cursor-dark').setup {
        -- For theme
        style = 'dark-midnight',
        -- For a transparent background
        transparent = true,
        -- If you have dashboard-nvim plugin installed
        dashboard = true,
      }
    end,
  },
  {
    'jwbaldwin/oscura.nvim',
    lazy = false,
    priority = 1000,
    -- config = function()
    --   require('oscura').setup {
    --     theme = 'oscura',
    --   }
    --   require('oscura').load()
    -- end,
  },
}
