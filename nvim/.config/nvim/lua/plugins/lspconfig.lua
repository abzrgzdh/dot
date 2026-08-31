return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            { path = "snacks.nvim",        words = { "Snacks" } },
            { path = "lazy.nvim",          words = { "LazyVim" } },
          },
        },
      },
      {
        "microsoft/python-type-stubs",
        cond = false
      },
      {
        "hedyhli/outline.nvim",
        lazy = true,
        cmd = { "Outline", "OutlineOpen" },
        keys = { -- Example mapping to toggle outline
          { "<leader>O", "<cmd>Outline<CR>", desc = "Toggle outline" },
        },
        opts = {
          outline_window = {
            width = 25,
            relative_width = true,
          }
        },
      },
    },
    config = function()
      -- -- To instead override globally
      -- -- https://github.com/ofseed/nvim/blob/91484d1a7a8d01f8ee9c792f3fcd9a96232a4cf1/lua/lsp.lua#L25-L32
      -- -- https://github.com/neovim/neovim/issues/32242#issuecomment-2683744917
      -- local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
      -- ---@diagnostic disable-next-line: duplicate-set-field
      -- function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
      --     opts = opts or {}
      --     opts.border = opts.border or "single"
      --     return orig_util_open_floating_preview(contents, syntax, opts, ...)
      -- end

      local capabilities = require('blink.cmp').get_lsp_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      -- local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- capabilities.textDocument.completion.completionItem.snippetSupport = true

      -- Config for all language servers
      vim.lsp.config('*', {
        root_markers = { ".git" },
        capabilities = capabilities,
      })

      -- List of enabled language servers
      vim.lsp.enable({
        "lua_ls",
        "clangd",
        "html", "css", "ts_ls", "json",
        "basedpyright",
        "ruff",
        "texlab",
        "julials",
        "gopls",
        "rust_analyzer",
        "tinymist"
      })

      -- General document formatting
      vim.keymap.set('n', '<leader>=', function() vim.lsp.buf.format { async = true } end,
        { silent = true, noremap = true })

      -- On attach settings
      local au = vim.api.nvim_create_augroup('LspAttach', { clear = true })

      -- Keymaps
      vim.api.nvim_create_autocmd('LspAttach', {
        group = au,
        desc = 'LSP keymaps',
        callback = function(args)
          local bufnr = args.buf
          local opts = { buffer = bufnr, silent = true, noremap = true }

          -- "grn" is mapped in Normal mode to vim.lsp.buf.rename()
          -- "gra" is mapped in Normal and Visual mode to vim.lsp.buf.code_action()
          -- "gri" is mapped in Normal mode to vim.lsp.buf.implementation()
          -- "gO" is mapped in Normal mode to vim.lsp.buf.document_symbol()

          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', function() vim.lsp.buf.hover { border = 'rounded' } end) -- border is not added
          vim.keymap.set('n', '<leader>li', vim.lsp.buf.incoming_calls, opts)
          vim.keymap.set('n', '<leader>lo', vim.lsp.buf.outgoing_calls, opts)
          vim.keymap.set('n', '<C-p>', function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
          vim.keymap.set('n', '<C-n>', function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
          -- vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts) -- by default bound to i_<C-s>
          vim.keymap.set('n', 'gh', vim.diagnostic.open_float, opts)
          vim.keymap.set("n", "gI", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "<leader>lr", vim.lsp.codelens.run, { buffer = bufnr, desc = "Run lens" })
          -- Always override the default to add context
          vim.keymap.set("n", "grr", function()
            vim.lsp.buf.references { includeDeclaration = false }
          end, { buffer = bufnr, desc = "References" })
          vim.keymap.set("n", "<leader>lh", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }, { bufnr = bufnr })
          end, opts)
        end,
      })

      -- Lsp symbol highlights
      vim.api.nvim_create_autocmd('LspAttach', {
        group = au,
        desc = 'LSP highlight',
        callback = function(args)
          local bufnr = args.buf
          local group = vim.api.nvim_create_augroup('lsp_document_highlight', {})

          local function buf_autocmd_document_highlight(buf)
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = buf,
              group = group,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = buf,
              group = 'lsp_document_highlight',
              callback = vim.lsp.buf.clear_references,
            })
          end

          local client = vim.lsp.get_client_by_id(args.data.client_id)
          -- client.server_capabilities.semanticTokensProvider = nil
          if client and client:supports_method('textDocument/documentHighlight') then
            buf_autocmd_document_highlight(args.buf)
          end
        end
      })
    end
  }
}
