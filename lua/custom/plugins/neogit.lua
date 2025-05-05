return {
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim', -- optional - Diff integration
      'nvim-telescope/telescope.nvim', -- optional
    },
    config = function()
      local neogit = require 'neogit'

      neogit.setup {
        -- graph_style = 'kitty',
        graph_style = 'unicode',
      }

      vim.keymap.set('n', '<Leader>gs', neogit.open, { desc = 'NeoGit' })
      vim.keymap.set('n', '<Leader>gln', '<cmd>Neogit log<CR>', { desc = '[G]it [L]og [N]eogit' })
    end,
  },
}
