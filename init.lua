vim.cmd('syntax on')
vim.cmd('filetype plugin indent on')

vim.opt.shiftwidth = 4 --default tab size
vim.opt.tabstop    = 4 --default tab size
vim.opt.expandtab  = true --use sepaces instead of tabs
vim.opt.colorcolumn = "120" 
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.wrap = false

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        -- add your plugins here
        ---------------------------------------------------------
        -- 1️⃣ Dracula Pro – loaded from a *local* directory
        -----------------------------------------------------------------
        {
            -- The name shown in `:Lazy` UI – can be anything you like.
            'dracula-pro-local',

            -- 👇 THIS IS THE IMPORTANT LINE.
            -- Give Lazy the absolute path to the folder that contains the repo.
            -- Use `vim.fn.expand()` if you want to use `~` for your home dir.
            dir = vim.fn.expand("~/.local/share/nvim/site/pack/themes/start/dracula_pro"),

            -- Load it right away (otherwise you’d have to call `require('lazy').load(...)` later).
            lazy = false,

            -- Give it a high priority so it’s available before UI plugins query the colourscheme.
            priority = 1000,

            -- Optional: run a tiny config after the plugin is on the runtimepath.
            config = function()
                -- Call the wrapper you wrote (see Section 3) – you can also call the
                -- dracula‑pro setup directly here if you prefer.
                vim.cmd("colorscheme dracula_pro_lincoln")
            end,
        },
        -- Syntax highlighting
        { "nvim-treesitter/nvim-treesitter", branch = 'master', lazy = false, build = ":TSUpdate" },
        -- EditorConfig support
        { "editorconfig/editorconfig-vim" },
        -- Language Server Configuration
        { "neovim/nvim-lspconfig" },
        { 
            "nvim-tree/nvim-tree.lua", 
            lazy = false,
            dependencies = {
                "nvim-tree/nvim-web-devicons",
            },
            config = function()
                require("nvim-tree").setup {
                    view = { width = {} }
                }
            end,
        },
        -- Find Files   
        {
            'nvim-telescope/telescope.nvim', version = '*',
            dependencies = {
                'nvim-lua/plenary.nvim',
                -- optional but recommended
                -- { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
            }
        },
        -- LSP "problems" icons in the gutter   
        { "TomDeneire/lsp-in-gutter.nvim", config=true },
        -- Bottom status bar
        {
            'nvim-lualine/lualine.nvim',
            dependencies = { 'nvim-tree/nvim-web-devicons' }
        },
        -- Show problem descriptions inline
        {
            "rachartier/tiny-inline-diagnostic.nvim",
            event = "VeryLazy",
            priority = 1000,
            opts = {},
        },
        -- Autocomplete
        {
            "hrsh7th/nvim-cmp",
            event = "InsertEnter",
            dependencies = {
                {
                    -- snippet plugin
                    "L3MON4D3/LuaSnip",
                    dependencies = "rafamadriz/friendly-snippets",
                    opts = { history = true, updateevents = "TextChanged,TextChangedI" },
                    config = function(_, opts)
                        require("luasnip").config.set_config(opts)
                        --require "nvchad.configs.luasnip"
                    end,
                },

                -- autopairing of (){}[] etc
                {
                    "windwp/nvim-autopairs",
                    opts = {
                        fast_wrap = {},
                        disable_filetype = { "TelescopePrompt", "vim" },
                    },
                    config = function(_, opts)
                        require("nvim-autopairs").setup(opts)

                        -- setup cmp for autopairs
                        local cmp_autopairs = require "nvim-autopairs.completion.cmp"
                        require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
                    end,
                },

                -- cmp sources plugins
                {
                    "saadparwaiz1/cmp_luasnip",
                    "hrsh7th/cmp-nvim-lua",
                    "hrsh7th/cmp-nvim-lsp",
                    "hrsh7th/cmp-buffer",
                    "https://codeberg.org/FelipeLema/cmp-async-path.git",
                },
            },
            opts = {}
        },
        -- Debugger
        {
            "mfussenegger/nvim-dap",
            dependencies = {
                "rcarriga/nvim-dap-ui",
            },
            event = "VeryLazy"
        },
        -- TestUI
        { "nvim-neotest/nvim-nio" },
        {
            "Issafalcon/neotest-dotnet",
            lazy = false,
            dependencies = {
                "nvim-neotest/neotest"
            }
        },
        -- So we can run the debugger from nvim
        {
            'ramboe/ramboe-dotnet-utils',
            dependencies = { 'mfussenegger/nvim-dap' }
        },
        {
            "folke/which-key.nvim",
            event = "VeryLazy",
            opts = {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            },
            keys = {
                {
                    "<leader>?",
                    function()
                        require("which-key").show({ global = false })
                    end,
                    desc = "Buffer Local Keymaps (which-key)",
                },
            },
        },
        {
            'stevearc/conform.nvim',
            opts = {},
        },
        -- Buffer picker
        {
            "leath-dub/snipe.nvim",
            keys = {
                {"gb", function () require("snipe").open_buffer_menu() end, desc = "Open Snipe buffer menu"}
            },
            opts = {}
        }
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    -- install = { colorscheme = { "habamax" } },
    -- automatically check for plugin updates
    checker = { enabled = true },
})

require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
    },
})

