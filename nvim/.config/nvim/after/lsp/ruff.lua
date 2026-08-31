return {
  cmd = {"ruff", "server"},
  filetypes = {"python"},
  root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
  init_options = {
    settings = {
      -- Server settings should go here
      -- Any extra CLI arguments for `ruff` go here.
      args = {},
    }
  }
}
