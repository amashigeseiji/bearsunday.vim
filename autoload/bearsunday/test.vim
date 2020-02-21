function! bearsunday#test#open() abort
  let l:testDir = substitute(expand('%:h'), '^src/', 'tests/', '')
  let l:testFile = substitute(expand('%:t'), '.php', 'Test.php', '')
  if !isdirectory(l:testDir)
    call mkdir(l:testDir, 'p')
  endif
  exec 'split'
  exec 'open ' . l:testDir . '/' . l:testFile
endfunction

function! bearsunday#test#execute() abort
  let l:testDir = substitute(expand('%:h'), '^src/', 'tests/', '')
  let l:testFile = substitute(expand('%:t'), '.php', 'Test.php', '')
  echo system('php vendor/bin/phpunit ' . l:testDir . '/' . l:testFile)
endfunction
