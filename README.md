![Lines of code](https://img.shields.io/tokei/lines/git.sr.ht/~nedia/auto_save.nvim?style=flat-square)

# AutoSave

Extremely simple auto save plugin.

All we're doing is creating an autocmd that runs on either `InsertLeave` and
`TextChanged`, or `config.events` if defined.

It checks if the buffer is able to be modified, isn't readonly, has a buftype
of `<empty>`, meaning it's not a terminal, and it's not a `Telescope` prompt
for example. Finally, it checks if the buffer has been modified.

If all conditions are met, we run `vim.cmd("w")` - if you've configured it to
run silently, it'll be silent. If you'd like to run your own command, you can
configure `save_cmd` or `save_fn`. If `save_cmd` is defined, this is preferred
and `save_fn` is discarded.

# Installing

## [lazy](https://github.com/folke/lazy.nvim)

```lua
{
  "https://git.sr.ht/~nedia/auto_save.nvim",
  event = "BufReadPost",
  config = function()
    require("auto_save").setup()
  end
}
```

## [packer](https://github.com/wbthomason/packer.nvim)

```lua
{
  "https://git.sr.ht/~nedia/auto_save.nvim",
  config = function()
    require("auto_save").setup()
  end
}
```

## [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'https://git.sr.ht/~nedia/auto_save.nvim'
lua require("auto_save").setup()
```

# Configuring

Only a few config options can be provided - these are displayed below, as well
as their default values.

```lua
{
  -- The name of the augroup.
  augroup_name = "AutoSavePlug"

  -- The events in which to trigger an auto save.
  events = { "InsertLeave", "TextChanged" }

  -- If you'd prefer to silence the output of `save_fn`.
  silent = true

  -- If you'd prefer to write a vim command.
  save_cmd = nil

  -- What to do after checking if auto save conditions have been met.
  save_fn = function()
    local config = require("auto_save.config")
    if config.save_cmd ~= nil then
      vim.cmd(config.save_cmd)
    elseif M.silent then
      vim.cmd("silent! w")
    else
      vim.cmd("w")
    end
  end
}
```
