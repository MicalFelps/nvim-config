return {
  {
    "folke/snacks.nvim",
    opts = {
      explorer = {
        enabled = false, -- This disables the explorer completely
      },
    },
    keys = {
      -- Disable the default Snacks explorer keymaps (prevents it from opening)
      { "<leader>e", false },
      { "<leader>E", false },
      { "<leader>fe", false },
      { "<leader>fE", false },
    },
  },
}
