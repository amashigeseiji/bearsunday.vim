function! bearsunday#buffer#open(content, title)
  silent! exec 'new ' . a:title
  silent! exec 'setl filetype=json'
  silent! exec 'setl buftype=nofile'
  silent! exec 'setl hidden'
  silent! exec 'setl bufhidden=wipe'
  silent! exec 'setl nowrap'
  silent! exec 'setl nonumber'
  call setline('.', a:content)
  silent! exec ':%s/\\u\([0-9a-f]\{4}\)/\=nr2char(eval("0x".submatch(1)),1)/g'
  execute 'map <buffer><silent> q :bd!<CR>'
  silent! exec 'setl readonly'
  silent! exec 'setl nomodifiable'
endfunction
