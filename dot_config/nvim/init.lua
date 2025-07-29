--
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

vim.o.signcolumn = "yes"
vim.o.wrap = false

--
-- NOW
--

-- Theme
now(function()
  add({ source = 'navarasu/onedark.nvim' })
  require('onedark').load()
  vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'Pmenu', { bg = 'none' })
end)

now(function()
  require('mini.icons').setup()
end)

now(function()
  add({
    source = 'stevearc/oil.nvim',
    depends = {
      'echasnovski/mini.icons'
    }
  })
  require('oil').setup({
    default_file_explorer = true,
    colums = {
      "icons"
    }
  })
end)

later(function()
  add({
    source = 'folke/snacks.nvim',
    opts = {
      explorer = {},
      gitbrowse = {},
      lazygit = {},
      picker = {}
    }
})
end)

--
-- LATER
--

--
-- KEYMAPS
--
vim.keymap.set('n', '<leader>e', ':Oil<CR>', { silent = true })
vim.keymap.set('n', '<leader>t', function() Snacks.explorer() end, { silent = true })
vim.keymap.set('n', '<leader>gB', function() Snacks.gitbrowse() end, { silent = true })
vim.keymap.set('n', '<leader>f', function() Snacks.picker.files() end, { silent = true })
vim.keymap.set('n', '<leader>h', function() Snacks.picker.help() end, { silent = true })
vim.keymap.set('', '<C-h>', ':wincmd h<CR>', { remap = true, silent = true })
vim.keymap.set('', '<C-j>', ':wincmd j<CR>', { remap = true, silent = true })
vim.keymap.set('', '<C-k>', ':wincmd k<CR>', { remap = true, silent = true })
vim.keymap.set('', '<C-l>', ':wincmd l<CR>', { remap = true, silent = true })

vim.api.nvim_create_user_command('LazyGit', function() Snacks.LazyGit() end, {})

