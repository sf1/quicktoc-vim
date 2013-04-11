function! s:nfig(n)
    let ntemp = a:n
    let nf = 1
    while ntemp >= 10
        let ntemp = ntemp / 10
        let nf += 1
    endwhile
    return nf
endfunction

function! latextoc#refresh()
    let pattern = '\\\(chapter\|section\|subsection\|subsubsection\).\{-}{\(.\{-}\)}'
    let bufnr = bufnr('%')
    let chapter = 0
    let section = 0
    let subsection = 0
    let subsubsection = 0
    let pos = getpos('.')
    let locList = []
    call cursor(1,1)
    while 1
        let n = search(pattern,'W')
        if n == 0
            break
        endif
        let typeTitle = matchlist(getline(n), pattern)
        call remove(typeTitle, 0)
        if typeTitle[0] == 'chapter'
            let chapter += 1
            let section = 0
            let subsection = 0
            let subsubsection = 0
        elseif typeTitle[0] == 'section'
            let section += 1
            let subsection = 0
            let subsubsection = 0
        elseif typeTitle[0] == 'subsection'
            let subsection += 1
            let subsubsection = 0
        elseif typeTitle[0] == 'subsubsection'
            let subsubsection += 1
        endif
        let temp = []
        if chapter > 0
            call add(temp, chapter)
        endif
        if section > 0
            call add(temp, section)
        endif
        if subsection > 0
            call add(temp, subsection)
        endif
        if subsubsection > 0
            call add(temp, subsubsection)
        endif
        let prefix = ''
        let level = 0
        for item in temp
            if level > 0
                let prefix = prefix . '.'
            endif
            let prefix .= item
            let level += 1
        endfor
        while level > 1
            let prefix = '    ' . prefix
            let level -= 1
        endwhile
        let nf = s:nfig(n)
        while nf <= 6
            let prefix = ' ' . prefix
            let nf += 1
        endwhile
        let prefix = '|' . prefix
        let entry = {}
        let entry.lnum = n
        let entry.bufnr = bufnr
        let entry.col = 0
        let entry.valid = 1
        let entry.vcol = 0
        let entry.nr = 0
        let entry.type = ''
        let entry.pattern = ''
        let entry.text = prefix . ' ' . typeTitle[1]
        call add(locList, entry)
    endwhile
    call setpos('.', pos)
    call setloclist(0, locList)
    lw
endfunction

