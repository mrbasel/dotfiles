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
" '+' now resolves to OSC 52 on remote hosts, so this reaches the local clipboard.
vnoremap <space>y "+y
nnoremap <C-p> :find *
nnoremap <C-s> :w<CR>
nnoremap <space><tab> :tabNext<CR>

" Copy to the clipboard of the terminal you are sitting at, not the remote host.
" Vim 9.1 bundles an OSC 52 clipboard provider: instead of writing to the
" remote host's X11/Wayland clipboard, yanks are sent to the outer terminal as
" an escape sequence. tmux is configured to forward these too.
if exists('&clipmethod')
  silent! packadd osc52
  if has_key(get(v:, 'clipproviders', {}), 'osc52')
    " tmux interferes with the automatic DA1 capability probe, so force it on.
    let g:osc52_force_avail = 1
    " Some terminals block forever when querying the clipboard via OSC 52, so
    " keep writes only; use the terminal's own paste for reading.
    let g:osc52_disable_paste = 1
    " Guard so re-sourcing ~/.vimrc doesn't append osc52 repeatedly.
    if &clipmethod !~# '\<osc52\>'
      set clipmethod+=osc52
    endif
  endif
endif

" Commands
:command! CopyBuffer let @+ = expand('%:p')
:command! Def :colorscheme default
:command! Date :put =strftime('%Y-%m-%d')

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
