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
      local map = function(keys, args, desc)
        vim.keymap.set('n', keys, '<cmd>Tig' .. ' ' .. args .. ' <CR>', { desc = desc })
      end

      map('<Leader>gf', '--first-parent --all', 'ti[G] [F]irst parent')
      map('<Leader>ga', '--all', 'ti[G] [A]ll')
      map('<Leader>gr', '--first-parent --all --reflog', 'ti[G]it [R]eflog first parent')
      map('<Leader>gR', '--all --reflog', 'ti[G] [R]eflog all')
      map('<Leader>gl', '--first-parent', 'ti[G] [L]og first parent')
      map('<Leader>gL', '', 'ti[G] [L]og all')
      -- map('<Leader>gs', 'status --first-parent --all', '[G]it [S]tatus')

      map('<Leader>gg', '--first-parent --all', 'ti[G] default [G]raph')

      vim.keymap.set('n', '<Leader>gs', vim.cmd.TigStatus, { desc = '[G]it [S]tatus' })
      vim.keymap.set('n', '<Leader>gh', vim.cmd.TigOpenCurrentFile, { desc = '[G]it [H]istory' })
      vim.keymap.set('n', '<Leader>gb', vim.cmd.TigBlame, { desc = '[G]it [B]lame' })
      vim.keymap.set('n', '<Leader>gG', vim.cmd.TigGrep, { desc = 'TigGrep' })
      vim.keymap.set('n', '<Leader>gR', vim.cmd.TigGrepResume, { desc = 'TigGrepResume' })
    end,
  },
}
