local base = require("mistral.base")

local M = {}

function M.setup(cwd)
    local projectDir = cwd .. '/kazekit'
    base.setupRootCommand(projectDir)
    base.setupFindInProjectCommand(projectDir)
end

return M
