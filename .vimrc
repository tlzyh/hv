" vim configuration
" Last Change: 2017/11/16
" Author: YangHui <tlz.yh@outlook.com>
" Maintainer: YangHui <tlz.yh@outlook.com>
" License: This file is placed in the public domain.

" 公共函数定义 {{{
" 是否是macOs
function! IsOSX()
    return has('macunix')
endfunction

" 是否是Linux平台
function! IsLinux()
    return has('unix') && !has('macunix') && !has('win32unix')
endfunction

" 是否是windows平台
function! IsWindows()
    return  (has('win32') || has('win64'))
endfunction

" 是否是GUI版本
function! IsGui()
    return has('gui_running')
endfunction
" }}}

set nocompatible

if !IsWindows()
    set shell=/bin/sh
endif

silent function! SwitchMenu()
    if IsWindows()
        if &guioptions =~# 'T'
            set guioptions-=T
            set guioptions-=m
        else
            set guioptions+=T
            set guioptions+=m
        endif
    endif
endfunction

" windows 平台设置
if IsWindows()
    " 隐藏菜单工具栏。开关为F3
    set guioptions-=m
    set guioptions-=T
    noremap <silent> <F3> :call SwitchMenu() <CR>

    " 禁用菜单的alt快捷键, Windows中一般都是 alt访问菜单
    set winaltkeys=no
endif

" 编码设置 {{{
if has("multi_byte")
    " 全局编码
    set encoding=utf-8
    " 无BOM头
    set nobomb
    " 可用编码列表
    set fileencodings=utf-8,cp936,latin-1
    " 设置新建，打开，保存时候的编码
    set fileencoding=utf-8
    " 终端编码
    let &termencoding=&encoding
    " 设置消息编码格式
    language messages zh_CN.utf-8
endif
"}}}

" 设置 vim-plug {{{
call plug#begin('~/.vim/plugin')
" color scheme
Plug 'tlzyh/vim-colors'

" 在线翻译
Plug 'tlzyh/vim-youdao-translater'

" Lua
Plug 'xolox/vim-misc'
Plug 'xolox/vim-lua-ftplugin'

Plug 'xolox/vim-shell'

" 高亮行
Plug 'vim-scripts/Visual-Mark'

