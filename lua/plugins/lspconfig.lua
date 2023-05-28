local lspconfig = require('lspconfig')
-- see server_configurations.md to configure individual servers

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


-- add all keymaps here
local function set_keymaps()
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "open diagnostic float" })
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "go to previous diagnostic" })
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "go to next diagnostic" })
    vim.keymap.set('n', '<leader>ce',
        function()
            local function success(diagnostic)
                print("Successfully copied error to the clipboard!")
                vim.fn.setreg('+', diagnostic.message)
            end

            local r, c = unpack(vim.api.nvim_win_get_cursor(0))
            local diagnostics = vim.diagnostic.get(0, { lnum = r - 1 })
            if #diagnostics == 1 then
                success(diagnostics[1])
            end

            for _, diagnostic in pairs(diagnostics) do
                if c >= diagnostic.col then
                    -- end_col is not a required field of diagnostic-structure
                    if diagnostic.end_col and c >= diagnostic.end_col then
                        return
                    end
                    success(diagnostic)
                end
            end
        end,

        { desc = "copy error into register" })
end

-- these need to be in an autocommand group since they should only be used after the lsp has attached
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        vim.keymap.set('n', '<leader>gD', vim.lsp.buf.declaration,
            {
                buffer = ev.buf,
                desc = "go to declaration LSP"
            })
        vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, {
            buffer = ev.buf,
            desc = "go to definition LSP"
        })
        vim.keymap.set('n', '<leader>h', vim.lsp.buf.hover, {
            buffer = ev.buf,
            desc = "hover LSP information"
        })
        vim.keymap.set('n', '<leader>I', vim.lsp.buf.implementation, {
            buffer = ev.buf,
            desc = "implementation LSP"
        })
        vim.keymap.set('n', '<leader>gt', vim.lsp.buf.type_definition, {
            buffer = ev.buf,
            desc = "go to type definition LSP"
        })
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {
            buffer = ev.buf,
            desc = "rename node under cursor LSP"
        })
        vim.keymap.set('n', '<leader>F',
            function()
                vim.lsp.buf.format { async = true }
            end,
            { buffer = ev.buf, desc = "format current file LSP" })
    end,
})

return {
    "neovim/nvim-lspconfig",
    lazy = false, -- cannot be lazy loaded because autocommands need to be set
    enabled = true,
    config = function(_, opts)
        for server, settings in pairs(lsp) do
            lspconfig[server].setup(settings)
        end
        set_keymaps()
    end,
}
