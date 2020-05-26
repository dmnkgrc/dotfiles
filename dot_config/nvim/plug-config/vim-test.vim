let test#strategy = "vimux"
" let g:test#custom_transformations = {'docker': function('DockerTransform')}
" let g:test#transformation = 'docker'
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
" nmap <silent> <leader>g :TestVisit<CR>
