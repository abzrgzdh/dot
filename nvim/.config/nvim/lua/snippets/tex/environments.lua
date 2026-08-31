-- Math context detection
local tex = {}
tex.in_mathzone = function() return vim.fn['vimtex#syntax#in_mathzone']() == 1 end
tex.in_text = function() return not tex.in_mathzone() end

local line_begin = require("luasnip.extras.expand_conditions").line_begin

local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep
local helpers = require('snippets.snippet_helper')
local get_visual = helpers.get_visual

-- Return snippet tables
return
{
  -- GENERIC ENVIRONMENT
  s({ trig = "begin" },
    fmta(
      [[
        \begin{<>}
          <>
        \end{<>}
      ]],
      {
        i(1),
        d(2, get_visual),
        rep(1),
      }
    ),
    { condition = line_begin }
  ),
  -- ENVIRONMENT WITH ONE EXTRA ARGUMENT
  s({ trig = "begin2", priority = 100 },
    fmta(
      [[
        \begin{<>}{<>}
          <>
        \end{<>}
      ]],
      {
        i(1),
        i(2),
        d(3, get_visual),
        rep(1),
      }
    ),
    { condition = line_begin }
  ),
  -- ENVIRONMENT WITH TWO EXTRA ARGUMENTS
  s({ trig = "beg3", priority = 100 },
    fmta(
      [[
        \begin{<>}{<>}{<>}
          <>
        \end{<>}
      ]],
      {
        i(1),
        i(2),
        i(3),
        d(4, get_visual),
        rep(1),
      }
    ),
    { condition = line_begin }
  ),
  -- EQUATION
  s({ trig = "equation", priority = 1011 },
    fmta(
      [[
        \begin{equation}
          <>
          \label{eq:<>}
        \end{equation}
      ]],
      {
        i(1),
        i(0),
      }
    ),
    { condition = line_begin }
  ),
  s({ trig = "equation*", priority = 100 },
    fmta(
      [[
        \begin{equation*}
          <>
        \end{equation*}
      ]],
      {
        i(1),
      }
    ),
    { condition = line_begin }
  ),
  -- SPLIT EQUATION
  s({ trig = "eqsplit" },
    fmta(
      [[
        \begin{equation}
          \begin{split}
            <>
          \end{split}
          \label{eq:<>}
        \end{equation}
      ]],
      {
        d(1, get_visual),
        i(0),
      }
    ),
    { condition = line_begin }
  ),
  -- ALIGN
  s({ trig = "align" },
    fmta(
      [[
        \begin{align}
          <>
          \label{eq:<>}
        \end{align}
      ]],
      {
        i(1),
        i(0),
      }
    ),
    { condition = line_begin }
  ),
  -- EQUATION + ALIGNED
  s({ trig = "eqalign", priority = 1010 },
    fmta(
      [[
        \begin{equation}
          \begin{aligned}
            <>
          \end{aligned}
          \label{eq:<>}
        \end{equation}
      ]],
      {
        d(1, get_visual),
        i(0),
      }
    ),
    { condition = line_begin }
  ),
  s({ trig = "eqgather" },
    fmta(
      [[
        \begin{equation}
          \begin{gathered}
            <>
          \end{gathered}
          \label{eq:<>}
        \end{equation}
      ]],
      {
        d(1, get_visual),
        i(0),
      }
    ),
    { condition = line_begin }
  ),
  -- ITEMIZE
  s({ trig = "itemize" },
    fmta(
      [[
        \begin{itemize}
          \item <>
        \end{itemize}
        ]],
      {
        i(0),
      }
    ),
    { condition = line_begin }
  ),
  -- ENUMERATE
  s({ trig = "eumerate", snippetType = "autosnippet" },
    fmta(
      [[
        \begin{enumerate}
          \item <>
        \end{enumerate}
        ]],
      {
        i(0),
      }
    )
  ),
  -- INLINE MATH
  s({ trig = "([^%l])mm", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta(
      "<>\\(<>\\)",
      {
        f(function(_, snip) return snip.captures[1] end),
        d(1, get_visual),
      }
    )
  ),
  -- INLINE MATH ON NEW LINE
  s({ trig = "^mm", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta(
      "\\(<>\\)",
      {
        i(1),
      })),
  -- DISPLAY MATH ON NEW LINE
  s({ trig = "^MM", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta(
      [[
      \[
        <>
      \]
      ]],
      {
        i(1),
      })),
  -- FIGURE
  s({ trig = "figure", priority = 1010 },
    fmta(
      [[
        \begin{figure}[htb!]
          \centering
          \includegraphics[width=<>\linewidth]{<>}
          \caption{<>}
          \label{fig:<>}
        \end{figure}
        ]],
      {
        i(1),
        i(2),
        i(3),
        i(4),
      }
    ),
    { condition = line_begin }
  ),
}
