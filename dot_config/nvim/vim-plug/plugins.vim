" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')
" Nginx
Plug 'chr4/nginx.vim'
Plug 'qwertologe/nextval.vim'
" Supertab
Plug 'ervandew/supertab'
let g:SuperTabDefaultCompletionType = "<C-X><C-O>"
" Fzf
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
" Tmux
Plug 'christoomey/vim-tmux-navigator'
Plug 'benmills/vimux'
" Coverage
Plug 'reinh/vim-makegreen'
" Vim test
Plug 'janko-m/vim-test'
" Dispatch
Plug 'tpope/vim-dispatch'
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
" Terraform
Plug 'hashivim/vim-terraform'
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
Plug 'elzr/vim-json'
let g:vim_json_syntax_conceal = 0
autocmd BufNewFile,BufRead .eslintrc set filetype=json
" Git
Plug 'airblade/vim-gitgutter'
Plug 'kablamo/vim-git-log'
Plug 'gregsexton/gitv', {'on': ['Gitv']}
" Git utilities inside vi,
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
" UI
Plug 'ciaranm/inkpot'
Plug 'ajh17/Spacegray.vim'
" Plug 'dracula/vim', { 'as': 'dracula' }
" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Ruby
Plug 'vim-ruby/vim-ruby'
" Golang
Plug 'fatih/vim-go'
" Docker
Plug 'ekalinin/Dockerfile.vim'
" Javascript
Plug 'mxw/vim-jsx'
let g:jsx_ext_required = 0
" MDX
Plug 'jxnblk/vim-mdx-js'
Plug 'ianks/vim-tsx'
" Typescript
Plug 'leafgarland/typescript-vim'
" Mustache/Handlebars
Plug 'mustache/vim-mustache-handlebars'
" PHP
Plug 'tobyS/vmustache'
Plug 'tobyS/pdv'
let g:pdv_template_dir = $HOME ."/.vim/bundle/pdv/templates_snip"
nnoremap <buffer> <C-p> :call pdv#DocumentWithSnip()<CR>
" Jenkins
Plug 'martinda/Jenkinsfile-vim-syntax'

call plug#end()

" Automatically install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif
