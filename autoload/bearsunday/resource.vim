function! s:makeCommand(method)
  let l:rootDir = bearsunday#composer#dir()
  let l:scheme = tolower(expand('%:p:h:t'))
  return 'php ' . l:rootDir . '/bin/' . l:scheme . '.php ' . a:method
endfunction

function! s:createUrl(...)
  let l:resource = expand('%:t:r')
  let l:uri = '/' . tolower(l:resource[0]) . l:resource[1:]
  let l:uriArgs = []
  for arg in a:000
    let l:arg = split(arg, '=')
    let l:encoded = system('php -r "echo urlencode(\"' . l:arg[1] . '\");"')
    call add(l:uriArgs, l:arg[0] . '=' . l:encoded)
  endfor
  let l:uriArgs = join(l:uriArgs, '&')
  if strlen(l:uriArgs)
    let l:uri = l:uri . '?' . l:uriArgs
  endif
  return l:uri
endfunction

function! bearsunday#resource#call(method, ...) abort
  let l:command = s:makeCommand(a:method)
  let l:uri = call('s:createUrl', a:000)
  let l:exec = l:command . " '" . l:uri . "'"
  let l:response = systemlist(l:exec)
  let l:linenum = 0
  for line in l:response
    if line == ''
      break
    endif
    let l:response[l:linenum] = '"' . line .'",'
    let l:linenum += 1
  endfor
  call insert(l:response, '"> request: ' . l:exec . '",', 0)
  call insert(l:response, '', 1)
  call insert(l:response, '"> response:",', 2)
  call bearsunday#buffer#open(l:response, escape(l:uri, '\'))
endfunction

function! bearsunday#resource#completion(ArgLead, CmdLine, CursorPos)
  "todo
endfunction
