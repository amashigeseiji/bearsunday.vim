scriptencoding utf-8
if exists('g:loaded_BEAR_plugin')
    finish
endif
let g:loaded_BEAR_plugin = 1

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=* -complete=customlist,bearsunday#resource#completion BEARResource call bearsunday#resource#call(<f-args>)
command! -nargs=* BEARBinding call bearsunday#binding#get(<f-args>)
command! BEARTestOpen call bearsunday#test#open()
command! BEARTestExec call bearsunday#test#execute()
command! PhpUnit call php#phpunit#run()

" snippet settings
let g:bearsunday_snippet_dir = expand('<sfile>:p:h') . '/../snippet/'
let g:bearsunday_snippet_mapping = {
      \ 'resource': '/Resource/',
      \ 'module': 'Module.php',
      \ 'interceptor': 'Interceptor.php',
      \ 'test': 'Test.php',
      \ 'default': '.php'
      \}

augroup new_file
  autocmd!
  autocmd BufNewFile *.php call bearsunday#template#newFile()
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
