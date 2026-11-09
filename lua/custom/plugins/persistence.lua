return {
  'folke/persistence.nvim',
  event = 'BufReadPre',
  opts = {},
  init = function()
    -- Sessions can't restore neo-tree's window, so keep it out and reopen it.
    vim.api.nvim_create_autocmd('User', { pattern = 'PersistenceSavePre', command = 'silent! Neotree close' })
    vim.api.nvim_create_autocmd('User', { pattern = 'PersistenceLoadPost', command = 'Neotree show' })
  end,
  keys = {
    {
      '<leader>qs',
      function()
        require('persistence').load()
      end,
      desc = 'Restore Session',
    },
    {
      '<leader>qS',
      function()
        require('persistence').select()
      end,
      desc = 'Select Session',
    },
    {
      '<leader>ql',
      function()
        require('persistence').load { last = true }
      end,
      desc = 'Restore Last Session',
    },
    {
      '<leader>qd',
      function()
        require('persistence').stop()
      end,
      desc = "Don't Save Current Session",
    },
  },
}
