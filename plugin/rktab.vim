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

  " Set tab name to current buffer 
  " When all below conditions fail, this will be used 
  let bn = bufname(currwinbufnr)

  if buflisted(currwinbufnr)
    let bn = bufname(currwinbufnr)

  elseif buflisted(prevwinbufnr)
    let bn = bufname(prevwinbufnr)

  else
    for i in buflist
      if buflisted(i)
        let bn = bufname(i)
        break
      endif
    endfor

  endif

  return fnamemodify(empty(bn) ? "[New]" : bn, ':t')
  
endfunction

set tabline=%!MyTabLine()
