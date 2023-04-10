-- Enable nvim-tree
local nvimtree = require("nvim-tree").setup()
if nvimtree then
    nvimtree.actions.change_dir.enable = false
end

vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', {})
vim.keymap.set('n', '<leader>ff', ':NvimTreeFindFile<CR>', {})


