local add, now = MiniDeps.add, MiniDeps.now
--
-- LazyDev
add({
    source = 'folke/lazydev.nvim',
    ft = 'lua',
    enabled = true
})


vim.g.lazydev_enable = true
vim.lsp.enable('lua_ls')

now(function() require('lazydev').setup() end)
