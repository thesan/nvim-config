-- Indent guides for Neovim
-- https://github.com/lukas-reineke/indent-blankline.nvim
return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  dependencies = { 'HiPhish/rainbow-delimiters.nvim' },
  config = function()
    local highlight = {
      'RainbowDelimiterRed',
      'RainbowDelimiterBlue',
      'RainbowDelimiterYellow',
      'RainbowDelimiterOrange',
      'RainbowDelimiterGreen',
      'RainbowDelimiterViolet',
      'RainbowDelimiterCyan',
    }
    local hooks = require 'ibl.hooks'
    -- create the highlight groups in the highlight setup hook, so they are reset
    -- every time the colorscheme changes
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, 'RainbowDelimiterRed', { fg = '#af0000' })
      vim.api.nvim_set_hl(0, 'RainbowDelimiterGreen', { fg = '#008700' })
      vim.api.nvim_set_hl(0, 'RainbowDelimiterYellow', { fg = '#ffaf00' })
      vim.api.nvim_set_hl(0, 'RainbowDelimiterBlue', { fg = '#005faf' })
      vim.api.nvim_set_hl(0, 'RainbowDelimiterOrange', { fg = '#d75f00' })
      vim.api.nvim_set_hl(0, 'RainbowDelimiterViolet', { fg = '#8700af' })
      vim.api.nvim_set_hl(0, 'RainbowDelimiterCyan', { fg = '#56B6C2' })
    end)

    vim.g.rainbow_delimiters = { highlight = highlight }
    require('ibl').setup { scope = { highlight = highlight } }

    hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
  end,
}
