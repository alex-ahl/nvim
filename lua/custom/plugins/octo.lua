return {
  'pwntester/octo.nvim',
  cmd = 'Octo',
  opts = {
    picker = 'telescope',
    enable_builtin = true,
  },
  keys = {
    { '<leader>op', '<cmd>Octo pr list<cr>', desc = 'List PRs' },
    { '<leader>oi', '<cmd>Octo issue list<cr>', desc = 'List Issues' },
    { '<leader>oc', '<cmd>Octo pr create<cr>', desc = 'Create PR' },
    {
      '<leader>ob',
      function()
        local num = vim.trim(vim.fn.system 'gh pr view --json number -q .number')
        if vim.v.shell_error ~= 0 or num == '' then
          vim.notify('No PR found for current branch', vim.log.levels.WARN)
          return
        end
        vim.cmd('Octo pr edit ' .. num)
      end,
      desc = "Open current branch's PR",
    },
    { '<leader>or', '<cmd>Octo review start<cr>', desc = 'Start PR Review' },
    { '<leader>oe', '<cmd>Octo review resume<cr>', desc = 'Resume PR Review' },
    { '<leader>oR', '<cmd>Octo review submit<cr>', desc = 'Submit PR Review' },
    { '<leader>od', '<cmd>Octo review discard<cr>', desc = 'Discard PR Review' },
    { '<leader>oC', '<cmd>Octo pr checkout<cr>', desc = 'Checkout PR' },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-tree/nvim-web-devicons',
  },
}
