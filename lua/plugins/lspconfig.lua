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

    -- Python
    pyright = {},
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
    dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/nvim-cmp',
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip',
        'windwp/nvim-autopairs',
    },

    -- init will set up autocompletion
    init = function()
        local cmp = require("cmp")

        cmp.setup({
            enabled = function()
                -- disable completion in comments
                local context = require 'cmp.config.context'
                -- keep command mode completion enabled when cursor is in a comment
                if vim.api.nvim_get_mode().mode == 'c' then
                    return true
                else
                    return not context.in_treesitter_capture("comment")
                        and not context.in_syntax_group("Comment")
                end
            end,
            -- a snippet engine MUST be used. LuaSnip is used here
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users
                end,
            },

            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },

            mapping = cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            }),

            sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' }, -- For luasnip users.
                },
                {
                    { name = 'buffer' },
                }),
        })

        -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline({ '/', '?' }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = 'buffer' }
            }
        })

        -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = 'path' }
            }, {
                { name = 'cmdline' }
            })
        })
    end,

    config = function(_, opts)
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        for server, settings in pairs(lsp) do
            settings.capabilities = capabilities
            lspconfig[server].setup(settings)
        end
        set_keymaps()
        local cmp_autopairs = require('nvim-autopairs.completion.cmp')
        local cmp = require('cmp')
        cmp.event:on(
            'confirm_done',
            cmp_autopairs.on_confirm_done()
        )
    end,
}
