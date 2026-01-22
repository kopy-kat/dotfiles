return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  -- make sure mason and mason-lspconfig are installed and loaded before using setup_handlers
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
  },
  config = function()
    -- safe requires so we can produce helpful errors instead of nil-call stacktraces
    local ok_mason, mason = pcall(require, "mason")
    local ok_mason_lspconfig, mason_lspconfig = pcall(require, "mason-lspconfig")
    local ok_lspconfig, lspconfig = pcall(require, "lspconfig")
    local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

    if not ok_lspconfig then
      vim.notify("nvim-lspconfig not available", vim.log.levels.ERROR)
      return
    end

    -- create LspAttach mappings (unchanged)
    local keymap = vim.keymap
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }

        opts.desc = "Show LSP references"
        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)
        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
        opts.desc = "Show LSP definitions in vertical split"
        keymap.set("n", "<leader>gv", function()
          vim.cmd("vsplit")
          vim.cmd("Telescope lsp_definitions")
        end, opts)
        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)
        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts)
        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
      end,
    })

    -- completion capabilities (guarded)
    local capabilities = ok_cmp and cmp_nvim_lsp.default_capabilities()
      or vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), {})

    -- diagnostic signs
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    -- If mason is available, setup it up first
    if ok_mason then
      -- optional: configure install location / UI etc.
      mason.setup()
    end

    -- if mason-lspconfig is present, call setup() then setup_handlers()
    if ok_mason_lspconfig then
      -- setup_handlers is provided by mason-lspconfig; guard the call
      if type(mason_lspconfig.setup_handlers) == "function" then
        mason_lspconfig.setup_handlers({
          -- default handler
          function(server_name)
            -- some servers have different names in lspconfig, guard those lookups
            local ok, srv = pcall(function()
              return lspconfig[server_name]
            end)
            if ok and srv then
              lspconfig[server_name].setup({
                capabilities = capabilities,
              })
            end
          end,
          ["lua_ls"] = function()
            if lspconfig["lua_ls"] then
              lspconfig["lua_ls"].setup({
                capabilities = capabilities,
                settings = {
                  Lua = {
                    diagnostics = { globals = { "vim" } },
                    completion = { callSnippet = "Replace" },
                  },
                },
              })
            end
          end,
          ["solidity"] = function()
            -- your custom mapping for solidity server name
            if lspconfig["solidity_ls_nomicfoundation"] then
              lspconfig["solidity_ls_nomicfoundation"].setup({
                capabilities = capabilities,
                settings = { solidity = { includePath = "" } },
              })
            end
          end,
        })
      else
        vim.notify("mason-lspconfig.setup_handlers not available", vim.log.levels.WARN)
      end
    else
      -- fallback: if user didn't install mason-lspconfig, still allow manual lspconfig setup
      vim.notify(
        "mason-lspconfig not available; skipping setup_handlers. You should add williamboman/mason-lspconfig.nvim to plugins.",
        vim.log.levels.WARN
      )

      -- Example manual setup for commonly used servers:
      -- if lspconfig["lua_ls"] then lspconfig["lua_ls"].setup({ capabilities = capabilities }) end
    end
  end,
}
