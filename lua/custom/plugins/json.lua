return {
  vim.api.nvim_create_user_command('JsonFormat', function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local content = table.concat(lines, '\n')

    local ok, decoded = pcall(vim.fn.json_decode, content)
    if ok and type(decoded) == 'string' then
      decoded = vim.fn.json_decode(decoded)
    end

    if not ok then
      vim.notify('Invalid JSON', vim.log.levels.ERROR)
      return
    end

    local json_str = vim.fn.json_encode(decoded)
    local temp_file = vim.fn.tempname()
    vim.fn.writefile({ json_str }, temp_file)

    local formatted = vim.fn.systemlist('jq . ' .. temp_file)
    vim.api.nvim_buf_set_lines(0, 0, -1, false, formatted)
  end, {}),

  vim.keymap.set('n', '<leader>jf', function()
    vim.bo.filetype = 'json'
    vim.cmd 'JsonFormat'
  end, { desc = 'Set JSON filetype and format' }),
}
