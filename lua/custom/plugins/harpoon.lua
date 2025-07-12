--
-- https://github.com/ThePrimeagen/harpoon
--

return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },

  config = function()
    local harpoon = require 'harpoon'

    harpoon:setup {
      settings = {
        save_on_toggle = true,
        save_on_change = true,
      },
    }

    -- Add file
    vim.keymap.set('n', '<leader>A', function()
      harpoon:list():add()
    end, { desc = 'Harpoon: Add file' })

    -- Menu
    vim.keymap.set('n', '<leader>a', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = 'Harpoon: open menu' })

    -- Navigate
    local wk = require 'which-key'
    for i = 1, 10 do
      local function nav()
        harpoon:list():select(i)
      end
      wk.add { '<leader>' .. i % 10, nav, hidden = true, mode = 'n' }
    end
  end,
}
