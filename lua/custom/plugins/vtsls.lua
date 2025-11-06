-- https://github.com/yioneko/nvim-vtsls
return {
  'yioneko/nvim-vtsls',
  dependencies = { 'neovim/nvim-lspconfig' },
  config = function()
    local vtsls = require 'vtsls'
    local configs = require 'lspconfig.configs'
    configs.vtsls = vtsls.lspconfig -- set default server config, optional but recommended

    require('lspconfig').vtsls.setup {
      -- explicitly add default filetypes, so that we can extend
      -- them in related extras
      filetypes = {
        'javascript',
        'javascriptreact',
        'javascript.jsx',
        'typescript',
        'typescriptreact',
        'typescript.tsx',
      },
      settings = {
        complete_function_calls = true,
        vtsls = {
          enableMoveToFileCodeAction = true,
          autoUseWorkspaceTsdk = true,
          experimental = {
            maxInlayHintLength = 30,
            completion = {
              enableServerSideFuzzyMatch = true,
            },
          },
        },
        typescript = {
          tsserver = {
            maxTsServerMemory = 8192, -- Increase memory limit (e.g., 8GB)
          },
          updateImportsOnFileMove = { enabled = 'always' },
          suggest = {
            completeFunctionCalls = true,
          },
          inlayHints = {
            enumMemberValues = { enabled = true },
            functionLikeReturnTypes = { enabled = true },
            parameterNames = { enabled = 'literals' },
            parameterTypes = { enabled = true },
            propertyDeclarationTypes = { enabled = true },
            variableTypes = { enabled = false },
          },
        },
      },
    }

    -- Keymaps
    vim.keymap.set('n', 'gD', function()
      local win = vim.api.nvim_get_current_win()
      vtsls.commands.goto_source_definition(win)
    end, { desc = 'Goto Source Definition' })

    vim.keymap.set('n', 'gR', vtsls.commands.file_references, { desc = 'File References' })

    vim.keymap.set('n', '<leader>zo', vtsls.commands.organize_imports, { desc = 'Organize Imports' })

    vim.keymap.set('n', '<leader>zM', vtsls.commands.add_missing_imports, { desc = 'Add missing imports' })

    vim.keymap.set('n', '<leader>zu', vtsls.commands.remove_unused_imports, { desc = 'Remove unused imports' })

    vim.keymap.set('n', '<leader>zD', vtsls.commands.fix_all, { desc = 'Fix all diagnostics' })

    vim.keymap.set('n', '<leader>zV', vtsls.commands.select_ts_version, { desc = 'Select TS workspace version' })
  end,
}
