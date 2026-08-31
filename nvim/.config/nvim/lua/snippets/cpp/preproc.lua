local helpers = require('snippets.snippet_helper')
local get_visual = helpers.get_visual

local line_begin = require("luasnip.extras.expand_conditions").line_begin

return
{
  -- GENERIC HEADER INCLUDE
  s({ trig = "inc", snippetType = "autosnippet" },
    fmt(
      [[#include <{}>]],
      {
        d(1, get_visual)
      }
    ),
    { condition = line_begin }
  ),
  s({ trig = "inq", snippetType = "autosnippet" },
    fmt(
      [[#include "{}"]],
      {
        d(1, get_visual)
      }
    ),
    { condition = line_begin }
  ),
  s({ trig = "iln", snippetType = "autosnippet" }, -- l: local headers
    fmt(
      [[#include "{}.h"]],
      {
        d(1, get_visual)
      }
    ),
    { condition = line_begin }
  ),
  -- STDIO HEADER
  s({ trig = "iio", snippetType = "autosnippet" },
    { t('#include <iostream>') },
    { condition = line_begin }
  ),
  -- STDLIB HEADER
  s({ trig = "ivv", snippetType = "autosnippet" },
    { t('#include <vector>') },
    { condition = line_begin }
  ),
  -- STRING HEADER
  s({ trig = "istt", snippetType = "autosnippet" },
    { t('#include <string>') },
    { condition = line_begin }
  ),
}
