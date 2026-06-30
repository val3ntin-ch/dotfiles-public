-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- disable providers we don't use (silences :checkhealth warnings)
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0

-- ensure terminals spawned inside nvim (lazygit, etc.) inherit true color support
vim.env.COLORTERM = "truecolor"
