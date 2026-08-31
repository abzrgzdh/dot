local helpers = require('snippets.snippet_helper')
local get_visual = helpers.get_visual

local line_begin = require("luasnip.extras.expand_conditions").line_begin

return
{

  s({ trig = "main" },
    fmta(
      [[
        int main(<>)
        {
            <>
            return 0;
        }
      ]],
      {
        i(1, "int argc, char** argv"),
        i(0)
      }
    ),
    { condition = line_begin }
  ),
}
