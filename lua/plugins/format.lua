return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        c = { "clang_format" },
        cpp = { "clang_format" },
      },

      -- Custom settings for the clang_format formatter
      formatters = {
        clang_format = {
          -- Fully override the default args if you want — or use prepend_args to add to them
          prepend_args = {
            "--style",
            "{BasedOnStyle: Google, SortIncludes: false, IncludeBlocks: Preserve, IndentWidth: 4, TabWidth: 4, UseTab: Never}",
          },

          -- If you prefer to completely replace the default args (not usually needed):
          -- args = { "--style", "{...your full style...}" },
        },
      },
    },
  },
}
