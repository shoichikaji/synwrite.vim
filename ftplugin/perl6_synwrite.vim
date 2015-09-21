" perl6_synwrite.vim : check syntax of Perl6 before writing
" original author : Ricardo Signes <rjbs-vim@public.manxome.org>
" modified by: Shoichi Kaji <skaji@cpan.org>

"" abort if b:did_perl6_synwrite is true: already loaded or user pref
if exists("b:did_perl6_synwrite")
	finish
endif
let b:did_perl6_synwrite = 1

"" execute the given do_command if the buffer is syntactically correct perl6
"" -- or if do_anyway is true
function! s:Perl6SynDo(do_anyway,do_command)
  let command = "!perl6 -c -"

  " resolve lib/ directories path,
  " and append them to @*INC
  let root = expand('%:p:h')
  while root != '/'
    if isdirectory(root.'/lib')
      let command = '!perl6 -I'.root.'/lib -c -'
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
command! -buffer -nargs=* -complete=file -range=% -bang W call s:Perl6SynDo("<bang>"=="!","<line1>,<line2>write<bang> <args>")
