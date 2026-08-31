vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2

vim.g.html_indent_script1 = "zero"
vim.g.html_indent_style1 = "zero"
-- Don't indent first child of these tags
vim.g.html_indent_autotags = "html" -- head, body

vim.opt_local.wrap = true

require("luasnip.loaders.from_vscode").load { include = { "html", "css", "javascript" }, }
-- require('luasnip').filetype_extend("html", {"djangohtml"})
