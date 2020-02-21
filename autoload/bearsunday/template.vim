
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
  for key in keys(g:bearsunday_snippet_mapping)
    if l:current =~ g:bearsunday_snippet_mapping[key]
      return expand(g:bearsunday_snippet_dir . 'snip-' . key)
    endif
  endfor
endfunction

" 行単位の置換
function! s:Subst(line)
  let l:line = a:line
  if l:line =~ "`namespace`"
    let l:namespace = bearsunday#composer#namespace()
    if l:namespace =~ "^$"
      let line = ""
    else
      let line = substitute(line, '`namespace`', escape(l:namespace, '\'), 'g')
    endif
  elseif line =~ "`class`"
    let line = substitute(line, '`class`', expand("%:t:r"), 'g')
  endif
  return line
endfunction
