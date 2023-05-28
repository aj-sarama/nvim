return {
    "ggandor/leap.nvim",
    lazy = true,
    event = "BufEnter",
    opts = {},
    config = function()
        require('leap').add_default_mappings()
    end
}
