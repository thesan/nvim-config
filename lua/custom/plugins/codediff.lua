--
-- https://github.com/esmuellert/codediff.nvim
--
local function setup_raw_conflict_workaround()
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
end

local function setup_hunk_navigation_workaround()
  -- In inline mode CodeDiff chooses modified-side line numbers before it
  -- checks whether focus is in the explorer. It also returns before cross-file
  -- navigation for single-file previews such as additions and conflicts.
  local navigation = require 'codediff.ui.view.navigation'
  if navigation._hunk_navigation_workaround then
    return
  end
  navigation._hunk_navigation_workaround = true

  local lifecycle = require 'codediff.ui.lifecycle'
  local config = require 'codediff.config'

  local function focus_inline_view()
    local session = lifecycle.get_session(vim.api.nvim_get_current_tabpage())
    if not session or session.layout ~= 'inline' then
      return true
    end

    local current_buf = vim.api.nvim_get_current_buf()
    if current_buf == session.original_bufnr or current_buf == session.modified_bufnr or current_buf == session.result_bufnr then
      return true
    end

    if not session.modified_win or not vim.api.nvim_win_is_valid(session.modified_win) then
      return false
    end

    vim.api.nvim_set_current_win(session.modified_win)
    return true
  end

  local function wrap_hunk_navigation(hunk_name, file_name, landing)
    local navigate = navigation[hunk_name]
    navigation[hunk_name] = function(...)
      if not focus_inline_view() then
        return false
      end

      local tabpage = vim.api.nvim_get_current_tabpage()
      local session = lifecycle.get_session(tabpage)
      local changes = session and session.stored_diff_result and session.stored_diff_result.changes
      if config.options.diff.cycle_hunks_across_files and changes and #changes == 0 then
        if not lifecycle.get_explorer(tabpage) then
          return false
        end

        session.pending_cursor_landing = landing
        return navigation[file_name]()
      end

      return navigate(...)
    end
  end

  wrap_hunk_navigation('next_hunk', 'next_file', 'first')
  wrap_hunk_navigation('prev_hunk', 'prev_file', 'last')
end

local function setup_tsgo_semantic_tokens_workaround()
  -- CodeDiff sends virtual buffers to an attached LSP for semantic tokens.
  -- Its unnamed inline buffers have the URI "file://", which crashes tsgo
  -- while it tries to resolve a relative tsconfig.json.
  local semantic = require 'codediff.ui.semantic_tokens'
  if semantic._tsgo_guard then
    return
  end
  semantic._tsgo_guard = true

  local apply_semantic_tokens = semantic.apply_semantic_tokens
  semantic.apply_semantic_tokens = function(left_buf, right_buf)
    if #vim.lsp.get_clients { bufnr = right_buf, name = 'tsgo' } > 0 then
      return false
    end

    return apply_semantic_tokens(left_buf, right_buf)
  end
end

return {
  'esmuellert/codediff.nvim',
  cmd = 'CodeDiff',
  keys = {
    { '<leader>gs', '<cmd>CodeDiff<cr>', desc = '[G]it [S]tatus' },
  },
  opts = {
    diff = {
      layout = 'inline',
      cycle_hunks_across_files = true,
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
    setup_tsgo_semantic_tokens_workaround()
    setup_raw_conflict_workaround()
    setup_hunk_navigation_workaround()
  end,
}
