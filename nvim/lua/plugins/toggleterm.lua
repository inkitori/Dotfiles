return {
  "akinsho/toggleterm.nvim",
  version = "*",
  cmd = { "ToggleTerm", "ToggleTermSendCurrentLine", "ToggleTermSendVisualLines" },
  keys = {
    { "<leader>tt", "<cmd>ToggleTerm direction=float<CR>",            desc = "Terminal (float)" },
    { "<leader>th", "<cmd>ToggleTerm direction=horizontal size=15<CR>", desc = "Terminal (horizontal)" },
    { "<leader>tv", "<cmd>ToggleTerm direction=vertical size=80<CR>",  desc = "Terminal (vertical)" },
    { "<C-\\>",     "<cmd>ToggleTerm direction=float<CR>",             desc = "Terminal (float)" },
    { "<C-\\>",     "<cmd>ToggleTerm direction=float<CR>", mode = "t", desc = "Terminal (float)" },
  },
  opts = {
    shade_terminals = false,
    float_opts = { border = "rounded" },
    highlights = {
      Normal       = { guibg = "NONE" },
      NormalFloat  = { guibg = "NONE" },
      FloatBorder  = { guibg = "NONE" },
    },
  },
}
