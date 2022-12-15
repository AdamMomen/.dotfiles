function! EmptyRegisters()
    let regs=split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
    for r in regs
        call setreg(r, [])
    endfor
endfun

augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 40})
augroup END

augroup solidity
    au BufNewFile,BufRead *.sol setfiletype solidity
augroup END

augroup scala
    au BufNewFile,BufRead *.scala TSBufEnable highlight
augroup END

augroup fish
    au BufNewFile,BufRead *.fish setfiletype fish
augroup END

augroup THE_PRIMEAGEN
    autocmd!
    autocmd BufWritePre * %s/\s\+$//e
    autocmd BufEnter,BufWinEnter,TabEnter *.sol :lua require'lsp_extensions'.inlay_hints{}
augroup END
