" ==============================================================================
" File:        literate.vim
" Description: vim plugin for evaluating source code blocks in md files
" Maintainer:  Marcio M Pereira <marcio.machado.pereira@gmail.com>
" License:     MIT
" ==============================================================================

" Global options {{{

if !exists("g:eval_start_src")
  let g:eval_start_src = "```"
endif
if !exists("g:eval_end_src")
  let g:eval_end_src   = "```"
endif
if !exists("g:eval_tmp_file")
  let g:eval_tmp_file  = tempname()
endif
if !exists("g:eval_res_file")
  let g:eval_res_file = tempname()
endif
if !exists("g:eval_run_cmd")
  let g:eval_run_cmd = {
        \ 'python': 'python3',
        \ 'sh': 'sh',
        \ 'bash': 'bash',
        \ 'perl': 'perl',
        \}
endif

" }}}

" Helper functions {{{

function! s:getRange() abort
  " save cursor position
  normal! mq

  " Flags:
  " c -- accept match at cursor position
  " b -- search backward instead of forward
  " W -- do not wrap around eof
  " e -- move cursor to the end of the match
  let start = search('\c^\s*'.g:eval_start_src, "cbWe")
  let end   = search('\c^\s*'.g:eval_end_src, "cW")

  " restore cursor position
  normal! 'q

  " check we are in range
  if end <= start || end < line('.')
      \ || (start == 0 && getline(start) !~ g:eval_start_src)
    return [-1, "Nothing to do here"]
  else
    return [start, end]
  endif
endfunction

function! s:getLang(lnum) abort
  let matches = matchlist(getline(a:lnum), '\c^\s*'.g:eval_start_src.'\s\+\(\w\+\)')

  " No :lang in source block header
  if len(matches) < 2
    return ""
  else
    return matches[1]
  endif
endfunction

function! s:getSrcBlock() abort
  let [start, end] = s:getRange()

  if start < 0
    echo end
    return {}
  else
    let lines = []
    for lnum in range(start+1, end-1)
      call add(lines, getline(lnum))
    endfor
    return {'start': start, 'end': end, 'lines': lines}
  endif
endfunction

function! s:writeSrcBlock(block) abort
  call writefile(a:block, g:eval_tmp_file)
endfunction

" }}}

" Public API {{{

function! literate#EvalCode() abort
  let block = s:getSrcBlock()

  if !empty(block)
    let lang  = s:getLang(block['start'])
    let cmd   = get(g:eval_run_cmd, lang, "")
    if !empty(cmd)
      call s:writeSrcBlock(block['lines'])
      let result = system(cmd . ' ' . g:eval_tmp_file . ' > ' . g:eval_res_file)
      let lnum = block['end']
      for line in readfile(g:eval_res_file, '')
	    call append(lnum, line)
        let lnum = lnum+1
      endfor
      echo ''
    else
      if empty(lang)
        echo 'Language not specified'
      else
        echo 'Language not supported'
      endif
    endif
  endif
endfunction

" }}}
