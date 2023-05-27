local telescopeConfig = require("telescope.config")
-- Clone the default Telescope configuration
local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

-- enables searching in hidden files
table.insert(vimgrep_arguments, "--hidden")
-- disables searching in the .git/ folder
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")

local action_layout = require("telescope.actions.layout")
local actions = require("telescope.actions")
local options = {
    defaults = {
        -- Default configuration for telescope goes here:
        -- config_key = value,
        mappings = {
            i = {
                ["<C-h>"] = "which_key", -- open which-key menu
                ["<Esc>"] = actions.close, -- close the prompt in insert mode
                ["<C-u>"] = false, -- clear the current prompt

                --["<C-j>"] = action_layout.toggle_preview, -- need to think about speed
            }
        }
    },
    pickers = {
        -- Default configuration for builtin pickers goes here:
        -- picker_name = {
        --   picker_config_key = value,
        --   ...
        -- }
        -- Now the picker_config_key will be applied every time you call this
        -- builtin picker
        find_files = {
		    -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
	        find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
		},
    },
    extensions = {
        -- Your extension configuration goes here:
        -- extension_name = {
        --   extension_config_key = value,
        -- }
        -- please take a look at the readme of the extension you want to configure
    },
}

-- put the setting of all highlight groups in this function
-- this function was written specifically to be used with rose-pine
local function set_highlight_groups()
    local util = require("rose-pine.util")
    util.highlight("TelescopeBorder", { fg = "highlight_high", bg = "none" })
    util.highlight("TelescopeNormal", { bg = "none" })
    util.highlight("TelescopePromptNormal", { bg = "base" })
    util.highlight("TelescopeResultsNormal", { fg = "subtle", bg = "none" })
    util.highlight("TelescopeSelection", { fg = "text", bg = "base" })
    util.highlight("TelescopeSelectionCaret", { fg = "rose", bg = "rose" })
end

-- sets all keymappings, called on init
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




return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.1',
    lazy = true,
    enabled = true,
    opts = options,
    config = function(_, opts)
        require("telescope").setup(opts)
        set_highlight_groups() -- this appears to work better in config than init
    end,
    init = function()
        set_keymaps()
    end,
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = "BufEnter",
}
