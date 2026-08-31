-- vim.api.nvim_create_autocmd("LspAttach", {
--   callback = function(args)
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--     if client and client.name == "clangd" then
--       client.server_capabilities.semanticTokensProvider = nil
--     end
--   end,
-- })

return {
  capabilities = {
    textDocument = {
      inactiveRegionsCapabilities = {
        inactiveRegions = true,
      },
    },
  },
  cmd = { 'clangd',
    unpack({
      "--enable-config=true",
      "--fallback-style=google",
      "--log=error",
      "--all-scopes-completion",
      -- "--completion-parse=always",
      "--completion-style=bundled",       -- detailed, bundled
      -- "--header-insertion=iwyu",
      "--header-insertion-decorators",
      "--offset-encoding=utf-16",
      "--ranking-model=heuristics",
      "--folding-ranges",
      "-j=1",
      "--limit-references=100",
      "--limit-results=20",
      "--background-index=true",
      "--pch-storage=disk",       -- memory, disk
      -- "--function-arg-placeholders=true",
    }) },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'proto' },   --  'cuda',
  root_markers = { '.clangd', '.clang-tidy', '.clang-format', 'compile_commands.json', 'compile_flags.txt', 'configure.ac', '.git', 'build/compile_commands.json' },
  settings = {
    clangd = {
      checkUpdates = false,
      restartAfterCrash = true,         -- Auto restart clangd (up to 4 times) if it crashes.
      onConfigChanged = "prompt",       -- values: prompt|restart|ignore  (if clangd 12+, will be ignored)
      semanticHighlighting = true,
      serverCompletionRanking = true,
      detectExtensionConflicts = true,
    }
  },
}
