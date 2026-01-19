local path_package = vim.fn.stdpath('data') .. '/site'
local mini_path = path_package .. '/pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
    vim.cmd('echo "Installing `mini.nvim`" | redraw')
    local clone_cmd = {
        'git', 'clone', '--filter=blob:none',
        -- Uncomment next line to use 'stable' branch
        -- '--branch', 'stable',
        'https://github.com/echasnovski/mini.nvim', mini_path
    }
    vim.fn.system(clone_cmd)
    vim.cmd('packadd mini.nvim | helptags ALL')
    vim.cmd('echo "Installed `mini.nvim`" | redraw')
end
-- Mini.deps
require('mini.deps').setup({ path = { package = path_package } })

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

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

now(function()
    require('mini.icons').setup()
end)
-- Treesitter
add({ source = 'nvim-treesitter/nvim-treesitter' })
now(function()
    require('nvim-treesitter').setup({
        ensure_installed = { "lua" },
        ignore_install = {},
        modules = {},
        sync_install = false,
        auto_install = false
    })
end)

-- Theme
add({ source = 'navarasu/onedark.nvim' }) -- Theme
now(function()
    require('onedark').load()
end)

-- Commenting
later(function()
    require('mini.comment').setup({
        mappings = {
            comment = '',
            comment_line = '',
            comment_visual = '#'
        }
    })
end)

-- Motions
add({ source = 'folke/flash.nvim' })

-- File explorer
add({
    source = 'stevearc/oil.nvim',
    depends = {
        'echasnovski/mini.icons'
    }
})
now(function()
    require('oil').setup({
        default_file_explorer = true,
        colums = {
            "icons"
        }
    })
end)

-- Various QoL from folke
add({
    source = 'folke/snacks.nvim',
    opts = {
        explorer = { enabled = true },
        gitbrowse = { enabled = true },
        lazygit = { enabled = true },
        notifier = { enabled = true },
        notify = { enabled = true },
        picker = { enabled = true }
    }
})
local Snacks = require('snacks')


-- Lsp Config
add({ source = 'https://github.com/neovim/nvim-lspconfig' })
add({ source = 'mason-org/mason.nvim' })
add({ source = 'mason-org/mason-lspconfig.nvim' })

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
add({
    source = 'folke/lazydev.nvim',
    ft = 'lua',
    enabled = true
})
later(function()
    vim.g.lazydev_enable = true
    require('lazydev').setup()
end)

-- Completion
add({ source = 'saghen/blink.cmp' })
later(function()
    require('blink.cmp').setup({
        fuzzy = {
            prebuilt_binaries = {
                force_version = "v1.8.0"
            },
        },
        keymap = {
        },
        signature = { enabled = true }
    })
end)

-- AI
add({
  source = 'yetone/avante.nvim',
  monitor = 'main',
  depends = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'echasnovski/mini.icons'
  },
  hooks = { post_checkout = function() vim.cmd('make') end }
})
later(function()
    require('avante').setup({
        provider = "vibe",
        acp_providers = {
            ["vibe"] = {
                command = "vibe-acp"
            }
        },
        strategies = {
            agent = { adapter = "vibe", model = "devstral-latest" },
            chat = { adapter = "vibe", model = "devstral-latest" },
            inline = { adapter = "vibe", model = "devstral-latest" },
        }
    })
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
vim.keymap.set('n', '<leader>mi', ':Minuet virtualtext toggle<CR>', { silent = true })
vim.keymap.set('n', "grd", vim.lsp.buf.definition, { silent = true })
vim.keymap.set('n', "grr", function() Snacks.picker.lsp_references() end, { silent = true })
vim.keymap.set('n', "gri", function() Snacks.picker.lsp_implementations() end, { silent = true })
vim.keymap.set('n', 'gO', function() end)
vim.keymap.del('n', 'gO')

vim.keymap.set({ 'n', 'x', 'o' }, 'gs', function() require("flash").jump() end, { silent = true })
vim.keymap.set('c', '<c-s>', function() require("flash").toggle() end, { silent = true })


if os.getenv('MISTRAL') then
    local mistral = require("mistral")
    now(function() mistral.setup() end)
    later(function() mistral.later() end)

    local project = os.getenv('MISTRAL_PROJECT')
    if not project then
        return
    end

    local projectConfig = require("mistral." .. project)
    if not projectConfig then
        return
    end
    local repoRoot = os.getenv('REPO_ROOT')
    projectConfig.setup(repoRoot)
    if (projectConfig.setupLater ~= nil) then
        later(function() projectConfig.setupLater(repoRoot) end)
    end
end

