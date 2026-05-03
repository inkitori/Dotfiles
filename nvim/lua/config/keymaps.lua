local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

map("n", "<C-Up>",    "<cmd>resize +2<CR>",          { desc = "Resize up" })
map("n", "<C-Down>",  "<cmd>resize -2<CR>",          { desc = "Resize down" })
map("n", "<C-Left>",  "<cmd>vertical resize -2<CR>", { desc = "Resize left" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Resize right" })

map("v", "<", "<gv", { desc = "Indent left, keep selection" })
map("v", ">", ">gv", { desc = "Indent right, keep selection" })

map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

map("n", "n", "nzzzv", { desc = "Next match, centered" })
map("n", "N", "Nzzzv", { desc = "Prev match, centered" })

map("n", "<leader>w", "<cmd>w<CR>",  { desc = "Write" })
map("n", "<leader>q", "<cmd>q<CR>",  { desc = "Quit" })

map("n", "]d", function() vim.diagnostic.goto_next() end, { desc = "Next diagnostic" })
map("n", "[d", function() vim.diagnostic.goto_prev() end, { desc = "Prev diagnostic" })
map("n", "<leader>cd", function() vim.diagnostic.open_float() end, { desc = "Line diagnostics" })
