"    ____      _ __        _
"   /  _/___  (_) /__   __(_)___ ___
"   / // __ \/ / __/ | / / / __ `__ \
" _/ // / / / / /__| |/ / / / / / / /
"/___/_/ /_/_/\__(_)___/_/_/ /_/ /_/


" Always source these
source $HOME/.config/nvim/vim-plug/plugins.vim
source $HOME/.config/nvim/general/settings.vim
source $HOME/.config/nvim/general/functions.vim
source $HOME/.config/nvim/keys/mappings.vim

if !exists('g:vscode')
  " Themes
  source $HOME/.config/nvim/themes/syntax.vim
  source $HOME/.config/nvim/themes/spacegray.vim

  " Plugin config
  source $HOME/.config/nvim/plug-config/fzf.vim
  source $HOME/.config/nvim/plug-config/coc.vim
  source $HOME/.config/nvim/plug-config/kite.vim
  source $HOME/.config/nvim/plug-config/vim-fugitive.vim
  source $HOME/.config/nvim/plug-config/vim-go.vim
  source $HOME/.config/nvim/plug-config/vim-startify.vim
  source $HOME/.config/nvim/plug-config/vim-test.vim
endif
