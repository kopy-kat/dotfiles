return {
  "nvim-pack/nvim-spectre",
  opts = {
    live_update = true,
    replace_engine = {
      ["sed"] = {
        cmd = "sed",
        args = {
          "-i",
          "",
          "-E",
        },
      },
    },
  },
}
