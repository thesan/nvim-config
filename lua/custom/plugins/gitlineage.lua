--
-- https://github.com/lionyxml/gitlineage.nvim
--
return {
  'lionyxml/gitlineage.nvim',
  dependencies = { 'sindrets/diffview.nvim' },
  cmd = 'GitLineage',
  keys = {
    { '<leader>gb', '<cmd>GitLineage<cr>', desc = '[G]it [B]lame (lineage)' },
  },
  opts = {
    keymap = false,
  },
}
