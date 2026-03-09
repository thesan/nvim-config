local M = {}
M.buffer_stack = {} -- Our list of buffers, newest first

local function goto_last_terminal()
  local current_is_term = (vim.bo.buftype == 'terminal')
  local function toggle(buftype)
    if current_is_term then
      return buftype == '' -- from a terminal switch to a normal buffer (files)
    else
      return buftype == 'terminal' -- from any non terminal buffer switch to a terminal
    end
  end

  vim.api.nvim_set_current_tabpage(1)

  -- Loop through stack starting from index 1 (most recent)
  for _, buf in ipairs(M.buffer_stack) do
    if vim.api.nvim_buf_is_valid(buf) and toggle(vim.bo[buf].buftype) then
      vim.api.nvim_set_current_buf(buf)
      return
    end
  end

  if not current_is_term then
    vim.cmd 'terminal'
  else
    vim.cmd 'enew'
  end
end
vim.keymap.set('n', '<leader>,', goto_last_terminal, { desc = 'Go to last terminal' })

-- Function to update the stack
local function update_stack()
  local cur_buf = vim.api.nvim_get_current_buf()

  -- Remove the buffer if it already exists in the stack
  for i, buf_id in ipairs(M.buffer_stack) do
    if buf_id == cur_buf then
      table.remove(M.buffer_stack, i)
      break
    end
  end

  -- Insert the current buffer at the top (index 1)
  table.insert(M.buffer_stack, 1, cur_buf)
end
-- Track every time we enter a buffer
vim.api.nvim_create_autocmd('BufEnter', {
  callback = update_stack,
})
