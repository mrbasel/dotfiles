vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>of', vim.diagnostic.open_float)
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- Close Neovim
vim.keymap.set('n', '<leader>Q', ':qa<cr>')

-- Save file
vim.keymap.set({'n', 'v'}, '<C-s>', ':w<cr>')

-- Buffer keymaps
vim.keymap.set('n', '<leader>q', ':bd<cr>')
vim.keymap.set('n', '<leader>bn', ':bn<cr>')
vim.keymap.set('n', '<leader>bb', ':bp<cr>')

for i = 1, 9 do
    vim.keymap.set('n', '<leader>b' .. i, ':BufferLineGoToBuffer' .. i .. '<cr>')
end

vim.keymap.set('n', '<leader>bcl', ':BufferLineCloseLeft<cr>')
vim.keymap.set('n', '<leader>bcr', ':BufferLineCloseRight<cr>')

-- Yank to system clipboard
vim.keymap.set('v', '<leader>y', '"+y')
