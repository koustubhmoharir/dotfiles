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

colorscheme desert
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

" Save with Ctrl+S in Normal mode (assumes ctrl+S does not freeze terminal)
nnoremap <C-s> :update<CR>

" Save with Ctrl+S in Insert mode (then returns to Insert mode)
inoremap <C-s> <C-O>:update<CR>

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
set foldmethod=syntax
set foldlevel=99

" Fold sections, default `0`.
let g:asciidoctor_folding = 1

" Fold options, default `0`.
let g:asciidoctor_fold_options = 1

" Allow buffers to be hidden without prompting to write them first
set hidden

" When a window is split, set the new window to appear at the bottom or right
set splitbelow
set splitright

" Code to install vim-plug (plugin manager for vim) automatically
" https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" List of plugins (plugin names are github repo names?)
call plug#begin()
Plug 'sheerun/vim-polyglot'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" Plug 'tpope/vim-fugitive'
" Plug 'preservim/nerdtree'
" Plug 'tpope/vim-obsession'
Plug 'habamax/vim-asciidoctor'
call plug#end()

" Add the Ctrl + Y shortcut to copy a filename from the Files window.
" This is based on https://github.com/junegunn/fzf.vim/issues/772#issuecomment-467283202
let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit',
      \ 'ctrl-y': {lines -> setreg('+', join(lines, "\n"))}}

" Map \f to the fzf Files command and \b to Buffers
" The ! after the command opens the fzf window full screen
nnoremap <silent> <Leader>f :Files!<CR>
nnoremap <silent> <Leader>g :GFiles!<CR>
nnoremap <silent> <Leader>b :Buffers!<CR>
nnoremap <silent> <Leader>t :NERDTree<CR>

" Improve the DiffOrig command added by defaults.vim
" This command opens a vertically split diff in a new tab
" The original (saved) file is shown as a non modifiable buffer
" It is sufficient to simply close the tab to exit everything cleanly
command! DiffOrig tab split | vert new | set bt=nofile | r ++edit # | 0d_
        \ | setlocal nomodifiable bufhidden=wipe nobuflisted noswapfile
        \ | silent f Original | diffthis | wincmd p | diffthis

" When there are multiple windows open, the bd command closes the active
" window too and this seems unintuitive. The Bd command below works around
" this to load the previous buffer, split the window, load the next (original)
" buffer in the split window and then delete the buffer to keep the window
" layout as it originally was. This will still not work if the previous buffer
" is the same as the current buffer.
command Bd bp | sp | bn | bd
