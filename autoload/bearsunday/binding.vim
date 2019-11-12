let s:bindingphp = expand('<sfile>:p:h') . '/binding.php'

function! bearsunday#binding#get(...) abort
  let l:namespace = bearsunday#composer#namespaceBase()
  let l:namespace = trim(l:namespace[0][0], '\\')
  let l:command = ['php', s:bindingphp]
  for i in a:000
    call add(l:command, '-f'. i)
  endfor
  let l:args = ['dir=' . bearsunday#composer#dir(), 'name="' . l:namespace . '"', 'context=prod-hal-app']
  call bearsunday#buffer#open(systemlist(join(l:command + l:args)), 'binding', 'json')
endfunction
