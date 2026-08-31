return {
  "L3MON4D3/LuaSnip",
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  config = function()
    local luasnip = require 'luasnip'

    luasnip.config.set_config {
      history = false,
      update_events = {"TextChanged","TextChangedI"},
      enable_autosnippets = true,
      store_selection_keys = "<Tab>",
      region_check_events = "InsertEnter,CursorMoved",
    }

    require("luasnip.loaders.from_lua").lazy_load({
      paths = vim.fn.stdpath("config") .. "/lua/snippets"
    })

    require("luasnip.loaders.from_vscode").load { include = { "html", "css", "javascript" }, }
  end

}
