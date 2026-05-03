return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function() return vim.fn.executable("make") == 1 end,
    },
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<leader>ff", function() require("telescope.builtin").find_files() end,  desc = "Find files" },
    { "<leader>fg", function() require("telescope.builtin").live_grep() end,   desc = "Live grep" },
    { "<leader>fb", function() require("telescope.builtin").buffers() end,     desc = "Buffers" },
    { "<leader>fh", function() require("telescope.builtin").help_tags() end,   desc = "Help tags" },
    { "<leader>fr", function() require("telescope.builtin").oldfiles() end,    desc = "Recent files" },
    { "<leader>fs", function() require("telescope.builtin").lsp_document_symbols() end, desc = "Document symbols" },
    { "<leader>fS", function() require("telescope.builtin").lsp_dynamic_workspace_symbols() end, desc = "Workspace symbols" },
    { "<leader>fd", function() require("telescope.builtin").diagnostics() end, desc = "Diagnostics" },
    { "<leader>fk", function() require("telescope.builtin").keymaps() end,     desc = "Keymaps" },
    { "<leader>/",  function() require("telescope.builtin").current_buffer_fuzzy_find() end, desc = "Search in buffer" },
  },
  opts = {
    defaults = {
      prompt_prefix = "  ",
      selection_caret = " ",
      path_display = { "truncate" },
      layout_config = { horizontal = { preview_width = 0.55 } },
      mappings = {
        i = {
          ["<C-u>"] = false,
          ["<Esc>"] = "close",
        },
      },
    },
    pickers = {
      find_files = { hidden = true, find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" } },
    },
  },
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    pcall(telescope.load_extension, "fzf")
  end,
}
