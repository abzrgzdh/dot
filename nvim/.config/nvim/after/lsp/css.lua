---@type vim.lsp.Config
return {
  -- on_attach = function()
  --   vim.keymap.set({ "n", "v" }, "<leader>=", function()
  --     require("conform").format({
  --       lsp_fallback = true,
  --       async = false,
  --       timeout_ms = 1000,
  --     })
  --   end)
  -- end,
  cmd = { 'vscode-css-language-server', '--stdio' },
  filetypes = { 'css', 'scss', 'less' },
  root_markers = { 'package.json', '.git' },
  init_options = { provideFormatter = false },
  settings = {
    css = { validate = true },
    scss = { validate = true },
    less = { validate = true },
  },
}
