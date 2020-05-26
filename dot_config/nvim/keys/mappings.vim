let mapleader="," " leader is comma
" let mapleader=" "


" jk is escape
inoremap jk <esc>
nnoremap B ^
nnoremap E $
nnoremap gV `[v`]     " Highlight last inserted code
nnoremap <leader>u :GundoToggle<CR>
" edit vimrc/zshrc and load vimrc bindings
nnoremap <leader>ev :vsp ~/.config/nvim/init.vim<CR>
nnoremap <leader>ez :vsp ~/.zshrc<CR>
nnoremap <leader>sv :so ~/.config/nvim/init.vim<CR>
" save session
nnoremap <leader>s :mksession<CR>
" open ag
nnoremap <leader>a :Ag<CR>
" Omnicomplete Better Nav
inoremap <expr> <c-j> ("\<C-n>")
inoremap <expr> <c-k> ("\<C-p>")
" turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>

" Error navigation
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>
