-- Enable bufferline
vim.opt.termguicolors = true
require("bufferline").setup {
    options = {
        numbers = "ordinal",
        offsets = {
            {
                filetype = "NvimTree",
                text = "File Explorer",
                separator = false,
            }

        }
    }
}
