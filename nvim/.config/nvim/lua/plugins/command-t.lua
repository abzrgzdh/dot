-- DOES NOT RESPECT WILDIGNORE
-- ONLY WORKS IN GIT_REPOS

-- source: https://github.com/vEnhance/dotfiles/blob/6dc85cc905f8a041876ad62bdc8faaf1e0cae696/nvim/lua/config/keymaps.lua#L54
local function is_git_repo()
  vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null")
  -- if vim.v.shell_error == 0 then
  --   print("Find File Git Repo")
  -- end
  return vim.v.shell_error == 0
end

return {
  "wincent/command-t",
  priority = 1000,
  lazy = false,
  build = 'cd lua/wincent/commandt/lib && make',
  config = function()
    require('wincent.commandt').setup({
    })

    -- ???
    vim.keymap.set("n", "<leader>F",
      function()
        if is_git_repo() then
          vim.cmd.CommandTGit()
        else
          vim.cmd.CommandTFind()
        end
      end,
      { noremap = true, silent = true }
    )

    vim.keymap.set("n", "<leader>eh", "<cmd>CommandTHelp<cr>", { noremap = true, silent = true })
  end,
}
