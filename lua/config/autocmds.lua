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

-- The worktree a commit message file belongs to. Resolved from the file, not
-- the cwd, so it names the repo being committed in. Git writes the file into
-- the git dir, where `rev-parse --show-toplevel` fails, except in a
-- submodule's (core.worktree is set). A linked worktree's git dir holds a
-- `gitdir` file pointing at <worktree>/.git; the main one is <top>/.git.
local function commit_worktree(msg_file)
  local git_dir = vim.fs.dirname(vim.fn.resolve(msg_file))

  local linked = git_dir .. '/gitdir'
  if vim.fn.filereadable(linked) == 1 then
    return vim.fs.dirname(vim.fs.abspath(vim.fn.readfile(linked)[1], git_dir))
  end

  local top = vim.fn.systemlist({ 'git', '-C', git_dir, 'rev-parse', '--show-toplevel' })[1]
  if vim.v.shell_error == 0 then
    return top
  end

  if vim.fs.basename(git_dir) == '.git' then
    return vim.fs.dirname(git_dir)
  end
end

-- ~/brain/commit-drafts/<top level, every / as ->. Agents compute the same
-- key from `git rev-parse --show-toplevel`, which returns the resolved path.
local function commit_draft_path(worktree)
  return vim.fn.expand '~/brain/commit-drafts/' .. vim.fn.resolve(worktree):gsub('/', '-')
end

-- Pull an agent-drafted commit message into the commit buffer.
-- An agent stages a commit and writes its message to this worktree's draft;
-- this reads it in and deletes it, so a stale draft can never leak into a
-- later commit. Only fires when the buffer holds nothing but comments.
--
-- Outside the git dir on purpose: agents are commonly barred from writing
-- inside .git, and ~/brain is already their write path.
vim.api.nvim_create_autocmd('FileType', {
  desc = "Insert the worktree's commit draft into an empty commit message",
  pattern = 'gitcommit',
  group = vim.api.nvim_create_augroup('commit-draft', { clear = true }),
  callback = function(args)
    local worktree = commit_worktree(vim.api.nvim_buf_get_name(args.buf))
    if not worktree then
      return
    end

    local draft = commit_draft_path(worktree)
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
