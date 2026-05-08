-- Dashboard records every LSP client's root_dir on VimLeavePre into
-- ~/.cache/nvim/dashboard/cache. Roslyn's go-to-definition on compiled
-- assemblies opens a temp "MetadataAsSource" file and registers its dir as
-- a root, which then shows up as a "project". Strip those before dashboard
-- reads the cache.
local function clean_project_cache()
  local path = vim.fn.stdpath 'cache' .. '/dashboard/cache'
  local f = io.open(path, 'r')
  if not f then
    return
  end
  local data = f:read '*a'
  f:close()
  local fn = loadstring(data)
  if not fn then
    return
  end
  local ok, list = pcall(fn)
  if not ok or type(list) ~= 'table' then
    return
  end
  local filtered = {}
  for _, p in ipairs(list) do
    if not p:match '/private/var/folders' and not p:match 'MetadataAsSource' then
      table.insert(filtered, p)
    end
  end
  if #filtered == #list then
    return
  end
  local out = io.open(path, 'w')
  if out then
    out:write('return ' .. vim.inspect(filtered))
    out:close()
  end
end

return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  init = clean_project_cache,
  opts = {
    theme = 'hyper',
    config = {
      header = {
        '',
        '',
        '  ███╗   ██╗██╗   ██╗██╗███╗   ███╗ ',
        '  ████╗  ██║██║   ██║██║████╗ ████║ ',
        '  ██╔██╗ ██║██║   ██║██║██╔████╔██║ ',
        '  ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║ ',
        '  ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║ ',
        '  ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝ ',
        '',
        '',
      },
      week_header = { enable = false },
      shortcut = {
        { desc = ' Find File', group = 'Label', action = 'Telescope find_files', key = 'f' },
        { desc = ' New File', group = 'Label', action = 'ene | startinsert', key = 'n' },
        { desc = ' Restore Session', group = 'Number', action = 'lua require("persistence").load()', key = 's' },
        { desc = ' Last Session', group = 'Number', action = 'lua require("persistence").load({ last = true })', key = 'l' },
        { desc = ' Recent Files', group = 'Label', action = 'Telescope oldfiles', key = 'r' },
        { desc = ' Quit', group = 'Error', action = 'qa', key = 'q' },
      },
    },
  },
}
