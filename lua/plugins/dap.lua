return {

  -- 1. DAP UI – beautiful panels for variables, call stack, etc.
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },

  -- 2. Inline virtual text (variable values next to code)
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      enabled = true,
      enabled_commands = true,
      highlight_changed_variables = true,
      highlight_new_as_changed = false,
      show_stop_reason = true,
      commented = false,
      only_first_definition = true,
      all_references = false,
      clear_on_continue = false, -- avoid flicker during continue
      -- You can customize display_callback if needed
    },
  },

  -- 3. Bridge: install & auto-configure adapters via Mason
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      ensure_installed = { "codelldb" },
      automatic_installation = true,
      automatic_setup = true, -- ← this enables default_setup for everything in ensure_installed
      handlers = {
        function(config)
          require("mason-nvim-dap").default_setup(config)
        end,
        -- If you ever need custom codelldb (usually NOT needed anymore):
        -- codelldb = function(config)
        --   config.adapters = {
        --     type = "server",
        --     port = "${port}",
        --     host = "127.0.0.1",
        --     executable = {
        --       command = vim.fn.exepath("codelldb"),
        --       args = { "--port", "${port}" },
        --     },
        --   }
        --   require("mason-nvim-dap").default_setup(config)
        -- end,
      },
    },
  },

  -- 4. Core nvim-dap + your custom configurations & keymaps
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    config = function()
      local dap = require("dap")

      -- Optional: add your manual launch config (good fallback)
      -- LazyVim extras (lang.clangd, lang.rust, etc.) often already provide similar/better ones
      for _, lang in ipairs({ "c", "cpp", "rust" }) do
        dap.configurations[lang] = dap.configurations[lang] or {}

        -- Only append if you want your custom one alongside defaults
        table.insert(dap.configurations[lang], {
          type = "codelldb",
          name = "Launch (manual input)",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          -- You can add more fields later:
          -- args = {},
          -- env = { SOME_VAR = "value" },
        })
      end

      -- Optional: for better logs when troubleshooting
      -- dap.set_log_level("TRACE")
    end,
  },
}
