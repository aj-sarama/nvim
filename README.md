# Simple Lua Neovim Config
*Author: AJ Sarama*

---

## Lazy Plugin Manager

I use [lazy](https://github.com/folke/lazy.nvim) to manage plugins.

### TODO
...

### Autocommands

TODO: write about autocommands file and what to put in there

### Keymaps

TODO: write about keymaps file and what to put in there

### Settings

TODO: write about settings chosen and what to put in there

### /lua/plugins directory

For each new plugin, create a new file in this directory named *[plugin_name].lua*. 
Follow the specs outlined in [lazy](https://github.com/folke/lazy.nvim)

## Plugin List

### Color scheme

My current color scheme is [rose-pine](https://github.com/rose-pine/neovim), however this is subject to frequent change.
Keep *rose-pine.lua* intact as a reference for changing color schemes. Change the *enabled* entry in the plugin options to false.  
<br>
Notes from managing color schemes with lazy:
1. Set the `priority` entry to `1000` 

### Tree sitter

TODO

### Telescope

TODO
