" vim configuration
" Last Change: 2017/11/03
" Author: YangHui <tlz.yh@outlook.com>
" Maintainer: YangHui <tlz.yh@outlook.com>
" License: his file is placed in the public domain.

" 是否是mac平台
silent function! is_osx()
    return has('macunix')
endfunction

" 是否是linux或者类linux平台
silent function! is_linux()
    return has('unix') && !has('macunix') && !has('win32unix')
endfunction

" 是否是windows平台
silent function! is_win()
    return  (has('win32') || has('win64'))
endfunction

set nocompatible
set background=dark

if !is_win()
    set shell=/bin/sh
endif

if is_win()
    set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after,$HOME/.vim/vimfiles
    set noerrorbells visualbell t_vb=
    if has('autocmd')
        " 关闭响铃
        autocmd GUIEnter * set visualbell t_vb=
    endif

    " 隐藏菜单工具栏。开关为F3
    set guioptions-=m
    set guioptions-=T
    map <silent> <F3> :if &guioptions =~# 'T' <Bar>
        \set guioptions-=T <Bar>
        \set guioptions-=m <bar>
    \else <Bar>
        \set guioptions+=T <Bar>
        \set guioptions+=m <Bar>
    \endif<CR>

    if has("multi_byte")
        set encoding=utf-8
        set nobomb
        set fileencodings=utf-8,chinese,latin-1
        set fileencoding=chinese
        let &termencoding=&encoding
        language messages zh_CN.utf-8
    endif
endif

" -------------------------------- 设置 vim-plug ----------------------
call plug#begin('~/.vim/plugin')
Plug 'tlzyh/vim-colors'
call plug#end()

" -------------------------------- End vim-plug ----------------------

function! InitializeDirectories()
    let parent = $HOME
    let prefix = 'vim'
    let dir_list = {
                \ 'backup': 'backupdir',
                \ 'views': 'viewdir',
                \ 'swap': 'directory' }

    if has('persistent_undo')
        let dir_list['undo'] = 'undodir'
    endif

    let common_dir = parent . '/.' . prefix

    for [dirname, settingname] in items(dir_list)
        let directory = common_dir . dirname . '/'
        if exists("*mkdir")
            if !isdirectory(directory)
                call mkdir(directory)
            endif
        endif
        if !isdirectory(directory)
            echo "Warning: Unable to create backup directory: " . directory
            echo "Try: mkdir -p " . directory
        else
            let directory = substitute(directory, " ", "\\\\ ", "g")
            exec "set " . settingname . "=" . directory
        endif
    endfor
endfunction
call InitializeDirectories()

if filereadable(expand("~/.vim/plugin/vim-colors/colors/molokai.vim"))
    colorscheme molokai
endif
