-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Pull an agent-drafted commit message into the commit buffer.
-- An agent stages a commit and writes its message to <gitdir>/COMMIT_DRAFT;
-- this reads it in and deletes it, so a stale draft can never leak into an
-- unrelated commit. Only fires when the buffer holds nothing but comments.
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Insert .git/COMMIT_DRAFT into an empty commit message',
  pattern = 'gitcommit',
  group = vim.api.nvim_create_augroup('commit-draft', { clear = true }),
  callback = function(args)
    -- The commit buffer IS <gitdir>/COMMIT_EDITMSG, so its own directory is the
    -- git dir — correct inside linked worktrees too, where .git is a file and
    -- the real dir is .git/worktrees/<name>. Read the name off args.buf, not '%':
    -- neogit sets the filetype before the buffer is the current one.
    local name = vim.api.nvim_buf_get_name(args.buf)
    if name == '' then
      return
    end
    local draft = vim.fn.fnamemodify(name, ':p:h') .. '/COMMIT_DRAFT'
    if vim.fn.filereadable(draft) == 0 then
      return
    end

    -- Don't clobber a message already typed (or one git pre-filled, e.g. merge/amend).
    for _, line in ipairs(vim.api.nvim_buf_get_lines(args.buf, 0, -1, false)) do
      if line ~= '' and not line:match '^#' then
        return
      end
    end

    local lines = vim.fn.readfile(draft)
    while #lines > 0 and lines[#lines] == '' do
      table.remove(lines)
    end
    vim.api.nvim_buf_set_lines(args.buf, 0, 0, false, lines)
    vim.fn.delete(draft)
    if vim.api.nvim_get_current_buf() == args.buf then
      vim.api.nvim_win_set_cursor(0, { 1, 0 })
    end
  end,
})
