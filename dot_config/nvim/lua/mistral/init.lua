local base = require('mistral.base')

local M = {}

function M.setup()
    local settings = require("mason-lspconfig.settings")
    local ensure_installed = vim.tbl_deep_extend(
        "force",
        settings.current.ensure_installed,
        {
            "pylsp",
            "pyright",
            "ty",
            "vtsls"
        }
    )
    settings.set({ ensure_installed = ensure_installed })

    vim.lsp.config("pylsp", {
        plugins = {
            black = { enabled = false },
            autopep8 = { enabled = false },
            yapf = { enabled = false },
            pyflakes = { enabled = false },
            pycodestyle = { enabled = false },
            pylsp_mypy = { enabled = true },
            pyls_isort = { enabled = true },

        }
    })

    vim.api.nvim_create_user_command("Pylsp", function()
        base.stopPythonLsps()
        vim.lsp.enable("pylsp", true)
    end, {})

    vim.api.nvim_create_user_command("Pyright", function()
        base.stopPythonLsps()
        vim.lsp.enable("pyright", true)
    end, {})

    vim.api.nvim_create_user_command("Ty", function()
        base.stopPythonLsps()
        vim.lsp.enable("ty", true)
    end, {})

    vim.api.nvim_create_user_command("Ts", function()
        vim.lsp.enable("vtsls", false)
        vim.lsp.enable("vtsls", true)
    end, {})
end

function M.later()
    vim.lsp.enable("pylsp")
end

return M
