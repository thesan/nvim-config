--
-- https://github.com/esmuellert/codediff.nvim
--
return {
  'esmuellert/codediff.nvim',
  cmd = 'CodeDiff',
  keys = {
    { '<leader>gs', '<cmd>CodeDiff<cr>', desc = '[G]it [S]tatus' },
  },
  opts = {
    diff = {
      layout = 'inline',
    },
    explorer = {
      view_mode = 'tree',
    },
    keymaps = {
      view = {
        focus_explorer = '<leader>gs',
      },
    },
  },
  config = function(_, opts)
    require('codediff').setup(opts)

    -- Bypass CodeDiff's three-way merge editor for conflicts. Show the real
    -- working-tree file unchanged, including its conflict markers.
    local view = require 'codediff.ui.view'
    if view._raw_conflict_workaround then
      return
    end
    view._raw_conflict_workaround = true

    local update = view.update

    view.update = function(tabpage, session_config, ...)
      if session_config and session_config.conflict then
        local path = vim.fs.joinpath(session_config.git_root, session_config.modified_path)
        require('codediff.ui.view.inline_view').show_single_file(tabpage, path, { side = 'modified' })
        return true
      end

      return update(tabpage, session_config, ...)
    end
  end,
}
