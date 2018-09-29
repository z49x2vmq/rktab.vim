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
    let s .= '%{MyTabLabel2(' . (i + 1) . ')}%T'

  endfor

  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#'

  " right-align the label to close the current tab page
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#%999Xclose'
  endif

  return s
endfunction

function! MyTabLabel2(n)
  let buflist = tabpagebuflist(a:n)

  " Current window of the tab
  let currwinnr = tabpagewinnr(a:n)
  let currwinbufnr = buflist[currwinnr - 1]

  " Previous window of the tab
  let prevwinnr = tabpagewinnr(a:n, '#')
  let prevwinbufnr = buflist[prevwinnr - 1]

  if !buflisted(currwinbufnr) && !buflisted(prevwinbufnr)
  " If both curr and prev windows are unlisted, select listed.
    for i in buflist
      if buflisted(i)
        return fnamemodify(bufname(i), ':t')
      endif
    endfor

    " When all the rest windows are unlisted use the current
    return bufname(currwinbufnr)

  elseif !buflisted(currwinbufnr)
    " If previous buffer is listed use it
    return fnamemodify(bufname(prevwinbufnr), ':t')

  endif

  " If current window is list just use it
  return fnamemodify(bufname(currwinbufnr), ':t')
endfunction

function! MyTabLabel(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let bufnr = buflist[winnr - 1]
  let bn = bufname(bufnr)

  if match(bn, "NERD_tree_[0-9][0-9]*$") == 0
    let winnr = tabpagewinnr(a:n, '#')
    let bn = bufname(buflist[winnr - 1])
  endif

  if empty(bn)
    let bn = "[No Name]"
  else
    let bn = fnamemodify(bn, ":t")
  endif

  return bn
endfunction

set tabline=%!MyTabLine()
