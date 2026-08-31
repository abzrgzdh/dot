---@diagnostic disable: unused-local

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

return {
  s({ trig = "sout", snippetType = "autosnippet" },
    fmta("System.out.println(<>);", { i(1) })
  ),

  s({ trig = "psv", snippetType = "autosnippet" },
    fmta("public static void <>", { i(1, "main") })
  ),

  s({ trig = "main" },
    fmta([[
        package <>;

        public class Main {
            public static void main(String[] argv) {
                <><>
            }
        }
        ]], { i(1), i(2), i(0) })
  ),

  s({ trig = "interface" },
    fmta([[
        public interface <> {
            <>
        }
        ]], { i(1), i(2) })
  ),

  s({ trig = "class" },
    fmta([[
        <> <>class <> <>{
            <>
        }
        ]], { i(1, "public"), i(2), i(3, "ClassName"), i(4), i(5) })
  ),

  s({ trig = "method" },
    fmta([[
        <> <><> <>(<>) {
            <>
        }<>
        ]], { i(1, "public"), i(2), i(3, "void"), i(4, "myMethod"), i(5), i(6), i(0) })
  ),

  s({ trig = "try" },
    fmta([[
        try {
            <>
        } catch (<>) {
            <>
        }<>
        ]], { i(1), i(2, "Exception e"), i(3), i(0) })
  ),

}
