return {
  "rose-pine/neovim",
  name = "rose-pine",
  priority = 1000,
  lazy = false,
  config = function()
    require("rose-pine").setup({
      variant = "main",
      styles = {
        bold = true,
        italic = false,
        transparency = true,
      },
    })
    vim.cmd.colorscheme("rose-pine")
  end,
}
