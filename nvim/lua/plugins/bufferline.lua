return {
  "akinsho/bufferline.nvim",
  version = "*",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<S-h>", "<cmd>BufferLineCyclePrev<CR>", desc = "Prev buffer" },
    { "<S-l>", "<cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
    { "<leader>bp", "<cmd>BufferLineTogglePin<CR>", desc = "Pin buffer" },
    { "<leader>bd", "<cmd>bdelete<CR>", desc = "Delete buffer" },
  },
  opts = {
    options = {
      diagnostics = "nvim_lsp",
      always_show_bufferline = true,
      show_buffer_close_icons = false,
      show_close_icon = false,
      offsets = {
        { filetype = "neo-tree", text = "Explorer", text_align = "left", separator = true },
      },
    },
  },
}
