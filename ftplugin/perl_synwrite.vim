" perl_synwrite.vim : check syntax of Perl before writing
" author : Ricardo Signes <rjbs-vim@public.manxome.org>
" $Id: /my/rjbs/conf/vim/perl_synwrite.vim 17554 2006-01-11T19:22:06.444484Z rjbs  $

""" to make syntax checking happen automatically on write, set
""" perl_synwrite_au; this is quirky, though, and isn't really advised
""" failing that, this script will map :Write to act like :write, but 
""" check syntax before writing;  :W[rite]! will write even if the syntax
""" check fails

""" if you have installed Vi::QuickFix (1.124 or later) you can assign
""" a true value to perl_synwrite_qf to use it to provide quickfix data
""" for the buffer

""" You can use the following lines to set perl_synwrite_qf automatically based
""" on whether it is likely to work:
"""   silent call system("perl -e0 -MVi::QuickFix")
"""   let perl_synwrite_qf = ! v:shell_error

"" abort if b:did_perl_synwrite is true: already loaded or user pref
if exists("b:did_perl_synwrite")
	finish
endif
let b:did_perl_synwrite = 1

let s:default_perl_synwrite_au = 0

"" execute the given do_command if the buffer is syntactically correct perl
"" -- or if do_anyway is true
function! s:PerlSynDo(do_anyway,do_command)
  let command = "!perl -Mwarnings -M-indirect=fatal -c"

  " resolve local/lib/perl5/ and lib/ directories path,
  " and append them to @INC
  let root = expand('%:p:h')
  while root != '/'
    if isdirectory(root.'/lib') || isdirectory(root.'/local/lib/perl5')
      let command = command . ' -I'.root.'/local/lib/perl5 -I'.root.'/lib'
      break
    endif
    let root = resolve(root.'/..')
  endwhile
  " echo command

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
command! -buffer -nargs=* -complete=file -range=% -bang W call s:PerlSynDo("<bang>"=="!","<line1>,<line2>write<bang> <args>")
