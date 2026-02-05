return {
  {
    "p00f/clangd_extensions.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    opts = {
      inlay_hints = {
        inline = false,
        only_current_line = false,
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=never",
            "--completion-style=detailed",
            "--cross-file-rename",
            "--fallback-style=llvm",
            "--function-arg-placeholders",
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
          keys = {
            { "<leader>ch", "<cmd>ClangdSwitchSourceHeader<CR>", desc = "Switch Source/Header" },
            { "<leader>cH", "<cmd>ClangdTypeHierarchy<CR>", desc = "Type Hierarchy" },
            { "<leader>ct", "<cmd>ClangdSymbolInfo<CR>", desc = "Type Hierarchy" },
          },
        },
      },
      setup = {
        clangd = function(_, opts)
          local ext_opts = LazyVim.opts("clangd_extensions.nvim") or {}
          require("clangd_extensions").setup(vim.tbl_deep_extend("force", ext_opts, { server = opts }))
          return true
        end,
      },
    },
  },
}
