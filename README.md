![Lines of code](https://img.shields.io/tokei/lines/git.sr.ht/~nedia/auto-save.nvim?style=flat-square)

Open an issue [here](https://todo.sr.ht/~nedia/nvim).

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

This plugin allows for some configuration, such as explicitly excluding some
filetypes, or defering the save function to allow for other things to run
beforehand.

# Installing

## [lazy](https://github.com/folke/lazy.nvim)

```lua
{
  "https://git.sr.ht/~nedia/auto-save.nvim",
  event = "BufReadPost",
  config = function()
    require("auto-save").setup()
  end
}
```

## [packer](https://github.com/wbthomason/packer.nvim)

```lua
{
  "https://git.sr.ht/~nedia/auto-save.nvim",
  config = function()
    require("auto-save").setup()
  end
}
```

## [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'https://git.sr.ht/~nedia/auto-save.nvim'
lua require("auto-save").setup()
```

# Configuring

Only a few config options can be provided - these are displayed below, as well
as their default values.

```lua
require("auto-save").setup({
  -- The name of the augroup.
  augroup_name = "AutoSavePlug",

  -- The events in which to trigger an auto save.
  events = { "InsertLeave", "TextChanged" },

  -- If you'd prefer to silence the output of `save_fn`.
  silent = true,

  -- If you'd prefer to write a vim command.
  save_cmd = nil,

  -- What to do after checking if auto save conditions have been met.
  save_fn = function()
    local config = require("auto-save.config")
    if config.save_cmd ~= nil then
      vim.cmd(config.save_cmd)
    elseif M.silent then
      vim.cmd("silent! w")
    else
      vim.cmd("w")
    end
  end,

  -- May define a timeout, or a duration to defer the save for - this allows
  -- for formatters to run, for example if they're configured via an autocmd
  -- that listens for `BufWritePre` event.
  timeout = nil,

  -- Define some filetypes to explicitly not save, in case our existing conditions
  -- don't quite catch all the buffers we'd prefer not to write to.
  exclude_ft = {},
})
```

Since I tend to use the mouse a fair bit (a habit I'm trying to break), my
config is as follows - it includes the `BufLeave` event (sometimes you move to
a buffer without leaving insert mode), and excludes my file explorer (just
seems to break it! Must be trying to write to it and messing up some sequential
operation):

```lua
require("auto-save").setup({
  events = { "InsertLeave", "BufLeave" },
  exclude_ft = { "neo-tree" },
})
```
