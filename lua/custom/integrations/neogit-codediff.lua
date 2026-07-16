local M = {}

local codediff = require 'custom.integrations.codediff'

local function git_root()
  return require('neogit.lib.git').repo.worktree_root or vim.uv.cwd()
end

local function register_on_close(opts)
  if not opts.on_close then
    return
  end

  vim.api.nvim_create_autocmd('BufEnter', {
    buffer = opts.on_close.handle,
    once = true,
    callback = opts.on_close.fn,
  })
end

local function commit_hash(item)
  if type(item) ~= 'string' then
    return nil
  end

  return item:match '%x+'
end

local function open_status(group, item, opts)
  return codediff.open_status {
    git_root = git_root(),
    group = group,
    path = opts.only and item or nil,
  }
end

---@param section_name string?
---@param item_name string|string[]|nil
---@param opts table?
function M.open(section_name, item_name, opts)
  opts = opts or {}
  register_on_close(opts)

  if (section_name == 'recent' or section_name == 'log' or (section_name and section_name:match 'unmerged$')) and item_name then
    if type(item_name) == 'table' then
      return codediff.open_revisions(item_name[1], item_name[#item_name], { cwd = git_root() })
    end

    local revision = commit_hash(item_name)
    if not revision then
      vim.notify('Neogit could not determine the selected revision', vim.log.levels.ERROR)
      return false
    end

    return codediff.open_commit(revision, { cwd = git_root() })
  end

  if section_name == 'range' and item_name then
    return codediff.open_range(item_name, { cwd = git_root() })
  end

  if (section_name == 'stashes' or section_name == 'commit') and item_name then
    return codediff.open_commit(item_name, { cwd = git_root() })
  end

  if section_name == 'conflict' then
    return open_status('conflicts', item_name, { only = item_name ~= nil })
  end

  if section_name == 'staged' then
    return open_status('staged', item_name, opts)
  end

  if section_name == 'unstaged' or section_name == 'untracked' then
    return open_status('unstaged', item_name, opts)
  end

  if section_name == 'merge' or section_name == 'worktree' then
    return open_status(nil, item_name, opts)
  end

  if not section_name and item_name then
    return codediff.open_commit(item_name, { cwd = git_root() })
  end

  return open_status(nil, item_name, opts)
end

return M
