vim.filetype.add({
  filename = {
    -- by default neovim think setup.cfg is a dosini file
    ["setup.cfg"] = "confini",
  }
})
