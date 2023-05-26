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
Keep *rose-pine.lua* intact as a reference for changing color schemes. Change the *enabled* entry in the plugin options to `false`
to disable the color scheme without deleting it.  
<br>
#### Notes from managing color schemes with lazy:  
1. Set the `priority` entry to `1000` to ensure the color scheme loads first.
2. The `config` function needs to require the module *and* run the vim command to set the color scheme.  

<br>

#### Other issues:
1. Setting the values for certain highlight groups, especially ones for other plugins that will be loaded after the color scheme 
does not currently work as intended. *rose-pine* has a `highlight_groups` table, however it seems that the configuration of other 
plugins afterwards overwrites the highlight groups.  

<br>

#### Current ideas to solve this issue: TODO
1. Modifying the highlight groups after the `setup` call in the `config` function: This has the downside of spreading references to 
highlight groups across several files. However, the highlight group settings would be local to each plugin, so keeping track of 
which highlight group belongs to which plugin coincidentally becomes easier in this case.
2. Adding autocommands to the color scheme *.lua* config: This has the benefit of keeping all highlight group-setting functionality 
within the color scheme plugin setup. The relevant event for the autocommand should be `BufEnter`.

### Tree sitter

TODO

### Telescope

TODO
