local M = {}

local config = require("auto_save.config")

local function create_autocmd()
  -- Write buffer when leaving Insert mode
  vim.api.nvim_create_autocmd(config.events, {
    group = vim.api.nvim_create_augroup(config.augroup_name, { clear = true }),
    pattern = "*",
    callback = function(args)
      local bufnr = args.buf or vim.api.nvim_get_current_buf()
      local is_modifiable = vim.fn.getbufvar(bufnr, "&modifiable")
      local is_readonly = vim.fn.getbufvar(bufnr, "&readonly")
      local buftype = vim.api.nvim_buf_get_option(bufnr, "buftype")
      local is_modified = vim.api.nvim_buf_get_option(bufnr, "modified")

      if is_modifiable and not is_readonly and buftype == "" and is_modified then
        config.save_fn()
      end
    end,
  })
end

function M.setup(opts)
  if opts then
    config.augroup_name = opts.augroup_name or config.augroup_name
    config.events = opts.events or config.events
    config.silent = opts.silent or config.silent
    config.save_cmd = opts.save_cmd or config.save_cmd
    config.save_fn = opts.save_fn or config.save_fn
  end

  create_autocmd()
end

return M
