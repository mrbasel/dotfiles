-- [[ Setting options ]]
-- See `:help vim.o`
-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Relative line numbers
vim.opt.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set colorscheme
vim.o.termguicolors = true
require("tokyonight").setup({
    transparent = true,
    styles = {
    sidebars = "transparent",
    floats = "transparent",
    },
})

vim.cmd [[
    hi lualine_a_normal guibg=none 
    hi lualine_b_normal guibg=none 
    hi lualine_c_normal guibg=none 
    hi lualine_c_inactive guibg=none 
]]
vim.cmd [[colorscheme tokyonight-night]]

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

vim.cmd('set autoindent expandtab tabstop=4 shiftwidth=4')


vim.api.nvim_command('set shell=/usr/bin/bash')
