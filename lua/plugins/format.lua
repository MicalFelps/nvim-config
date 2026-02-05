return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        c = {
          {
            exe = "clang-format",
            args = {
              "-style={BasedOnStyle: Google, SortIncludes: false, IncludeBlocks: Preserve, IndentWidth: 4, TabWidth: 4, UseTab: Never}",
            },
          },
        },
        cpp = {
          {
            exe = "clang-format",
            args = {
              "-style={BasedOnStyle: Google, SortIncludes: false, IncludeBlocks: Preserve, IndentWidth: 4, TabWidth: 4, UseTab: Never}",
            },
          },
        },
      },
    },
  },
}
