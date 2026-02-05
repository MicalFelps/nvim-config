-- ~/.config/nvim/lua/plugins/cpp.lua

return {
  -- Trouble.nvim
  {
    "folke/trouble.nvim",
    opts = {
      use_diagnostic_signs = true,
      modes = { diagnostics = { auto_open = false } },
    },
  },

  -- Emoji completion for nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji", "hrsh7th/cmp-nvim-lsp" },
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji", group_index = 2 })
    end,
  },

  -- clangd LSP override
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--cross-file-rename",
            "--fallback-style=llvm",
            -- "--compile-commands-dir=build", -- uncomment if fixed build folder
          },
          keys = {
            { "<leader>ch", "<cmd>ClangdSwitchSourceHeader<CR>", desc = "Switch Source/Header" },
            { "<leader>cH", "<cmd>ClangdTypeHierarchy<CR>", desc = "Type Hierarchy" },
            { "<leader>ct", "<cmd>ClangdSymbolInfo<CR>", desc = "Symbol Info" },
          },
          init_options = {
            clangdFileStatus = true,
            usePlaceholders = true,
            completeUnimported = true,
          },
        },
      },
    },
  },

  -- Treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "c", "cpp", "cmake", "make" })
      end
    end,
  },

  -- Mason tools
  {
    "mason-org/mason.nvim",
    opts = {
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

  -- cmake-tools config
  {
    "Civitasv/cmake-tools.nvim",
    opts = {
      cmake_build_directory = "build",
      cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
      cmake_build_options = { "--parallel" },
    },
  },

  -- Formatting (conform.nvim)
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        c = { "clang_format" },
        cpp = { "clang_format" },
        cmake = { "cmakelang" },
      },
    },
  },

  -- Linting (nvim-lint)
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        c = { "cpplint" },
        cpp = { "cpplint" },
        cmake = { "cmakelint" },
      },
    },
  },

  -- Debugging (DAP with codelldb)
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        "jay-babu/mason-nvim-dap.nvim",
        opts = {
          ensure_installed = { "codelldb" },
          handlers = {
            codelldb = function(config)
              config.adapters = {
                type = "server",
                port = "${port}",
                executable = {
                  command = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb",
                  args = { "--port", "${port}" },
                },
              }
              require("mason-nvim-dap").default_setup(config)
            end,
          },
        },
      },
    },
    keys = {
      {
        "<F5>",
        function()
          require("dap").continue()
        end,
        desc = "Debugger: Continue",
      },
      {
        "<F10>",
        function()
          require("dap").step_over()
        end,
        desc = "Debugger: Step Over",
      },
      {
        "<F11>",
        function()
          require("dap").step_into()
        end,
        desc = "Debugger: Step Into",
      },
      {
        "<F12>",
        function()
          require("dap").step_out()
        end,
        desc = "Debugger: Step Out",
      },
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
      },
    },
  },

  -- Optional extras
  { "folke/todo-comments.nvim", enabled = true },
  { "windwp/nvim-ts-autotag", enabled = false },
}
