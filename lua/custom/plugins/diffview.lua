return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
  keys = {
    { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = 'Diffview Open' },
    { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = 'Diffview File History' },
    { '<leader>gq', '<cmd>DiffviewClose<cr>', desc = 'Diffview Close' },
    {
      '<leader>gP',
      function()
        local function sh(cmd) return (vim.fn.systemlist(cmd)[1] or ''):gsub('%s+$', '') end
        local base = sh 'git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null'
        if base == '' then
          for _, b in ipairs { 'origin/main', 'origin/master' } do
            if sh('git rev-parse --verify --quiet ' .. b) ~= '' then base = b; break end
          end
        end
        if base == '' then vim.notify('No origin/main or origin/master found', vim.log.levels.ERROR); return end
        vim.cmd('DiffviewOpen ' .. base .. '...HEAD')
      end,
      desc = 'Diffview PR changes (vs base)',
    },
  },
  opts = {
    view = {
      merge_tool = { layout = 'diff3_mixed', disable_diagnostics = true },
    },
  },
}
