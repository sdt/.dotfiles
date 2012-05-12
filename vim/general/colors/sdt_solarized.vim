" Modified version of solarized colorscheme
"
let g:solarized_termtrans=1
set background=dark

runtime colors/solarized.vim

" Solarized colorscheme overrides
hi StatusLine    cterm=NONE ctermfg=3
hi StatusLineNC  cterm=bold
hi VertSplit     cterm=bold ctermfg=2

" Make long git commit messages more visible
hi def link gitcommitOverflow		Error

let g:colors_name='sdt_solarized'
