"
" Author: Sebastian Fleissner
" Copyright: (C) 2013 Sebastian Fleissner
" License: Vim License - see ':help license'. 
"

if exists("b:did_ftplugin_markdown_quicktoc")
  finish
endif
let b:did_ftplugin_markdown_quicktoc = 1

nnoremap <buffer><localleader>c :call quicktoc#latex()<cr>
