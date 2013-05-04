"
" Author: Sebastian Fleissner
" Copyright: (C) 2013 Sebastian Fleissner
" License: Vim License - see ':help license'. 
"

function! s:nfig(n)
    let ntemp = a:n
    let nf = 1
    while ntemp >= 10
        let ntemp = ntemp / 10
        let nf += 1
    endwhile
    return nf
endfunction

function! s:createTOC()
    let toc = {}
    let toc.entries = []
    return toc
endfunction

function! s:addEntry(toc, title, level, lineNo)
    let lvl = a:level
    let prefix = ''
    while lvl > 1
        let prefix = '    ' . prefix
        let lvl -= 1
    endwhile    
    let nf = s:nfig(a:lineNo)
    while nf <= 6
        let prefix = ' ' . prefix
        let nf += 1
    endwhile
    let prefix = '|' . prefix
    let entry = {}
    let entry.lnum = a:lineNo
    let entry.bufnr = bufnr('%')
    let entry.col = 0
    let entry.valid = 1
    let entry.vcol = 0
    let entry.nr = 0
    let entry.type = ''
    let entry.pattern = ''
    let entry.text = prefix . ' ' . a:title
    call add(a:toc.entries,entry)
endfunction

function! quicktoc#markdown()
    let pattern ='^.*\n[=-]\+\|^#\+'
    let pos = getpos('.')
    let toc = s:createTOC()
    call cursor(1,1)
    while 1
        let n = search(pattern,'Wc')
        if n == 0
            break
        endif
        let line = getline(n)
        let nextLine = getline(n+1)
        let title = line
        let level = 1
        if stridx(line, '#') == 0
            let typeTitle = matchlist(line, '^\(#\+\) \(.*\)')
            let level = strlen(typeTitle[1])
            let title = typeTitle[2]
        else
            if stridx(nextLine,'=') == 0
                let level = 1
            elseif stridx(nextLine,'-') == 0
                let level = 2
            endif
        endif
        call s:addEntry(toc, title, level, n)
        call cursor(getpos('.')[1]+1,1)
    endwhile
    call setpos('.', pos)
    call setloclist(0, toc.entries)
    lw
endfunction

function! quicktoc#latex()
    let pattern = '\\\(chapter\|section\|subsection\|subsubsection\).\{-}{\(.\{-}\)}'
    let chapter = 0
    let section = 0
    let subsection = 0
    let subsubsection = 0
    let pos = getpos('.')
    let toc = s:createTOC()
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
        call s:addEntry(toc, prefix . ' ' . typeTitle[1], level, n)
    endwhile
    call setpos('.', pos)
    call setloclist(0, toc.entries)
    lw
endfunction

