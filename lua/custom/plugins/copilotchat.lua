-- https://github.com/CopilotC-Nvim/CopilotChat.nvim
return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      -- { 'github/copilot.vim' }, -- or zbirenbaum/copilot.lua
      { 'zbirenbaum/copilot.lua' },
      { 'nvim-lua/plenary.nvim', branch = 'master' }, -- for curl, log and async functions
    },
    build = 'make tiktoken', -- Only on MacOS or Linux

    keys = {
      {
        '<leader>c',
        function()
          require('CopilotChat').open {
            sticky = {
              '$claude-sonnet-4.5',
              '#buffer',
              '#gitdiff:staged',
            },
          }
        end,
        desc = 'Copilot Chat',
      },
    },

    -- See Commands section for default commands if you want to lazy load on them
    config = function()
      local config = require 'CopilotChat.config'
      config.mappings.reset = false -- disable the reset mapping

      require('CopilotChat').setup()
    end,
  },
}
