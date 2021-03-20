" ==============================================================================
" File:        literate.vim
" Description: vim plugin for evaluating source code blocks in md files
" Maintainer:  Marcio M Pereira <marcio.machado.pereira@gmail.com>
" License:     MIT
" ==============================================================================

" Init {{{

if exists('loaded_literate')
    finish
endif
let loaded_literate = 1

" }}}
" Commands {{{

command! -nargs=0 EvalCode call literate#EvalCode()

" }}}
" Mappings {{{

if !exists('g:eval_map_key')
    let g:eval_map_key = 1
endif

if g:eval_map_key
  autocmd BufNewFile,BufRead *.md nnoremap <buffer> <leader>e :call literate#EvalCode()<cr>
endif

" }}}
