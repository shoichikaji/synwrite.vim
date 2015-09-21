if exists("b:did_python_synwrite")
  finish
endif
let b:did_python_synwrite = 1

function! s:PythonSynDo(do_anyway,do_command)
  let command = "!python - -m py_compile"

  exec "write" command

  silent! cgetfile " try to read the error file
  if !v:shell_error || a:do_anyway
    exec a:do_command
    set nomod
  endif
endfunction

command! -buffer -nargs=* -complete=file -range=% -bang W call s:PythonSynDo("<bang>"=="!","<line1>,<line2>write<bang> <args>")
