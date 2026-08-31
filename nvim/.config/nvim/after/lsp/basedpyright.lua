return {
  on_attach = function(client, bufnr)
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    -- vim.keymap.set({ "n", "v" }, "<leader>=", function()
    --   require("conform").format({
    --     lsp_fallback = true,
    --     async = false,
    --     timeout_ms = 1000,
    --   })
    -- end)

    --- What is this bruvsky?
    vim.api.nvim_create_autocmd('LspTokenUpdate', {
      buffer = bufnr,
      callback = function(args)
        if args.data.client_id ~= client.id then
          return
        end
        ---@type STTokenRange
        local token = args.data.token
        if
            token.type == 'parameter' and not token.modifiers.definition
        then
          local captures = vim.treesitter.get_captures_at_pos(
            bufnr,
            token.line,
            token.start_col
          )
          if
              vim.iter(captures):any(function(capture)
                return capture.lang == 'python'
                    and (
                      capture.capture == 'variable.parameter'  -- inside function call
                      or capture.capture == 'variable.builtin' -- self / cls param
                    )
              end)
          then
            -- abort override
            return
          end
          vim.lsp.semantic_tokens.highlight_token(
            token,
            args.buf,
            args.data.client_id,
            '@variable.parameter.reference'
          )
        end
      end,
    })
  end,

  cmd = { "basedpyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = {
    'pyproject.toml',
    'setup.py',
    '.git',
  },
  settings = {
    basedpyright = {
      -- pyright = {
      --   disableLanguageServices = false,
      --   disableOrganizeImports = false,
      -- },
      analysis = {
        autoImportCompletions = true,
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,

        typeCheckingMode = "off",
        diagnosticMode = "openFilesOnly", -- or workspace

        inlayHints = {
          functionReturnTypes = false,
          genericTypes = false,
          callArgumentNames = false,
          variableTypes = false,
        },
      },
      -- typeCheckingMode = "standard", -- values: off | basic | standard | strict | recommended | all

      linting = {
        enabled = false,
      }

    }
  },
  single_file_support = true,

  -- Disable all diagnostics from Pyright (since I'm using ruff for that)
  handlers = {
    ["textDocument/publishDiagnostics"] = function() end,
  }
}
