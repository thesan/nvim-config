--
-- https://github.com/rbong/vim-flog
--
-- Monkey-patch flog graph to hide merge branch lines in first-parent mode.
-- When --first-parent is active, git still reports all parents but only the
-- first parent's commits appear in the log.  Flog places the extra parents on
-- branches and immediately removes them as "missing", producing 3 extra lines
-- per merge commit.  This patch trims parents to just the first one when the
-- git command contains --first-parent, so flog treats every commit as
-- single-parent and draws a clean linear graph.
--
local function patch_flog_graph()
  local graph = require 'flog/graph'
  local orig = graph.get_graph
  graph.get_graph = function(
    instance_number,
    is_vim,
    is_nvim,
    enable_porcelain,
    start_token,
    enable_extended_chars,
    enable_extra_padding,
    enable_graph,
    default_collapsed,
    cmd,
    collapsed_commits
  )
    -- Detect --first-parent in the git command
    if cmd:find '%-%-first%-parent' then
      -- Wrap cmd to strip all but the first parent from the parent line.
      -- Flog's format outputs: hash\nparent1 parent2 ...\nrefs\nbody...
      -- We pipe through awk to keep only the first parent on parent lines.
      --
      -- The format flog uses alternates lines:
      --   line 1: start_token
      --   then per commit: hash, parents, refs, body lines..., start_token
      -- We use sed to replace parent lines (lines with multiple space-separated hashes)
      -- Actually, the simplest approach: use git's --format to only output first parent.
      -- But flog constructs its own format string, so we post-process instead.
      cmd = cmd
        .. " | awk '"
        .. 'BEGIN { state=0 } '
        .. '{ '
        .. '  if (state==0) { print; state=1 }' -- hash
        .. '  else if (state==1) { ' -- parents: keep only first
        .. '    split($0, a, " "); print a[1]; state=2 '
        .. '  }'
        .. '  else if (state==2) { print; state=3 }' -- refs
        .. '  else { ' -- body lines until start_token
        .. '    print; '
        .. '    if ($0 == "'
        .. start_token
        .. '") state=0 '
        .. '  }'
        .. "}'"
    end
    return orig(
      instance_number,
      is_vim,
      is_nvim,
      enable_porcelain,
      start_token,
      enable_extended_chars,
      enable_extra_padding,
      enable_graph,
      default_collapsed,
      cmd,
      collapsed_commits
    )
  end
end

return {
  'rbong/vim-flog',
  dependencies = { 'tpope/vim-fugitive' },
  cmd = { 'Flog', 'Flogsplit' },
  init = function()
    vim.g.flog_permanent_default_opts = { date = 'short', max_count = 1000 }
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'floggraph',
      callback = function()
        vim.keymap.set('n', '<CR>', function()
          local hash = vim.fn['flog#Format'] '%h'
          require('custom.integrations.codediff').open_commit(hash)
        end, { buffer = true, desc = 'Open commit in CodeDiff' })
      end,
    })
  end,
  config = function()
    patch_flog_graph()
  end,
  keys = {
    { '<leader>gl', '<cmd>Flog -date=short -no-graph -- --first-parent<cr>', desc = 'Flog - Git log (first-parent)' },
    { '<leader>gL', '<cmd>Flog -date=short -first-parent -all<cr>', desc = 'Flog - Git log (all but first-parent)' },
    { '<leader>gA', '<cmd>Flog -date=short -all<cr>', desc = 'Flog - Git log (All)' },
  },
}
