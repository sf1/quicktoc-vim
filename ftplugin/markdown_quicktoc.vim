
if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

nnoremap <buffer><localleader>c :call quicktoc#markdown()<cr>
