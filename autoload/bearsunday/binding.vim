let s:bindingphp = expand('<sfile>:p:h') . '/binding.php'

function! bearsunday#binding#get(word) abort
  let l:namespace = bearsunday#composer#namespaceBase()
  let l:namespace = trim(l:namespace[0][0], '\\')
  let l:command = ['php', s:bindingphp]
  if a:word != ''
    call add(l:command, '-f'. a:word)
  endif
  let l:args = ['dir=' . bearsunday#composer#dir(), 'name="' . l:namespace . '"', 'context=prod-hal-app']
  call bearsunday#buffer#open(systemlist(join(l:command + l:args)), 'binding', 'json')
endfunction
