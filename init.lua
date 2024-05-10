-- settings from https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.breakindent = true
vim.o.clipboard = "unnamedplus"
vim.o.completeopt = "menuone,noselect"
vim.opt.hlsearch = true
vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.linebreak = true
vim.o.mouse = "a"
vim.o.shiftwidth = 4
vim.o.smartcase = true
vim.o.tabstop = 4
vim.o.termguicolors = true
vim.o.timeoutlen = 500
vim.o.undofile = true
vim.o.updatetime = 250
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.signcolumn = "yes"


-- set keybinds
vim.keymap.set("n", "<leader>b", ":e #<CR>", {})
vim.keymap.set("n", "<leader>E", vim.cmd.Ex, {})
vim.keymap.set("n", "<leader>t", ":terminal<CR>", {})
vim.keymap.set("n", "<leader>T", ":tabnew | term<CR>", {})
vim.keymap.set("n", "<leader>n", ":bnext<CR>", {})
vim.keymap.set("n", "<leader>p", ":bprevious<CR>", {})
vim.keymap.set("n", "<leader>g", vim.cmd.Git)
vim.keymap.set("v", "ga", "<Plug>(EasyAlign)")
vim.keymap.set("n", "ga", "<Plug>(EasyAlign)")
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })


-- Comment: https://github.com/numToStr/Comment.nvim
require("Comment").setup()


-- fidget: https://github.com/j-hui/fidget.nvim
require("fidget").setup()


-- gitsigns: https://github.com/lewis6991/gitsigns.nvim
require('gitsigns').setup()


-- none-ls: https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md
local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.biome,
        null_ls.builtins.formatting.markdownlint,
    },
})


-- telescope: https://github.com/nvim-telescope/telescope.nvim
require("telescope").setup {}
pcall(require("telescope").load_extension, "fzf")
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>sb", builtin.buffers, {})
vim.keymap.set("n", "<C-e>", builtin.find_files, {})
vim.keymap.set("n", "<leader>sg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>sh", builtin.help_tags, {})



-- treesitter: https://github.com/nvim-treesitter/nvim-treesitter
require "nvim-treesitter.configs".setup {
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}


-- lspconfig-
-- see server configurations: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local lspconfig = require("lspconfig")

---Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.bashls.setup {}
lspconfig.cssls.setup {}
lspconfig.ruff_lsp.setup {
    init_options = {
        settings = {
            args = { "--ignore", "F841", "--ignore", "F401" },
        }
    }
}
lspconfig.clangd.setup {}
lspconfig.dockerls.setup {}
lspconfig.html.setup {
    capabilities = capabilities,
}
lspconfig.hls.setup {} -- haskell
lspconfig.jdtls.setup { cmd = { "jdt-language-server", "-configuration", "/home/alis/.cache/jdtls/config", "-data", "/home/alis/.cache/jdtls/workspace" } }
lspconfig.lemminx.setup {}
lspconfig.lua_ls.setup {
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
            },
            diagnostics = {
                globals = {
                    'vim',
                    'require'
                },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
            },
        },
    },
}
lspconfig.pyright.setup {
    settings = {
        python = {
            analysis = {
                diagnosticSeverityOverrides = {
                    reportUnusedVariable = "none"
                }
            }
        }
    }
}
lspconfig.rust_analyzer.setup {}
lspconfig.tsserver.setup {}

-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>f", function()
            vim.lsp.buf.format { async = true }
        end, opts)
    end,
})


-- nvim-cmp
local cmp = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()
luasnip.config.setup {}

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    completion = {
        completeopt = "menu,menuone,noinsert"
    },
    mapping = cmp.mapping.preset.insert {
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete {},
        ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
    },
}


-- disable line numbers and startinsert in :terminal
vim.api.nvim_create_autocmd({ "TermOpen" }, {
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"
        vim.cmd("startinsert")

        if vim.g.colors_name == "adwaita" then
            vim.opt_local.winhighlight = "Normal:TermNormal,EndOfBuffer:TermEndOfBuffer"
        end
    end,
})

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
    callback = function()
        if vim.g.colors_name == "adwaita" then
            local normal_bg   --- @type string
            local normal_fg   --- @type string
            local terminal_bg --- @type string
            local terminal_fg --- @type string
            local border      --- @type string
            local line_nr     --- @type string

            if vim.o.background == "dark" then
                normal_bg = "#242424"
                normal_fg = "#c0bfbc"
                terminal_bg = "#1e1e1e"
                terminal_fg = "#ffffff"
                border = "#4f4f4f"
                line_nr = "#5e5c64"
            else
                normal_bg = "#fcfcfc"
                normal_fg = "#504e55"
                terminal_bg = "#ffffff"
                terminal_fg = "#000000"
                border = "#c0bfbc"
                line_nr = "#b0afac"
            end

            vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = normal_bg, fg = normal_bg })
            vim.api.nvim_set_hl(0, "LineNrAbove", { fg = line_nr })
            vim.api.nvim_set_hl(0, "LineNr", { fg = "#9a9996", bold = true })
            vim.api.nvim_set_hl(0, "LineNrBelow", { fg = line_nr })
            vim.api.nvim_set_hl(0, "Normal", { bg = normal_bg, fg = normal_fg })
            vim.api.nvim_set_hl(0, "SignColumn", { bg = normal_bg })
            vim.api.nvim_set_hl(0, "TablineSel", { bg = normal_bg })
            vim.api.nvim_set_hl(0, "VertSplit", { bg = normal_bg, fg = border })

            vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#33b2a4", bg = normal_bg })
            vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#ff7800", bg = normal_bg })
            vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#f66151", bg = normal_bg })

            vim.api.nvim_set_hl(0, "TermNormal", { bg = terminal_bg, fg = terminal_fg })
            vim.api.nvim_set_hl(0, "TermEndOfBuffer", { bg = terminal_bg, fg = terminal_bg })
        end
    end
})


vim.cmd("colorscheme adwaita")
