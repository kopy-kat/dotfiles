return {
  {
    "ruifm/gitlinker.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("gitlinker").setup({
        opts = {
          -- adds current line nr in the url for normal mode
          add_current_line_on_normal_mode = false,
          -- print the url after performing the action
          print_url = false,
        },
      })
    end,
  },
}
