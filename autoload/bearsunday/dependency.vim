function! bearsunday#dependency#get(...) abort
  let l:namespace = bearsunday#composer#namespaceBase()
  let l:namespace = trim(l:namespace[0][0], '\\')
  let l:list = systemlist('php dependency.php dir=' . bearsunday#composer#dir() . ' name="' . l:namespace . '" context=prod-hal-app')
  call bearsunday#buffer#open(l:list, 'dependency', 'json')
endfunction
