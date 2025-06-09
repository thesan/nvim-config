return {
  'nvim-treesitter/nvim-treesitter-context',
  config = function()
    ts_context = require 'treesitter-context'
    ts_context.setup {
      multiline_threshold = 1,
      vim.keymap.set('n', '[C', function()
        ts_context.go_to_context(vim.v.count1)
      end, { silent = true, desc = 'Go to context' }),
    }
  end,
}
