return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  ---@global Snacks
  opts = {
    -- bigfile = { enabled = true },
    -- dashboard = { enabled = false },
    -- explorer = { enabled = true },
    -- indent = { enabled = true },
    -- input = { enabled = true },
    picker = {
      enabled = true,
      layout = "ivy",
      hidden = true,
      layouts = {
        ivy = {
          layout = {
            box = "vertical",
            backdrop = false,
            row = -1,
            width = 0,
            height = 0.7,
            border = "top",
            title = " {title} {live} {flags}",
            title_pos = "left",
            { win = "input", height = 1, border = "bottom" },
            {
              box = "horizontal",
              { win = "list",    border = "none" },
              { win = "preview", title = "{preview}", width = 0.5, border = "left" },
            },
          },
        }
      },
    },
    -- notifier = { enabled = false },
    -- quickfile = { enabled = true },
    scope = { enabled = true },
    -- scroll = { enabled = false },
    -- statuscolumn = { enabled = true },
    -- words = { enabled = true },

  },
  keys = {
    {
      "<leader>f",
      function()
        Snacks.picker.smart({
          cwd = vim.fn.getcwd(),
          layout = { preset = "ivy" },
          exclude = _G.rc_wildignore,
          multi = { "files" },
        })
      end,
    },
    { "<leader>j",  function() Snacks.picker.smart({ cwd = vim.fn.getcwd() }) end },
    { "<leader>,",  function() Snacks.picker.buffers({ on_show = function() vim.cmd.stopinsert() end, }) end },
    { "<leader>/",  function() Snacks.picker.grep() end },
    { "<leader>n",  function() Snacks.picker.notifications() end },
    { "<leader>en", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end },
    { "<leader>ed", function() Snacks.picker.git_files({ cwd = vim.fn.expand("~/.dot/") }) end },
    { "<leader>es", function() Snacks.picker.git_files({ cwd = "~/code/abzrg/snippets/" }) end },
    { "<leader>ek", function() Snacks.picker.keymaps() end },
    { "<leader>eo", function() Snacks.picker.recent() end },
  }
}
