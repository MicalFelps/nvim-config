return {
  {
    "mason-org/mason.nvim",
    opts = {
      ui = {
        icons = {
          package_pending = " ",
          package_installed = " ",
          package_uninstalled = " ",
        },
      },
      ensure_installed = {
        "clangd",
        "clang-format",
        "codelldb",
        "cpplint",
        "cmakelang",
        "cmakelint",
      },
    },
  },
}
