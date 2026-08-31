local helpers = require('snippets.snippet_helper')
local get_visual = helpers.get_visual

-- Math context detection
local tex = {}
tex.in_mathzone = function() return vim.fn['vimtex#syntax#in_mathzone']() == 1 end
tex.in_text = function() return not tex.in_mathzone() end

-- Return snippet tables
return
{
  -- SUPERSCRIPT '
  s({ trig = "([%w%)%]%}])'", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta(
      "<>^{<>}",
      {
        f(function(_, snip) return snip.captures[1] end),
        d(1, get_visual),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- SUBSCRIPT ;
  s({ trig = "([%w%)%]%}]);", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta(
      "<>_{<>}",
      {
        f(function(_, snip) return snip.captures[1] end),
        d(1, get_visual),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- SUBSCRIPT AND SUPERSCRIPT __
  s({ trig = "([%w%)%]%}])__", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta(
      "<>^{<>}_{<>}",
      {
        f(function(_, snip) return snip.captures[1] end),
        i(1),
        i(2),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- TEXT SUBSCRIPT
  s({ trig = '_:', snippetType = "autosnippet", wordTrig = false },
    fmta("_{\\mathrm{<>}}",
      { d(1, get_visual) }
    ),
    { condition = tex.in_mathzone }
  ),
  -- SUPERSCRIPT SHORTCUT
  -- Places the first alphanumeric character after the trigger into a superscript.
  s({trig = '([%w%)%]%}])"([%w])', regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>^{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        f( function(_, snip) return snip.captures[2] end ),
      }
    ),
    {condition = tex.in_mathzone}
  ),
  -- SUBSCRIPT SHORTCUT
  -- Places the first alphanumeric character after the trigger into a subscript.
  s({trig = '([%w%)%]%}]):([%w])', regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>_{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        f( function(_, snip) return snip.captures[2] end ),
      }
    ),
    {condition = tex.in_mathzone}
  ),
  -- EULER'S NUMBER SUPERSCRIPT SHORTCUT (use exp when it becomes cumbersome to use e)
  s({trig = '([^%a])ee', regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>e^{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual)
      }
    ),
    {condition = tex.in_mathzone}
  ),
  -- ZERO SUBSCRIPT SHORTCUT
  s({ trig = '([%a%)%]%}])00', regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta(
      "<>_{<>}",
      {
        f(function(_, snip) return snip.captures[1] end),
        t("0")
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- MINUS ONE SUPERSCRIPT SHORTCUT
  s({ trig = '([%a%)%]%}])01', regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta(
      "<>_{<>}",
      {
        f(function(_, snip) return snip.captures[1] end),
        t("-1")
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- ONE SUPERSCRIPT SHORTCUT
  s({ trig = '([%a%)%]%}])11', regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta(
      "<>_{<>}",
      {
        f(function(_, snip) return snip.captures[1] end),
        t("1")
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- I SUBSCRIPT SHORTCUT
  s({ trig = '([%a%)%]%}])ii', wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta(
      "<>_{<>}",
      {
        f(function(_, snip) return snip.captures[1] end),
        t("i")
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- J SUBSCRIPT SHORTCUT (since jk triggers snippet jump forward)
  s({ trig = '([%a%)%]%}])jj', wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta(
      "<>_{<>}",
      {
        f(function(_, snip) return snip.captures[1] end),
        t("j")
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- K SUBSCRIPT SHORTCUT
  s({ trig = '([%a%)%]%}])kk', wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta(
      "<>_{<>}",
      {
        f(function(_, snip) return snip.captures[1] end),
        t("k")
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- PLUS SUPERSCRIPT SHORTCUT
  s({ trig = '([%a%)%]%}])%+%+', regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta(
      "<>^{<>}",
      {
        f(function(_, snip) return snip.captures[1] end),
        t("+")
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- COMPLEMENT SUPERSCRIPT
  s({ trig = '([%a%)%]%}])CC', regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta(
      "<>^{<>}",
      {
        f(function(_, snip) return snip.captures[1] end),
        t("\\complement")
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- CONJUGATE (STAR) SUPERSCRIPT SHORTCUT
  s({ trig = '([%a%)%]%}])%*%*', regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta(
      "<>^{<>}",
      {
        f(function(_, snip) return snip.captures[1] end),
        t("*")
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- VECTOR, i.e. \vec
  s({ trig = "([^%a])vv", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta(
      "<>\\mb{<>}",
      {
        f(function(_, snip) return snip.captures[1] end),
        d(1, get_visual),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- DEFAULT UNIT VECTOR WITH SUBSCRIPT, i.e. \unitvector_{}
  s({ trig = "([^%a])ue", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta(
      "<>\\unitvector_{<>}",
      {
        f(function(_, snip) return snip.captures[1] end),
        d(1, get_visual),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- UNIT VECTOR WITH HAT, i.e. \uvec{}
  s({ trig = "([^%a])uv", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta(
      "<>\\uvec{<>}",
      {
        f(function(_, snip) return snip.captures[1] end),
        d(1, get_visual),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- -- MATRIX, i.e. \vec
  -- s({trig = "([^%a])mt", wordTrig = false, regTrig = true, snippetType="autosnippet"},
  --   fmta(
  --     "<>\\mat{<>}",
  --     {
  --       f( function(_, snip) return snip.captures[1] end ),
  --       d(1, get_visual),
  --     }
  --   ),
  --   {condition = tex.in_mathzone}
  -- ),
  -- FRACTION
  s({ trig = "([^%a])ff", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta(
      "<>\\f{<>}{<>}",
      {
        f(function(_, snip) return snip.captures[1] end),
        d(1, get_visual),
        i(2),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- ANGLE
  s({ trig = "ang", regTrig = false, wordTrig = false },
    fmta(
      "<>\\ang{<>}",
      {
        f(function(_, snip) return snip.captures[1] end),
        d(1, get_visual),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- ABSOLUTE VALUE
  s({ trig = "abs", regTrig = false, wordTrig = false },
    fmta(
      "<>\\abs{<>}",
      {
        f(function(_, snip) return snip.captures[1] end),
        d(1, get_visual),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- SQUARE ROOT
  s({ trig = "sqrt", wordTrig = false, regTrig = false },
    fmta(
      "<>\\sqrt{<>}",
      {
        f(function(_, snip) return snip.captures[1] end),
        d(1, get_visual),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- BINOMIAL SYMBOL
  s({ trig = "binom", wordTrig = false, regTrig = true },
    fmta(
      "<>\\binom{<>}{<>}",
      {
        f(function(_, snip) return snip.captures[1] end),
        i(1),
        i(2),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- LOGARITHM WITH BASE SUBSCRIPT
  s({ trig = "log", wordTrig = false, regTrig = true },
    fmta(
      "<>\\log_{<>}",
      {
        f(function(_, snip) return snip.captures[1] end),
        i(1),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- NATURAL LOGARITHM
  s({ trig = "ln", wordTrig = false, regTrig = true },
    fmta(
      "<>\\ln{<>}",
      {
        f(function(_, snip) return snip.captures[1] end),
        i(1),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- TIME DERIVATIVE
  s({ trig = "([^%a])ddt", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta(
      "<>\\ddt{<>}",
      {
        f(function(_, snip) return snip.captures[1] end),
        d(1, get_visual),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- DERIVATIVE ddx
  s({ trig = "([^%a])ddx", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta(
      "<>\\ddx{<>}",
      {
        f(function(_, snip) return snip.captures[1] end),
        i(1)
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- DERIVATIVE ddy
  s({ trig = "([^%a])ddy", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta(
      "<>\\ddy{<>}",
      {
        f(function(_, snip) return snip.captures[1] end),
        i(1)
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- DERIVATIVE ddz
  s({ trig = "([^%a])ddz", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta(
      "<>\\ddz{<>}",
      {
        f(function(_, snip) return snip.captures[1] end),
        i(1)
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- DERIVATIVE with numerator and denominator (v: variable)
  s({ trig = "([^%a])ddv", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta(
      "<>\\ddv{<>}{<>}",
      {
        f(function(_, snip) return snip.captures[1] end),
        i(1),
        i(2)
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- DERIVATIVE with numerator, denominator, and higher-order argument
  s({ trig = "ddnv", wordTrig = false, regTrig = true },
    fmta(
      "<>\\ddvn{<>}{<>}{<>}",
      {
        f(function(_, snip) return snip.captures[1] end),
        i(1),
        i(2),
        i(3),
      }
    ),
    { condition = tex.in_mathzone }
  ),

  -- \newcommand{\p}{\partial}
  s({ trig = "pp", snippetType = "autosnippet" },
    {
      t("\\p"),
    },
    { condition = tex.in_mathzone }
  ),

  -- -- PARTIAL DERIVATIVE with denominator only
  -- s({trig = "([^%a])pV", wordTrig = false, regTrig = true, snippetType="autosnippet"},
  --   fmta(
  --     "<>\\pdvOne{<>}",
  --     {
  --       f( function(_, snip) return snip.captures[1] end ),
  --       d(1, get_visual),
  --     }
  --   ),
  --   {condition = tex.in_mathzone}
  -- ),
  -- -- PARTIAL DERIVATIVE with numerator and denominator
  -- s({trig = "([^%a])pvv", wordTrig = false, regTrig = true, snippetType="autosnippet"},
  --   fmta(
  --     "<>\\pdv{<>}{<>}",
  --     {
  --       f( function(_, snip) return snip.captures[1] end ),
  --       i(1),
  --       i(2)
  --     }
  --   ),
  --   {condition = tex.in_mathzone}
  -- ),
  -- -- PARTIAL DERIVATIVE with numerator, denominator, and higher-order argument
  -- s({trig = "([^%a])ppv", wordTrig = false, regTrig = true, snippetType="autosnippet"},
  --   fmta(
  --     "<>\\pdvN{<>}{<>}{<>}",
  --     {
  --       f( function(_, snip) return snip.captures[1] end ),
  --       i(1),
  --       i(2),
  --       i(3),
  --     }
  --   ),
  --   {condition = tex.in_mathzone}
  -- ),
  -- SUM with lower limit
  s({ trig = "([^%a])sum", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta(
      "<>\\sum_{<>}",
      {
        f(function(_, snip) return snip.captures[1] end),
        i(1),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- SUM with upper and lower limit
  s({ trig = "([^%a])suM", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta(
      "<>\\sum_{<>}^{<>}",
      {
        f(function(_, snip) return snip.captures[1] end),
        i(1),
        i(2),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- INTEGRAL with upper and lower limit
  s({ trig = "([^%a])intt", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta(
      "<>\\int_{<>}^{<>}",
      {
        f(function(_, snip) return snip.captures[1] end),
        i(1),
        i(2),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- INTEGRAL from positive to negative infinity
  s({ trig = "([^%a])intf", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta(
      "<>\\int_{\\infty}^{\\infty}",
      {
        f(function(_, snip) return snip.captures[1] end),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- BOXED command
  s({ trig = "boxed", wordTrig = false, regTrig = false },
    fmta(
      "<>\\boxed{<>}",
      {
        f(function(_, snip) return snip.captures[1] end),
        d(1, get_visual)
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- COLORBOXED command
  s({ trig = "colorboxed", wordTrig = false, regTrig = false },
    fmta(
      "<>\\boxed{<>}",
      {
        f(function(_, snip) return snip.captures[1] end),
        d(1, get_visual)
      }
    ),
    { condition = tex.in_mathzone }
  ),
  --
  -- BEGIN STATIC SNIPPETS
  --

  -- -- DIFFERENTIAL, i.e. \diff (interfere with ddt)
  -- s({trig = "dd", snippetType="autosnippet", priority=2000, snippetType="autosnippet"},
  --   {
  --     t("\\d"),
  --   },
  --   {condition = tex.in_mathzone}
  -- ),
  -- BASIC INTEGRAL SYMBOL, i.e. \int
  s({ trig = "in1", snippetType = "autosnippet" },
    {
      t("\\int"),
    },
    { condition = tex.in_mathzone }
  ),
  -- DOUBLE INTEGRAL, i.e. \iint
  s({ trig = "in2", snippetType = "autosnippet" },
    {
      t("\\iint"),
    },
    { condition = tex.in_mathzone }
  ),
  -- TRIPLE INTEGRAL, i.e. \iiint
  s({ trig = "in3", snippetType = "autosnippet" },
    {
      t("\\iiint"),
    },
    { condition = tex.in_mathzone }
  ),
  -- CLOSED SINGLE INTEGRAL, i.e. \oint
  s({ trig = "oi1", snippetType = "autosnippet" },
    {
      t("\\oint"),
    },
    { condition = tex.in_mathzone }
  ),
  -- CLOSED DOUBLE INTEGRAL, i.e. \oiint
  s({ trig = "oi2", snippetType = "autosnippet" },
    {
      t("\\oiint"),
    },
    { condition = tex.in_mathzone }
  ),
  -- -- GRADIENT OPERATOR, i.e. \grad
  -- s({trig = "gdd", snippetType="autosnippet"},
  --   {
  --     t("\\grad "),
  --   },
  --   {condition = tex.in_mathzone}
  -- ),
  -- -- CURL OPERATOR, i.e. \curl
  -- s({trig = "cll", snippetType="autosnippet"},
  --   {
  --     t("\\curl "),
  --   },
  --   {condition = tex.in_mathzone}
  -- ),
  -- -- DIVERGENCE OPERATOR, i.e. \divergence
  -- s({trig = "DI", snippetType="autosnippet"},
  --   {
  --     t("\\div "),
  --   },
  --   {condition = tex.in_mathzone}
  -- ),
  -- -- LAPLACIAN OPERATOR, i.e. \laplacian
  -- s({trig = "laa", snippetType="autosnippet"},
  --   {
  --     t("\\laplacian "),
  --   },
  --   {condition = tex.in_mathzone}
  -- ),
  -- PARALLEL SYMBOL, i.e. \parallel
  s({ trig = "||", snippetType = "autosnippet" },
    {
      t("\\parallel"),
    }
  ),
  -- CDOTS, i.e. \cdots
  s({ trig = "cdd", snippetType = "autosnippet" },
    {
      t("\\cdots"),
    }
  ),
  -- LDOTS, i.e. \ldots
  s({ trig = "ldd", snippetType = "autosnippet" },
    {
      t("\\ldots"),
    }
  ),
  -- EQUIV, i.e. \equiv
  s({ trig = "eqq", snippetType = "autosnippet" },
    {
      t("\\equiv "),
    }
  ),
  -- SETMINUS, i.e. \setminus
  s({ trig = "stm", snippetType = "autosnippet" },
    {
      t("\\setminus "),
    }
  ),
  -- SUBSET, i.e. \subset
  s({ trig = "sbb", snippetType = "autosnippet" },
    {
      t("\\subset "),
    }
  ),
  -- APPROX, i.e. \approx
  s({ trig = "px", snippetType = "autosnippet" },
    {
      t("\\approx "),
    },
    { condition = tex.in_mathzone }
  ),
  -- PROPTO, i.e. \propto
  s({ trig = "pt", snippetType = "autosnippet" },
    {
      t("\\propto "),
    },
    { condition = tex.in_mathzone }
  ),
  -- COLON, i.e. \colon
  s({ trig = "::", snippetType = "autosnippet" },
    {
      t("\\colon "),
    }
  ),
  -- IMPLIES, i.e. \implies
  s({ trig = ">>", snippetType = "autosnippet" },
    {
      t("\\implies "),
    }
  ),
  -- DOT PRODUCT, i.e. \cdot
  s({ trig = ",.", snippetType = "autosnippet" },
    {
      t("\\cdot "),
    }
  ),
  -- -- CROSS PRODUCT, i.e. \times
  -- s({trig = "xx", snippetType="autosnippet"},
  --   {
  --     t("\\times "),
  --   }
  -- ),
}
