-- vim.o.winborder        = 'none'
vim.o.winborder        = 'rounded'

vim.opt.number         = true
vim.opt.relativenumber = true

vim.opt.autoindent     = true -- maintain indent of current line
vim.opt.expandtab      = true -- always use tabs instead of spaces
vim.opt.smarttab       = true -- <tab>/<BS> indent/deindent in loading whitespace
vim.opt.shiftwidth     = 4
vim.opt.tabstop        = 4    -- spaces per tab

vim.opt.hlsearch       = true
vim.opt.ignorecase     = true
vim.opt.incsearch      = true
vim.opt.smartcase      = true

vim.opt.scrolloff      = 3 -- start scroll 3 lines before edge of the viewport
vim.opt.sidescrolloff  = 3

vim.opt.splitbelow     = true -- open horizontal splits below current window
vim.opt.splitright     = true -- open vertical splits to the right of the current window

vim.opt.backup         = false
vim.opt.swapfile       = false -- don't create swap file
vim.opt.writebackup    = false

vim.opt.path           = "**"

vim.opt.wildmenu       = true -- show options as list when switching to buffers etc
vim.opt.wildignorecase = true
vim.opt.wildchar       = 9    -- ('<Tab>') character to trigger wildcard expansion
vim.opt.wildcharm      = 26   -- ('<C-z>') substitue for 'wildchar' in macros
vim.opt.wildmode       = {    -- shell-like autocomplete to unambigious portion
  'longest', 'list', 'full'
}

_G.rc_wildignore = { -- patterns to ingore durng file navigation
  '*.git/*', '*.tags', 'tags', '*build/*', '*.o', '*.class', '*.egg-info/**',
  '__pycache__', 'venv', '*venv/**', '*dist/**', '**/.vim/undo/**', '**/.vim/pack/**',
  '*.cache/*', "main", "a.out", "*.dSYM/*"
}
vim.opt.wildignore:append(_G.rc_wildignore)

vim.opt.undofile   = true
vim.opt.undodir    = vim.fn.stdpath('cache') .. "/undo"

vim.opt.fillchars  = { diff = "∙", --[[eob = " ",--]] fold = " ", vert = "┃", }

vim.opt.list       = true
vim.opt.listchars  = { nbsp = '¬', extends = '»', precedes = '«', tab = '▸ ', trail = '•', }

vim.opt.showcmd    = true
vim.opt.showbreak  = '↪ '
vim.opt.linebreak  = true
vim.opt.cmdheight  = 1

vim.opt.laststatus = 3

vim.cmd [[
  set statusline=%<%f\ %y\ %h%w%m%r\ %=%{%\ &showcmdloc\ ==\ 'statusline'\ ?\ '%-10.S\ '\ :\ ''\ %}%{%\ exists('b:ke\ ymap_name')\ ?\ '<'..b:keymap_name..'>\ '\ :\ ''\ %}%{%\ &busy\ >\ 0\ ?\ '◐\ '\ :\ ''\ %}%{%\ luaeval('(package.loaded[''vim.diagnostic'']\ and\ vim.diagnostic.status()\ ..\ ''\ '')\ or\ ''''\ ')\ %}%{%\ &ruler\ ?\ (\ &rulerformat\ ==\ ''\ ?\ '%-14.(%l,%c%V%)\ %P'\ :\ &rulerformat\ )\ :\ ''\ %}
]]

-- vim.opt.statusline     = table.concat({
--   "%<%f",        -- file path
--   " %y",         -- filetype
--   " %h%w%m%r",   -- help flag, preview flag, modified flag, readonly flag
--   " %=",         -- right align rest
--   "%{% &showcmdloc == 'statusline' ? '%-10.S ' : '' %}",
--   "%{% exists('b:keymap_name') ? '<'..b:keymap_name..'> ' : '' %}",
--   "%{% &busy > 0 ? '◐ ' : '' %}",
--   "%(%{luaeval('(package.loaded[''vim.diagnostic''] and vim.diagnostic.status()) or '''' ')} %)",
--   "%{% &ruler ? ( &rulerformat == '' ? '%-14.(%l,%c%V%) %P' : &rulerformat ) : '' %}",
-- }, " ")

vim.opt.updatetime     = 200 -- CursorHold interval

vim.opt.pumheight      = 10

vim.opt.breakindent    = true
vim.opt.wrap           = false
vim.opt.cursorline     = true
vim.opt.cursorlineopt  = "both"
vim.opt.cursorcolumn   = false
vim.opt.equalalways    = false
vim.opt.joinspaces     = false -- Don't autoinsert two spaces after '.', '?', '!' for join command
vim.opt.lazyredraw     = true  -- Don't bother updating screen during macro playback
vim.opt.showmatch      = false
vim.opt.showmode       = false
vim.opt.termguicolors  = true
vim.opt.title          = true

vim.opt.encoding       = "utf-8"
-- vim.opt.fileformat  = "unix" -- creates problem with gitsigns
--
-- vim.opt.foldmethod      = 'expr'
vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext       = ""
-- vim.opt.foldlevelstart = 99
-- vim.opt_local.foldtext = "v:lua.vim.treesitter.foldtext()"

vim.opt.inccommand     = "split" -- live preview of :s results
vim.opt.mouse          = "a"     -- enable mouse
vim.opt.shortmess      = "FfilnxtToOcw"
vim.opt.signcolumn     = "yes"
vim.opt.virtualedit    = "block" -- allow cursor to move where there is no text in visual block mode
vim.opt.startofline    = false
vim.opt.spellcapcheck  = ''      -- don't check for capital letters at start of sentence
vim.opt.spelllang      = 'en_us,en_gb'

vim.opt.clipboard      = "unnamedplus"

vim.opt.isfname:remove("=") -- Avoid recognizing = as part of file name
-- vim.opt.iskeyword:append("-") -- treat dash separated words as a word text object

vim.opt.completeopt   = {
  "menu", "menuone", "noselect"
}

vim.opt.fileencodings = {
  "utf-8"
}

vim.opt.suffixesadd   = {
  ".js", ".es", ".jsx", ".json", ".css", ".less", "sass", ".styl", ".php",
  ".py", ".md"
}

-- vim.wo.colorcolumn =

-- local textwidth       = 80
vim.opt.textwidth     = 79
vim.wo.colorcolumn    = "+1"

-- -- Editor Config
-- -- Put `max_line_length` to use
-- ---@diagnostic disable-next-line: duplicate-set-field
-- require('editorconfig').properties
-- .max_line_length      = function(bufnr, val, _)
--     vim.opt_local.colorcolumn = val
--     vim.b[bufnr].textwidth = tonumber(val)
-- end

-- vim.opt.guicursor     = {
--   "n-v-c-sm:block",
--   "i-ci-ve:block",
--   "r-cr-o:hor20",
--   "t:block-blinkon500-blinkoff500-TermCursor"
-- }

if vim.fn.has('nvim-0.12') == 1 then
  vim.o.diffopt = 'internal,filler,closeoff,inline:simple,linematch:40'
elseif vim.fn.has('nvim-0.11') == 1 then
  vim.o.diffopt = 'internal,filler,closeoff,linematch:40'
end

-- -- Enable undercurl
-- vim.cmd([[let &t_Cs = "\e[4:3m"]])
-- vim.cmd([[let &t_Ce = "\e[4:0m"]])
