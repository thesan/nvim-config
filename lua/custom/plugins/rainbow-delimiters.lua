return {
  'HiPhish/rainbow-delimiters.nvim',
  event = 'VeryLazy',
  config = function()
    require('rainbow-delimiters.setup').setup {

      -- strategy = {
      --   [''] = require 'rainbow-delimiters.strategy.global',
      --   ['vim'] = require 'rainbow-delimiters.strategy.vim',
      -- },
      -- query = {
      --   [''] = 'rainbow-delimiters',
      --   ['vim'] = 'rainbow-delimiters-vim',
      -- },
      highlight = {
        'RainbowDelimiterRed',
        'RainbowDelimiterBlue',
        'RainbowDelimiterYellow',
        -- 'RainbowDelimiterOrange',
        'RainbowDelimiterGreen',
        'RainbowDelimiterViolet',
        'RainbowDelimiterCyan',
      },
    }
  end,
}
