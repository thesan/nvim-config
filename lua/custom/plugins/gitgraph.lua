--
-- https://github.com/isakbm/gitgraph.nvim
--
return {
  'isakbm/gitgraph.nvim',
  dir = '~/Projects/devenv/gitgraph.nvim',
  dev = true,
  opts = {
    git_cmd = 'git',
    symbols = {
      merge_commit = '',
      commit = '',
      merge_commit_end = '',
      commit_end = '',

      -- Advanced symbols
      GVER = '',
      GHOR = '',
      GCLD = '',
      GCRD = '╭',
      GCLU = '',
      GCRU = '',
      GLRU = '',
      GLRD = '',
      GLUD = '',
      GRUD = '',
      GFORKU = '',
      GFORKD = '',
      GRUDCD = '',
      GRUDCU = '',
      GLUDCD = '',
      GLUDCU = '',
      GLRDCL = '',
      GLRDCR = '',
      GLRUCL = '',
      GLRUCR = '',
    },
    format = {
      timestamp = '%H:%M:%S %d-%m-%Y',
      -- fields = { 'hash', 'timestamp', 'author', 'branch_name', 'tag' },
      fields = { 'hash', 'branch_name', 'tag', 'author', 'timestamp', 'message' },
    },
    hooks = {
      -- Check diff of a commit
      on_select_commit = function(commit)
        require('custom.integrations.codediff').open_commit(commit.hash)
      end,
      -- Check diff from commit a -> commit b
      on_select_range_commit = function(from, to)
        require('custom.integrations.codediff').open_commit_range(from.hash, to.hash)
      end,
    },
  },
  keys = {
    {
      '<leader>gh',
      function()
        -- require('gitgraph').draw({}, { all = false, max_count = 400, revision_range = 'HEAD' })
        require('gitgraph').draw({}, { all = false, max_count = 400, revision_range = 'HEAD --first-parent' })
      end,
      desc = 'GitGraph - Current Branch history',
    },
    {
      '<leader>gL',
      function()
        -- require('gitgraph').draw({}, { all = false, max_count = 400, revision_range = 'HEAD' })
        require('gitgraph').draw({}, { all = false, max_count = 400, revision_range = 'HEAD --first-parent' })
      end,
      desc = 'GitGraph - Current Branch history',
    },
    {
      '<leader>gl',
      function()
        require('gitgraph').draw({}, { all = true, max_count = 4000, revision_range = 'HEAD --first-parent' })
      end,
      desc = 'GitGraph - Full graph',
    },
    -- {
    --   '<leader>gLa',
    --   function()
    --     require('gitgraph').draw({}, { all = true, max_count = 400 })
    --   end,
    --   desc = 'GitGraph - Draw',
    -- },
    -- {
    --   '<leader>gLl',
    --   function()
    --     require('gitgraph').draw({}, { all = true, max_count = 400, revision_range = 'HEAD --first-parent' })
    --   end,
    --   desc = 'GitGraph - Draw',
    -- },
    {
      '<leader>gR',
      function()
        require('gitgraph').draw({}, { all = false, max_count = 400, revision_range = '--all --first-parent --reflog' })
      end,
      desc = 'GitGraph - With reflog',
    },
  },
}
