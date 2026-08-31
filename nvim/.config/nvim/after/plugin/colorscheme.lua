-- vim.opt.background = "dark"
-- vim.cmd.highlight({ "link SnacksPickerListCursorLine CursorLine", bang = true })
-- vim.cmd.highlight("clear Function")
-- vim.cmd.highlight("clear Identifier")
-- vim.cmd.highlight("Statement gui=None guifg=nvimlightred")

-- vim.cmd.colorscheme "catppuccin"

--[[
vim.cmd.colorscheme "vacme"

vim.cmd.highlight "Normal guibg=#ffffea"
vim.cmd.highlight "NormalFloat guibg=None gui=None"
vim.cmd.highlight("StatusLine gui=bold")
vim.cmd.highlight "FloatBorder guibg=None guifg=black"
-- vim.cmd.highlight("Comment guifg=#525252")
vim.cmd.highlight("WinSeparator guifg=None, guibg=None gui=None")
vim.cmd.highlight("MatchParen guibg=#98ce8f")
vim.cmd.highlight("clear Delimiter")
vim.cmd.highlight("Float guibg=None")
vim.cmd.highlight("Number guibg=None")
vim.cmd.highlight("Constant guibg=None")
vim.cmd.highlight("String guibg=None")
vim.cmd.highlight("Operator guibg=None")
vim.cmd.highlight("Macro guibg=None")
vim.cmd.highlight("Keyword guibg=None")
vim.cmd.highlight("@lsp guibg=None")
vim.cmd.highlight("clear Function")
vim.cmd.highlight("clear Identifier")
vim.cmd.highlight("clear @variable")
vim.cmd.highlight("PmenuSel gui=None")
-- vim.cmd.highlight ("String guifg=#47763e")
-- vim.cmd.highlight ("DiffAdd guifg=NvimDarkGrey1 guibg=NvimLightGreen")
vim.cmd.highlight ("CursorLineNr guibg=#eaebdb guifg=NvimDarkYellow")
vim.cmd.highlight("ColorColumn guibg=#cfdecc")

vim.cmd.highlight("GitOverflow guibg=#cfdecc")
vim.cmd.highlight("gitcommitFirstLine gui=bold")
vim.cmd.highlight("gitcommitOverflow guibg=#f2acaa guifg=None")
vim.cmd.highlight("gitcommitTrailerToken guifg=#6868a7")

vim.cmd.highlight("Conditional gui=bold guibg=None")
vim.cmd.highlight("Type guibg=None")
vim.cmd.highlight("Include guibg=None")
vim.cmd.highlight("StorageClass guibg=None")

vim.cmd.highlight "LspReferenceText guibg=#cfdecc gui=None"

vim.cmd.highlight "SpellBad guifg=None"
--]]



-------------------------------------------------------------------------------

---[[

vim.opt.background = "dark"

local foreground = "#c5c8c6"
local background = "#1d1f21"
local selection  = "#373b41"
local line       = "#282a2e"
local comment    = "#969896"
local red        = "#cc6666"
local orange     = "#de935f"
local yellow     = "#f0c674"
local green      = "#b5bd68"
local aqua       = "#8abeb7"
local blue       = "#81a2be"
local skyblue    = "skyblue"
local purple     = "#b294bb"
local window     = "#4d5057"


vim.cmd.colorschem("default")
vim.cmd.highlight("Normal guibg=none")

-- vim.cmd.highlight("Comment guifg=".. comment)
-- vim.cmd.highlight("StatusLine guibg=" .. background)
vim.cmd.highlight({ "link SnacksPickerListCursorLine CursorLine", bang = true })
-- vim.cmd.highlight("clear Identifier")
-- vim.cmd.highlight("@lsp.typemod.parameter.readonly gui=italic")
-- vim.cmd.highlight("@lsp.typemod.property.readonly gui=italic")
-- vim.cmd.highlight("@lsp.typemod.typeParameter gui=italic")
-- vim.cmd.highlight("@lsp.typemod.variable.readonly gui=italic")
vim.cmd.highlight ("Statement gui=none guifg=nvimlightmagenta")
-- vim.cmd.highlight ("Constant guifg=" .. skyblue)
-- vim.cmd.highlight ("String guifg=" .. blue) -- #8ec07c
-- vim.cmd.highlight ("Special guifg=" .. aqua)
-- vim.cmd.highlight "clear Type"
-- vim.cmd.highlight ("Function guifg=" .. purple)
-- -- vim.cmd.highlight "clear Function"
-- -- vim.cmd.highlight "PreProc guifg=lightslategray"
-- vim.cmd.highlight ("Visual gui=none guibg=" .. selection)
-- vim.cmd.highlight ("CursorLine gui=none guibg=" .. line)
-- vim.cmd.highlight ("@lsp.type.parameter guifg=lightyellow")
-- -- vim.cmd.highlight ("Operator guifg=nvimlightgray4")


-- Cuda
vim.cmd.highlight ("cudaVariable guifg=".. yellow)

--]]


