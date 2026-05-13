" Load the defaults.vim file first
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

" set cursor to be a blinking line in insert mode
let &t_SI .= "\<Esc>[5 q"
" set cursor to be a solid box in normal mode
let &t_EI .= "\<Esc>[2 q"
" set cursor to be a blinking box in replace mode
let &t_SR .= "\<Esc>[1 q"
" set cursor to replace mode when leaving buffer in all windows
" revert cursor back to normal mode when entering buffer
augroup CursorShape
  autocmd!
  autocmd BufEnter * execute 'silent !echo -ne "' . &t_EI . '"'
  autocmd BufWinLeave * execute 'silent !echo -ne "' . &t_SI . '"'
augroup END

" Enable the mouse in all modes
set mouse=a
set scrolloff=0

" Without this, dragging window separators doesn't work
set ttymouse=sgr

set belloff=all
set tabstop=4
set shiftwidth=4 smarttab
set expandtab
set autoindent
set smartindent
set ignorecase smartcase

set timeout           " Enable timeout for mappings (Leader key)
set ttimeout          " Enable timeout for terminal key codes (Esc)
set timeoutlen=300   " Wait 1000ms for mapping completion (Leader key)
set ttimeoutlen=10    " Wait only 10ms for terminal key codes (Escape)

" Without this basic horizontal movements don't wrap
set whichwrap+=<,>,[,],h,l

" Don't wrap in the middle of a word
set linebreak
" Display the last line even if it cannot be displayed fully
set display+=lastline

" This shows the absolute line number aligned left and relative line numbers aligned right in the left margin
set relativenumber number

set showcmd

" remap the Enter key to insert a newline before the cursor while remaining in normal mode. Shift Enter will insert a newline after the cursor.
nnoremap <CR> i<CR><Esc>
nnoremap <S-CR> a<CR><Esc>

" remap Alt k, Alt j, Alt Up, Alt Down to move the current line up and down
" Due to some limitations of terminal interaction, the input sequence is
" specified as the raw input obtained by pressing Ctrl v followed by the
" actual key sequence to be mapped.
nnoremap k :m -2<CR>
nnoremap j :m +1<CR>
nnoremap [1;3A :m -2<CR>
nnoremap [1;3B :m +1<CR>

" Remap up and down arrow keys to move through wrapped lines in both insert
" and normal modes. The idea is that hjkl keys are for logical navigation and
" arrow keys are for visual navigation.
nnoremap <silent> <Up> gk
nnoremap <silent> <Down> gj
inoremap <silent> <Up> <C-o>gk
inoremap <silent> <Down> <C-o>gj

" Similar visual navigation remappings for Home and End.
nnoremap <silent> <Home> g^
nnoremap <silent> <End> g$
inoremap <silent> <Home> <C-o>g^
inoremap <silent> <End> <C-o>g$

" Remap \w to write the file from insert mode
inoremap <Leader>w <C-o>:w<CR>

" Remap Alt w and Alt u to delete forward unlike Ctrl w and Ctrl u that delete
" backward
inoremap w <C-o>dw
inoremap u <C-o>d$

" Flash the cursor line with \c
nnoremap <silent> <Leader>c :set cursorline<CR>:sleep 300m<CR>:set nocursorline<CR>

" Put yanked (copied) content on the system clipboard automatically
nnoremap y "+y
nnoremap yy "+yy
xnoremap y "+y

set foldcolumn=3

" Allow buffers to be hidden without prompting to write them first
set hidden

" When a window is split, set the new window to appear at the bottom or right
set splitbelow
set splitright
