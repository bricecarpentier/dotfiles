local M = {}

local pythonLsps = { "pylsp", "pyright", "ty" }
function M.stopPythonLsps()
    vim.iter(pythonLsps):each(function (l)
        vim.lsp.enable(l, false)
    end)
end

function M.setupRootCommand(dir)
    vim.api.nvim_create_user_command("Root", function()
        require('oil').open(dir)
    end, {})
end

function M.setupFindInProjectCommand(dir)
    vim.api.nvim_create_user_command("FindInProject",
    function()
        require('snacks').picker.files({
            dirs = { dir },
            hidden = true
        })
    end,
    {})
    vim.keymap.set('n', '<leader>fp', ':FindInProject<CR>', { silent = true })
end

return M
