local github = function(pkg) return 'https://github.com/' .. pkg end

vim.pack.add({ github('nvim-mini/mini.nvim') })

local now = function(f) require('mini.misc').safely('now', f) end
local later = function(f) require('mini.misc').safely('later', f) end

-- Basic config
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.relativenumber = true
vim.o.number = true

vim.o.splitbelow = true
vim.o.splitright = true

vim.o.signcolumn = "yes"
vim.o.wrap = false
vim.o.winborder = "rounded"
vim.o.exrc = true

require('mini.icons').setup()

-- Treesitter
vim.pack.add({ github('romus204/tree-sitter-manager.nvim') })
now(function()
    require('tree-sitter-manager').setup({
        auto_install = true
    })
end)
-- 
-- Theme
vim.pack.add({ github('navarasu/onedark.nvim') }) -- Theme
now(function()
    require('onedark').load()
end)

-- Commenting
later(function()
    require('mini.comment').setup({
        mappings = {
            comment = '',
            comment_line = '#',
            comment_visual = '#'
        }
    })
end)

-- Motions
vim.pack.add({ github('folke/flash.nvim') })

-- File explorer
vim.pack.add({ github('stevearc/oil.nvim') })
now(function()
    require('oil').setup({
        default_file_explorer = true,
        colums = {
            "icons"
        }
    })
end)

-- Various QoL from folke
vim.pack.add({ github('folke/snacks.nvim') })
local snacks = require('snacks')
snacks.setup({
    explorer = { enabled = true },
    gitbrowse = { enabled = true },
    lazygit = { enabled = true },
    notifier = { enabled = true },
    notify = { enabled = true },
    picker = { enabled = true }
})


-- Lsp Config
vim.pack.add({ github('neovim/nvim-lspconfig') })
vim.pack.add({ github('mason-org/mason.nvim') })
vim.pack.add({ github('mason-org/mason-lspconfig.nvim') })

now(function()
    require('mason-lspconfig.settings').set({
        ensure_installed = { 'lua_ls' },
        automatic_enable = { 'lua_ls' }
    })
end)
later(function()
    require('mason').setup()
    require('mason-lspconfig').setup({})
end)

-- LazyDev
vim.pack.add({ github('folke/lazydev.nvim') })
later(function()
    require('lazydev').setup()
end)

--
-- USER FUNCTIONS
--
local function copyFileName(opts)
    local filename
    if opts.args == 'full' then
        filename = vim.fn.expand('%:p')
    else
        filename = vim.fn.expand('%:t')
    end
    vim.fn.setreg('+', filename)
    print('Copied to clipboard: ' .. filename)
end

--
-- USER COMMANDS
--
vim.api.nvim_create_user_command('Buffers', function() Snacks.picker.buffers() end, {})
vim.api.nvim_create_user_command('ColorSchemes', function() Snacks.picker.colorschemes() end, {})
vim.api.nvim_create_user_command('Diagnostics', function() Snacks.picker.diagnostics() end, {})
vim.api.nvim_create_user_command('DiagnosticsBuffer', function() Snacks.picker.diagnostics_buffer() end, {})
vim.api.nvim_create_user_command('Explore', function() Snacks.explorer() end, {})
vim.api.nvim_create_user_command('Files', function() Snacks.picker.files({ hidden = true }) end, {})
vim.api.nvim_create_user_command('Find', function() Snacks.picker.grep() end, {})
vim.api.nvim_create_user_command('GitBrowse', function() Snacks.gitbrowse() end, {})
vim.api.nvim_create_user_command('GitFiles', function() Snacks.picker.git_files() end, {})
vim.api.nvim_create_user_command('GitStatus', function() Snacks.picker.git_status() end, {})
vim.api.nvim_create_user_command('GitLog', function() Snacks.picker.git_log() end, {})
vim.api.nvim_create_user_command('Help', function() Snacks.picker.help() end, {})
vim.api.nvim_create_user_command('Keymaps', function() Snacks.picker.keymaps() end, {})
vim.api.nvim_create_user_command('LazyGit', function() Snacks.lazygit() end, {})
vim.api.nvim_create_user_command('Recent', function() Snacks.picker.recent() end, {})
vim.api.nvim_create_user_command('Smart', function() Snacks.picker.smart() end, {})
vim.api.nvim_create_user_command('Symbols', function() require('snacks').picker.lsp_symbols() end, {})
vim.api.nvim_create_user_command('WorkspaceSymbols', function() Snacks.picker.lsp_workspace_symbols() end, {})
vim.api.nvim_create_user_command('CopyFileName', copyFileName, {
    nargs = '?',
    complete = function(_, line)
        return { 'full' }
    end,
    desc = 'Copy current file name (or full path with "full") to system clipboard'
})
-- 
-- 
--
-- KEYMAPS
--
vim.keymap.set('n', '=', vim.lsp.buf.format, { silent = false })
vim.keymap.set('n', '<leader>e', ':Oil<CR>', { silent = true })
vim.keymap.set('n', '<leader>fb', ':Buffers<CR>', { silent = true })
vim.keymap.set('n', '<leader>ff', ':Files<CR>', { silent = true })
vim.keymap.set('n', '<leader>fg', ':GitFiles<CR>', { silent = true })
vim.keymap.set('n', '<leader>fr', ':Recent<CR>', { silent = true })
vim.keymap.set('n', '<leader>fs', ':Smart<CR>', { silent = true })
vim.keymap.set('n', '<leader>g', ':LazyGit<CR>', { silent = true })
vim.keymap.set('n', '<leader>h', ':noh<CR>', { silent = true })
vim.keymap.set('n', "grd", vim.lsp.buf.definition, { silent = true })
vim.keymap.set('n', "grr", function() snacks.picker.lsp_references() end, { silent = true })
vim.keymap.set('n', "gri", function() snacks.picker.lsp_implementations() end, { silent = true })
vim.keymap.set('n', 'gO', function() end)
vim.keymap.del('n', 'gO')

vim.keymap.set({ 'n', 'x', 'o' }, 'gs', function() require("flash").jump() end, { silent = true })
vim.keymap.set('c', '<c-s>', function() require("flash").toggle() end, { silent = true })

-- if os.getenv('MISTRAL') then
--     local mistral = require("mistral")
--     now(function() mistral.setup() end)
--     later(function() mistral.later() end)
-- 
--     local project = os.getenv('MISTRAL_PROJECT')
--     if not project then
--         return
--     end
-- 
--     local projectConfig = require("mistral." .. project)
--     if not projectConfig then
--         return
--     end
--     local repoRoot = os.getenv('REPO_ROOT')
--     projectConfig.setup(repoRoot)
--     if (projectConfig.setupLater ~= nil) then
--         later(function() projectConfig.setupLater(repoRoot) end)
--     end
-- end
