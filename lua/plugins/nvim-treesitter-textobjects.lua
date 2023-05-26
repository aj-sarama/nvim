-- the treesitter objects config is tied to the treesitter config.
-- find all the text object mappings and logic in nvim-treesitter.lua
return {
    "nvim-treesitter/nvim-treesitter-textobjects",
    lazy = false, -- treesitter currently isn't lazy loaded
    enabled = true,
    dependencies = {"nvim-treesitter/nvim-treesitter"},
    opts = options,
}
