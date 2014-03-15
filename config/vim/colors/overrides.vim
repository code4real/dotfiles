" Special overrides.
" Try to remove almost all red since it won't work for vid recording.

" Need urxvt to take advantage of multiple fonts.
hi String cterm=italic
hi Function cterm=bold
"hi Identifier cterm=bold

" Enable terminal’s transparent BG.
"hi Normal ctermbg=NONE

" Standout search: red on yellow
hi Search ctermfg=196 ctermbg=226
hi Title cterm=bold

" Override for dull.
hi MatchParen ctermbg=237

" Brighten up visual mode.
hi Visual ctermbg=238

" EOL column marker
hi ColorColumn ctermbg=232

" Molokai uses 144; 136 too dark
hi String cterm=italic ctermfg=143 guifg=#E6DB74
hi Normal ctermfg=253

hi SpellBad ctermbg=196

" JS/Coffee
hi Float ctermfg=25
hi Number ctermfg=67
hi Structure ctermfg=226

" Molokai overrides for bad recording red -> blue
hi Statement term=bold cterm=bold ctermfg=67
hi Operator term=bold cterm=bold ctermfg=94
hi Keyword term=bold cterm=bold ctermfg=67
hi Conditional term=bold cterm=bold ctermfg=67
hi Repeat term=bold cterm=bold ctermfg=67
hi SpecialChar term=bold cterm=bold ctermfg=94

" Set background to darkest black for better contrast.
hi Normal ctermbg=16

" Someone screwed up todo to be black on black
hi Todo ctermfg=245

" Rainbow-parentheses
" See also rbpt_colorpairs in .vimrc, but can't do cterm=bold there
"hi level16c ctermfg=red cterm=bold
"hi level1c ctermfg=darkcyan cterm=bold
"hi level2c ctermfg=226 cterm=bold
"hi level3c ctermfg=darkcyan cterm=bold
"hi level4c ctermfg=226 cterm=bold
"hi level5c ctermfg=darkcyan cterm=bold
"hi level6c ctermfg=226 cterm=bold
"hi level7c ctermfg=darkcyan cterm=bold
"hi level8c ctermfg=226 cterm=bold
"hi level9c ctermfg=darkcyan cterm=bold
"hi level10c ctermfg=226 cterm=bold
"hi level11c ctermfg=darkcyan cterm=bold
"hi level12c ctermfg=226 cterm=bold
"hi level13c ctermfg=darkcyan cterm=bold
"hi level14c ctermfg=226 cterm=bold
"hi level15c ctermfg=darkcyan cterm=bold
"hi level16c ctermfg=226 cterm=bold

" More colorful strings (molokai)
