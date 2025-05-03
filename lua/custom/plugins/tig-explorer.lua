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
      vim.keymap.set('n', '<Leader>gT', vim.cmd.TigOpenCurrentFile, { desc = 'TigOpenCurrentFile' })
      vim.keymap.set('n', '<Leader>gt', vim.cmd.TigOpenProjectRootDir, { desc = 'TigOpenProjectRootDir' })
      vim.keymap.set('n', '<Leader>gg', vim.cmd.TigGrep, { desc = 'TigGrep' })
      vim.keymap.set('n', '<Leader>gr', vim.cmd.TigGrepResume, { desc = 'TigGrepResume' })
      vim.keymap.set('n', '<Leader>gb', vim.cmd.TigBlame, { desc = 'TigBlame' })
    end,
  },
}
