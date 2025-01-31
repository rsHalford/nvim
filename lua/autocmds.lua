-- Show line diagnostics on cursor hover
vim.api.nvim_create_autocmd({ 'CursorHold' }, {
  pattern = '*',
  callback = function()
    for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
      if vim.api.nvim_win_get_config(winid).zindex then return end
    end
    vim.diagnostic.config({
      virtual_text = false,
      severity_sort = true,
    })
    vim.diagnostic.open_float({
      scope = 'line',
      header = '',
      border = 'single',
    })
  end,
})
