
-- Git telescope commands
--
vim.api.nvim_create_user_command('Commits', function(_)
    require('telescope.builtin').git_commits()
end, {})

vim.api.nvim_create_user_command('Bcommits', function(_)
    require('telescope.builtin').git_bcommits()
end, {})

vim.api.nvim_create_user_command('Status', function(_)
    require('telescope.builtin').git_status()
end, {})

vim.api.nvim_create_user_command('Stash', function(_)
    require('telescope.builtin').git_stash()
end, {})

