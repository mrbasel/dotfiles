-- Enable bufferline
vim.opt.termguicolors = true
require("bufferline").setup {
    options = {
        offsets = {
            {
                filetype = "NvimTree",
                text = "File Explorer",
                separator = false,
            }

        }
    }

}
