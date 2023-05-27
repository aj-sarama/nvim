-- Below is a table of languages that will be installed when setup() is run
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

-- parsers will be installed inside your nvim/ directory
local parser_path = os.getenv("HOME") .. "/.config/nvim/parsers"
vim.opt.runtimepath:append(parser_path)

--[[
    NOTE: 'auto_install' is currently set to false, which should be the case whenever the TreeSitter CLI is not installed.
          If you have the TS CLI installed, change 'auto_install' to true to automatically install parsers for languages.
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

            selection modes changes the visual mode for a particular query (ex. "V" for linewise selection)
        --]]
        select = {
            enable = true,
            keymaps = {
                ["<leader>sf"] = { query = "@function.outer", desc = "select function outer" },
                ["<leader>sF"] = { query = "@function.inner", desc = "select function inner" },
            },
            selection_modes = {
                -- select entire lines for these queries
                ["@function.outer"] = "V",
                ["@function.inner"] = "V",
            },
            include_surrounding_whitespace = true,
        },
        --[[
            'move' allows for cursor movement options on various queries
        --]]
        move = {
            enable = true,
            set_jumps = true, -- makes these motions change the jump list
            -- goes to the start of the next match based on the query
            goto_next_start = {
                ["]]"] = { query = "@function.outer", desc = "next function start" },
            },
            -- goes to the end of the next match
            goto_next_end = {
            },
            -- goes to the start of the next match in reverse order
            goto_previous_start = {
                ["[["] = { query = "@function.outer", desc = "prev function start" },
            },
            -- goes to the end of the next match in reverse order
            goto_previous_end = {
            },
        },
        --[[
            'swap' implements swapping parameters using text objects
        --]]
        swap = {
            enable = true,
            swap_next = {
                ["<leader>s"] = { query = "@parameter.inner", desc = "swap with next parameter" },
            },
            swap_previous = {
                ["<leader>S"] = { query = "@parameter.inner", desc = "swap with previous parameter" },
            }
        },
    }

}

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

