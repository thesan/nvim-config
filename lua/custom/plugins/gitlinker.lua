return {
  'ruifm/gitlinker.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    remote = 'origin',
    mappings = nil,
  },
  keys = {
    {
      'gh',
      function()
        require('gitlinker').get_buf_range_url('n', {
          action_callback = require('gitlinker.actions').open_in_browser,
        })
      end,
      desc = 'Open in GitHub',
      mode = 'n',
    },
    {
      'gh',
      function()
        require('gitlinker').get_buf_range_url('v', {
          action_callback = require('gitlinker.actions').open_in_browser,
        })
      end,
      desc = 'Open in GitHub',
      mode = 'v',
    },
    {
      'gy',
      function()
        require('gitlinker').get_buf_range_url 'n'
      end,
      desc = 'Copy GitHub URL',
      mode = 'n',
    },
    {
      'gy',
      function()
        require('gitlinker').get_buf_range_url 'v'
      end,
      desc = 'Copy GitHub URL',
      mode = 'v',
    },
  },
}
