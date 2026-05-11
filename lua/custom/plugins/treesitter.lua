return { -- Highlight, edit, and navigate code
  -- Migrated to the `main` branch (rewrite). See :h nvim-treesitter.
  -- Requires Neovim 0.12+, tree-sitter CLI >= 0.26.1, and a C compiler.
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false, -- main branch does not support lazy-loading
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter').setup {
      install_dir = vim.fn.stdpath 'data' .. '/site',
    }

    local ensure_installed = {
      'bash',
      'c',
      'c_sharp',
      'css',
      'diff',
      'html',
      'javascript',
      'json',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'query',
      'toml',
      'tsx',
      'typescript',
      'vim',
      'vimdoc',
      'yaml',
    }
    require('nvim-treesitter').install(ensure_installed)

    -- Highlighting and indent are no longer auto-enabled by `setup`.
    -- Start treesitter for any filetype that has a parser; ignore filetypes that don't.
    -- Only set the TS indentexpr when the language actually has an indents query —
    -- otherwise we silently disable Vim's default indent (e.g. C# breaks without this guard).
    vim.api.nvim_create_autocmd('FileType', {
      callback = function(ev)
        pcall(vim.treesitter.start, ev.buf)
        local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
        if lang and vim.treesitter.query.get(lang, 'indents') then
          vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
