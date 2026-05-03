return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>cf",
      function() require("conform").format({ async = true, lsp_fallback = true }) end,
      mode = { "n", "v" },
      desc = "Format buffer",
    },
    {
      "<leader>tf",
      function()
        if vim.g.disable_autoformat or vim.b.disable_autoformat then
          vim.g.disable_autoformat = false
          vim.b.disable_autoformat = false
          vim.notify("Format-on-save: ON")
        else
          vim.g.disable_autoformat = true
          vim.notify("Format-on-save: OFF (global)")
        end
      end,
      desc = "Toggle format-on-save",
    },
  },
  opts = {
    formatters_by_ft = {
      lua        = { "stylua" },
      python     = { "ruff_format", "ruff_organize_imports" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      json       = { "prettier" },
      jsonc      = { "prettier" },
      yaml       = { "prettier" },
      markdown   = { "prettier" },
      html       = { "prettier" },
      css        = { "prettier" },
      c          = { "clang-format" },
      cpp        = { "clang-format" },
    },
    format_on_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 1500, lsp_fallback = true }
    end,
  },
}
