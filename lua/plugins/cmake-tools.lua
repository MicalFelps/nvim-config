return {
  {
    "Civitasv/cmake-tools.nvim",
    opts = {
      cmake_build_directory = "build",
      cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
      cmake_build_options = { "--parallel" },
    },
  },
}
