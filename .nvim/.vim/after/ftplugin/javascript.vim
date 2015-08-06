augroup jsgroup
  au! BufEnter *.js nnoremap <Leader>b :call fxns#InsertDebugLine("debugger;", line('.'))<CR>
augroup END
