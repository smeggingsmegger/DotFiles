augroup pygroup
  au! BufEnter *.py nnoremap <Leader>b :call fxns#InsertDebugLine("import pudb; pudb.set_trace()  # XXX BREAKPOINT", line('.'))<CR>
augroup END
