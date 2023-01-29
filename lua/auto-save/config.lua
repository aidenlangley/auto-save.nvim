local M = {}

-- The name of the augroup.
M.augroup_name = "AutoSavePlug"

-- The events in which to trigger an auto save.
M.events = { "InsertLeave", "TextChanged" }

-- If you'd prefer to silence the output of `save_fn`.
M.silent = true

-- If you'd prefer to write a vim command.
M.save_cmd = nil

-- What to do after checking if auto save conditions have been met.
M.save_fn = function()
  if M.save_cmd ~= nil then
    vim.cmd(M.save_cmd)
  elseif M.silent then
    vim.cmd("silent! w")
  else
    vim.cmd("w")
  end
end

-- May define a timeout, or a duration to defer the save for - this allows
-- for formatters to run, for example if they're configured via an autocmd
-- that listens for `BufWritePre` event.
M.timeout = nil

return M
