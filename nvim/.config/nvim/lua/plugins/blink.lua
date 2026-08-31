return {
  "https://github.com/saghen/blink.cmp",
  version = "v1.*",
  event = "InsertEnter",
  config = function()
    require("blink-cmp").setup {
      fuzzy = {
        implementation = "lua"
        -- prebuilt_binaries = {
        --   download = false,
        -- }
      },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono'
      },

      snippets = {
        preset = 'luasnip',
        expand = function(snippet) require('luasnip').lsp_expand(snippet) end,
        active = function(filter)
          if filter and filter.direction then
            return require('luasnip').jumpable(filter.direction)
          end
          return require('luasnip').in_snippet()
        end,
        jump = function(direction) require('luasnip').jump(direction) end,
      },

      completion = {
        -- 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
        keyword = { range = 'full', },

        -- Insert completion item on selection, don't select by default
        list = { selection = { preselect = true, auto_insert = true } },

        -- Show documentation when selecting a completion item
        documentation = {
          auto_show = true,
          -- auto_show_delay_ms = 0,
          -- window = {
          --   border = "rounded",
          -- }

        },

        -- Display a preview of the selected item on the current line
        ghost_text = { enabled = false },

        menu = {
          -- auto_show = false,
          -- auto_show_delay_ms = 500,
          border = "single",
          -- winhighlight = "Normal:Normal",
          draw = {
            columns = { --[[{ 'kind_icon' },]] { 'label' }, { 'kind' } },
            -- columns = { { 'kind' }, { 'label' } },
          }
        },

        trigger = {
          show_on_insert_on_trigger_character = true,
          show_on_backspace_in_keyword = true,
        },

        accept = {
          auto_brackets = {
            enabled = true,
            kind_resolution = {
              enabled = true,
              -- Disable kind auto_brackets for latex files
              blocked_filetypes = { 'tex' },
            },
          },
        },
      },

      sources = {
        default = {
          'lsp',
          'path', 'snippets', 'buffer'
        },

        providers = {
          path = {
            min_keyword_length = 0,
            score_offset = 4,
          },
          snippets = {
            min_keyword_length = 3,
            score_offset = 120,
          },
          lsp = {
            min_keyword_length = 0,
            score_offset = 90,
          },
          buffer = {
            min_keyword_length = 3,
            score_offset = 100,
          },
        },
      },

      cmdline = {
        enabled = false
      },

      signature = { enabled = true },

      keymap = {
        preset = "super-tab",

        ["<C-Space>"] = {
          "show",
          "hide",
          -- "show_documentation",
          -- "hide_documentation",
        },

        ["<CR>"] = { "accept", "fallback" },
        ["<C-l>"] = { 'hide', 'fallback' },
        -- ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        -- ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        -- ["<C-L"] = { 'hide', 'fallback' },
        ["<C-j"] = {},
        ["<C-k>"] = {},
        ['<C-b>'] = {},
        ['<C-f>'] = {},
        ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
        -- ["<C-n"] = { "select_next", "fallback" },
        -- ["<C-p>"] = { "select_prev", "fallback" },
      },
    }

    -- Easier cancel
    vim.keymap.set('i', 'jk', function() require("blink.cmp").hide() end, { noremap = true, silent = true })
  end
}
