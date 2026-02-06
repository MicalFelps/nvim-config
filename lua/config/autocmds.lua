-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- lua/config/autocmds.lua

local dap_group = vim.api.nvim_create_augroup("DapCustomSigns", { clear = true })

local function setup_dap_signs()
  -- Highlights (adjust colors to match your theme)
  vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#ff0000" }) -- bright red
  vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#ffa500" }) -- orange
  vim.api.nvim_set_hl(0, "DapBreakpointRejected", { fg = "#ff4500" }) -- red-orange
  vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#00bfff" }) -- deep sky blue
  vim.api.nvim_set_hl(0, "DapStopped", { fg = "#00ff00" }) -- lime green

  -- Signs
  vim.fn.sign_define("DapBreakpoint", {
    text = "●", -- change to "🛑", "🔴", "", "•", etc.
    texthl = "DapBreakpoint",
    linehl = "", -- or "CursorLine" for line highlight
    numhl = "DapBreakpoint",
  })

  vim.fn.sign_define("DapBreakpointCondition", {
    text = "◆",
    texthl = "DapBreakpointCondition",
    linehl = "",
    numhl = "DapBreakpointCondition",
  })

  vim.fn.sign_define("DapBreakpointRejected", {
    text = "✖",
    texthl = "DapBreakpointRejected",
    linehl = "",
    numhl = "DapBreakpointRejected",
  })

  vim.fn.sign_define("DapLogPoint", {
    text = "●",
    texthl = "DapLogPoint",
    linehl = "",
    numhl = "DapLogPoint",
  })

  vim.fn.sign_define("DapStopped", {
    text = "→",
    texthl = "DapStopped",
    linehl = "CursorLine", -- optional: highlight paused line
    numhl = "DapStopped",
  })
end

-- Run immediately (in case event already fired)
setup_dap_signs()

-- Re-apply on any colorscheme change
vim.api.nvim_create_autocmd("ColorScheme", {
  group = dap_group,
  pattern = "*",
  callback = setup_dap_signs,
  desc = "Re-apply DAP custom signs after colorscheme load",
})
