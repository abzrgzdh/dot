vim.opt_local.commentstring = "// %s"

-- Auto indent for c/c++ files (private: will be deindented)
--    source: https://stackoverflow.com/a/7623017/13041067
-- vim.opt.cindent         = true
vim.opt_local.cinoptions = vim.opt_local.cinoptions + 'g0' -- do not indent public/private/protected in c++ files
vim.opt_local.cindent = true

-- Fix switch case indentation
-- src: https://stackoverflow.com/a/3445040/13041067
vim.opt_local.cinoptions = vim.opt_local.cinoptions + { "l1" }

-- Don't indent in namespace
-- src: https://stackoverflow.com/a/8125118/13041067
vim.opt_local.cinoptions = vim.opt_local.cinoptions + { "l1" }
vim.opt_local.cinoptions = vim.opt_local.cinoptions + { "N-s" }

-- Don't indent templates in C++
vim.opt_local.cinoptions = vim.opt_local.cinoptions + { "t0" }

-- Parameter/argument wrap
vim.opt_local.cinoptions = vim.opt_local.cinoptions + { ":0", "l1", "t0", "g0", "(0" }

-- vim.opt.foldmethod      = 'expr'

-- local treesitter_parsers = require('nvim-treesitter.parsers')
-- if treesitter_parsers.has_parser "c" then
--     local folds_query = [[
--     [
--       (function_definition)
--     ] @fold
--   ]]
--
--     require("vim.treesitter.query").set("c", "folds", folds_query)
-- end
