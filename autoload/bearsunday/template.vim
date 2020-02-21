let s:snippetDir = expand('<sfile>:p:h') . '/../../'

function! bearsunday#template#newFile()
  let l:composerDir = bearsunday#composer#dir()
  if l:composerDir =~ "^$"
    return
  endif
  let l:input = s:Snippet()
  let l:templ = []
  for line in readfile(l:input)
    call add(l:templ, s:Subst(line))
  endfor
  return setline('.', l:templ)
endfunction

" snippet の取得
function! s:Snippet()
  let l:current = expand('%:p')
  if l:current =~ '/Resource/'
    return expand(s:snippetDir . 'snip-resource')
  elseif l:current =~ 'Module.php'
    return expand(s:snippetDir . 'snip-module')
  else
    return expand(s:snippetDir . 'snip-default')
  endif
endfunction

" 行単位の置換
function! s:Subst(line)
  let l:line = a:line
  if l:line =~ "`namespace`"
    let l:namespace = escape(bearsunday#composer#namespace(), '\')
    if l:namespace =~ "^$"
      let line = ""
    else
      let line = substitute(line, '`namespace`', escape(bearsunday#composer#namespace(), '\'), 'g')
    endif
  elseif line =~ "`class`"
    let line = substitute(line, '`class`', expand("%:t:r"), 'g')
  endif
  return line
endfunction
