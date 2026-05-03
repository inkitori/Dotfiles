return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufNewFile", "BufWritePost" },
  config = function()
    local lint = require("lint")
    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      python = { "ruff" },
    }

    -- Skip linters whose executables aren't on PATH yet (Mason still installing,
    -- or the project doesn't ship a particular tool). Avoids noisy ENOENT errors.
    local function try_lint()
      local names = lint.linters_by_ft[vim.bo.filetype] or {}
      local runnable = {}
      for _, name in ipairs(names) do
        local linter = lint.linters[name]
        if linter then
          local cmd = type(linter.cmd) == "function" and linter.cmd() or linter.cmd
          if cmd and vim.fn.executable(cmd) == 1 then
            table.insert(runnable, name)
          end
        end
      end
      if #runnable > 0 then
        lint.try_lint(runnable)
      end
    end

    local g = vim.api.nvim_create_augroup("user_lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
      group = g,
      callback = try_lint,
    })
  end,
}