require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "lua",
        "vim",
        "vimdoc",
        "markdown",
        "markdown_inline",
        "c_sharp",
        "razor",
        "html",
        "css",
        "javascript",
        "jsdoc",
        "powershell",
        "typescript",
        "xml",
        "json",
        "yaml",
        "sql",
        "dockerfile"
    },
    highlight = {
        enable = true
    },
    indent = {
        enable = true
    }
})

vim.lsp.enable("roslyn_ls")
vim.lsp.enable("lua_ls")
vim.lsp.enable("jsonls")
vim.lsp.enable("html")
vim.lsp.inlay_hint.enable()

vim.keymap.set("n", "<C-n>", "<Cmd>NvimTreeToggle<CR>", {})

require('telescope').setup({
    defaults = {
        layout_strategy = 'vertical',
        layout_config = {
            vertical = { width = 120 }
            -- other layout configuration here
        },
        -- other defaults configuration here
    },
    -- other configuration values here
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

vim.keymap.set('n', "<F12>", vim.lsp.buf.definition, {desc = 'Jump to Definition'})
vim.keymap.set("n", "<C-k>c", "<Plug>(comment_toggle_linewise_current)", { silent = true })
vim.opt.termguicolors = true

require("lualine").setup({
    sections = {
        lualine_c = {
            {
                'filename',
                path = 1,
                file_status = true
            }
        }
    }
})
require("lsp-in-gutter").setup()
require("tiny-inline-diagnostic").setup()
local cmp = require('cmp')
cmp.setup({
    snippet = {
        expand = function(args)
            equire('luasnip').lsp_expand(args.body)
        end
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "nvim_lua" },
        { name = "async_path" },
    },
})
local dap = require("dap")
local netcoredbg_adapter = {
    type = "executable",
    command = "/snap/bin/netcoredbg",
    args = { "--interpreter=vscode" },
}

dap.adapters.coreclr = netcoredbg_adapter
dap.adapters.netcoredbg = netcoredbg_adapter
dap.configurations.cs = {
    {
        type = "coreclr",
        name = "launch - netcoredbg",
        request = "launch",
        program = function()
            return require("dap-dll-autopicker").build_dll_path()
        end,
    },
}
vim.keymap.set("n", "<F5>", dap.continue, { desc = "DAP: Continue/Start"})
vim.keymap.set("n", "<F9>", dap.toggle_breakpoint, { desc = "DAP: Toggle breakpoint"})
vim.keymap.set("n", "<F10>", dap.step_over, { desc = "DAP: Step over"})
vim.keymap.set("n", "<F11>", dap.step_into, { desc = "DAP: Step into"})
vim.keymap.set("n", "<F8>", dap.step_out, { desc = "DAP: Step out"})
vim.keymap.set("n", "<leader>dr", dap.repl.open, {desc = "DAP: REPL open"})
vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "DAP: Run last"})

local dapui = require("dapui")

-- open the ui as soon as we are debugging
dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

-- https://emojipedia.org/en/stickers/search?q=circle
vim.fn.sign_define('DapBreakpoint',
{
    text = '⚪',
    texthl = 'DapBreakpointSymbol',
    linehl = 'DapBreakpoint',
    numhl = 'DapBreakpoint'
})

vim.fn.sign_define('DapStopped',
{
    text = '🔴',
    texthl = 'yellow',
    linehl = 'DapBreakpoint',
    numhl = 'DapBreakpoint'
})
vim.fn.sign_define('DapBreakpointRejected',
{
    text = '⭕',
    texthl = 'DapStoppedSymbol',
    linehl = 'DapBreakpoint',
    numhl = 'DapBreakpoint'
})

-- more minimal ui
dapui.setup({
    expand_lines = true,
    controls = { enabled = true }, 
    floating = { border = "rounded" },

    -- Set dapui window
    render = {
        max_type_length = 60,
        max_value_lines = 200,
    },

    -- Only one layout: just the "scopes" (variables) list at the bottom
    --  layouts = {
        --    {
            --      elements = {
                --        { id = "scopes", size = 1.0 }, -- 100% of this panel is scopes
                --      },
                --      size = 15,                       -- height in lines (adjust to taste)
                --      position = "bottom",             -- "left", "right", "top", "bottom"
                --    },
                --  },
            })



            vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "DAP UI toggle"})
            vim.keymap.set({ "n", "v" }, "<leader>dw", function() dapui.eval(nil, { enter = true }) end, { desc = "DAP Add word under cursor to Watches"})
            vim.keymap.set({ "n", "v" }, "Q", function() dapui.eval() end, {desc = "DAP Peek"})

            local neotest = require("neotest")

            vim.keymap.set("n", "<leader>dt", function() neotest.run.run({ strategy = "dap" }) end, {desc = "Debug nearest test"})
            vim.keymap.set("n", "<F6>", function() neotest.run.run({ strategy = "dap" }) end, {desc = "Debug nearest test"})

            vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, {desc = "LSP Rename symbol"})

            -- IMPORTANT: vim diagnostic configuration AFTER LSPs are loaded
            vim.diagnostic.config(
                {
                    underline = true,
                    virtual_text = false,
                    update_in_insert = false,
                    severity_sort = true,
                    signs = {
                        text = {
                            [vim.diagnostic.severity.ERROR] = " ",
                            [vim.diagnostic.severity.WARN]  = " ",
                            [vim.diagnostic.severity.HINT]  = " ",
                            [vim.diagnostic.severity.INFO]  = " ",
                        }
                    }
                }
            )
