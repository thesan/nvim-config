--[[
  https://github.com/jiaoshijie/undotree

  Mappings:
    j    : move_next
    k    : move_prev
    gj   : move2parent
    J    : move_change_next
    K    : move_change_prev
    <CR> : action_enter
    p    : enter_diffbuf
    q    : quit
--]]

return {
  'jiaoshijie/undotree',

  config = function()
    local undotree = require 'undotree'

    undotree.setup {
      float_diff = true, -- using float window previews diff, set this `true` will disable layout option
      layout = 'left_bottom', -- "left_bottom", "left_left_bottom"
      position = 'right', -- "left", "right", "bottom"
      window = {
        winblend = 0,
      },
    }

    vim.keymap.set('n', '<leader>u', undotree.toggle, { desc = 'Undo tree' })
  end,
}
