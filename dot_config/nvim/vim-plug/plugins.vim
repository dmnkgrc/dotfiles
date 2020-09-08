" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')
" Nginx
Plug 'qwertologe/nextval.vim'
" Supertab
" Plug 'ervandew/supertab'
" let g:SuperTabDefaultCompletionType = "<C-X><C-O>"
" Jump to any location
Plug 'justinmk/vim-sneak'
let g:sneak#label = 1
Plug 'unblevable/quick-scope'
" Todos
Plug 'vuciv/vim-bujo'
" Fzf
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-rooter'
" Tmux
Plug 'christoomey/vim-tmux-navigator'
Plug 'benmills/vimux'
" Coverage
Plug 'reinh/vim-makegreen'
" Vim test
Plug 'janko-m/vim-test'
" Dispatch
Plug 'tpope/vim-dispatch'
" Repeat
Plug 'tpope/vim-repeat'
" Work with variants of a word
Plug 'tpope/vim-abolish'
" Autoclose
Plug 'Townk/vim-autoclose'
" Surround
Plug 'tpope/vim-surround'
" CSS
Plug 'vim-scripts/CSSMinister'
" Markdown preview
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
" Start sreen
Plug 'mhinz/vim-startify'
" Generic programming
Plug 'Yggdroot/indentLine'
" Language server
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'Xuyuanp/nerdtree-git-plugin'
" Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'
" Better comments
Plug 'tpope/vim-commentary'
Plug 'scrooloose/nerdcommenter'
" Plug 'scrooloose/nerdtree'
" Developer icons
Plug 'ryanoasis/vim-devicons'
" JSON
let g:vim_json_syntax_conceal = 0
autocmd BufNewFile,BufRead .eslintrc set filetype=json
" Git
Plug 'airblade/vim-gitgutter'
Plug 'kablamo/vim-git-log'
Plug 'gregsexton/gitv', {'on': ['Gitv']}
" Git utilities inside vi,
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
" JS
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
" UI
Plug 'ciaranm/inkpot'
Plug 'ajh17/Spacegray.vim'
" Plug 'dracula/vim', { 'as': 'dracula' }
" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Ruby
Plug 'tpope/vim-rails'
" JavaScript
Plug 'posva/vim-vue'
" Mustache
Plug 'tobyS/vmustache'
" Polyglot
Plug 'sheerun/vim-polyglot'
let g:vim_markdown_conceal_code_blocks = 0
" Go
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

call plug#end()

" Automatically install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif
