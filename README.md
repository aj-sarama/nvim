# Lua Neovim Config

---

## Plugin Manager

[lazy](https://github.com/folke/lazy.nvim) is the plugin manager used in this config. `lazy.nvim` lazy-loads plugins in order to 
reduce startup times and spread out the inevitable performance hits many plugins may cause.

## File Structure

```
nvim
├── README.md
├── init.lua
├── lazy-lock.json
├── lua
│   ├── autocommands.lua
│   ├── keymaps.lua
│   ├── plugins
│   │   ├── lspconfig.lua
│   │   ├── nvim-treesitter-textobjects.lua
│   │   ├── nvim-treesitter.lua
│   │   └── ...
│   └── settings.lua
└── parsers
```

### init.lua

`init.lua` requires the 3 `*.lua` files in `lua/` (descriptions of these files are in the following sections). This file also 
sets up the package manager. `lazy.nvim` default configuration can be changed here.

### autocommands.lua

`autocommands.lua` is a file for creating autocommands that do not pertain to a particular plugin. Plugin-specific autocommands 
should go in the `[plugin-name].lua` file in `lua/plugins/`.  
Current autocommands in `autocommands.lua`:  
- None!

### keymaps.lua

`keymaps.lua` is a file for setting non plugin-specific keymappings. For example, `<leader>` is set to `<Space>` in this file.

### settings.lua

`settings.lua` is a file for standard vim settings such as relative line numbers and cursor type.

### /lua/plugins/ Directory

Each plugin used in this config (with some exceptions) has their own `[plugin-name].lua` file. `lazy.nvim` will automatically require 
each of these modules, and each one is expected to return a configuration table that follows the specs outlined in 
[lazy](https://github.com/folke/lazy.nvim).

## Plugin List

1. [rose-pine](https://github.com/rose-pine/neovim) colorscheme
2. [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) for treesitter-based highlighting and motions
3. [telescope](https://github.com/nvim-telescope/telescope.nvim) for fuzzy finding over files, code, and other lists
4. [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) for LSP integration and many powerful motions

# Plugin Details

---

## Color Scheme

My current color scheme is [rose-pine](https://github.com/rose-pine/neovim), however this is subject to frequent change.
Keep `rose-pine.lua` intact as a reference for creating config files for new color schemes. Change the `enabled` entry in the plugin options to `false`
to disable the color scheme without deleting it.  

### Notes from managing color schemes with lazy:  
1. Set the `priority` entry to `1000` to ensure the color scheme loads first.
2. The `config` function needs to require the module *and* run the vim command to set the color scheme.  

### Other issues:
Setting the values for certain highlight groups, especially ones for other plugins that will be loaded after the color scheme 
does not currently work as intended. The `rose-pine` setup has a `highlight_groups` table, however it seems that the configuration of other 
plugins afterwards overwrites the highlight groups. This appears to be an issue specific to managing plugins with `lazy.nvim`.  

### Changing highlight groups per-plugin
Changing highlight groups pertaining to a specific plugin should occur in that plugin's lua module.
There are functions in most of the relevant plugin config files named `set_highlight_groups()`.  


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

## Treesitter

Treesitter manages syntax highlights and motions when writing or editing code.  

### Setting languages:
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

### Changing highlight groups:

Examples for changing highlight groups for treesitter nodes are in `/lua/plugin/nvim-treesitter.lua` `change_highlight_groups()`. 

### Treesitter playground:

*NOTE: treesitter playground is installed but typically disabled in my config. Edit the treesitter playground config to enable it.*  
<br>
Treesitter playground can assist with identifying the highlight groups for making changes. Use the command `:TSHighlightCapturesUnderCursor` 
to get highlight information on a given node. This can be helpful for identifying highlight groups so they can be changed in the 
previously mentioned function.

### Node-based selection:

The following bindings can be useful for somewhat fine-grained incremental selection:
- `<CR>` to initialize incremental selection on the current node (under cursor)
- `<CR>` to include the next node in the selection
- `<Tab>` to increment the scope
- `<S-Tab>` to decrement nodes from the selection

## Treesitter Text Objects

### Selection:

This config supports the following functionality using treesitter text objects:
- `<leader>sf` to select the entire function the cursor-targeted node is currently in (query on the tag `@function.outer`)
- `<leader>sF` to select the inside of the function the cursor-targeted node is currently in (query on the tag `@function.inner`)

More text object queries can be found in the [official documentation](https://github.com/nvim-treesitter/nvim-treesitter-textobjects#text-objects-select).  

### Movement:

- `[[` to go to the beginning of the previous function
- `]]` to go to the beginning of the next function

### Swapping: 

Use the following mappings to swap parameters in tuples, function parameters, etc.:
- `<leader>s` to swap nodes forward
- `<leader>S` to swap nodes backward

## Telescope

### Installed pickers, sorters, extensions
1. None!

<br>

### Telescope keymaps

A function is provided in *telescope.nvim* where the mappings for opening certain pickers should go:
```lua
local function set_keymaps()
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "telescope find file" })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "telescope live grep"})
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "telescope buffers" })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "telescope help pages" })
    vim.keymap.set('n', '<leader>fi', builtin.builtin, { desc = "telescope builtin pickers" })
    vim.keymap.set('n', '<leader>fm', builtin.marks, { desc = "telescope marks" })
    vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = "telescope git files" })
end
```
The above handles most of the commonly used built-in pickers. Search over all built-in pickers using `<leader>fi`.

<br>

A few handy non-default mappings were also added:
- `<C-u>` to clear the current prompt in the telescope window

## LSP

This config does not use an automatic LSP management tool. All language servers should be installed with `brew` (or other package 
manager). 

### Setting up a new language server

To set up a new language server, first make sure it is installed and available somewhere in nvim's `rtp`. Then, add an entry to the 
`lsp` table in `/lua/plugins/lspconfig.lua`. Here is an example for `lua-language-server`:  

```lua
local lsp = {
    -- Lua
    lua_ls = {
        settings = {
            Lua = {
                runtime = {
                    version = 'LuaJIT',
                },
                diagnostics = {
                    globals = { 'vim' },
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    },
}
```
Each language server has their own unique settings and defaults to configure. See `nvim-lspconfig` [server configuration](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md)
for details on how to install and set up a specific language server.  

### Keymappings

The following are default key mappings for all language servers in this config. Note that not all functionality is available for every language server.  

- `<leader>gD` to go to declaration (under cursor)
- `<leader>gd` to go to definition (under cursor)
- `<leader>h` show hovering window with information about text under the cursor
- `<leader>I` to go to implementation (under cursor)
- `<leader>gt` to go to the type definition (under cursor)
- `<leader>rn` to rename a node (under cursor)
- `<leader>F` to asynchronously run the attached LSP's formatter on the current file

### Diagnostics

The following functionality for working with language server diagnostics (such as errors and warnings) was also included:
- `<leader>e` to open the in-line diagnostic message into a floating window
- `[d` to jump to the previous diagnostic in the file
- `]d` to jump to the next diagnostic in the file
- `<leader>ce` to copy the diagnostic sourced under the cursor into the system clipboard (this is a custom function I wrote in `/lua/plugins/lspconfig.lua`)

### Code Actions

Code actions are not yet implemented.

### Debugging LSP

The first step in determining whether an LSP is working is to run `:LspInfo` and verify that the expected LSP is attached to the 
current buffer.

## Autocomplete + Snippets

Since autocomplete and LSP go hand-in-hand, their setups are included in the same file. `cmp.nvim` is set up in the `init` function 
in `/lua/plugins/nvim-lspconfig.lua`. Connecting autocomplete functionality to the LSP is done automatically in the `config` function.  

### Keymappings

The following keymappings are used to navigate the autocomplete windows that will show up when writing code:
- `<C-b>` scroll the preview documentation up 4 lines
- `<C-f>` scroll the preview documentation down 4 lines
- `<C-Space>` complete the selected mapping
- `<C-e>` abort the mapping window
- `<CR>` autocomplete *NOTE: the snippet must be selected explicitly for <CR> to complete*

### Snippets

`LuaSnip.nvim` is the snippet engine used together with `cmp.nvim`. No additional snippet functionality has been added outside of 
the defaults.



