" sh_synwrite.vim : check syntax of bash before writing
" original : perl_synwrite.vim by Ricardo Signes <rjbs-vim@public.manxome.org>
" modified by: Shoichi Kaji <skaji@cpan.org>

"" abort if b:did_sh_synwrite is true: already loaded or user pref
if exists("b:did_sh_synwrite")
	finish
endif
let b:did_sh_synwrite = 1

"" execute the given do_command if the buffer is syntactically correct perl6
"" -- or if do_anyway is true
function! s:ShSynDo(do_anyway,do_command)
  let command = "!bash -sn"

  " we need to cat here because :exec would add a space between ! and command
  " let to_exec = "write !" . command
  exec "write" command

  silent! cgetfile " try to read the error file
  if !v:shell_error || a:do_anyway
    exec a:do_command
    set nomod
  endif
endfunction

"" the :Write command
command! -buffer -nargs=* -complete=file -range=% -bang W call s:ShSynDo("<bang>"=="!","<line1>,<line2>write<bang> <args>")