" 搜索
Plug 'junegunn/fzf', { 'dir': '~/.vim/fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

" 内容查找
Plug 'tlzyh/grep'

" 状态栏
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'skywind3000/asyncrun.vim'

" Plug 'liuchengxu/space-vim-dark'
call plug#end()
" End vim-plug }}}

" 通用配置 {{{
filetype plugin indent on
syntax on
set mouse=a
set mousehide
scriptencoding utf-8

if has('clipboard')
    if has('unnamedplus')
        set clipboard=unnamed,unnamedplus
    else
        set clipboard=unnamed
    endif
endif

set shortmess+=filmnrxoOtT
set viewoptions=folds,options,cursor,unix,slash
set virtualedit=onemore
set history=1000
set nospell
set hidden
set iskeyword-=.
set iskeyword-=#
set iskeyword-=-

" 切换buffer的时候，光标回到之前的位置
function! ResCur()
    if line("'\"") <= line("$")
        silent! normal! g`"
        return 1
    endif
endfunction
augroup resCur
    autocmd!
    autocmd BufWinEnter * call ResCur()
augroup END

set backup
if has('persistent_undo')
    set undofile
    set undolevels=1000
    set undoreload=10000
endif

set tabpagemax=15
set showmode
set cursorline

highlight clear SignColumn
highlight clear LineNr

if has('cmdline_info')
    set ruler
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)
    set showcmd
endif

set backspace=indent,eol,start
set linespace=0
set relativenumber
set number
set showmatch
set incsearch
set hlsearch
set winminheight=0
set ignorecase
set smartcase
set wildmenu
set wildmode=list:longest,full
set whichwrap=b,s,h,l,<,>,[,]
set scrolljump=5
set scrolloff=3
set foldenable
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:. 
set nowrap
set autoindent
set shiftwidth=4
set expandtab
set tabstop=4
set softtabstop=4
set nojoinspaces
set splitright
set splitbelow
set pastetoggle=<F12>

" 关闭响铃
if IsGui()
	autocmd GUIEnter * set visualbell t_vb=
endif
set noerrorbells visualbell t_vb=

let mapleader = ','
" }}}

" 字体字号{{{
if IsGui()
    set guioptions-=T
    set lines=40
    if IsLinux()
        set guifont=Andale\ Mono\ Regular\ 12,Menlo\ Regular\ 11,Consolas\ Regular\ 12,Courier\ New\ Regular\ 14
    elseif IsOSX()
        set guifont=Andale\ Mono\ Regular:h12,Menlo\ Regular:h11,Consolas\ Regular:h12,Courier\ New\ Regular:h14
    elseif IsWindows()
        " set guifont=,Courier_New:h10
        set guifont=Courier_New:h11,Andale_Mono:h11,Menlo:h10,Consolas:h10
    endif
else
    if &term == 'xterm' || &term == 'screen'
        set t_Co=256
    endif
endif
"}}}

" vimrc编辑 {{{
nnoremap <leader>ev :tabnew $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
" }}}


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

" quickfix 配置
" silent function! OpenOrCloseQuickfix()
"     " 垂直打开，去掉前缀 vert为水平打开
"     " TODO
"     vert copen 30
" endfunction
" vnoremap <silent> <C-Q> <Esc>:call OpenOrCloseQuickfix() <CR>
" nnoremap <silent> <C-Q> <Esc>:call OpenOrCloseQuickfix() <CR>
" 设置quickfix 打开文件到新的tab
set switchbuf+=useopen,usetab,newtab


" 文件折叠 {{{
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

" 文件内容搜索 {{{
" 获取选中的文字
function! GetVisualSelection()
    try
        let a_save = @a
        normal! gv"ay
        return @a
    finally
        let @a = a_save
    endtry
endfunction
" 获取光标位置字符
function! GetCursorWord()
    return expand("<cword>")
endfunction

silent function! ExecuteGrep(str)
    if strlen(a:str) > 0
        copen
        execute "AsyncRun grep -rna \"" . a:str . "\" " . getcwd()
    endif
endfunction

" 文件中删除
silent function! SearchInFiles()
    let str = GetVisualSelection()
    if strlen(str) <= 0
        let str = GetCursorWord()
    endif
    call ExecuteGrep(str)
endfunction

" 搜索输入的内容
silent function! SearchInputWord()
    let word = input("Please enter the word: ")
    exe "norm! \<Esc><CR>"
    call ExecuteGrep(word)
endfunction

if executable('grep')
    " 设置使用grep
    if IsWindows()
        set grepprg=grep\ -nH
    endif
    vnoremap <silent> <C-S> :call SearchInFiles() <CR>
    nnoremap <silent> <C-S> :call SearchInFiles() <CR>

    noremap <silent><M-1> :call SearchInputWord()<CR>
    inoremap <silent><M-1> <ESC>:call SearchInputWord()<CR>
else
    throw 'grep executable not found'
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
    if exists("g:hv_pre_tab_nr")
        execute "tabn " . g:hv_pre_tab_nr
    endif
endfunction

if IsGui()
    if IsOSX()
        " set macmeta
        noremap <silent><C-TAB> :call SwitchToPreTab()<CR>
        inoremap <silent><C-TAB> <ESC>:call SwitchToPreTab()<CR>
        noremap <silent><D-1> :tabn 1<CR>
        noremap <silent><D-2> :tabn 2<CR>
        noremap <silent><D-3> :tabn 3<CR>
        noremap <silent><D-4> :tabn 4<CR>
        noremap <silent><D-5> :tabn 5<CR>
        noremap <silent><D-6> :tabn 6<CR>
        noremap <silent><D-7> :tabn 7<CR>
        noremap <silent><D-8> :tabn 8<CR>
        noremap <silent><D-9> :tabn 9<CR>
        noremap <silent><D-0> :tabn 10<CR>
        inoremap <silent><D-1> <ESC>:tabn 1<CR>
        inoremap <silent><D-2> <ESC>:tabn 2<CR>
        inoremap <silent><D-3> <ESC>:tabn 3<CR>
        inoremap <silent><D-4> <ESC>:tabn 4<CR>
        inoremap <silent><D-5> <ESC>:tabn 5<CR>
        inoremap <silent><D-6> <ESC>:tabn 6<CR>
        inoremap <silent><D-7> <ESC>:tabn 7<CR>
        inoremap <silent><D-8> <ESC>:tabn 8<CR>
        inoremap <silent><D-9> <ESC>:tabn 9<CR>
        inoremap <silent><D-0> <ESC>:tabn 10<CR>
        noremap <silent><D-O> :browse tabnew<CR>
        inoremap <silent><D-O> <ESC>:browse tabnew<CR>
    else
        " set macmeta
        noremap <silent><C-TAB> :call SwitchToPreTab()<CR>
        inoremap <silent><C-TAB> <ESC>:call SwitchToPreTab()<CR>
        " noremap <silent><M-1> :tabn 1<CR>
        noremap <silent><M-2> :tabn 2<CR>
        noremap <silent><M-3> :tabn 3<CR>
        noremap <silent><M-4> :tabn 4<CR>
        noremap <silent><M-5> :tabn 5<CR>
        noremap <silent><M-6> :tabn 6<CR>
        noremap <silent><M-7> :tabn 7<CR>
        noremap <silent><M-8> :tabn 8<CR>
        noremap <silent><M-9> :tabn 9<CR>
        noremap <silent><M-0> :tabn 10<CR>
        inoremap <silent><M-1> <ESC>:tabn 1<CR>
        inoremap <silent><M-2> <ESC>:tabn 2<CR>
        inoremap <silent><M-3> <ESC>:tabn 3<CR>
        inoremap <silent><M-4> <ESC>:tabn 4<CR>
        inoremap <silent><M-5> <ESC>:tabn 5<CR>
        inoremap <silent><M-6> <ESC>:tabn 6<CR>
        inoremap <silent><M-7> <ESC>:tabn 7<CR>
        inoremap <silent><M-8> <ESC>:tabn 8<CR>
        inoremap <silent><M-9> <ESC>:tabn 9<CR>
        inoremap <silent><M-0> <ESC>:tabn 10<CR>
    end
else
    " 使用终端自定义按键序列，把alt-n 或者alt-shift-n 设置为
    " 发送 "<ESC>]{0}n~" 按键序列
    noremap <silent><ESC>]{0}1~ :tabn 1<CR>
    noremap <silent><ESC>]{0}2~ :tabn 2<CR>
    noremap <silent><ESC>]{0}3~ :tabn 3<CR>
    noremap <silent><ESC>]{0}4~ :tabn 4<CR>
    noremap <silent><ESC>]{0}5~ :tabn 5<CR>
    noremap <silent><ESC>]{0}6~ :tabn 6<CR>
    noremap <silent><ESC>]{0}7~ :tabn 7<CR>
    noremap <silent><ESC>]{0}8~ :tabn 8<CR>
    noremap <silent><ESC>]{0}9~ :tabn 9<CR>
    noremap <silent><ESC>]{0}0~ :tabn 10<CR>
    inoremap <silent><ESC>]{0}1~ <ESC>:tabn 1<CR>
    inoremap <silent><ESC>]{0}2~ <ESC>:tabn 2<CR>
    inoremap <silent><ESC>]{0}3~ <ESC>:tabn 3<CR>
    inoremap <silent><ESC>]{0}4~ <ESC>:tabn 4<CR>
    inoremap <silent><ESC>]{0}5~ <ESC>:tabn 5<CR>
    inoremap <silent><ESC>]{0}6~ <ESC>:tabn 6<CR>
    inoremap <silent><ESC>]{0}7~ <ESC>:tabn 7<CR>
    inoremap <silent><ESC>]{0}8~ <ESC>:tabn 8<CR>
    inoremap <silent><ESC>]{0}9~ <ESC>:tabn 9<CR>
    inoremap <silent><ESC>]{0}0~ <ESC>:tabn 10<CR>
endif

" 终端模式下的TabLine， 参见官方文档示例
function! CreateTerminalTabLine()
    let s = ''
    for i in range(tabpagenr('$'))
        if i + 1 == tabpagenr()
            let s .= '%#TabLineSel#'
        else
            let s .= '%#TabLine#'
        endif
        let s .= '%' . (i + 1) . 'T'
        let s .= ' %{GetTerminalTabLineString(' . (i + 1) . ')} '
    endfor
    let s .= '%#TabLineFill#%T'
    if tabpagenr('$') > 1
        let s .= '%=%#TabLine#%999XX'
    endif
    return s
endfunc

" 获取名字
function! GetBuffOrTabString(bufnr, fullname, tabnr)
    let l:name = bufname(a:bufnr)
    if getbufvar(a:bufnr, '&modifiable')
        if l:name == ''
            return '[No Name]'
        else
            if a:fullname 
                return fnamemodify(l:name, ':p')
            else
                if a:tabnr
                    return '[' . a:tabnr . ']' . fnamemodify(l:name, ':t')
                else
                    return fnamemodify(l:name, ':t')
                endif
            endif
        endif
    else
        let l:buftype = getbufvar(a:bufnr, '&buftype')
        if l:buftype == 'quickfix'
            return '[Quickfix]'
        elseif l:name != ''
            if a:fullname 
                return '-'.fnamemodify(l:name, ':p')
            else
                if a:tabnr
                    return '-' . '[' . a:tabnr . ']' . fnamemodify(l:name, ':t')
                else
                    return '-' . fnamemodify(l:name, ':t')
                end
            endif
        else
        endif
        return '[No Name]'
    endif
endfunc

function! GetTerminalTabLineString(n)
    let l:buflist = tabpagebuflist(a:n)
    let l:winnr = tabpagewinnr(a:n)
    let l:bufnr = l:buflist[l:winnr - 1]
    return GetBuffOrTabString(l:bufnr, 0, a:n)
endfunc

function! GetGuiTabLineString()
    let l:num = v:lnum
    let l:buflist = tabpagebuflist(l:num)
    let l:winnr = tabpagewinnr(l:num)
    let l:bufnr = l:buflist[l:winnr - 1]
    return GetBuffOrTabString(l:bufnr, 0, l:num)
endfunc

set tabline=%!CreateTerminalTabLine()
set guitablabel=%{GetGuiTabLineString()}

function! GetGuiTabTip()
    let tip = ''
    let bufnrlist = tabpagebuflist(v:lnum)
    for bufnr in bufnrlist
        if tip != ''
            let tip .= " \n"
        endif
        let name = GetBuffOrTabString(bufnr, 1, 0)
        let tip .= name
        if getbufvar(bufnr, "&modified")
            let tip .= ' [+]'
        endif
        if getbufvar(bufnr, "&modifiable")==0
            let tip .= ' [-]'
        endif
    endfor
    return tip
endfunc
set guitabtooltip=%{GetGuiTabTip()}
" }}}

" netrw 插件 {{{
function! OpenExploreTerminal(where)
    let l:path = expand("%:p:h")
    if l:path == ''
        let l:path = getcwd()
    endif
    if a:where == 0
        exec 'Explore '.fnameescape(l:path)
    elseif a:where == 1
        exec 'vnew'
        exec 'Explore '.fnameescape(l:path)
    else
        exec 'tabnew'
        exec 'Explore '.fnameescape(l:path)
    endif
endfunc

function! s:FilterPush(desc, wildcard)
    let g:browsefilter .= a:desc . " (" . a:wildcard . ")\t" . a:wildcard . "\n"
endfunc
function! OpenBrowseGUI(where)
    let l:path = expand("%:p:h")
    if l:path == '' | let l:path = getcwd() | endif
    if exists('g:browsefilter') && exists('b:browsefilter')
        if g:browsefilter != ''
            let b:browsefilter = g:browsefilter
        endif
    endif
    if a:where == 0
        exec 'browse e '.fnameescape(l:path)
    elseif a:where == 1
        exec 'browse vnew '.fnameescape(l:path)
    else
        exec 'browse tabnew '.fnameescape(l:path)
    endif
endfunc

if IsGui()
    let g:browsefilter = ''
    call s:FilterPush("All Files", "*")
    call s:FilterPush("C/C++/Object-C", "*.c;*.cpp;*.cc;*.h;*.hh;*.hpp;*.m;*.mm")
    call s:FilterPush("Python", "*.py;*.pyw")
    call s:FilterPush("Text", "*.txt")
    call s:FilterPush("Lua", "*.lua")
    call s:FilterPush("Vim Script", "*.vim")

    vnoremap <silent> <C-O> :call OpenBrowseGUI(2) <CR>
    nnoremap <silent> <C-O> :call OpenBrowseGUI(2) <CR>
    inoremap <silent> <C-O> :call OpenBrowseGUI(2) <CR>
else
    vnoremap <silent> <C-O> :call OpenExploreTerminal(2) <CR>
    nnoremap <silent> <C-O> :call OpenExploreTerminal(2) <CR>
    inoremap <silent> <C-O> :call OpenExploreTerminal(2) <CR>
endif
" }}}

" 状态栏 {{{
" 如果没有powerline 使用自己的配置
if isdirectory(expand("~/.vim/plugin/vim-airline"))
    if isdirectory(expand("~/.vim/plugin/vim-airline-themes"))
        if !exists('g:airline_theme')
            let g:airline_theme = 'solarized'
        endif
        if !exists('g:airline_powerline_fonts')
            let g:airline_left_sep='›'
            let g:airline_right_sep='‹'
        endif
    endif
else
    if has('statusline')
        set laststatus=2
        set statusline=%<%f\
        set statusline+=%w%h%m%r
        set statusline+=\ [%{&ff}/%Y]
        set statusline+=\ [%{getcwd()}]
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%
    endif
endif
" }}}

" 在线翻译 {{{
if isdirectory(expand("~/.vim/plugin/vim-youdao-translater"))
    vnoremap <silent> <C-T> <Esc>:Ydv<CR> 
    nnoremap <silent> <C-T> <Esc>:Ydc<CR> 
    noremap <leader>yd :Yde<CR>
end
" }}}

" FZF 插件配置 {{{
if isdirectory(expand("~/.vim/plugin/fzf.vim"))
    function! s:build_quickfix_list(lines)
      call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
      copen
      cc
    endfunction

    let g:fzf_action = {
      \ 'ctrl-q': function('s:build_quickfix_list'),
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit' }

    let g:fzf_layout = { 'down': '~40%' }

    let g:fzf_colors =
    \ { 'fg':      ['fg', 'Normal'],
      \ 'bg':      ['bg', 'Normal'],
      \ 'hl':      ['fg', 'Comment'],
      \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
      \ 'hl+':     ['fg', 'Statement'],
      \ 'info':    ['fg', 'PreProc'],
      \ 'border':  ['fg', 'Ignore'],
      \ 'prompt':  ['fg', 'Conditional'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker':  ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment'] }

    let g:fzf_history_dir = '~/.local/share/fzf-history'
    vnoremap <silent> <C-P> <Esc>:FZF<CR>
    nnoremap <silent> <C-P> <Esc>:FZF<CR>
end
" }}}

" 初始化目录 {{{
function! InitializeDirectories()
    let parent = $HOME . '/.vimtmpdir/'

    " create parent dir
    if !isdirectory(parent)
        call mkdir(parent)
    endif

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
            execute "set " . settingname . "=" . directory
        endif
    endfor
endfunction
call InitializeDirectories()
" }}}

" 主题设置 {{{
if filereadable(expand("~/.vim/plugin/vim-colors/colors/molokai.vim"))
    colorscheme molokai
endif
" }}}


