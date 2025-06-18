-- NOTE: Plugins can specify dependencies.
--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin

return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        pickers = {
          find_files = { theme = 'ivy' },
          live_grep = { theme = 'ivy' },
          buffers = { theme = 'ivy' },
          help_tags = { theme = 'ivy' },
        },
        defaults = {
          initial_mode = 'normal', -- start in normal mode
          layout_config = {
            scroll_speed = 3, -- set scroll_speed for C-u C-d
          },
          mappings = {
            n = {
              ['gh'] = 'which_key',
              ['<C-\\>'] = require('telescope.actions.layout').toggle_preview,
              ['dd'] = require('telescope.actions').delete_buffer,
              ['q'] = require('telescope.actions').close,

              -- https://github.com/linkarzu/dotfiles-latest/blob/d227281efac6be04e4ef0c691b5d3f8444101cbf/neovim/neobean/lua/plugins/telescope.lua
              ['J'] = require('telescope.actions').preview_scrolling_down,
              ['K'] = require('telescope.actions').preview_scrolling_up,
              ['H'] = require('telescope.actions').preview_scrolling_left,
              ['L'] = require('telescope.actions').preview_scrolling_right,

              -- These will scroll the RESULTS window
              ['<C-d>'] = require('telescope.actions').results_scrolling_down,
              ['<C-u>'] = require('telescope.actions').results_scrolling_up,
            },
            i = {
              ['<C-h>'] = 'which_key',
              ['<C-\\>'] = require('telescope.actions.layout').toggle_preview,
            },
          },
          preview = {
            hide_on_startup = true, -- hide previewer when picker starts
          },

          -- When I search for stuff in telescope, I want the path to be shown
          -- first, this helps in files that are very deep in the tree and I
          -- cannot see their name.
          -- Also notice the "reverse_directories" option which will show the
          -- closest dir right after the filename
          path_display = {
            filename_first = {
              reverse_directories = true,
            },
          },
        },

        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'

      -- this one doesn't work
      -- local search_current_selection = function()
      --   vim.cmd 'normal! "y'
      --   builtin.grep_string { search = vim.fn.input('Grep/ ', vim.fn.getreg '+') }
      -- end

      local search_current_word = function()
        builtin.grep_string { search = vim.fn.input('Grep/ ', vim.fn.expand '<cword>') }
      end

      local search_word = function()
        -- builtin.grep_string { search = vim.fn.input 'Grep/ ', theme = 'ivy' }
        -- local frecency = require('telescope').extensions.frecency
        builtin.grep_string(require('telescope.themes').get_ivy {
          workspace = 'CWD',
          search = vim.fn.input 'Grep/ ',
          use_regex = true,
          -- Frecency would be nice but it ignores files without a score
          -- search_dirs = frecency.query {},
          previewer = true,
        })
      end

      local file_frecency = function()
        require('telescope').extensions.frecency.frecency(require('telescope.themes').get_ivy {
          workspace = 'CWD',
        })
      end

      local search_files = function(options)
        return function()
          builtin.find_files(options)
        end
      end

      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })

      vim.keymap.set('n', '<leader>sf', file_frecency, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>sF', search_files { hidden = true, no_ignore = true, no_ignore_parent = true }, { desc = '[S]earch all [F]iles' })

      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })

      vim.keymap.set('n', '<leader>sw', search_current_word, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', search_word, { desc = '[S]earch by [G]rep' })

      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader>gS', builtin.git_status, { desc = '[G]it [S]earch [S]tatus' })

      -- Quick to access keys:
      vim.keymap.set('n', '<leader>p', file_frecency, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>/', search_word, { desc = '[S]earch by [G]rep' })
      -- vim.keymap.set('v', '<leader>/', search_current_selection, { desc = '[S]earch by [G]rep' })

      -- -- Slightly advanced example of overriding default behavior and theme
      -- vim.keymap.set('n', '<leader>/', function()
      --   -- You can pass additional configuration to Telescope to change the theme, layout, etc.
      --   builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      --     winblend = 10,
      --     previewer = false,
      --   })
      -- end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
