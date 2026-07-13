return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    config = function()
      local treesitter = require 'nvim-treesitter'
      local ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }

      treesitter.install(ensure_installed)

      local disabled_indent = { markdown = true, ruby = true }
      local installing = {}

      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local filetype = vim.bo[args.buf].filetype
          local language = vim.treesitter.language.get_lang(filetype)
          if not language then
            return
          end

          local parser_loaded, parser_available = pcall(vim.treesitter.language.add, language)
          if not parser_loaded or not parser_available then
            if not installing[language] and vim.tbl_contains(treesitter.get_available(), language) then
              installing[language] = true
              treesitter.install(language)
            end
            return
          end

          local started = pcall(vim.treesitter.start, args.buf, language)
          if not started then
            return
          end
          if not disabled_indent[language] then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },
}
-- vim: ts=2 sts=2 sw=2 et
