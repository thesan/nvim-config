return {
  'github/copilot.vim',
  config = function()
    -- vim.g.copilot_filetypes = {
    --   ['*'] = false,  -- Disable for all file types by default
    --   ['javascript'] = true,
    --   ['typescript'] = true,
    --   ['python'] = true,
    --   ['lua'] = true,
    --   ['html'] = true,
    --   ['css'] = true,
    -- }
    -- vim.g.copilot_no_tab_map = true  -- Disable default tab mapping
    vim.keymap.set('i', '<C-e>', 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false })
    vim.keymap.set('i', '<M-f>', '<Plug>(copilot-accept-word)')
    vim.keymap.set('i', '<M-j>', 'copilot#Next()', { expr = true, silent = true })
    vim.keymap.set('i', '<M-k>', 'copilot#Previous()', { expr = true, silent = true })
  end,
}
