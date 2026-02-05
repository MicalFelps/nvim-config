return {

  -- 1. Core DAP
  {
    "mfussenegger/nvim-dap",
    lazy = true, -- loaded by keys or events
    dependencies = {
      -- UI for DAP
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        opts = {}, -- defaults are usually fine
        config = function(_, opts)
          local dap = require("dap")
          local dapui = require("dapui")
          dapui.setup(opts)

          -- Auto open/close UI
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

      -- Virtual text (shows variable values inline)
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {
          enabled = true,
          enabled_commands = true,
          highlight_changed_variables = true,
          highlight_new_as_changed = true,
        },
      },

      -- Optional: better icons
      {
        "nvim-tree/nvim-web-devicons", -- already in LazyVim, but ensure
      },
    },

    -- Install & configure adapters via mason-nvim-dap
    {
      "mason-org/mason.nvim",
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        vim.list_extend(opts.ensure_installed, { "codelldb" })
      end,
    },

    {
      "jay-babu/mason-nvim-dap.nvim",
      dependencies = { "mason-org/mason.nvim", "mfussenegger/nvim-dap" },
      opts = {
        ensure_installed = { "codelldb" },
        handlers = {
          -- Special handler for codelldb
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

  -- 2. Keymaps
  {
    "mfussenegger/nvim-dap",
    keys = {
      -- Basic debugging
      {
        "<F5>",
        function()
          require("dap").continue()
        end,
        desc = "DAP: Continue",
      },
      {
        "<F10>",
        function()
          require("dap").step_over()
        end,
        desc = "DAP: Step Over",
      },
      {
        "<F11>",
        function()
          require("dap").step_into()
        end,
        desc = "DAP: Step Into",
      },
      {
        "<F12>",
        function()
          require("dap").step_out()
        end,
        desc = "DAP: Step Out",
      },

      -- Breakpoints & UI
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "DAP: Toggle Breakpoint",
      },
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "DAP: Conditional Breakpoint",
      },
      {
        "<leader>du",
        function()
          require("dapui").toggle()
        end,
        desc = "DAP: Toggle UI",
      },
      {
        "<leader>de",
        function()
          require("dapui").eval()
        end,
        desc = "DAP: Eval under cursor",
        mode = { "n", "v" },
      },
    },
  },

  -- 3. Optional: simple launch config for C/C++/Rust (prompts for executable)
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")

      -- Minimal launch config (used if no language extra provides better ones)
      for _, ft in ipairs({ "c", "cpp", "rust" }) do
        dap.configurations[ft] = dap.configurations[ft] or {}
        table.insert(dap.configurations[ft], {
          type = "codelldb",
          name = "Launch (manual)",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        })
      end
    end,
  },
}
