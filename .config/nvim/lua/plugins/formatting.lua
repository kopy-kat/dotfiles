return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        javascript = { "biome" },
        typescript = { "biome" },
        javascriptreact = { "biome" },
        typescriptreact = { "biome" },
        css = { "biome" },
        json = { "biome" },
        lua = { "stylua" },
        solidity = { "forge_fmt" },
      },
      format_on_save = {
        lsp_fallback = false,
        async = false,
        timeout_ms = 1000,
      },
      formatters = {
        forge_fmt = function()
          return {
            command = "forge",
            args = { "fmt" },
            cwd = require("conform.util").root_file({ "foundry.toml" }),
            -- When cwd is not found, don't run the formatter (default false)
            require_cwd = true,
            condition = function(ctx)
              return vim.fs.basename(ctx.filename) ~= "foundry.toml"
            end,
          }
        end,
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
