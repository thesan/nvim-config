--[[
  https://github.com/iberianpig/tig-explorer.vim

  e, <Ctrl-o>: edit on existing tab
  <Ctrl-t>   : edit on new tab
  <Ctrl-v>   : edit with vsplit window
  <Ctrl-s>   : edit with split window

  <ESC> o: open with commit on existing tab
  <ESC> t: open with commit on new tab
  <ESC> v: open with commit with vsplit window
  <ESC> s: open with commit with split window
--]]
return {
  {
    'iberianpig/tig-explorer.vim',
    dependencies = { 'rbgrouleff/bclose.vim' },
    config = function()
      -- vim.keymap.set('n', '<Leader>gs', vim.cmd.TigStatus, { desc = '[G]it [S]tatus' })
      vim.keymap.set('n', '<Leader>gh', vim.cmd.TigOpenCurrentFile, { desc = '[G]it [H]istory' })
      vim.keymap.set('n', '<Leader>gg', vim.cmd.TigGrep, { desc = 'TigGrep' })
      vim.keymap.set('n', '<Leader>gr', vim.cmd.TigGrepResume, { desc = 'TigGrepResume' })
      vim.keymap.set('n', '<Leader>gb', vim.cmd.TigBlame, { desc = '[G]it [B]lame' })

      -- Log graphs
      vim.keymap.set('n', '<Leader>glc', '<cmd>Tig --first-parent<CR>', { desc = '[G]it [L]og [C]urrent' })
      vim.keymap.set('n', '<Leader>gla', '<cmd>Tig --first-parent --all<CR>', { desc = '[G]it [L]og [A]ll' })
      vim.keymap.set('n', '<Leader>glr', '<cmd>Tig --first-parent --all --reflog<CR>', { desc = '[G]it [L]og [R]eflog' })
    end,
  },
}
