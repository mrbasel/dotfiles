local utils = require("basel.utils");

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
    defaults = {
        mappings = {
            i = {
                ['<C-u>'] = false,
                ['<C-d>'] = false,
            },
        },
        vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--hidden',
        },
    },
    pickers = {
        buffers = {
            initial_mode = 'normal',
        },
        find_files = {
            hidden = true,
        },
        git_commits = {
            git_command = { "git", "log", "--pretty=%h %an | %s", "--abbrev-commit", "--", "." }
        },
        git_bcommits = {
            git_command = { "git", "log", "--pretty=%h %an | %s", "--abbrev-commit" }
        },
    },
    extentions = {
        coc = {
            prefer_locations = true
        }
    }
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>sf', function ()
    if utils.is_git_repo() then
       require('telescope.builtin').git_files()
    else
       require('telescope.builtin').find_files()
    end
end, { desc = '[S]earch [F]iles' })

vim.keymap.set('n', '<leader>saf', require('telescope.builtin').find_files, { desc = '[S]earch [A]ll [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })
