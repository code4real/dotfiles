" Comments
"
" Somewhat tuned to molokai theme.
" https://github.com/tomasr/molokai

"se background=dark
"let g:solarized_termcolors=256
"colorscheme solarized
"
" This scheme also supports detecting trailing whitespace. You should
" set this in your .vimrc:
" match ExtraWhitespace /\s\+$/
hi ExtraWhitespace ctermbg=darkgray guibg=darkgray

"hi Comment      guifg=#808080 ctermfg=244
"hi Comment  cterm=bold ctermfg=0

"set background="dark"
"echo &background
if &background == "light"
    "echo "comments: using light bg"
else
    "echo "comments: using dark bg"
endif

"echo "in colors/comments.vim" | sleep 1

" Special comments. See ~/.vim/ftplugin/comments.vim
"hi Comment                 guifg=#800000 ctermfg=241
hi CommentCode             guifg=#800000 ctermfg=1
hi CommentCode             guifg=#800000 ctermfg=244
"hi CommentDescription      guifg=#8787ff ctermfg=105 cterm=bold
hi CommentDescription      guifg=#8787ff ctermfg=26 cterm=bold
hi CommentKing             guifg=#dadada ctermfg=253 cterm=bold
hi CommentSmart            guifg=#af8787 ctermfg=138
hi CommentJavadoc          guifg=#d7d7af ctermfg=187
hi CommentEpydoc           guifg=#d7d7af ctermfg=187
hi CommentMajorSection     guifg=#ffffff ctermfg=15 cterm=bold
hi CommentMiddleSection    guifg=#eeeeee ctermfg=255
hi CommentMinorSection     guifg=#dadada ctermfg=253
hi CommentInfo             guifg=#87d700 ctermfg=112 cterm=bold
hi CommentDisabled         guifg=#9e9e9e  ctermfg=236
hi CommentEol              guifg=#000080 ctermfg=blue
hi CommentTripleDirkString guifg=#005f5f ctermfg=23
hi CommentTripleTickString guifg=#9e9e9e ctermfg=247
hi CommentRestIdentifier   guifg=#9e9e9e ctermfg=247
hi CommentRun              ctermfg=124 cterm=bold


" Python comment extensions.
hi link pythonTripleDirkString   CommentTripleDirkString
hi link pythonTripleTickString   CommentTripleTickString
hi link pythonRestIdentifier     CommentRestIdentifier
