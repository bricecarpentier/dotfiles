local now, later = require("mini.deps").now, require("mini.deps").later

now(function()
	local settings = require("mason-lspconfig.settings")
	local ensure_installed = vim.tbl_deep_extend(
		"force",
		settings.current.ensure_installed,
		{ "biome", "denols" }
	)
	settings.set({ ensure_installed = ensure_installed })

    vim.lsp.config("denols", {
        root_markers = { "deno.json", "deno.jsonc" }
    })
end)

later(function()
	vim.lsp.enable("denols")
	vim.api.nvim_create_user_command("Deno", function()
		vim.lsp.enable("denols", false)
		vim.lsp.enable("denols", true)
	end, {})
end)
