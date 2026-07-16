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
}
