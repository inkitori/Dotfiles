return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "TSUpdate", "TSInstall", "TSInstallInfo", "TSModuleInfo" },
  main = "nvim-treesitter.configs",
  opts = {
    ensure_installed = {
      "bash", "c", "cpp", "css", "diff", "dockerfile", "go", "html",
      "javascript", "json", "jsonc", "lua", "luadoc", "make", "markdown",
      "markdown_inline", "python", "regex", "rust", "toml", "tsx",
      "typescript", "vim", "vimdoc", "yaml",
    },
    auto_install = true,
    highlight = { enable = true, additional_vim_regex_highlighting = false },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>",
        node_incremental = "<C-space>",
        scope_incremental = false,
        node_decremental = "<bs>",
      },
    },
  },
}
