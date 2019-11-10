let s:sfile = expand('<sfile>:p:h')
function! bearsunday#binding#get(...) abort
  let l:namespace = bearsunday#composer#namespaceBase()
  let l:namespace = trim(l:namespace[0][0], '\\')
  let l:list = systemlist('php ' . s:sfile . '/binding.php dir=' . bearsunday#composer#dir() . ' name="' . l:namespace . '" context=prod-hal-app')
  call bearsunday#buffer#open(l:list, 'binding', 'json')
endfunction
