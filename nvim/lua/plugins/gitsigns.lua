return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = {
      add          = { text = "▎" },
      change       = { text = "▎" },
      delete       = { text = "" },
      topdelete    = { text = "" },
      changedelete = { text = "▎" },
      untracked    = { text = "▎" },
    },
    on_attach = function(buffer)
      local gs = package.loaded.gitsigns
      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = desc })
      end
      map("n", "]h", gs.next_hunk, "Next hunk")
      map("n", "[h", gs.prev_hunk, "Prev hunk")
      map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>",   "Stage hunk")
      map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>",   "Reset hunk")
      map("n", "<leader>hS", gs.stage_buffer,                       "Stage buffer")
      map("n", "<leader>hu", gs.undo_stage_hunk,                    "Undo stage hunk")
      map("n", "<leader>hp", gs.preview_hunk,                       "Preview hunk")
      map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
      map("n", "<leader>hd", gs.diffthis,                           "Diff this")
    end,
  },
}
