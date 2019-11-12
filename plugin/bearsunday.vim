scriptencoding utf-8
if exists('g:loaded_BEAR_plugin')
    finish
endif
let g:loaded_BEAR_plugin = 1

let s:save_cpo = &cpo
set cpo&vim

let s:scriptDir = expand('<sfile>:p:h')

command! BEARNewResource call bearsunday#template#newFile(s:scriptDir . '/../snip-resource')
command! BEARNewModule call bearsunday#template#newFile(s:scriptDir . '/../snip-module')
command! -nargs=* -complete=customlist,bearsunday#resource#completion BEARResource call bearsunday#resource#call(<f-args>)
command! -nargs=* BEARBinding call bearsunday#binding#get(<f-args>)

augroup new_file
  autocmd!
  autocmd BufNewFile */Resource/App/*.php,*/Resource/Page/*.php :BEARNewResource
  autocmd BufNewFile */Module/*.php :BEARNewModule
  autocmd BufNewFile *.php call bearsunday#template#newFile(s:scriptDir. '/../snip-default')
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
