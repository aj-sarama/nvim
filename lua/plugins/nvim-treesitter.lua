-- list of installed languages
-- any languages added to this list will be automatically installed on the next setup() call
local languages = {
    "c", 
    "lua",
    "vim",
    "vimdoc",
    "query",
    -- ALL ABOVE ARE CONSIDERED REQUIRED
    -- ADD NEW LANGUAGES BELOW
    "python",
    "rust",
    "haskell",
}

-- parsers will be installed here
local parser_path = os.getenv("HOME") .. "/.config/nvim/parsers"

vim.opt.runtimepath:append(parser_path)

--[[
    NOTE: 'auto_install' is currently set to false, which should be the case whenever the TreeSitter CLI is not installed.
    -> If you have the TS CLI installed, change 'auto_install' to true to automatically install parsers for languages.
--]]
local options = {
    ensure_installed = languages,
    sync_install = false,
    auto_install = false,
    parser_install_dir = parser_path,

    highlight = {
        enable = true,
        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
        -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
        -- the name of the parser)
        -- list of language that will be disabled
        disable = {},
        additional_vim_regex_highlighting = false,
    },

    incremental_selection = {
        enable = true,
        keymaps = {
            -- set to `false` to disable one of the mappings
            init_selection = "<cr>",
            node_incremental = "<cr>",
            scope_incremental = "<tab>",
            node_decremental = "<s-tab>",
        },
    },

    indent = {
        enable = true,
    },

    -- text object support is included in this config
    textobjects = {
        --[[
            'select' allows for selection on various queries in visual mode.

            the example "af" selects the entire function outer when in a node that is contained by a function
        --]]
        select = {
            enable = true,
            keymaps = {
                ["af"] = { query = "@function.outer", desc = "select function outer (TSObject)" },
                ["if"] = { query = "@function.inner", desc = "select function inner (TSObject)" },
                ["oc"] = { query = "@comment.outer", desc = "select comment (TSObject)" },
            }
        }
    }

}

--[[
    Below are some simple functions that use treesitter utility to swap adjacent nodes using a keymap.
    
    swap_forward() will swap the node that the cursor is on with the next node
    swap_backward() does the same in reverse

    The keymaps for this functionality are set below the functions
--]]
local ts_utils = require('nvim-treesitter.ts_utils')
local function swap_forward()
    local curr_node = ts_utils.get_node_at_cursor()
    local next_node = ts_utils.get_next_node(curr_node, true, true)
    local buffer_number = vim.fn.bufnr('%')
    if curr_node and next_node then
        ts_utils.swap_nodes(curr_node, next_node, buffer_number, true) 
    end
end

local function swap_backward()
    local curr_node = ts_utils.get_node_at_cursor()
    local next_node = ts_utils.get_previous_node(curr_node, true, true)
    local buffer_number = vim.fn.bufnr('%')
    if curr_node and next_node then
        ts_utils.swap_nodes(curr_node, next_node, buffer_number, true) 
    end
end

local function test(a, b, c)
    print("test")
end 

-- KEYMAPS
-- swap node forward
vim.keymap.set("n", "<space>s", swap_forward, { noremap = true, desc = "TS swap forward" })
-- swap node backward
vim.keymap.set("n", "<space>S", swap_backward, { noremap = true, desc = "TS swap backward" })


-- In the event that you want to reassign certain highlight groups, add to this function:
local function change_highlight_groups()
    -- (scope, node type, link = highlight group name)
    -- 0 is the global scope
    vim.api.nvim_set_hl(0, "@keyword.operator", { link = "Conditional" })
end

return { "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false, -- lazy loading treesitter causes more issues than it seems to be worth
    config = function()
        require("nvim-treesitter.configs").setup(options)
        change_highlight_groups()
    end,
}

