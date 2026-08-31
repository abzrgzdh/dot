return {
  "wassup05/fortran.nvim",
  lazy = true,
  -- load the plugin when `ft` is fortran
  ft = { "fortran" },
  opts = {
    server_opts = {
      enabled = true,
      path = "fortls",
      args = {
        "--notify_init",
        '--lowercase_intrinsics',
        "--hover_signature",
        "--hover_language=fortran",
        "--use_signature_help",
        "--enable_code_actions",
      },
      filetypes = { "fortran" },
      settings = {},
    },

    fpm_opts = {
      enabled = true,
      path = "fpm",
      args = {
        -- fpm args go here exactly as you would pass them to fpm
      },
      terminal = true,
    },

    formatter_opts = {
      enabled = true,
      path = "fprettify",
      format_on_save = false,
      args = {
        -- fpretiffy args go here exactly as you would pass them to fprettify
      },
    },
  }
}
