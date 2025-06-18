return {
  {
    'youyoumu/pretty-ts-errors.nvim',
    dependencies = {
      'MeanderingProgrammer/render-markdown.nvim',
    },
    config = function()
      require('pretty-ts-errors').setup {
        auto_open = false, -- Automatically show errors on hover
        float_opts = {
          border = 'rounded', -- Border style for floating windows
          max_width = 120, -- Maximum width of floating windows
          max_height = 60, -- Maximum height of floating windows
          wrap = false, -- Whether to wrap long lines
        },
      }

      -- Show error under cursor
      vim.keymap.set('n', '<leader>te', function()
        require('pretty-ts-errors').show_formatted_error()
      end, { desc = 'Show TS error' })

      -- Show all errors in file
      vim.keymap.set('n', '<leader>tE', function()
        require('pretty-ts-errors').open_all_errors()
      end, { desc = 'Show all TS errors' })

      -- Toggle auto-display
      vim.keymap.set('n', '<leader>tt', function()
        require('pretty-ts-errors').toggle_auto_open()
      end, { desc = 'Toggle TS error auto-display' })
    end,
  },
}
