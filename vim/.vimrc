set path+=**
set wildmenu
set ignorecase
set tabstop=4
set shiftwidth=4
set expandtab
set number relativenumber
set laststatus=2

colorscheme torte

nnoremap <space>e :Rex<CR>
vnoremap <space>y "+y
nnoremap <C-p> :find *
nnoremap <C-s> :w<CR>
nnoremap <space><tab> :tabNext<CR>

" Commands
:command! CopyBuffer let @+ = expand('%:p')
:command! Def :colorscheme default

" hide Netrw banner
let g:netrw_banner = 0

" Function for defining keymaps in Netrw
function! NetrwMapping()
endfunction

augroup netrw_mapping
  autocmd!
  autocmd filetype netrw call NetrwMapping()
augroup END

" Netrw keymappings
function! NetrwMapping()
  nmap <buffer> a %
  nmap <buffer> A d
endfunction

" Add Man command
runtime! ftplugin/man.vim
