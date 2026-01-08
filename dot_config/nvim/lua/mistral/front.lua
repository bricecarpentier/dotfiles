local base = require("mistral.base")

local M = {}

function M.setup(cwd)
    local projectDir = cwd .. '/ts'
    base.setupRootCommand(projectDir)
    base.setupFindInProjectCommand(projectDir)
end

function M.setupLater(cwd)
    base.stopPythonLsps()
    vim.lsp.enable('vtsls', true)
end

return M
