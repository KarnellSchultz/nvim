return {
  -- ═══════════════════════════════════════════════════════════════════════════
  -- GRUVBOX - Retro groove color scheme
  -- ═══════════════════════════════════════════════════════════════════════════
  {
    'ellisonleao/gruvbox.nvim',
    name = 'gruvbox',
    opts = {
      terminal_colors = true,
      undercurl = true,
      underline = true,
      bold = true,
      italic = {
        strings = true,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
      },
      strikethrough = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      invert_intend_guides = false,
      inverse = true,
      contrast = '', -- Options: 'hard', 'soft', or '' (medium)
      palette_overrides = {},
      overrides = {},
      dim_inactive = false,
      transparent_mode = false,
    },
    -- config = function()
    --   require('gruvbox').setup()
    --   vim.cmd.colorscheme 'gruvbox'
    -- end,
  },

  -- ═══════════════════════════════════════════════════════════════════════════
  -- ROSE PINE - All natural pine, faux fur, and a bit of soho vibes
  -- ═══════════════════════════════════════════════════════════════════════════
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    opts = {
      variant = 'main', -- Options: 'auto', 'main', 'moon', 'dawn'
      dark_variant = 'main',
      dim_inactive_windows = false,
      extend_background_behind_borders = true,
      enable = {
        terminal = true,
        legacy_highlights = true,
        migrations = true,
      },
      styles = {
        bold = true,
        italic = true,
        transparency = false,
      },
    },
    -- config = function()
    --   require('rose-pine').setup()
    --   vim.cmd.colorscheme 'rose-pine'
    --   -- Other variants: 'rose-pine-main', 'rose-pine-moon', 'rose-pine-dawn'
    -- end,
  },

  -- ═══════════════════════════════════════════════════════════════════════════
  -- CATPPUCCIN - Soothing pastel theme (4 flavors)
  -- ═══════════════════════════════════════════════════════════════════════════
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    opts = {
      flavour = 'mocha', -- Options: 'latte', 'frappe', 'macchiato', 'mocha'
      background = {
        light = 'latte',
        dark = 'mocha',
      },
      transparent_background = false,
      show_end_of_buffer = false,
      term_colors = false,
      dim_inactive = {
        enabled = false,
        shade = 'dark',
        percentage = 0.15,
      },
      no_italic = false,
      no_bold = false,
      no_underline = false,
      styles = {
        comments = { 'italic' },
        conditionals = { 'italic' },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        telescope = {
          enabled = true,
        },
        mason = true,
        which_key = true,
      },
    },
    -- config = function()
    --   require('catppuccin').setup()
    --   vim.cmd.colorscheme 'catppuccin-mocha'
    --   -- Other flavors: 'catppuccin-latte', 'catppuccin-frappe', 'catppuccin-macchiato'
    -- end,
  },

  -- ═══════════════════════════════════════════════════════════════════════════
  -- TOKYO NIGHT - A clean, dark theme (4 variants)
  -- ═══════════════════════════════════════════════════════════════════════════
  {
    'folke/tokyonight.nvim',
    name = 'tokyonight',
    opts = {
      style = 'night', -- Options: 'storm', 'moon', 'night', 'day'
      light_style = 'day',
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = 'dark',
        floats = 'dark',
      },
      sidebars = { 'qf', 'help' },
      day_brightness = 0.3,
      hide_inactive_statusline = false,
      dim_inactive = false,
      lualine_bold = false,
    },
    -- config = function()
    --   require('tokyonight').setup()
    --   vim.cmd.colorscheme 'tokyonight'
    --   -- Other variants: 'tokyonight-night', 'tokyonight-storm', 'tokyonight-day', 'tokyonight-moon'
    -- end,
  },

  -- ═══════════════════════════════════════════════════════════════════════════
  -- DRACULA - Dark theme with vibrant colors
  -- ═══════════════════════════════════════════════════════════════════════════
  {
    'Mofiqul/dracula.nvim',
    name = 'dracula',
    opts = {
      colors = {},
      show_end_of_buffer = true,
      transparent_bg = false,
      lualine_bg_color = '#44475a',
      italic_comment = true,
      overrides = {},
    },
    -- config = function()
    --   require('dracula').setup()
    --   vim.cmd.colorscheme 'dracula'
    --   -- Soft variant available: 'dracula-soft'
    -- end,
  },

  -- ═══════════════════════════════════════════════════════════════════════════
  -- NORD - Arctic, north-bluish color palette
  -- ═══════════════════════════════════════════════════════════════════════════
  {
    'shaunsingh/nord.nvim',
    name = 'nord',
    -- config = function()
    --   vim.g.nord_contrast = true
    --   vim.g.nord_borders = false
    --   vim.g.nord_disable_background = false
    --   vim.g.nord_italic = false
    --   vim.g.nord_uniform_diff_background = true
    --   vim.g.nord_bold = false
    --   require('nord').set()
    --   vim.cmd.colorscheme 'nord'
    -- end,
  },

  -- ═══════════════════════════════════════════════════════════════════════════
  -- NIGHTFOX - Highly customizable theme (7 variants)
  -- ═══════════════════════════════════════════════════════════════════════════
  {
    'EdenEast/nightfox.nvim',
    name = 'nightfox',
    opts = {
      options = {
        compile_path = vim.fn.stdpath 'cache' .. '/nightfox',
        compile_file_suffix = '_compiled',
        transparent = false,
        terminal_colors = true,
        dim_inactive = false,
        module_default = true,
        colorblind = {
          enable = false,
          simulate_only = false,
          severity = {
            protan = 0,
            deutan = 0,
            tritan = 0,
          },
        },
        styles = {
          comments = 'italic',
          conditionals = 'NONE',
          constants = 'NONE',
          functions = 'NONE',
          keywords = 'NONE',
          numbers = 'NONE',
          operators = 'NONE',
          strings = 'NONE',
          types = 'NONE',
          variables = 'NONE',
        },
        inverse = {
          match_paren = false,
          visual = false,
          search = false,
        },
      },
    },
    -- config = function()
    --   require('nightfox').setup()
    --   vim.cmd.colorscheme 'nightfox'
    --   -- Variants: 'nightfox', 'dawnfox', 'dayfox', 'duskfox', 'nordfox', 'terafox', 'carbonfox'
    -- end,
  },

  -- ═══════════════════════════════════════════════════════════════════════════
  -- GITHUB THEME - GitHub's VS Code themes
  -- ═══════════════════════════════════════════════════════════════════════════
  {
    'projekt0n/github-nvim-theme',
    name = 'github-theme',
    opts = {
      options = {
        compile_path = vim.fn.stdpath 'cache' .. '/github-theme',
        compile_file_suffix = '_compiled',
        hide_end_of_buffer = true,
        hide_nc_statusline = true,
        transparent = false,
        terminal_colors = true,
        dim_inactive = false,
        module_default = true,
        styles = {
          comments = 'italic',
          functions = 'NONE',
          keywords = 'NONE',
          variables = 'NONE',
          conditionals = 'NONE',
          constants = 'NONE',
          numbers = 'NONE',
          operators = 'NONE',
          strings = 'NONE',
          types = 'NONE',
        },
        inverse = {
          match_paren = false,
          visual = false,
          search = false,
        },
      },
    },
    -- config = function()
    --   require('github-theme').setup()
    --   vim.cmd.colorscheme 'github_dark_default'
    --   -- Variants: 'github_dark', 'github_dark_default', 'github_dark_dimmed',
    --   -- 'github_light', 'github_light_default', 'github_light_high_contrast'
    -- end,
  },

  -- ═══════════════════════════════════════════════════════════════════════════
  -- ONE DARK PRO - Atom's iconic One Dark theme (6 styles)
  -- ═══════════════════════════════════════════════════════════════════════════
  {
    'navarasu/onedark.nvim',
    name = 'onedark',
    opts = {
      style = 'dark', -- Options: 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer'
      transparent = false,
      term_colors = true,
      ending_tildes = false,
      cmp_itemkind_reverse = false,
      toggle_style_key = nil,
      toggle_style_list = { 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' },
      code_style = {
        comments = 'italic',
        keywords = 'none',
        functions = 'none',
        strings = 'none',
        variables = 'none',
      },
      lualine = {
        transparent = false,
      },
      colors = {},
      highlights = {},
      diagnostics = {
        darker = true,
        undercurl = true,
        background = true,
      },
    },
    -- config = function()
    --   require('onedark').setup()
    --   require('onedark').load()
    --   -- Tip: You can toggle styles with the toggle_style_key if you set it
    -- end,
  },

  -- ═══════════════════════════════════════════════════════════════════════════
  -- BLACK METAL - Dark themes inspired by black metal bands
  -- ═══════════════════════════════════════════════════════════════════════════
  {
    'metalelf0/black-metal-theme-neovim',
    name = 'black-metal',
    opts = {
      theme = 'gorgoroth', -- Options: 'bathory', 'burzum', 'dark-funeral', 'gorgoroth',
      -- 'immortal', 'khold', 'marduk', 'mayhem', 'nile', 'venom'
    },
    -- config = function()
    --   require('black-metal').setup {
    --     theme = 'gorgoroth',
    --   }
    --   require('black-metal').load()
    -- end,
  },

  -- ═══════════════════════════════════════════════════════════════════════════
  -- CURSOR DARK - Dark theme with multiple variants
  -- ═══════════════════════════════════════════════════════════════════════════
  {
    'ydkulks/cursor-dark.nvim',
    name = 'cursor-dark',
    opts = {},
    -- config = function()
    --   require('cursor-dark').setup {}
    --   vim.cmd.colorscheme 'cursor-dark-midnight'
    --   -- Variants: 'cursor-dark-midnight', 'cursor-dark-twilight'
    -- end,
  },

  -- ═══════════════════════════════════════════════════════════════════════════
  -- OSCURA - Dark theme with excellent contrast ⭐ CURRENTLY ACTIVE
  -- ═══════════════════════════════════════════════════════════════════════════
  {
    'jwbaldwin/oscura.nvim',
    lazy = false, -- Load immediately on startup
    priority = 1000, -- Load before other plugins
    opts = {
      theme = 'oscura',
    },
    config = function()
      require('oscura').setup {
        theme = 'oscura',
      }
      require('oscura').load()
    end,
  },

  -- ═══════════════════════════════════════════════════════════════════════════
  -- VESPER - Soft, muted dark theme
  -- ═══════════════════════════════════════════════════════════════════════════
  {
    'datsfilipe/vesper.nvim',
    name = 'vesper',
    -- config = function()
    --   vim.cmd.colorscheme 'vesper'
    -- end,
  },

  -- ═══════════════════════════════════════════════════════════════════════════
  -- KANAGAWA - Dark theme inspired by famous paintings (3 variants)
  -- ═══════════════════════════════════════════════════════════════════════════
  {
    'rebelot/kanagawa.nvim',
    name = 'kanagawa',
    opts = {
      compile = false,
      undercurl = true,
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = false,
      dimInactive = false,
      terminalColors = true,
      colors = {
        palette = {},
        theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
      },
      overrides = function(colors) return {} end,
      theme = 'wave', -- Options: 'wave', 'dragon', 'lotus'
      background = {
        dark = 'wave',
        light = 'lotus',
      },
    },
    -- config = function()
    --   require('kanagawa').setup()
    --   vim.cmd.colorscheme 'kanagawa'
    --   -- Variants: 'kanagawa', 'kanagawa-wave', 'kanagawa-dragon', 'kanagawa-lotus'
    -- end,
  },

  -- ═══════════════════════════════════════════════════════════════════════════
  -- EVERFOREST - Green-based warm theme (Excellent Light Theme) ⭐
  -- ═══════════════════════════════════════════════════════════════════════════
  {
    'sainnhe/everforest',
    name = 'everforest',
    -- config = function()
    --   -- Background options: 'hard', 'medium' (default), 'soft'
    --   vim.g.everforest_background = 'medium'
    --
    --   -- Enable/disable italic for comments and keywords
    --   vim.g.everforest_enable_italic = 1
    --
    --   -- Disable italic for comments only
    --   vim.g.everforest_disable_italic_comment = 0
    --
    --   -- Control diagnostic text highlighting style
    --   vim.g.everforest_diagnostic_text_highlight = 0
    --
    --   -- Control diagnostic line highlighting
    --   vim.g.everforest_diagnostic_line_highlight = 0
    --
    --   -- Control diagnostic virtual text style (0: grey, 1: colored)
    --   vim.g.everforest_diagnostic_virtual_text = 'grey'
    --
    --   -- Disable terminal colors
    --   vim.g.everforest_disable_terminal_colors = 0
    --
    --   -- Current word highlighting (0: disabled, 1: grey bg, 2: bold)
    --   vim.g.everforest_current_word = 'grey background'
    --
    --   -- Transparent background (0: disabled, 1: enabled, 2: all)
    --   vim.g.everforest_transparent_background = 0
    --
    --   -- Better performance for large files
    --   vim.g.everforest_better_performance = 1
    --
    --   -- Sign column background (default matches background)
    --   vim.g.everforest_sign_column_background = 'none'
    --
    --   -- Spell check highlighting
    --   vim.g.everforest_spell_foreground = 'none'
    --
    --   -- UI related (sidebar, float)
    --   vim.g.everforest_ui_contrast = 'low' -- Options: 'low', 'high'
    --
    --   -- Dim inactive windows
    --   vim.g.everforest_dim_inactive_windows = 0
    --
    --   -- Show visual bell
    --   vim.g.everforest_show_eob = 1
    --
    --   -- Cursor line/column
    --   vim.g.everforest_cursor = 'auto'
    --
    --   -- Lightline/Airline theme
    --   vim.g.everforest_lightline_disable_bold = 0
    --
    --   -- Set background to light for light variant
    --   vim.o.background = 'light'  -- Use 'dark' for dark variant
    --
    --   vim.cmd.colorscheme 'everforest'
    -- end,
  },

  -- ═══════════════════════════════════════════════════════════════════════════
  -- EDGE - Clean & elegant theme (Excellent Light Theme) ⭐
  -- ═══════════════════════════════════════════════════════════════════════════
  {
    'sainnhe/edge',
    name = 'edge',
    -- config = function()
    --   -- Style options: 'default', 'aura', 'neon' (dark variants only)
    --   vim.g.edge_style = 'default'
    --
    --   -- Dim inactive windows
    --   vim.g.edge_dim_inactive_windows = 0
    --
    --   -- Disable italic
    --   vim.g.edge_disable_italic_comment = 0
    --
    --   -- Enable italic
    --   vim.g.edge_enable_italic = 1
    --
    --   -- Cursor line
    --   vim.g.edge_cursor = 'auto'
    --
    --   -- Menu selection
    --   vim.g.edge_menu_selection_background = 'blue' -- Options: 'blue', 'green', 'purple'
    --
    --   -- Transparent background (0: disabled, 1: enabled, 2: all)
    --   vim.g.edge_transparent_background = 0
    --
    --   -- Show end-of-buffer tildes
    --   vim.g.edge_show_eob = 1
    --
    --   -- Better performance
    --   vim.g.edge_better_performance = 1
    --
    --   -- Diagnostic display
    --   vim.g.edge_diagnostic_text_highlight = 0
    --   vim.g.edge_diagnostic_line_highlight = 0
    --   vim.g.edge_diagnostic_virtual_text = 'grey'
    --
    --   -- Current word highlighting
    --   vim.g.edge_current_word = 'grey background'
    --
    --   -- Disable terminal colors
    --   vim.g.edge_disable_terminal_colors = 0
    --
    --   -- Lightline/Airline theme
    --   vim.g.edge_lightline_disable_bold = 0
    --
    --   -- Sign column background
    --   vim.g.edge_sign_column_background = 'none'
    --
    --   -- Spell foreground
    --   vim.g.edge_spell_foreground = 'none'
    --
    --   -- Set background to light for light variant
    --   vim.o.background = 'light'  -- Use 'dark' for dark variant
    --
    --   vim.cmd.colorscheme 'edge'
    -- end,
  },

  -- ═══════════════════════════════════════════════════════════════════════════
  -- SOLARIZED OSAKA - Modern Solarized reimplementation ⭐
  -- ═══════════════════════════════════════════════════════════════════════════
  {
    'craftzdog/solarized-osaka.nvim',
    name = 'solarized-osaka',
    opts = {
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = 'dark',
        floats = 'dark',
      },
      sidebars = { 'qf', 'help', 'terminal' },
      day_brightness = 0.3,
      hide_inactive_statusline = false,
      dim_inactive = false,
      lualine_bold = false,

      --- You can override specific color groups to use other groups or a hex color
      --- function will be called with a ColorScheme table
      on_colors = function(colors) end,

      --- You can override specific highlights to use other groups or a hex color
      --- function will be called with a Highlights and ColorScheme table
      on_highlights = function(highlights, colors) end,
    },
    -- config = function()
    --   require('solarized-osaka').setup()
    --   vim.cmd.colorscheme 'solarized-osaka'
    --   -- For light variant, set: vim.o.background = 'light' before colorscheme command
    --   -- Or use: vim.cmd.colorscheme 'solarized-osaka-light'
    -- end,
  },
}
