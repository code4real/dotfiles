" ruby
"
"echo "Loading custom ruby ftplugin..."
"sleep 1

source ~/.vim/ftplugin/defaults.vim

let ruby_operators = 1
let ruby_space_errors = 1

" Omni
let g:SuperTabDefaultCompletionType = "<c-x><c-o>"

" Ruby rcodecomplete
" http://vootey.wordpress.com/2010/03/28/ruby-code-completion-with-vim/
" fri is a pain to install (if possible)
let g:rct_completion_use_fri = 0  " not really working

" Rails (MVCh)
" There are several more of these available; see rails.txt.
nmap <Leader>m :Rmodel<CR>
nmap <Leader>v :Rview<CR>
nmap <Leader>c :Rcontroller<CR>
nmap <Leader>h :Rhelper<CR>
nmap <Leader>s :Rspec<CR>
nmap <Leader>j :Rjavascript<CR>
