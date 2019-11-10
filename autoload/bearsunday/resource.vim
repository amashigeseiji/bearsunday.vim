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
  let l:result = bearsunday#resource#response(l:response)
  call insert(l:result['response'], tolower(expand('%:p:h:t')) . ' ' . l:uri, 0)
  if l:result['mediaType'] == 'json'
    let l:result['response'][0] = '"' . l:result['response'][0] . '",'
  endif
  call insert(l:result['response'], '', 1)
  call bearsunday#buffer#open(l:result['response'], escape(l:uri, '\'), l:result['mediaType'])
endfunction

function! bearsunday#resource#response(response) abort
  let l:linenum = 0
  let l:header = []
  let l:mediaType = ''
  for line in a:response
    if l:linenum == 0
      let l:head = match(line, '^[0-9]\{3\} ')
      if l:head != 0
        return {'response': a:response, 'mediaType': ''}
      endif
    endif
    if line == ''
      break
    endif
    if line =~ 'content-type'
      if line =~ 'json'
        let l:mediaType = 'json'
      elseif line =~ 'html'
        let l:mediaType = 'html'
      endif
    endif
    call add(l:header, line)
    let l:linenum += 1
  endfor

  let l:linenum = 0
  if l:mediaType =~ 'json'
    for line in l:header
      let a:response[l:linenum] = printf('"%s",', line)
      let l:linenum += 1
    endfor
  endif

  return { 'response': a:response, 'mediaType': l:mediaType }
endfunction

function! bearsunday#resource#completion(ArgLead, CmdLine, CursorPos) abort
  let l:cmd = split(a:CmdLine, ' ', 1)
  let l:len_cmd = len(l:cmd)

  if l:len_cmd <= 2
    let l:commands = ['get ', 'post ', 'put ', 'patch ', 'delete ']
    let l:filtered = filter(l:commands, { k, v -> search('on' . trim(v, ' '), 'n') })
    let l:filter_cmd = printf('v:val =~ "^%s"', a:ArgLead)
    return filter(l:filtered + ['options ', 'head '], l:filter_cmd)
  endif

  if l:len_cmd > 2
    let l:method = 'function on' . l:cmd[1]
    let l:searched = search(l:method, 'n')
    if l:searched > 0
      let l:line = getline(l:searched)
      while 1
        let l:searched += 1
        let l:line .= getline(l:searched)
        if l:line =~ ')'
          break
        endif
      endwhile
      let l:matched = split(trim(matchstr(l:line, '(.*)'), '()'), ',')
      let l:funcArgs = map(l:matched, { k, v -> trim(matchstr(v, '$[^, ]*'), '$') . '=' })
      return l:funcArgs
    endif
  endif
endfunction
