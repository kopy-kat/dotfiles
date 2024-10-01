return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    local copilot = require("copilot")
    copilot.setup({
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = false, -- Disable the default accept keymap
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
    })

    -- Custom function to handle Tab key
    local function clever_tab()
      if require("copilot.suggestion").is_visible() then
        require("copilot.suggestion").accept()
      else
        return vim.api.nvim_replace_termcodes("<Tab>", true, false, true)
      end
    end

    -- Set up the keymapping
    vim.keymap.set("i", "<Tab>", clever_tab, { expr = true, replace_keycodes = false })
    vim.keymap.set("n", "ct", function()
      require("copilot.suggestion").toggle_auto_trigger()
    end, { expr = false })
  end,
}
