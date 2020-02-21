let s:bufnr = -1

function! bearsunday#buffer#open(content, fileType)
  if s:bufnr > -1
    call bearsunday#buffer#close()
  endif
  silent! exec 'new'
  if a:fileType != ''
    silent! exec 'setl filetype=' . a:fileType
  endif
  silent! exec 'setl buftype=nofile'
  silent! exec 'setl hidden'
  silent! exec 'setl bufhidden=wipe'
  silent! exec 'setl nowrap'
  silent! exec 'setl nonumber'
  call setline('.', a:content)
  silent! exec ':%s/\\u\([0-9a-f]\{4}\)/\=nr2char(eval("0x".submatch(1)),1)/g'
  execute 'map <buffer><silent> q :call bearsunday#buffer#close()<CR>'
  silent! exec 'setl readonly'
  silent! exec 'setl nomodifiable'
  let s:bufnr = bufnr()
endfunction

function! bearsunday#buffer#close()
  exec 'bdelete ' . s:bufnr
  let s:bufnr = -1
endfunction
