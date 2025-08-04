-- Mini.nvim
--
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

-- Theme
add({ source = 'navarasu/onedark.nvim' }) -- Theme
now(function()
    require('onedark').load()
    vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'Pmenu', { bg = 'none' })
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

-- Lsp Config
add({ source = 'https://github.com/neovim/nvim-lspconfig' })

-- Completion
add({ source = 'saghen/blink.cmp' })
now(function()
    require('blink.cmp').setup({
        fuzzy = {
            prebuilt_binaries = {
                force_version = "v1.6.0"
            }
        },
        keymap = {
            ['<CR>'] = { 'accept', 'fallback' },
            ['<Tab>'] = { 'accept', 'fallback' },
        }
    })
end)

--
-- USER COMMANDS
--
vim.api.nvim_create_user_command('Diagnostics', function() Snacks.picker.diagnostics() end, {})
vim.api.nvim_create_user_command('DiagnosticsBuffer', function() Snacks.picker.diagnostics_buffer() end, {})
vim.api.nvim_create_user_command('Explore', function() Snacks.explorer() end, {})
vim.api.nvim_create_user_command('Files', function() Snacks.picker.files() end, {})
vim.api.nvim_create_user_command('Find', function() Snacks.picker.grep() end, {})
vim.api.nvim_create_user_command('GitBrowse', function() Snacks.gitbrowse() end, {})
vim.api.nvim_create_user_command('GitStatus', function() Snacks.picker.git_status() end, {})
vim.api.nvim_create_user_command('GitLog', function() Snacks.picker.git_log() end, {})
vim.api.nvim_create_user_command('Help', function() Snacks.picker.help() end, {})
vim.api.nvim_create_user_command('Keymaps', function() Snacks.picker.keymaps() end, {})
vim.api.nvim_create_user_command('LazyGit', function() Snacks.lazygit() end, {})
vim.api.nvim_create_user_command('Recent', function() Snacks.picker.recent() end, {})
vim.api.nvim_create_user_command('Symbols', function() Snacks.picker.lsp_symbols() end, {})
vim.api.nvim_create_user_command('WorkspaceSymbols', function() Snacks.picker.lsp_workspace_symbols() end, {})



--
-- KEYMAPS
--
vim.keymap.set('n', '=', vim.lsp.buf.format, { silent = false })
vim.keymap.set('n', '<leader>e', ':Oil<CR>', { silent = true })
vim.keymap.set('n', '<leader>f', ':Files<CR>', { silent = true })
vim.keymap.set('n', "grd", vim.lsp.buf.definition, { silent = true })
vim.keymap.set('n', "grr", function() Snacks.picker.lsp_references() end, { silent = true })
vim.keymap.set('n', "gri", function() Snacks.picker.lsp_implementations() end, { silent = true })
vim.keymap.set('n', 'gO', function() end)
vim.keymap.del('n', 'gO')

vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', { remap = true, silent = true })
vim.keymap.set('n', '<M-C-left>', ':wincmd h<CR>', { remap = true, silent = true })
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>', { remap = true, silent = true })
vim.keymap.set('n', '<M-C-down>', ':wincmd j<CR>', { remap = true, silent = true })
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', { remap = true, silent = true })
vim.keymap.set('n', '<M-C-up>', ':wincmd k<CR>', { remap = true, silent = true })
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', { remap = true, silent = true })
vim.keymap.set('n', '<M-C-right>', ':wincmd l<CR>', { remap = true, silent = true })
vim.keymap.set({ 'n', 'x', 'o' }, '<leader><leader>s', function() require("flash").jump() end, { silent = true })
vim.keymap.set('c', '<c-s>', function() require("flash").toggle() end, { silent = true })
