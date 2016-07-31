if exists("b:did_go_synwrite")
  finish
endif
let b:did_go_synwrite = 1

function! s:GoSynDo(do_anyway,do_command)
  let command = "!go fmt"

  exec "write" command

  silent! cgetfile " try to read the error file
  if !v:shell_error || a:do_anyway
    exec a:do_command
    set nomod
  endif
endfunction

"" the :Write command
command! -buffer -nargs=* -complete=file -range=% -bang W call s:GoSynDo("<bang>"=="!","<line1>,<line2>write<bang> <args>")
