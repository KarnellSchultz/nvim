-- telescope.nvim
return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    -- branch = "0.1.x",
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        config = function()
          require('telescope').load_extension 'fzf'
        end,
      },
    },
    config = function()
      require('telescope').setup {
        defaults = {

          border = {
            prompt = { 1, 1, 1, 1 },
            results = { 1, 1, 1, 1 },
            preview = { 1, 1, 1, 1 },
          },
          borderchars = {
            prompt = { ' ', ' ', '─', '│', '│', ' ', '─', '└' },
            results = { '─', ' ', ' ', '│', '┌', '─', ' ', '│' },
            preview = { '─', '│', '─', '│', '┬', '┐', '┘', '┴' },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = 'smart_case',
          },
        },
        pickers = {
          colorscheme = {
            enable_preview = true,
          },
          find_files = {
            hidden = true,
            find_command = {
              'rg',
              '--files',
              '--glob',
              '!{.git/*,.next/*,.svelte-kit/*,target/*,node_modules/*}',
              '--path-separator',
              '/',
            },
          },
        },
      }

      require('telescope').load_extension 'fzf'
      require('telescope').load_extension 'zoxide'
      -- telescope setup

      local builtin = require 'telescope.builtin'

      -- vim.keymap.set(
      --   'n',
      --   '<leader>sf',
      --   "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>",
      --   {}
      -- )
      -- vim.keymap.set('n', '<leader>ws', builtin.lsp_workspace_symbols, {})
      vim.keymap.set('n', '<leader>sz', ':Telescope zoxide list<CR>', {})

      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>sc', builtin.git_files, { desc = '[S]earch [C]ode' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>st', builtin.colorscheme, { desc = '[S]earch [T]heme' })
    end,
  },
  {
    'jvgrootveld/telescope-zoxide',
    config = function() end,
  },
  {
    'nvim-telescope/telescope-ui-select.nvim',
    config = function()
      require('telescope').setup {
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown {},
          },
        },
      }
      -- To get ui-select loaded and working with telescope, you need to call
      -- load_extension, somewhere after setup function:
      require('telescope').load_extension 'ui-select'
    end,
  },
}
