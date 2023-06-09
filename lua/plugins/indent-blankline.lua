local options = {
    char_highlight_list = {
        "IndentBlanklineIndent1",
    },
}

local function set_highlight_groups()
    local colors = require('rose-pine.palette')
    vim.api.nvim_set_hl(0, "IndentBlanklineIndent1", { fg = colors["highlight_low"], bg = "none", nocombine = true })
end

return {
    "lukas-reineke/indent-blankline.nvim",
    lazy = true,
    opts = options,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    init = function()
        set_highlight_groups()
    end,
    event = "BufEnter",
}
