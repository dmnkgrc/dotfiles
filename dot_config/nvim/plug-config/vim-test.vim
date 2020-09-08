let test#strategy = "vimux"
" let g:test#custom_transformations = {'docker': function('DockerTransform')}
" let g:test#transformation = 'docker'
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
autocmd BufEnter ~/code/react/hub-ui/libs/ui/* let g:test#javascript#jest#options = '--config=libs/ui/jest.config.js'
autocmd BufEnter ~/code/react/hub-ui/libs/shared/logger/* let g:test#javascript#jest#options = '--config=libs/shared/logger/jest.config.js'
autocmd BufEnter ~/code/react/hub-ui/apps/hub/* let g:test#javascript#jest#options = '--config=apps/hub/jest.config.js'
autocmd BufEnter ~/code/react/hub-ui/apps/static-site-system/* let g:test#javascript#jest#options = '--config=apps/static-site-system/jest.config.js'
" nmap <silent> <leader>g :TestVisit<CR>
