# Simple Lua Neovim Config

---

## Lazy Plugin Manager

I use [lazy](https://github.com/folke/lazy.nvim) to manage plugins.

### TODO
...

### Autocommands

TODO: write about autocommands file and what to put in there

### Keymaps

The file *lua/keymaps.lua* should set any non-plugin keymappings. `<leader>` is set to `<space>` in this file.

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
Setting the values for certain highlight groups, especially ones for other plugins that will be loaded after the color scheme 
does not currently work as intended. *rose-pine* has a `highlight_groups` table, however it seems that the configuration of other 
plugins afterwards overwrites the highlight groups. This appears to be an issue specific to managing plugins with lazy.  
<br>

#### Changing highlight groups per-plugin
The changing of highlight groups pertaining to a specific plugin are located within functions in the lua config files for that 
specific plugin.  

Here is an example of a function changing the highlight groups for `telescope.nvim`. The function is called in the `config` 
function provided to lazy:
```lua
local function set_highlight_groups()
    local util = require("rose-pine.util")
    util.highlight("TelescopeBorder", { fg = "highlight_high", bg = "none" })
    util.highlight("TelescopeNormal", { bg = "none" })
    util.highlight("TelescopePromptNormal", { bg = "base" })
    util.highlight("TelescopeResultsNormal", { fg = "subtle", bg = "none" })
    util.highlight("TelescopeSelection", { fg = "text", bg = "base" })
    util.highlight("TelescopeSelectionCaret", { fg = "rose", bg = "rose" })
end
```

<br>

### Treesitter

Treesitter manages syntax highlights and motions when writing or editing code.  

#### Setting languages:
Add any language (see `:TSModuleInfo` for a list of supported languages) by adding an element to this table in *nvim-treesitter.lua*:  
```lua
local languages = {
    "c", 
    "lua",
    "vim",
    "vimdoc",
    "query",
    -- ADD NEW LANGUAGES BELOW
    "python",
    "rust",
    "haskell",
}
```  
*note that the nvim-treesitter documentation recommends not removing the first 5 parsers listed*  
<br>
The treesitter parsers will be installed inside `/.config/nvim/parsers`. 
<br>

#### Changing highlight groups:

Examples for changing highlight groups for treesitter nodes are in */lua/plugin/nvim-treesitter.lua* `change_highlight_groups()`. 

#### Treesitter playground:

*NOTE: treesitter playground is installed but typically disabled in my config. Edit the treesitter playground config to enable it.*  
<br>
Treesitter playground can assist with identifying the highlight groups for making changes. Use the command `:TSHighlightCapturesUnderCursor` 
to get highlight information on a given node. This can be helpful for identifying highlight groups so they can be changed in the 
previously mentioned function.

### Treesitter text objects

#### Selection:

Use the following mappings in visual mode:
- `<leader>sf` to select the entire function the cursor-targeted node is currently in (query on the tag `@function.outer`)
- `<leader>sF` to select the inside of the function the cursor-targeted node is currently in (query on the tag `@function.inner`)

More text object queries can be found in the [official documentation](https://github.com/nvim-treesitter/nvim-treesitter-textobjects#text-objects-select).  

#### Movement:

Use the following motions:  
- `[[` to go to the beginning of the previous function
- `]]` to go to the beginning of the next function

#### Swapping: 

Use the following mappings to swap parameters in tuples, function parameters, etc.:
- `<leader>s` to swap nodes forward
- `<leader>S` to swap nodes backward



### Telescope



#### Pickers used
1. LSP picker TODO  

<br>

#### Changing telescope keymaps

A function is provided in *telescope.nvim* where the mappings for opening certain pickers should go:
```lua
local function set_keymaps()
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
    vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
end
```

#### Current keymaps

- `<leader>ff` to pick a file
- `<leader>fg` to do a live string grep
- `<leader>fb` to pick a buffer
- `<leader>fh` to pick help tags


### LSP





TODO
