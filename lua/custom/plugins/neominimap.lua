-- Per-window minimap with treesitter, diagnostics, search, git, and mark integrations.
-- Auto-enables only for buffers taller than the screen.
return {
  'Isrothy/neominimap.nvim',
  version = 'v3.*.*',
  lazy = false,
  keys = {
    { '<leader>mm', '<cmd>Neominimap Toggle<cr>', desc = '[M]inimap toggle' },
    { '<leader>mf', '<cmd>Neominimap ToggleFocus<cr>', desc = '[M]inimap [F]ocus' },
    { '<leader>mr', '<cmd>Neominimap Refresh<cr>', desc = '[M]inimap [R]efresh' },
  },
  init = function()
    vim.opt.wrap = false
    vim.opt.sidescrolloff = 36
    vim.g.neominimap = {
      auto_enable = true,
      layout = 'float',
      buf_filter = function(bufnr)
        return vim.api.nvim_buf_line_count(bufnr) > vim.o.lines
      end,
    }
  end,
}
