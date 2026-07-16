--
-- https://github.com/lionyxml/gitlineage.nvim
--
return {
  'lionyxml/gitlineage.nvim',
  cmd = 'GitLineage',
  keys = {
    { '<leader>gb', '<cmd>GitLineage<cr>', desc = '[G]it [B]lame (lineage)' },
    {
      '<leader>gb',
      ':GitLineage<cr>',
      mode = 'x',
      desc = '[G]it [B]lame selection (lineage)',
    },
  },
  opts = {
    keymap = false,
    keys = {
      open_diff = false,
    },
  },
  config = function(_, opts)
    require('gitlineage').setup(opts)

    local group = vim.api.nvim_create_augroup('GitLineageCodeDiff', { clear = true })
    vim.api.nvim_create_autocmd('BufWinEnter', {
      group = group,
      pattern = 'gitlineage://*',
      callback = function(args)
        vim.keymap.set('n', '<CR>', function()
          local revision = vim.api.nvim_get_current_line():match '^commit (%x+)'
          if not revision then
            vim.notify('gitlineage: not on a commit line', vim.log.levels.WARN)
            return
          end

          require('custom.integrations.codediff').open_commit(revision)
        end, { buffer = args.buf, silent = true, desc = 'Open commit in CodeDiff' })
      end,
    })
  end,
}
