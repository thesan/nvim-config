--
-- https://github.com/NeogitOrg/neogit
--
return {
  'NeogitOrg/neogit',
  dependencies = {
    'nvim-lua/plenary.nvim', -- required
    'sindrets/diffview.nvim', -- optional - Diff integration
    'nvim-tree/nvim-web-devicons', -- optional - Icons for sindrets/diffview.nvim

    -- Only one of these is needed.
    'nvim-telescope/telescope.nvim', -- optional
    -- "ibhagwan/fzf-lua",              -- optional
    -- "echasnovski/mini.pick",         -- optional
    -- "folke/snacks.nvim",             -- optional
  },
  config = function()
    local neogit = require 'neogit'

    neogit.setup {
      -- "ascii"   is the graph the git CLI generates
      -- "unicode" is the graph like https://github.com/rbong/vim-flog
      -- "kitty"   is the graph like https://github.com/isakbm/gitgraph.nvim - use https://github.com/rbong/flog-symbols if you don't use Kitty
      graph_style = 'unicode',
    }

    local diffview = require 'diffview'
    local actions = require 'diffview.actions'

    local goto_file_edit = function()
      -- This function is used to open the file in the editor.
      -- It will close the diffview window after opening the file.
      actions.goto_file_edit()
      vim.cmd 'tabnext' -- Switch to the next tab
      vim.cmd 'tabclose' -- Close the diffview tab
    end

    local set_1col_layout = function()
      -- Go to the first split (the leftmost one)
      vim.cmd 'wincmd h'
      vim.cmd 'wincmd h'

      vim.cmd 'wincmd l' -- Go to the second split
      vim.cmd 'vertical resize 7' -- Set its width to few characters

      vim.cmd 'wincmd l' -- Go to the last split
    end

    local reset_layout = function()
      actions.toggle_files()
      actions.toggle_files()
    end

    diffview.setup {
      enhanced_diff_hl = true,
      view = {
        -- Configure the layout and behavior of different types of views.
        -- Available layouts:
        --  'diff1_plain'
        --    |'diff2_horizontal'
        --    |'diff2_vertical'
        --    |'diff3_horizontal'
        --    |'diff3_vertical'
        --    |'diff3_mixed'
        --    |'diff4_mixed'
        -- For more info, see |diffview-config-view.x.layout|.
        default = {
          -- Config for changed files, and staged files in diff views.
          layout = 'diff2_horizontal',
          disable_diagnostics = true, -- Temporarily disable diagnostics for diff buffers while in the view.
          winbar_info = false, -- See |diffview-config-view.x.winbar_info|
        },
      },
      keymaps = {
        view = {
          ['q'] = diffview.close, -- Close the diffview window
          ['<C-n>'] = actions.select_next_entry, -- Move to the next file in the diff view
          ['<C-p>'] = actions.select_prev_entry, -- Move to the previous file in the diff view
          -- ['gf'] = goto_file_edit,
          ['<C-a>'] = set_1col_layout,
          ['<C-s>'] = reset_layout,
        },
        file_panel = {
          ['q'] = diffview.close, -- Close the diffview window
          ['<C-n>'] = actions.select_next_entry, -- Move to the next file in the diff view
          ['<C-p>'] = actions.select_prev_entry, -- Move to the previous file in the diff view
          -- ['gf'] = goto_file_edit,
          ['<C-a>'] = set_1col_layout,
          ['<C-s>'] = reset_layout,
        },
      },
    }

    vim.keymap.set('n', '<Leader>gg', neogit.open, { desc = 'Neo[G]it' })
    vim.keymap.set('n', '<Leader>gl', function()
      neogit.open { 'log' }
    end, { desc = 'Neo[G]it [L]og' })
    vim.keymap.set('n', '<Leader>gc', function()
      neogit.open { 'commit' }
    end, { desc = 'Neo[G]it [C]ommit' })
    vim.keymap.set('n', '<Leader>gs', diffview.open, { desc = '[G]it [S]tatus' })
  end,
}
