--
-- https://github.com/linrongbin16/gitlinker.nvim
--
local function preferred_remote()
  local remotes = vim.fn.systemlist('git remote')
  local has = {}
  for _, r in ipairs(remotes) do
    has[r] = true
  end
  if has['origin'] then return 'origin' end
  if has['upstream'] then return 'upstream' end
  return nil
end

return {
  'linrongbin16/gitlinker.nvim',
  opts = {},
  keys = {
    {
      'gh',
      function()
        require('gitlinker').link({
          action = require('gitlinker.actions').system,
          router_type = 'blame',
          remote = preferred_remote(),
        })
      end,
      desc = 'Open blame in GitHub',
      mode = { 'n', 'v' },
    },
    {
      'gy',
      function()
        require('gitlinker').link({ remote = preferred_remote() })
      end,
      desc = 'Copy GitHub URL',
      mode = { 'n', 'v' },
    },
  },
}
