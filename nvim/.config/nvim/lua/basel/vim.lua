-- [[ Setting options ]]
-- See `:help vim.o`
-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

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
-- vim.o.termguicolors = true
vim.cmd [[colorscheme tokyonight-night]]
-- vim.cmd [[
-- hi Normal guibg=none ctermbg=none
-- hi LineNr guibg=none ctermbg=none
-- hi Folded guibg=none ctermbg=none
-- hi NonText guibg=none ctermbg=none
-- hi SpecialKey guibg=none ctermbg=none
-- hi VertSplit guibg=none ctermbg=none
-- hi SignColumn guibg=none ctermbg=none
-- hi EndOfBuffer guibg=none ctermbg=none
--
-- ]]

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

vim.cmd('set autoindent expandtab tabstop=4 shiftwidth=4')


vim.api.nvim_command('set shell=/usr/bin/bash')
