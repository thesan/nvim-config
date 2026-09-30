vim.api.nvim_create_user_command('CopyRelPath', "call setreg('+', expand('%:.'))", {})
vim.api.nvim_create_user_command('CopyHomePath', "call setreg('+', expand('%:p:~'))", {})
vim.api.nvim_create_user_command('W', 'write', {})

vim.api.nvim_create_user_command('OpenDir', function()
  local dir = vim.fn.expand '%:h'
  if dir == '' then
    dir = vim.fn.getcwd()
  end
  vim.fn.jobstart({ 'open', dir }, { detach = true })
end, { desc = 'Open current file directory' })
