-- Create scratch buffer
Config.new_scratch_buffer = function() vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true)) end

-- Toggle quickfix menu
Config.toggle_quickfix = function()
  local cur_tabnr = vim.fn.tabpagenr()
  for _, wininfo in ipairs(vim.fn.getwininfo()) do
    if wininfo.quickfix == 1 and wininfo.tabnr == cur_tabnr then return vim.cmd('cclose') end
  end
  vim.cmd('copen')
end

Config.pick_modified_untracked = function()
  local local_opts = { command = { 'git', 'ls-files', '--modified', '--others', '--exclude-standard' } }
  local source = {
    name = 'Git files (modified + untracked)',
    show = function(buf_id, items, query) return MiniPick.default_show(buf_id, items, query, { show_icons = true }) end,
  }
  return MiniPick.builtin.cli(local_opts, { source = source })
end