-------------------------------------------------------------------------------

-- vim.cmd.colorscheme "vague"
-- -- vim.cmd.highlight "VertSplit guifg=nvimlightgray"
-- vim.cmd.highlight "Normal guibg=None"
-- vim.cmd.highlight "NormalFloat guibg=#121415 gui=None"
-- vim.cmd.highlight "Whitespace guifg=#3e3e49"

--
-- -- -- guibg=#12161d
-- vim.cmd.highlight "Normal guibg=None gui=None"
-- -- vim.cmd.highlight "Normal guibg=#12161d gui=None"
-- -- vim.cmd.highlight "NormalFloat guibg=nvimdarkgray2 gui=None"
-- -- vim.cmd.highlight "LspReferenceText guibg=#3c3836 gui=None"
-- vim.cmd.highlight "Statement guifg=NvimLightYellow gui=None"
-- -- vim.cmd.highlight "Statement guifg=#fb4934 gui=None"
-- --vim.cmd.highlight "Operator guifg=NvimLightBlue"
-- -- vim.cmd.highlight "Operator guifg=#a5aFaA"
-- vim.cmd.highlight "Constant guifg=nvimlightgreen"
-- -- vim.cmd.highlight "Constant guifg=nvimlightblue"
-- -- vim.cmd.highlight "String guifg=nvimlightblue" -- #8ec07c
--
-- --
-- vim.cmd.highlight "clear Function"
-- -- vim.cmd.highlight "Function guifg=#aBa0c2" -- aBa0c2
-- -- vim.cmd.highlight "link @constructor Function"
-- --
-- vim.cmd.highlight "clear Identifier"
--
-- -- vim.cmd.highlight "clear Keyword"
-- -- vim.cmd.highlight "@keyword.type guifg=None"
-- -- vim.cmd.highlight "@keyword.function guifg=None"
-- --
-- vim.cmd.highlight "CursorLine guibg=#1e222a"
-- vim.cmd.highlight "Visual guibg=#3e424a"
-- vim.cmd.highlight({ "link ColorColumn CursorLine", bang = true })
-- vim.cmd.highlight({ "link CursorColumn CursorLine", bang = true })
-- vim.cmd.highlight({ "link SnacksPickerListCursorLine CursorLine", bang = true })
-- -- vim.cmd.highlight "DiagnosticUnnecessary guifg=#B8860B"
-- -- vim.cmd.highlight "Precondit guifg=#fe8019" --
-- -- vim.cmd.highlight "PreProc guifg=#afa7a7"
-- -- vim.cmd.highlight "@keyword.import guifg=#afa7a7"
-- --
-- -- vim.cmd.highlight "Special guifg=#fabd2f"
-- -- vim.cmd.highlight "Statusline guibg=#161a22"
-- -- vim.cmd.highlight "Pmenu cterm=reverse guifg=nvimlightgray2"
-- -- vim.cmd.highlight "PmenuSel cterm=underline,reverse guifg=nvimlightgray2 guibg=nvimdarkgray2 blend=0"
-- -- -- vim.cmd.highlight "Pmenu guibg=None gui=None"
-- -- -- vim.cmd.highlight "PmenuSel guibg=None gui=None"
-- -- -- vim.cmd.highlight({ "link PmenuSel CursorLine", bang = true })
-- -- vim.cmd.highlight "PmenuMatch     cterm=bold gui=bold"
-- -- vim.cmd.highlight "PmenuMatchSel  cterm=bold gui=bold"
-- --
-- -- vim.cmd [[
-- -- hi SnacksPickerMatch  gui=bold guifg=#fabd2f
-- -- hi CmpItemAbbrMatch  gui=bold guifg=#fabd2f
-- -- hi BlinkCmpLabelMatch  gui=bold guifg=#fabd2f
-- -- hi CmpItemAbbrMatchFuzzy  gui=bold guifg=#fabd2f
-- -- hi TelescopeMatching  gui=bold guifg=#fabd2f
-- -- ]]
-- --
-- --
-- -- vim.cmd.highlight "DiagnosticUnderlineWarn gui=underline guisp=None"
-- -- vim.cmd.highlight "DiagnosticUnderlineError gui=underline guisp=None"
-- -- vim.cmd.highlight "DiagnosticUnderlineInfo gui=underline guisp=None"
-- -- vim.cmd.highlight "DiagnosticUnderlineHint gui=underline guisp=None"
-- -- vim.cmd.highlight "DiagnosticUnderlineOk gui=underline guisp=None"
-- --
--
-- vim.cmd.highlight "@lsp.typemod.function.definition guifg=NvimLightmagenta" -- af87d7 fe8019
-- vim.cmd.highlight "@lsp.typemod.function.declaration guifg=NvimLightmagenta"
-- vim.cmd.highlight "@lsp.typemod.method.declaration guifg=NvimLightmagenta"
--
-- vim.cmd.highlight "@lsp.type.typeParameter.cpp gui=italic guifg=nvimlightred"
--
-- vim.cmd.highlight "cErrInParen guifg=None guibg=None"
--
-- vim.cmd.highlight "Todo guifg=nvimlightcyan"
--
-- -- vim.cmd.highlight "@lsp.typemod.function.definition guifg=#af87d7" -- af87d7 fe8019
-- -- vim.cmd.highlight "@lsp.typemod.function.declaration guifg=#af87d7"
-- -- vim.cmd.highlight "@lsp.typemod.method.declaration guifg=#af87d7"
-- --
-- --
-- -- -- vim.cmd.highlight "@lsp.typemod.variable.declaration guifg=#af87d7"
-- --
-- -- -- vim.cmd.highlight({ "link @lsp.type.macro Function", bang = true })
-- -- vim.cmd.highlight "@lsp.type.macro guifg=None"
-- --
-- -- -- Markup
-- -- vim.cmd.highlight({ "link @markup.link.label Constant", bang = true })
-- -- vim.cmd.highlight({ "link @markup.link Function", bang = true })
-- -- vim.cmd.highlight "Title guifg=#af87d7"
-- -- vim.cmd.highlight "@markup.quote guifg=None gui=italic"
-- -- -- vim.cmd.highlight "link @punctuation.special Function"
-- -- vim.cmd.highlight "link @markup.list Function"
-- -- -- vim.cmd.highlight "@label guifg=NvimLightBlue"
-- -- vim.cmd.highlight "link @keyword.directive Function"
-- -- vim.cmd.highlight "link @markup.raw Constant"
-- --
-- -- -- Git
-- -- vim.cmd.highlight({ "gitcommitSummary gui=bold guifg=nvimlightgray2" })
-- -- vim.cmd.highlight "gitcommitOverflow guifg=#fb4934"
-- --
-- -- -- CSS
-- -- vim.cmd.highlight "cssPseudoClassID guifg=#af87d7"
-- --
-- -- -- ASM
-- -- vim.cmd.highlight({ "link asmLabel @lsp.typemod.function.definition", bang = true })
-- --
--
--
--
-- _G.comment_dimmed = false
-- if _G.comment_dimmed == false then
--   vim.cmd.highlight "Comment guifg=NvimLightGray4"
--   _G.comment_dimmed = true
-- else
--   vim.cmd.highlight "Comment guifg=NvimDarkGray4"
--   _G.comment_dimmed = false
-- end
--
-- vim.keymap.set({ 'n', 'v' }, '<leader>C', function()
--   if _G.comment_dimmed == false then
--     vim.cmd.highlight "Comment guifg=NvimLightGray4"
--     _G.comment_dimmed = true
--   else
--     vim.cmd.highlight "Comment guifg=NvimDarkGray4"
--     _G.comment_dimmed = false
--   end
-- end, { noremap = true, silent = true })
