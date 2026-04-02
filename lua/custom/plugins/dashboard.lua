return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
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
