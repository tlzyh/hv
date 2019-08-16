" vim configuration
" Last Change: 2019/08/16
" Author: YangHui <tlz.yh@outlook.com>
" Maintainer: YangHui <tlz.yh@outlook.com>
" License: This file is placed in the public domain.
" gui 相关配置

" GUI基本配置 {{{
if exists('g:GuiLoaded')
    GuiPopupmenu 0
    GuiTabline 0
    GuiLinespace 0
    Guifont! Courier\ New:h12
    call GuiWindowMaximized(1)
endif
" }}}

" tab 设置 {{{
" 左右切换tab
noremap <C-H> gT
noremap <C-L> gt

silent function! TabLeaveInit()
    let g:hv_pre_tab_nr = tabpagenr()
endfunction
augroup tab_leave
    autocmd!
    autocmd TabLeave * call TabLeaveInit()
augroup END

" 切换到上一页
silent function! SwitchToPreTab()
    if exists("g:hv_pre_tab_nr") && g:hv_pre_tab_nr > 0
        let l:pn = tabpagenr('$')
        if g:hv_pre_tab_nr <= l:pn
            execute "tabn " . g:hv_pre_tab_nr
        else
            let g:hv_pre_tab_nr = 0
        endif
    endif
endfunction
if exists('g:GuiLoaded')
    noremap <silent><C-TAB> :call SwitchToPreTab()<CR>
    inoremap <silent><C-TAB> <ESC>:call SwitchToPreTab()<CR>
endif

" 目录切换设置 {{{
" 第一次打开的目录作为工程目录
silent function! GuiEnterInit()
    let g:hv_project_directory = getcwd()
endfunction
augroup project_dir_init
    autocmd!
    autocmd GUIEnter * call GuiEnterInit()
augroup END
" 打开Buff，当前目录切换到当前文件所在目录
" autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
silent function! SwitchProjectDir()
    if bufname("") !~ "^\[A-Za-z0-9\]*://"
        if toupper(getcwd()) == toupper(g:hv_project_directory)
            " 设置为当前路径, 可以拼接路径，也可以像下面一样
            lcd %:p:h
            echo 'change to current directory:' . getcwd()
        else
            execute "lcd " . g:hv_project_directory
            echo 'change to project directory:' . g:hv_project_directory
        endif
    endif
endfunction
vnoremap <silent> <C-D> :call SwitchProjectDir() <CR>
nnoremap <silent> <C-D> :call SwitchProjectDir() <CR>
" }}}

