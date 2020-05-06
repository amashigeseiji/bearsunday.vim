function! php#phpunit#run() abort
  let l:runner = 'phpunit'
  let l:response = systemlist(l:runner)
  let l:error = s:getErrors(l:response)
  for e in keys(l:error)
    call s:bufferOpen(l:error[e])
  endfor
  "call s:bufferOpen(l:response)
endfunction

function! s:getErrors(phpunitResult) abort
  let l:result = []
  let l:errorCount = 0
  let l:error = {}
  for line in a:phpunitResult
    if line =~ '\v^There (was|were) \d+ (error|failure)s?:'
      let l:errorCount = matchstr(line, '\d\+')
    endif

    if l:errorCount > 0
      if line =~ "\\v^(OK|FAILURES!|ERRORS!|--)"
        unlet l:currentError
      endif
      if line =~ '\v^\d+\)'
        let l:currentError = substitute(line, '\v^\d+\) ', '', '')
        let l:error[l:currentError] = []
      endif

      if exists('l:currentError')
        call add(l:error[l:currentError], line)
      endif
    endif
  endfor
  return l:error
endfunction

function! s:bufferOpen(content) abort
  silent! exec 'new'
  silent! exec 'setl filetype=phpunit_result'
  silent! exec 'setl buftype=nofile'
  silent! exec 'setl hidden'
  silent! exec 'setl bufhidden=wipe'
  silent! exec 'setl nowrap'
  silent! exec 'setl nonumber'
  call setline('.', a:content)
  execute 'map <buffer><silent> q :bd<cr>'
  silent! exec 'setl readonly'
  silent! exec 'setl nomodifiable'
endfunction
