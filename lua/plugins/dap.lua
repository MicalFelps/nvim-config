return {
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    config = function()
      local dap = require("dap")

      dap.adapters.codelldb = {
        type = "executable",
        command = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb",
        args = {}, -- stdio mode
      }

      --
      -- 2️⃣TCP adapter
      --
      local tcp_port_user = nil -- user can override with :SetDAPPort
      local tcp_port_default = 1234

      -- Command to set the TCP port from Neovim
      vim.api.nvim_create_user_command("SetDAPPort", function(opts)
        tcp_port_user = tonumber(opts.args)
        print("DAP TCP port set to", tcp_port_user)
      end, { nargs = 1 })

      -- Function to check if a port is free
      local function is_port_free(port)
        local ok, socket = pcall(require, "socket")
        if not ok then
          return false
        end
        local s = socket.bind("127.0.0.1", port)
        if s then
          s:close()
          return true
        end
        return false
      end

      -- Function to pick which port to use
      local function choose_tcp_port()
        local port = tcp_port_user or tcp_port_default
        if is_port_free(port) then
          return port
        end

        -- fallback: pick a random free port
        local ok, socket = pcall(require, "socket")
        if ok then
          local s = assert(socket.bind("127.0.0.1", 0))
          local free_port = s:getsockname()[2]
          s:close()
          return free_port
        end

        return 4321
      end

      dap.adapters.codelldb_tcp = function(callback)
        local port = choose_tcp_port()
        callback({
          type = "server",
          host = "127.0.0.1",
          port = port,
          executable = {
            command = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb",
            args = { "--port", tostring(port) },
          },
        })
      end

      --
      --  Manual launch configs for C, C++, rust
      --
      for _, lang in ipairs({ "c", "cpp", "rust" }) do
        dap.configurations[lang] = dap.configurations[lang] or {}

        -- stdio launch
        table.insert(dap.configurations[lang], {
          type = "codelldb",
          name = "codelldb - IO",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        })

        -- TCP launch
        table.insert(dap.configurations[lang], {
          type = "codelldb_tcp",
          name = "codelldb - TCP",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        })
      end

      -- Optional: for better logs when troubleshooting
      -- dap.set_log_level("TRACE")
    end,
  },

  -- Optional: DAP UI
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

  -- Optional: Virtual text
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
}
