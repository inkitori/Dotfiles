return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    win = { border = "rounded" },
    spec = {
      { "<leader>b", group = "buffer" },
      { "<leader>c", group = "code" },
      { "<leader>f", group = "find/file" },
      { "<leader>h", group = "git hunk" },
      { "<leader>t", group = "toggle/term" },
      { "<leader>x", group = "trouble/diagnostics" },
    },
  },
  keys = {
    {
      "<leader>?",
      function() require("which-key").show({ global = false }) end,
      desc = "Buffer keymaps",
    },
  },
}
