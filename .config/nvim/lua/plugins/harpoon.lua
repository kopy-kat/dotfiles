return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-telescope/telescope.nvim" },
  opts = {
    menu = {
      width = vim.api.nvim_win_get_width(0) - 4,
    },
    settings = {
      save_on_toggle = true,
    },
  },
  keys = function()
    local harpoon = require("harpoon")

    -- Custom Telescope-based UI
    local conf = require("telescope.config").values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require("telescope.pickers")
        .new({}, {
          prompt_title = "Harpoon",
          finder = require("telescope.finders").new_table({
            results = file_paths,
          }),
          previewer = conf.file_previewer({}),
          sorter = conf.generic_sorter({}),
          attach_mappings = function(prompt_bufnr, map)
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")
            map("i", "<CR>", function()
              local selection = action_state.get_selected_entry()
              actions.close(prompt_bufnr)
              vim.cmd("edit " .. selection.value)
            end)
            return true
          end,
        })
        :find()
    end

    local keys = {
      {
        "<leader>H",
        function()
          harpoon:list():add()
        end,
        desc = "Harpoon File",
      },
      {
        "<C-e>",
        function()
          toggle_telescope(harpoon:list())
        end,
        desc = "Harpoon Telescope Menu (Alt key)",
      },
    }

    -- Jump to Harpoon file
    for i = 1, 9 do
      table.insert(keys, {
        "<leader>" .. i,
        function()
          harpoon:list():select(i)
        end,
        desc = "Harpoon to File " .. i,
      })
    end

    return keys
  end,
}
