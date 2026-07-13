--
-- https://github.com/NeogitOrg/neogit
--
return {
  'NeogitOrg/neogit',
  -- url = 'https://github.com/thesan/neogit.git',
  dir = '~/Projects/devenv/neogit',
  dev = true,

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
      -- graph_style = 'kitty',
      graph_style = 'ascii',
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

    local toggle_diff1_layout = function()
      local diffview_lib = require 'diffview.lib'
      local DiffView = require('diffview.scene.views.diff.diff_view').DiffView
      local Diff1 = require('diffview.scene.layouts.diff_1').Diff1

      local view = diffview_lib.get_current_view()
      if not view or not view:instanceof(DiffView) or not view.cur_entry then
        return
      end

      if view.cur_entry.kind == 'conflicting' then
        actions.cycle_layout()
        return
      end

      local target_layout = view.cur_layout:instanceof(Diff1) and DiffView.get_default_layout() or Diff1
      local cur_file = view.cur_entry
      local main = view.cur_layout:get_main_win()
      local ok, pos = pcall(vim.api.nvim_win_get_cursor, main.id)
      local was_focused = view.cur_layout:is_focused()

      for _, entry in ipairs(view.panel:ordered_file_list()) do
        if entry.kind ~= 'conflicting' then
          entry:convert_layout(target_layout)
        end
      end

      cur_file.layout.emitter:once('files_opened', function()
        main = view.cur_layout:get_main_win()
        if ok then
          pcall(vim.api.nvim_win_set_cursor, main.id, pos)
        end

        if was_focused then
          main:focus()
        else
          view.cur_layout:sync_scroll()
        end
      end)

      view:set_file(cur_file, false)
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
          ['<C-a>'] = toggle_diff1_layout,
          ['<C-s>'] = reset_layout,
          ['<C-r>'] = 'RefreshBuffer',
        },
        popup = {
          ['<C-r>'] = 'RefreshBuffer',
          ['<Esc>'] = false, -- Disable the escape key
        },
        file_panel = {
          ['q'] = diffview.close, -- Close the diffview window
          ['<C-n>'] = actions.select_next_entry, -- Move to the next file in the diff view
          ['<C-p>'] = actions.select_prev_entry, -- Move to the previous file in the diff view
          -- ['gf'] = goto_file_edit,
          ['<C-a>'] = toggle_diff1_layout,
          ['<C-s>'] = reset_layout,
        },
      },
    }

    vim.keymap.set('n', '<Leader>gg', neogit.open, { desc = 'Neo[G]it' })
    -- vim.keymap.set('n', '<Leader>gl', function()
    --   neogit.open { 'log' }
    -- end, { desc = 'Neo[G]it [L]og' })
    vim.keymap.set('n', '<Leader>gc', function()
      neogit.open { 'commit' }
    end, { desc = 'Neo[G]it [C]ommit' })
    vim.keymap.set('n', '<Leader>gs', diffview.open, { desc = '[G]it [S]tatus' })
  end,
}
