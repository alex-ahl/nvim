return {
  'ThePrimeagen/git-worktree.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    local worktree = require 'git-worktree'

    worktree.setup {
      change_directory_command = 'cd', -- or 'tcd' for tab-local
      update_on_change = true,
      clearjumps_on_change = true,
    }

    -- Load telescope extension
    require('telescope').load_extension 'git_worktree'
  end,
  keys = {
    { '<leader>gw', '<cmd>Telescope git_worktree git_worktrees<cr>', desc = 'List worktrees' },
    { '<leader>gW', '<cmd>Telescope git_worktree create_git_worktree<cr>', desc = 'Create worktree' },
  },
}
