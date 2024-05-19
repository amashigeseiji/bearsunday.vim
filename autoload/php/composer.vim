" fixme: php# というプレフィックス名がでかすぎる

let s:composer = {}
let s:composerLoaded = 0
let s:composerDir = ''

" ファイルの探索処理 {{{
" see https://blog.engineer.adways.net/entry/2018/07/27/150000
function! s:FindFile(dir, pattern)
  let dir = (a:dir)[1:]
  let files = split(glob(dir . "/*"), "\n")
  for file in files
    let l:filename = fnamemodify(file, ":t")
    if l:filename == a:pattern
      return file
    endif
  endfor
endfunction
"}}}

" get composer {{{
function! s:GetComposer()
  if s:composerLoaded
    return s:composer
  endif

  echo ''
  let l:count         = 0
  let l:current_dir   = expand("%:p:h")
  let l:pwd           = getcwd()
  while l:count < len(split(l:current_dir, "\/"))
    let file = s:FindFile(execute("pwd"), "composer.json")
    if !empty(file)
      break
    else
      execute "lcd ../"
      let l:pwd = getcwd()
      let l:count += 1
    endif
  endwhile

  if empty(file)
    cd %:h
  else
    let s:composerDir = l:pwd
    let s:composer = json_decode(join(readfile(l:file)))
  endif
  let s:composerLoaded = 1
  return s:composer
endfunction
" }}}

function! php#composer#namespaceBase()
  let l:composer = s:GetComposer()
  let l:items = []
  if (has_key(l:composer, 'autoload') && has_key(l:composer['autoload'], 'psr-4'))
    for i in keys(l:composer['autoload']['psr-4'])
      call add(l:items, [i, l:composer['autoload']['psr-4'][i]])
    endfor
  endif
  if (has_key(l:composer, 'autoload-dev') && has_key(l:composer['autoload-dev'], 'psr-4'))
    for i in keys(l:composer['autoload-dev']['psr-4'])
      call add(l:items, [i, l:composer['autoload-dev']['psr-4'][i]])
    endfor
  endif
  return l:items
endfunction

" Get namespace from composer.json {{{
" todo: 表記ゆれ対応
" {
"   'Foo\\': 'foo/',
"   'Bar': 'src',
" }
function! php#composer#namespace()
  let l:namespaces = php#composer#namespaceBase()
  let l:current = expand('%:h') . '/'
  let l:substitute = ''
  for j in l:namespaces
    if l:current =~ j[1]
      let l:substitute = substitute(l:current, j[1], escape(j[0], '\\'), "")
    endif
  endfor
  let l:substitute = substitute(l:substitute, '/', '\\', 'g')
  let l:substitute = substitute(l:substitute, '\\$', '', '')
  return substitute(l:substitute, '/', '', '')
endfunction
" }}}

" get composer directory
function! php#composer#dir()
  call s:GetComposer()
  return s:composerDir
endfunction
