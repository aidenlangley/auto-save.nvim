local M = {}

local config = require("auto-save.config")

local function can_save(bufnr)
  local is_modifiable = vim.fn.getbufvar(bufnr, "&modifiable") == 1
  local is_readonly = vim.fn.getbufvar(bufnr, "&readonly") == 1
  local buftype = vim.api.nvim_buf_get_option(bufnr, "buftype")
  local is_modified = vim.api.nvim_buf_get_option(bufnr, "modified")

  return is_modifiable and not is_readonly and buftype == "" and is_modified
end

local function create_autocmd()
  -- Write buffer when leaving Insert mode
  vim.api.nvim_create_autocmd(config.events, {
    group = vim.api.nvim_create_augroup(config.augroup_name, { clear = true }),
    pattern = "*",
    callback = function(args)
      if can_save(args.buf or vim.api.nvim_get_current_buf()) then
        if config.timeout ~= nil then
          ---@diagnostic disable-next-line: param-type-mismatch
          vim.defer_fn(config.save_fn, config.timeout)
        else
          config.save_fn()
        end
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
    config.timeout = opts.timeout or config.timeout
  end

  create_autocmd()
end

return M
