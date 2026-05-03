return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  cmd = "Neotree",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<CR>",            desc = "File explorer (toggle)" },
    { "<leader>E", "<cmd>Neotree reveal<CR>",            desc = "File explorer (reveal current)" },
    { "<leader>fe", "<cmd>Neotree float toggle<CR>",     desc = "File explorer (floating)" },
  },
  init = function()
    -- Replace netrw entirely with neo-tree
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    -- If nvim is started with a directory arg (e.g. `nvim .`), eagerly load neo-tree
    if vim.fn.argc(-1) == 1 then
      local arg = vim.fn.argv(0)
      local stat = vim.uv.fs_stat(arg)
      if stat and stat.type == "directory" then
        require("lazy").load({ plugins = { "neo-tree.nvim" } })
      end
    end
  end,
  opts = {
    close_if_last_window = true,
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,
    filesystem = {
      follow_current_file = { enabled = true },
      hijack_netrw_behavior = "open_current",
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = true,
      },
    },
    window = {
      width = 32,
      mappings = {
        ["<space>"] = "none",
        ["l"] = "open",
        ["h"] = "close_node",
      },
    },
    default_component_configs = {
      indent = { with_markers = true, indent_marker = "│", last_indent_marker = "└" },
    },
  },
}
