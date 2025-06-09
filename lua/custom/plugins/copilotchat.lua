return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      { 'github/copilot.vim' }, -- or zbirenbaum/copilot.lua
      { 'nvim-lua/plenary.nvim', branch = 'master' }, -- for curl, log and async functions
    },
    build = 'make tiktoken', -- Only on MacOS or Linux

    keys = {
      { '<leader>c', '<cmd>CopilotChat<cr>', desc = 'Copilot Chat' },
    },

    -- See Commands section for default commands if you want to lazy load on them
    config = function()
      require('CopilotChat').setup()
    end,
  },
}
