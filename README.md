# AutoSave

Extremely simple auto save plugin.

# Installing

## [lazy](https://github.com/folke/lazy.nvim) & [packer](https://github.com/wbthomason/packer.nvim)

```lua
{
  "https://git.sr.ht/~nedia/auto_save.nvim",
  config = function()
    require("auto_save").setup()
  end
}
```

## vim-plug

```vim
Plug 'https://git.sr.ht/~nedia/auto_save.nvim'
lua require("auto-save").setup()
```
