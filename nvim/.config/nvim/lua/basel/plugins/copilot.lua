vim.g.copilot_assume_mapped = true
vim.api.nvim_set_keymap('i', '<C-f>', 'copilot#Accept("<CR>")', { expr = true, silent = true })
