return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
  keys = {
    { "<leader>vd", "<cmd>DiffviewOpen<cr>", desc = "Open diff view" },
    { "<leader>vc", "<cmd>DiffviewClose<cr>", desc = "Close diff view" },
    { "<leader>vh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
    { "<leader>vr", "<cmd>DiffviewOpen origin/main...HEAD<cr>", desc = "Review PR changes" },
  },
  config = function()
    local actions = require("diffview.actions")

    require("diffview").setup({
      enhanced_diff_hl = true,
      view = {
        default = {
          layout = "diff2_horizontal",
        },
        merge_tool = {
          layout = "diff3_horizontal",
        },
        file_history = {
          layout = "diff2_horizontal",
        },
      },
      file_panel = {
        listing_style = "list",
        win_config = {
          position = "left",
          width = 35,
        },
      },
      keymaps = {
        view = {
          -- Navigation between hunks (changes)
          { "n", "]c", actions.next_conflict, { desc = "Next change/conflict" } },
          { "n", "[c", actions.prev_conflict, { desc = "Prev change/conflict" } },
          { "n", "]x", actions.next_conflict, { desc = "Next change/conflict" } },
          { "n", "[x", actions.prev_conflict, { desc = "Prev change/conflict" } },
          -- Jump to next/prev file in the diff
          { "n", "]f", actions.select_next_entry, { desc = "Next file" } },
          { "n", "[f", actions.select_prev_entry, { desc = "Prev file" } },
          -- Toggle file panel
          { "n", "<leader>e", actions.toggle_files, { desc = "Toggle file panel" } },
          -- Focus file panel
          { "n", "<leader>b", actions.focus_files, { desc = "Focus file panel" } },
          -- Toggle full file vs only changes (both panes)
          {
            "n",
            "<leader>o",
            function()
              local current_tab = vim.api.nvim_get_current_tabpage()
              local new_state = not vim.wo.foldenable

              for _, win in ipairs(vim.api.nvim_tabpage_list_wins(current_tab)) do
                local buf = vim.api.nvim_win_get_buf(win)
                local bufname = vim.api.nvim_buf_get_name(buf)
                if bufname:match("diffview://") then
                  vim.api.nvim_win_call(win, function()
                    vim.wo.foldenable = new_state
                  end)
                end
              end
            end,
            { desc = "Toggle full file / only changes (both panes)" },
          },
        },
        file_panel = {
          -- Navigation in file panel
          { "n", "j", actions.next_entry, { desc = "Next file" } },
          { "n", "k", actions.prev_entry, { desc = "Prev file" } },
          { "n", "<cr>", actions.select_entry, { desc = "Open file diff" } },
          { "n", "o", actions.select_entry, { desc = "Open file diff" } },
          { "n", "l", actions.select_entry, { desc = "Open file diff" } },
          { "n", "<tab>", actions.select_next_entry, { desc = "Open next file" } },
          { "n", "<s-tab>", actions.select_prev_entry, { desc = "Open prev file" } },
          -- Toggle panel
          { "n", "<leader>e", actions.toggle_files, { desc = "Toggle file panel" } },
          -- Refresh
          { "n", "R", actions.refresh_files, { desc = "Refresh" } },
        },
      },
    })
  end,
}
