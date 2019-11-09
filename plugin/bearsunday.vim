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
command! -nargs=* -complete=customlist,bearsunday#resource#completion BEARResourceGet call bearsunday#resource#call('get', <f-args>)
command! -nargs=* -complete=customlist,bearsunday#resource#completion BEARResourcePut call bearsunday#resource#call('put', <f-args>)
command! -nargs=* -complete=customlist,bearsunday#resource#completion BEARResourcePost call bearsunday#resource#call('post', <f-args>)
command! -nargs=* -complete=customlist,bearsunday#resource#completion BEARResourceDelete call bearsunday#resource#call('delete', <f-args>)
command! -nargs=* -complete=customlist,bearsunday#resource#completion BEARResourceOptions call bearsunday#resource#call('options', <f-args>)

augroup new_file
  autocmd!
  autocmd BufNewFile */Resource/App/*.php,*/Resource/Page/*.php :BEARNewResource
  autocmd BufNewFile */Module/*.php :BEARNewModule
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
