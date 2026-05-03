local g = vim.api.nvim_create_augroup("user_cmds", { clear = true })

-- Transparency: clear backgrounds on every colorscheme load so plugin floats
-- (telescope, neo-tree, which-key, trouble, blink.cmp) inherit terminal bg.
vim.api.nvim_create_autocmd("ColorScheme", {
  group = g,
  callback = function()
    local groups = {
      "Normal", "NormalNC", "NormalFloat", "FloatBorder",
      "SignColumn", "LineNr", "CursorLineNr", "EndOfBuffer",
      "VertSplit", "WinSeparator", "StatusLine", "StatusLineNC",
      "TelescopeNormal", "TelescopeBorder", "TelescopePromptNormal",
      "TelescopePromptBorder", "TelescopeResultsNormal", "TelescopePreviewNormal",
      "NeoTreeNormal", "NeoTreeNormalNC", "NeoTreeEndOfBuffer",
      "WhichKeyFloat", "TroubleNormal", "TroubleNormalNC",
      "BufferLineFill", "Pmenu", "PmenuSel",
      "BlinkCmpMenu", "BlinkCmpMenuBorder", "BlinkCmpDoc", "BlinkCmpDocBorder",
    }
    for _, group in ipairs(groups) do
      vim.api.nvim_set_hl(0, group, { bg = "NONE", ctermbg = "NONE" })
    end
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = g,
  callback = function() vim.highlight.on_yank({ timeout = 200 }) end,
})

-- Trim trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = g,
  callback = function()
    local save = vim.fn.winsaveview()
    vim.cmd([[silent! %s/\s\+$//e]])
    vim.fn.winrestview(save)
  end,
})
