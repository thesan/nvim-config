vim.keymap.set('n', '<leader>cc', function()
  vim.cmd 'terminal opencode -m github-copilot/gemini-3-flash-preview --agent="plan"'
end, { desc = 'OpenCode quick question' })

vim.keymap.set('n', '<leader>cp', function()
  vim.cmd 'terminal opencode -m github-copilot/claude-opus-4.6 --agent="plan"'
end, { desc = 'OpenCode plan' })
