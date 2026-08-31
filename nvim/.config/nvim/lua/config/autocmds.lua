local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Highlight yank
local highlight_yank_group = augroup("HighlightYank", { clear = true })
autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank { higroup = "IncSearch", timeout = 100 }
  end,
  group = highlight_yank_group,
})

-- Auto resize splits upon window resize
local auto_resize_group = augroup("AutoResizeSplit", { clear = true })
autocmd("vimResized", {
  pattern = "*",
  command = vim.cmd('execute "normal! \\<C-w>="'),
  group = auto_resize_group,
})

-- Formatting options only achieved this way
local format_options_group = augroup("FormatOptions", { clear = true })
autocmd({ "FileType" }, {
  pattern = "*",
  callback = function()
    vim.opt.formatoptions = "jcqnl"
  end,
  group = format_options_group
})

-- When editing a file, always jump to the last known cursor position.
-- Don't do it when the position is invalid, when inside an event handler
-- (happens when dropping a file on gvim) and for a commit message (it's
-- likely a different one than last time).
local lastplace_group = augroup("LastPlace", { clear = true })
vim.api.nvim_create_autocmd('BufReadPost', {
  group = lastplace_group,
  callback = function(args)
    local valid_line = vim.fn.line([['"]]) >= 1 and vim.fn.line([['"]]) < vim.fn.line('$')
    local not_commit = vim.b[args.buf].filetype ~= 'commit'

    if valid_line and not_commit then
      vim.cmd([[normal! g`"]])
    end
  end,
})

-- Some unknown issue with fuzzy finder plugins
local fix_relative_path = augroup("FixRelPath", { clear = true })
autocmd({ "BufRead", "BufReadPost", "FileReadPost" }, {
  pattern = "*",
  callback = function()
    vim.fn.chdir(vim.fn.getcwd())
  end,
  group = fix_relative_path,
})


-- Enable cursorcolumn when we
-- - enter into visual block mode from any mode
-- - enter into insert mode from visual block mode
-- and Disables it when we leave the modes above

local group = vim.api.nvim_create_augroup("CursorColumnVisualBlock", { clear = true })

vim.api.nvim_create_autocmd("ModeChanged", {
  group = group,
  pattern = "*",
  callback = function()
    if vim.fn.mode() == "\22" or vim.v.event.old_mode == "\22" then
      vim.opt_local.cursorcolumn = true
    end
  end
})

vim.api.nvim_create_autocmd("ModeChanged", {
  group = group,
  pattern = "*",
  callback = function()
    if vim.fn.mode() == "\22" then
      vim.opt_local.cursorcolumn = true
      return
    end
    if vim.fn.mode() == "i" and vim.v.event.old_mode == "\22" then
      vim.opt_local.cursorcolumn = true
    else
      vim.opt_local.cursorcolumn = false
    end
  end,
})
