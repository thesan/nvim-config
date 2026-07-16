local M = {}

local function ensure_loaded()
  local ok, lazy = pcall(require, 'lazy')
  if ok then
    lazy.load { plugins = { 'codediff.nvim' } }
  end

  return pcall(require, 'codediff')
end

local function notify_error(message)
  vim.notify(message, vim.log.levels.ERROR)
end

local function run_git(args, cwd, opts)
  opts = opts or {}

  local result = vim.system(vim.list_extend({ 'git' }, args), {
    cwd = cwd,
    stdin = opts.stdin,
    text = true,
  }):wait()

  if result.code ~= 0 then
    return nil, vim.trim(result.stderr or 'Git command failed')
  end

  return vim.trim(result.stdout or ''), nil
end

local function run_codediff(args, opts)
  opts = opts or {}
  if not ensure_loaded() then
    notify_error('CodeDiff is not available')
    return false
  end

  local previous_cwd = vim.fn.getcwd()
  if opts.cwd and opts.cwd ~= previous_cwd then
    vim.api.nvim_set_current_dir(opts.cwd)
  end

  local ok, err = pcall(vim.cmd, {
    cmd = 'CodeDiff',
    args = args,
  })

  if opts.cwd and opts.cwd ~= previous_cwd then
    vim.api.nvim_set_current_dir(previous_cwd)
  end

  if not ok then
    notify_error(err)
    return false
  end

  return true
end

function M.open_revisions(original, modified, opts)
  return run_codediff({ original, modified }, opts)
end

local function parent_or_empty_tree(revision, cwd)
  local parent = run_git({ 'rev-parse', '--verify', revision .. '^' }, cwd)

  if not parent then
    local empty_tree, err = run_git({ 'hash-object', '-t', 'tree', '--stdin' }, cwd, { stdin = '' })
    if not empty_tree then
      notify_error('Unable to resolve the parent of ' .. revision .. ': ' .. err)
      return nil
    end
    parent = empty_tree
  end

  return parent
end

function M.open_commit(revision, opts)
  opts = opts or {}
  local parent = parent_or_empty_tree(revision, opts.cwd or vim.uv.cwd())
  return parent and M.open_revisions(parent, revision, opts) or false
end

function M.open_commit_range(first, last, opts)
  opts = opts or {}
  local parent = parent_or_empty_tree(first, opts.cwd or vim.uv.cwd())
  return parent and M.open_revisions(parent, last, opts) or false
end

function M.open_range(range, opts)
  local separator_start = range:find('...', 1, true)
  if separator_start then
    return run_codediff({ range }, opts)
  end

  separator_start = range:find('..', 1, true)
  if not separator_start then
    return M.open_commit(range, opts)
  end

  local original = range:sub(1, separator_start - 1)
  local modified = range:sub(separator_start + 2)
  return M.open_revisions(original, modified, opts)
end

local function visible_groups(group)
  if not group then
    return { staged = true, unstaged = true, conflicts = true }
  end

  return {
    staged = group == 'staged',
    unstaged = group == 'unstaged',
    conflicts = group == 'conflicts',
  }
end

local function filter_status(status, group, path)
  local filtered = vim.deepcopy(status)
  local groups = { 'staged', 'unstaged', 'conflicts' }

  for _, name in ipairs(groups) do
    filtered[name] = filtered[name] or {}
    if group and name ~= group then
      filtered[name] = {}
    elseif path then
      filtered[name] = vim.tbl_filter(function(file)
        return file.path == path
      end, filtered[name])
    end
  end

  return filtered
end

local function status_is_empty(status)
  return #status.staged == 0 and #status.unstaged == 0 and #status.conflicts == 0
end

function M.open_status(opts)
  opts = opts or {}
  if not ensure_loaded() then
    notify_error('CodeDiff is not available')
    return false
  end

  local git = require 'codediff.core.git'
  local view = require 'codediff.ui.view'
  local config = require 'codediff.config'

  local function create_view(git_root)
    git.get_status(git_root, function(err, status)
      vim.schedule(function()
        if err then
          notify_error(err)
          return
        end

        local filtered = filter_status(status, opts.group, opts.path)
        if status_is_empty(filtered) then
          vim.notify('No matching changes to show', vim.log.levels.INFO)
          return
        end

        local previous_groups = config.options.explorer.visible_groups
        config.options.explorer.visible_groups = visible_groups(opts.group)

        local ok, create_err = pcall(view.create, {
          mode = 'explorer',
          git_root = git_root,
          original_path = '',
          modified_path = '',
          original_revision = nil,
          modified_revision = nil,
          explorer_data = {
            status_result = filtered,
            focus_file = opts.path,
          },
        }, '')

        config.options.explorer.visible_groups = previous_groups

        if not ok then
          notify_error(create_err)
        end
      end)
    end)
  end

  if opts.git_root then
    create_view(opts.git_root)
    return true
  end

  git.get_git_root(opts.cwd or vim.uv.cwd(), function(err, git_root)
    if err then
      vim.schedule(function()
        notify_error(err)
      end)
      return
    end
    create_view(git_root)
  end)

  return true
end

return M
