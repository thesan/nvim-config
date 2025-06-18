-- return {
--   'github/copilot.vim',
--   config = function()
--     -- vim.g.copilot_filetypes = {
--     --   ['*'] = false,  -- Disable for all file types by default
--     --   ['javascript'] = true,
--     --   ['typescript'] = true,
--     --   ['python'] = true,
--     --   ['lua'] = true,
--     --   ['html'] = true,
--     --   ['css'] = true,
--     -- }
--     -- vim.g.copilot_no_tab_map = true  -- Disable default tab mapping
--     vim.keymap.set('i', '<C-e>', 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false })
--     vim.keymap.set('i', '<M-f>', '<Plug>(copilot-accept-word)')
--     vim.keymap.set('i', '<M-j>', 'copilot#Next()', { expr = true, silent = true })
--     vim.keymap.set('i', '<M-k>', 'copilot#Previous()', { expr = true, silent = true })
--   end,
-- }

return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  build = ':Copilot auth',
  event = 'BufReadPost',
  config = function()
    require('copilot').setup {
      suggestion = {
        enabled = not vim.g.ai_cmp,
        auto_trigger = true,
        hide_during_completion = vim.g.ai_cmp,
        keymap = {
          accept = false, -- handled by nvim-cmp / blink.cmp
          next = '<M-]>',
          prev = '<M-[>',
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    }

    local suggestion = require 'copilot.suggestion'
    vim.keymap.set('i', '<C-e>', suggestion.accept, { expr = true, replace_keycodes = false })
    vim.keymap.set('i', '<M-f>', suggestion.accept_word, { silent = true })
    -- vim.keymap.set('i', '<M-j>', 'copilot#Next()', { expr = true, silent = true })
    -- vim.keymap.set('i', '<M-k>', 'copilot#Previous()', { expr = true, silent = true })
  end,
}
