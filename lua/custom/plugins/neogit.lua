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

    -- Only one of these is needed.
    'nvim-telescope/telescope.nvim', -- optional
    -- "ibhagwan/fzf-lua",              -- optional
    -- "echasnovski/mini.pick",         -- optional
    -- "folke/snacks.nvim",             -- optional
  },
  config = function()
    -- Neogit only exposes a Diffview integration slot. Supply a CodeDiff-backed
    -- adapter under that module name so its diff popup remains fully available.
    package.preload['neogit.integrations.diffview'] = function()
      return require 'custom.integrations.neogit-codediff'
    end

    local neogit = require 'neogit'

    neogit.setup {
      -- "ascii"   is the graph the git CLI generates
      -- "unicode" is the graph like https://github.com/rbong/vim-flog
      -- "kitty"   is the graph like https://github.com/isakbm/gitgraph.nvim - use https://github.com/rbong/flog-symbols if you don't use Kitty
      -- graph_style = 'kitty',
      graph_style = 'ascii',
      integrations = {
        diffview = true,
      },
    }

    vim.keymap.set('n', '<Leader>gg', neogit.open, { desc = 'Neo[G]it' })
    -- vim.keymap.set('n', '<Leader>gl', function()
    --   neogit.open { 'log' }
    -- end, { desc = 'Neo[G]it [L]og' })
    vim.keymap.set('n', '<Leader>gc', function()
      neogit.open { 'commit' }
    end, { desc = 'Neo[G]it [C]ommit' })
  end,
}
