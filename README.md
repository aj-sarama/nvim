# Simple Lua Neovim Config
*Author: AJ Sarama*

---

## Lazy Plugin Manager

I use [lazy](https://github.com/folke/lazy.nvim) to manage plugins. The file structure is as follows:
nvim/  
├── README.md
├── init.lua
├── lazy-lock.json
├── lua
│   ├── autocommands.lua
│   ├── keymaps.lua
│   ├── plugins
│   │   ├── nvim-treesitter.lua
│   │   ├── rose-pine.lua
│   │   ├── telescope.lua
│   │   ├── treesitter-playground.lua
│   │   └── which-key.lua
│   └── settings.lua
└── parsers
    ├── parser
    │   ├── c.so
    │   ├── haskell.so
    │   ├── lua.so
    │   ├── python.so
    │   ├── query.so
    │   ├── rust.so
    │   ├── vim.so
    │   └── vimdoc.so
    └── parser-info
        ├── c.revision
        ├── haskell.revision
        ├── lua.revision
        ├── python.revision
        ├── query.revision
        ├── rust.revision
        ├── vim.revision
        └── vimdoc.revision

## Autocommands

TODO: write about autocommands file and what to put in there

## Keymaps

TODO: write about keymaps file and what to put in there

## Settings

TODO: write about settings chosen and what to put in there

## /lua/plugins directory

For each new plugin, create a new file in this directory named *[plugin_name].lua*. 
Follow the specs outlined in [lazy](https://github.com/folke/lazy.nvim)
