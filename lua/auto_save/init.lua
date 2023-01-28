local config = require("auto_save.config")

-- Write buffer when leaving Insert mode
vim.api.nvim_create_autocmd(config.events, {
  group = vim.api.nvim_create_augroup(config.augroup_name, { clear = true }),
  pattern = "*",
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local is_modifiable = vim.fn.getbufvar(bufnr, "&modifiable")
    local is_readonly = vim.fn.getbufvar(bufnr, "&readonly")
    local buftype = vim.api.nvim_buf_get_option(bufnr, "buftype")
    local is_modified = vim.api.nvim_buf_get_option(bufnr, "modified")

    if is_modifiable and not is_readonly and buftype == "" and is_modified then
      config.save_fn()
    end
  end,
})
