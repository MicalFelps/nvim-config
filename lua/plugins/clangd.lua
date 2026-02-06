-- lua/plugins/clangd.lua
-- Safe extension of clangd config – only apply changes if clangd is present

return {

  {
    "p00f/clangd_extensions.nvim",
    lazy = true,
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
    opts = function(_, opts)
      -- Guard: only proceed if clangd is actually configured in this pass
      if not opts.servers or not opts.servers.clangd then
        return opts -- ← early return = no crash on cmake/json/etc.
      end

      local clangd = opts.servers.clangd

      -- Safe cmd extension (start from whatever is already there)
      local base_cmd = clangd.cmd
        or {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--cross-file-rename",
          "--fallback-style=llvm",
        }

      clangd.cmd = vim.list_extend(vim.deepcopy(base_cmd), {
        "--header-insertion=never",
      })

      -- Safe merge for init_options
      clangd.init_options = vim.tbl_deep_extend("force", clangd.init_options or {}, {
        usePlaceholders = true,
        completeUnimported = true,
        clangdFileStatus = true,
      })

      -- Append your keys safely
      clangd.keys = vim.list_extend(clangd.keys or {}, {
        { "<leader>ch", "<cmd>ClangdSwitchSourceHeader<CR>", desc = "Switch Source/Header" },
        { "<leader>cH", "<cmd>ClangdTypeHierarchy<CR>", desc = "Type Hierarchy" },
        { "<leader>ct", "<cmd>ClangdSymbolInfo<CR>", desc = "Symbol Info" },
      })

      return opts
    end,

    setup = {
      clangd = function(_, opts)
        -- Only run extensions setup if clangd is real
        if opts then
          local ext_opts = require("lazyvim.util").opts("clangd_extensions.nvim") or {}
          require("clangd_extensions").setup(vim.tbl_deep_extend("force", ext_opts, { server = opts }))
        end
        return true
      end,
    },
  },
}
