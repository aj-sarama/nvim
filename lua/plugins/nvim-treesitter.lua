-- list of installed languages
-- automatic install set to OFF
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

-- parsers will be installed inside the config directory somewhere
local parser_path = os.getenv("HOME") .. "/.config/nvim/parsers"

vim.opt.runtimepath:append(parser_path)
local options = {
    ensure_installed = languages,
    sync_install = false,
    -- Keep set to false unless TreeSitter CLI Installed
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
    }

}
test = { "a", "b", "c" }
-- adding swap capabilities via a keymap
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

-- keymaps
vim.keymap.set("n", "<space>s", swap_forward, { noremap = true, desc = "TS swap forward" })
vim.keymap.set("n", "<space>S", swap_backward, { noremap = true, desc = "TS swap backward" })

-- changing highlight groups

return { "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false, -- lazy loading treesitter causes more issues than it seems to be worth
    config = function()
        require("nvim-treesitter.configs").setup(options)
        vim.api.nvim_set_hl(0, "@keyword.operator", { link = "Conditional" })
    end,
}

