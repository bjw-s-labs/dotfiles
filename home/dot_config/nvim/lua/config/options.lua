vim.opt.cmdheight = 0
vim.opt.cursorline = true -- Enable highlighting of the current line
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.laststatus = 3 -- global statusline
vim.opt.number = true -- Print line number
vim.opt.relativenumber = false -- Relative line numbers
vim.opt.ruler = false -- Disable the default ruler
vim.opt.shiftwidth = 2 -- Size of an indent
vim.opt.showmode = false -- Don't show the mode, since it's already in the status line
vim.opt.signcolumn = "yes" -- Keep signcolumn on by default
vim.opt.smartindent = true -- Insert indents automatically
vim.opt.tabstop = 2 -- Number of spaces tabs count for
vim.opt.termguicolors = true -- True color support
vim.opt.wrap = false -- Disable line wrap

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)
