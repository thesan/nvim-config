local function rename_term()
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.bo[bufnr].buftype ~= 'terminal' then
    return
  end

  -- Use the title sent by the shell (e.g., "htop" or "node index.js")
  local title = vim.b.term_title
  if not title or title == '' then
    return
  end

  -- TEMP SOLUTION:
  -- If the title contains a "/" or looks like a prompt (e.g., contains @ or ~),
  -- we'll assume the shell is idle and just call it "zsh" (or your shell name).
  local display_title = title
  if title:find '/' and title:find '@' and title:find '~' then
    display_title = vim.fn.fnamemodify(vim.env.SHELL, ':t') -- e.g., "zsh"
  end

  -- We need to make the name unique so Neovim doesn't throw an error
  -- We'll format it as: term://[PID]:[Command]
  local pid = vim.b.terminal_job_id
  local new_name = 'term://' .. pid .. ': ' .. display_title

  -- Only rename if the name has actually changed to avoid infinite loops
  if vim.api.nvim_buf_get_name(bufnr) ~= new_name then
    -- SAVE the current alternate buffer before renaming
    local alt = vim.fn.bufnr '#'

    -- pcall prevents the script from crashing if the name is somehow invalid
    pcall(vim.api.nvim_buf_set_name, bufnr, new_name)

    -- RESTORE the alternate buffer so <C-6> still works
    if alt > 0 and vim.api.nvim_buf_is_valid(alt) then
      vim.fn.setreg('#', alt)
    end
  end
end

vim.api.nvim_create_autocmd({ 'TermResponse', 'BufEnter', 'CursorHold' }, {
  callback = rename_term,
})
