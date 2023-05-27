local options = {
  defaults = {
    -- Default configuration for telescope goes here:
    -- config_key = value,
    mappings = {
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        ["<C-h>"] = "which_key"
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
  },
  extensions = {
    -- Your extension configuration goes here:
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure
  }
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

return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.1',
    lazy = true,
    enabled = true,
    opts = options,
    config = function(_, opts)
        require("telescope").setup(opts)

        vim.keymap.set("n", "<space>ff", ":Telescope find_files<CR>")
        set_highlight_groups()
    end,
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = "BufEnter",
}
