-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  init = function()
    -- Show the tree, without taking focus, once the first real file is open.
    -- Started without arguments, that is after leaving the dashboard.
    local function is_file(buf)
      return vim.bo[buf].buftype == '' and vim.api.nvim_buf_get_name(buf) ~= ''
    end
    local function show()
      if vim.o.diff or vim.tbl_contains({ 'gitcommit', 'gitrebase' }, vim.bo.filetype) then
        return
      end
      vim.cmd 'Neotree show'
    end
    vim.api.nvim_create_autocmd('VimEnter', {
      once = true,
      callback = function()
        if is_file(0) then
          vim.schedule(show)
          return
        end
        vim.api.nvim_create_autocmd('BufEnter', {
          callback = function(ev)
            if not is_file(ev.buf) then
              return
            end
            vim.schedule(show)
            return true -- delete this autocmd
          end,
        })
      end,
    })
  end,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    filesystem = {
      follow_current_file = { enabled = true },
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
      filtered_items = {
        visible = false,
        hide_dotfiles = false,
        hide_gitignored = true,
        hide_by_name = {
          'node_modules',
          'obj',
          'bin',
        },
        always_show = {
          'private',
        },
        always_show_by_pattern = { -- uses glob style patterns
          '.env*',
          '*/private/*', -- private's contents are gitignored too, not just the dir
          'Directory.Build.props',
        },
      },
    },
  },
}
