" vim: ts=2 sw=2 expandtab
function! MyTabLine()
  let s = ''

  for i in range(tabpagenr('$'))
    if i != 0
      let s .= "%#TabLine# "
    endif

    " select the highlighting
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif

    " set the tab page number (for mouse clicks)
    let s .= '%' . (i + 1) . 'T'

    " the label is made by MyTabLabel()
    let s .= '%{MyTabLabel(' . (i + 1) . ')}%T'

  endfor

  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#'

  " right-align the label to close the current tab page
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#%999Xclose'
  endif

  return s
endfunction

function! MyTabLabel(n)
  let buflist = tabpagebuflist(a:n)

  " Current window of the tab
  let currwinnr = tabpagewinnr(a:n)
  let currwinbufnr = buflist[currwinnr - 1]

  " Previous window of the tab
  let prevwinnr = tabpagewinnr(a:n, '#')
  let prevwinbufnr = buflist[prevwinnr - 1]

  if buflisted(currwinbufnr) && !empty(bufname(currwinbufnr))
    let buf = currwinbufnr
  elseif buflisted(prevwinbufnr) && !empty(bufname(prevwinbufnr))
    let buf = prevwinbufnr
  else
    for i in reverse(buflist)
      if !empty(bufname(i))
        let buf = i
        if buflisted(i)
          break
        endif
      endif
    endfor

    " If buf is not set or buf is not listed,
    " we need to fallback to currwin and prevwin
    if !exists("buf") || !buflisted(buf)
      if !empty(bufname(currwinbufnr))
        let buf = currwinbufnr
      elseif !empty(bufname(prevwinbufnr))
        let buf = prevwinbufnr
      endif
    endif
  endif

  let bn = (exists("buf")) ? bufname(buf) : ""
  let wins = tabpagewinnr(a:n, '$')

  let winslabel = (wins > 1 ? wins . " " : "")
  let bufnamelabel = fnamemodify(empty(bn) ? "[No Name]" : bn, ':t')

  return winslabel . bufnamelabel

endfunction


hi TabLine gui=NONE cterm=NONE
set tabline=%!MyTabLine()
