vim.filetype.add({
  filename = {
    ["controlDict"] = "foam",
    ["physicsProperties"] = "foam",
    ["transportProperties"] = "foam",
    ["fluidProperties"] = "foam",
    ["solidProperties"] = "foam",
  }
})

--[[
/*--------------------------------*- C++ -*----------------------------------*\
--]]
vim.filetype.add {
  pattern = {
    ['.*'] = {
      function(path, bufnr)
        local content = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ''
        -- -*- C++ -*-
        if vim.regex([[\/\*-\{-}-\*- C++ -\*-*\*\\$]]):match_str(content) ~= nil then
          return 'foam'
        end
      end,
      { priority = -math.huge },
    },
  },
}
